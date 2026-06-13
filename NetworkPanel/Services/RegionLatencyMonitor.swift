import Foundation
import Combine

struct RegionLatencyResult: Identifiable, Equatable, Sendable {
    enum Kind: Sendable {
        case domestic
        case foreign
    }

    let kind: Kind
    let label: String
    let latencyMillis: Int

    var id: String {
        switch kind {
        case .domestic:
            return "domestic"
        case .foreign:
            return "foreign"
        }
    }
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

    private func fetchIPInfo(ip: String?) async -> IPInfoData? {
        var urlString = ipInfoURL
        if let ip, let encoded = ip.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            urlString += "?ip=\(encoded)"
        }
        guard let result = await fetchText(urlString: urlString, method: "GET", timeout: 3.5),
              let data = result.body.data(using: .utf8),
              let root = try? JSONDecoder().decode(IPInfoResponse.self, from: data) else {
            return nil
        }
        return root.data
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

    private func countryCode(_ info: IPInfoData) -> String {
        info.country?.code ?? ""
    }

    private func buildLabel(info: IPInfoData, foreign: Bool) -> String {
        var parts: [String] = []
        if foreign {
            append(info.country?.name, to: &parts)
        }
        if !appendArray(info.regionsShort, to: &parts) {
            _ = appendArray(info.regions, to: &parts)
        }
        append(info.asInfo?.info, to: &parts)
        append(info.asInfo?.name, to: &parts)
        return parts.prefix(3).joined(separator: " ")
    }

    @discardableResult
    private func appendArray(_ values: [String]?, to parts: inout [String]) -> Bool {
        guard let values else { return false }
        let before = parts.count
        for item in values {
            append(item, to: &parts)
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

private struct IPInfoResponse: Decodable, Sendable {
    let data: IPInfoData?
}

private struct IPInfoData: Decodable, Sendable {
    let country: IPInfoCountry?
    let regions: [String]?
    let regionsShort: [String]?
    let asInfo: IPInfoAS?

    enum CodingKeys: String, CodingKey {
        case country
        case regions
        case regionsShort = "regions_short"
        case asInfo = "as"
    }
}

private struct IPInfoCountry: Decodable, Sendable {
    let code: String?
    let name: String?
}

private struct IPInfoAS: Decodable, Sendable {
    let name: String?
    let info: String?
}
