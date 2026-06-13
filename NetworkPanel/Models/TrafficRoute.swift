import Foundation

struct TrafficRoute: Identifiable, Codable, Equatable, Sendable {
    var id: UUID
    var name: String
    var url: String
    var threads: Int
    var enabled: Bool

    init(id: UUID = UUID(), name: String, url: String, threads: Int = 4, enabled: Bool = true) {
        self.id = id
        self.name = name
        self.url = url
        self.threads = max(1, min(64, threads))
        self.enabled = enabled
    }

    var displayName: String {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmed.isEmpty {
            return trimmed
        }
        guard let host = URL(string: normalizedURL)?.host, !host.isEmpty else {
            return "未命名线路"
        }
        return host
    }

    var normalizedURL: String {
        let trimmed = url.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.lowercased().hasPrefix("http://") || trimmed.lowercased().hasPrefix("https://") {
            return trimmed
        }
        return "https://\(trimmed)"
    }
}
