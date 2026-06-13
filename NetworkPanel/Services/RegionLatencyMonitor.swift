import Foundation
import Combine

struct RegionLatencyResult: Identifiable, Equatable, Sendable {
    enum Kind: Sendable {
        case domestic
        case foreign
    }

    let id = UUID()
    let kind: Kind
    let label: String
    let latencyMillis: Int
}

@MainActor
final class RegionLatencyMonitor: ObservableObject {
    @Published private(set) var results: [RegionLatencyResult] = []
    @Published private(set) var isChecking = false

    private let ipInfoURL = "https://app.netart.cn/network-panel/ip.ajax"
    private let domesticURL = "https://connectivitycheck.platform.hicloud.com/generate_204"
    private let cloudflareTraceURL = "https://cp.cloudflare.com/cdn-cgi/trace"
    private var refreshTask: Task<Void, Never>?

    func start() {
        guard refreshTask == nil else { return }
        refreshTask = Task { [weak self] in
            await self?.refresh()
            while !Task.isCancelled {
                try? await Task.sleep(nanoseconds: 30_000_000_000)
                await self?.refresh()
            }
        }
    }

    func stop() {
        refreshTask?.cancel()
        refreshTask = nil
    }

    func refresh() async {
        guard !isChecking else { return }
        isChecking = true
        let domestic = await queryDomesticLatency()
        let foreign = await queryForeignLatency()
        results = [domestic, foreign].compactMap { $0 }
        isChecking = false
    }

    private func queryDomesticLatency() async -> RegionLatencyResult? {
        guard let latency = await measureLatency(urlString: domesticURL, method: "HEAD", timeout: 2.5),
              let info = await fetchIPInfo(ip: nil),
              countryCode(info).uppercased() == "CN" else {
            return nil
        }
        let label = buildLabel(info: info, foreign: false)
        guard !label.isEmpty else { return nil }
        return RegionLatencyResult(kind: .domestic, label: label, latencyMillis: latency)
    }

    private func queryForeignLatency() async -> RegionLatencyResult? {
        guard let trace = await fetchText(urlString: cloudflareTraceURL, method: "GET", timeout: 3.5),
              let ip = parseTrace(trace.body, key: "ip"),
              let info = await fetchIPInfo(ip: ip),
              countryCode(info).uppercased() != "CN" else {
            return nil
        }
        let label = buildLabel(info: info, foreign: true)
        guard !label.isEmpty else { return nil }
        return RegionLatencyResult(kind: .foreign, label: label, latencyMillis: trace.latencyMillis)
    }

    private func fetchIPInfo(ip: String?) async -> [String: Any]? {
        var urlString = ipInfoURL
        if let ip, let encoded = ip.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            urlString += "?ip=\(encoded)"
        }
        guard let result = await fetchText(urlString: urlString, method: "GET", timeout: 3.5),
              let data = result.body.data(using: .utf8),
              let root = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            return nil
        }
        return root["data"] as? [String: Any]
    }

    private func measureLatency(urlString: String, method: String, timeout: TimeInterval) async -> Int? {
        guard let url = URL(string: urlString) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.timeoutInterval = timeout
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        let start = Date()
        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            guard (response as? HTTPURLResponse)?.statusCode != nil else { return nil }
            return max(1, Int(Date().timeIntervalSince(start) * 1000))
        } catch {
            return nil
        }
    }

    private func fetchText(urlString: String, method: String, timeout: TimeInterval) async -> (latencyMillis: Int, body: String)? {
        guard let url = URL(string: urlString) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.timeoutInterval = timeout
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        let start = Date()
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard (response as? HTTPURLResponse)?.statusCode != nil,
                  let body = String(data: data, encoding: .utf8) else {
                return nil
            }
            return (max(1, Int(Date().timeIntervalSince(start) * 1000)), body)
        } catch {
            return nil
        }
    }

    private func parseTrace(_ body: String, key: String) -> String? {
        let prefix = "\(key)="
        return body
            .split(whereSeparator: \.isNewline)
            .first { $0.hasPrefix(prefix) }?
            .dropFirst(prefix.count)
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private func countryCode(_ info: [String: Any]) -> String {
        (info["country"] as? [String: Any])?["code"] as? String ?? ""
    }

    private func buildLabel(info: [String: Any], foreign: Bool) -> String {
        var parts: [String] = []
        if foreign, let country = info["country"] as? [String: Any] {
            append(country["name"] as? String, to: &parts)
        }
        if !appendArray(info["regions_short"], to: &parts) {
            _ = appendArray(info["regions"], to: &parts)
        }
        if let asInfo = info["as"] as? [String: Any] {
            append(asInfo["info"] as? String, to: &parts)
            append(asInfo["name"] as? String, to: &parts)
        }
        return parts.prefix(3).joined(separator: " ")
    }

    @discardableResult
    private func appendArray(_ value: Any?, to parts: inout [String]) -> Bool {
        guard let values = value as? [Any] else { return false }
        let before = parts.count
        for item in values {
            append(item as? String, to: &parts)
        }
        return parts.count > before
    }

    private func append(_ value: String?, to parts: inout [String]) {
        guard let value = value?.trimmingCharacters(in: .whitespacesAndNewlines),
              !value.isEmpty,
              !parts.contains(value) else {
            return
        }
        parts.append(value)
    }
}
