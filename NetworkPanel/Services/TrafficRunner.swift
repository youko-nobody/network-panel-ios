import Foundation
import Combine

@MainActor
final class TrafficRunner: ObservableObject {
    @Published private(set) var isRunning = false
    @Published private(set) var sessionBytes: Int64 = 0
    @Published private(set) var bytesPerSecond: Int64 = 0
    @Published private(set) var activeWorkers = 0
    @Published private(set) var statusText = "待开始"

    private var tasks: [Task<Void, Never>] = []
    private var rateTask: Task<Void, Never>?
    private var lastRateBytes: Int64 = 0
    private var lastRateTime = Date()
    private var rateWindowBytes: Int64 = 0
    private var rateWindowStart = Date()
    private weak var store: AppStore?

    func start(route: TrafficRoute, store: AppStore) {
        guard !isRunning else { return }
        self.store = store
        isRunning = true
        statusText = "运行中"
        BackgroundAudioKeeper.shared.start()
        bytesPerSecond = 0
        activeWorkers = 0
        lastRateBytes = sessionBytes
        lastRateTime = Date()
        rateWindowBytes = 0
        rateWindowStart = Date()

        let workerCount = store.enhancedConcurrency ? store.threadCount : 1
        for _ in 0..<max(1, workerCount) {
            let task = Task.detached(priority: .utility) { [weak self] in
                guard let self else { return }
                await self.runWorker(route: route)
            }
            tasks.append(task)
        }

        rateTask = Task { [weak self] in
            while !(Task.isCancelled) {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                self?.updateRate()
            }
        }
    }

    func pause() {
        guard isRunning else { return }
        statusText = "已暂停"
        isRunning = false
        tasks.forEach { $0.cancel() }
        tasks.removeAll()
        rateTask?.cancel()
        rateTask = nil
        BackgroundAudioKeeper.shared.stop()
        bytesPerSecond = 0
        activeWorkers = 0
    }

    func resetSession() {
        sessionBytes = 0
        bytesPerSecond = 0
        lastRateBytes = 0
        lastRateTime = Date()
    }

    private nonisolated func runWorker(route: TrafficRoute) async {
        await MainActor.run {
            self.activeWorkers += 1
        }
        defer {
            Task { @MainActor in
                self.activeWorkers = max(0, self.activeWorkers - 1)
            }
        }

        while !Task.isCancelled {
            guard let url = URL(string: route.normalizedURL + cacheBuster(route.normalizedURL)) else {
                try? await Task.sleep(nanoseconds: 700_000_000)
                continue
            }

            do {
                var request = URLRequest(url: url)
                request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
                request.timeoutInterval = 12
                request.setValue("no-cache", forHTTPHeaderField: "Cache-Control")
                request.setValue("identity", forHTTPHeaderField: "Accept-Encoding")
                let (bytes, _) = try await URLSession.shared.bytes(for: request)
                var localCount: Int64 = 0
                for try await _ in bytes {
                    if Task.isCancelled { break }
                    localCount += 1
                    if localCount >= 32_768 {
                        await addBytes(localCount)
                        if let delay = await rateLimitDelay(bytes: localCount), delay > 0 {
                            try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
                        }
                        localCount = 0
                    }
                }
                if localCount > 0 {
                    await addBytes(localCount)
                    if let delay = await rateLimitDelay(bytes: localCount), delay > 0 {
                        try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
                    }
                }
            } catch {
                try? await Task.sleep(nanoseconds: 700_000_000)
            }
        }
    }

    @MainActor
    private func addBytes(_ bytes: Int64) {
        guard isRunning, bytes > 0 else { return }
        if let limit = store?.trafficLimitBytes, limit > 0 {
            let remaining = limit - sessionBytes
            guard remaining > 0 else {
                pause()
                statusText = "已达到流量上限"
                return
            }
            let acceptedBytes = min(bytes, remaining)
            sessionBytes += acceptedBytes
            store?.addTotalBytes(acceptedBytes)
            if acceptedBytes < bytes {
                pause()
                statusText = "已达到流量上限"
            }
            return
        }
        sessionBytes += bytes
        store?.addTotalBytes(bytes)
    }

    @MainActor
    private func rateLimitDelay(bytes: Int64) -> TimeInterval? {
        guard isRunning,
              bytes > 0,
              let rateLimitMbps = store?.rateLimitMbps,
              rateLimitMbps > 0 else {
            return nil
        }
        let limitBytesPerSecond = Int64(rateLimitMbps) * 1_000_000 / 8
        guard limitBytesPerSecond > 0 else { return nil }

        let now = Date()
        let elapsed = now.timeIntervalSince(rateWindowStart)
        if elapsed >= 1.0 {
            rateWindowStart = now
            rateWindowBytes = 0
        }

        rateWindowBytes += bytes
        let expectedElapsed = Double(rateWindowBytes) / Double(limitBytesPerSecond)
        let actualElapsed = max(0, Date().timeIntervalSince(rateWindowStart))
        let delay = expectedElapsed - actualElapsed
        return max(0, delay)
    }

    @MainActor
    private func updateRate() {
        let now = Date()
        let elapsed = max(0.1, now.timeIntervalSince(lastRateTime))
        let delta = max(0, sessionBytes - lastRateBytes)
        bytesPerSecond = Int64(Double(delta) / elapsed)
        lastRateBytes = sessionBytes
        lastRateTime = now
    }

    private nonisolated func cacheBuster(_ url: String) -> String {
        let join = url.contains("?") ? "&" : "?"
        return "\(join)np_t=\(Int(Date().timeIntervalSince1970 * 1000))_\(UUID().uuidString)"
    }
}
