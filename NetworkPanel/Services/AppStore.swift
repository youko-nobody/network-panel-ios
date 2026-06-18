import Foundation
import Combine

struct RouteImportResult: Equatable {
    let imported: Int
    let skipped: Int

    var message: String {
        if imported > 0 {
            return "已导入 \(imported) 条，跳过 \(skipped) 条。"
        }
        return "没有可导入的节点，跳过 \(skipped) 条。"
    }
}

@MainActor
final class AppStore: ObservableObject {
    private static let httpURLRegex = try! NSRegularExpression(pattern: #"https?://[^\s，,|]+"#, options: [.caseInsensitive])
    private static let importTokenRegex = try! NSRegularExpression(pattern: #"[^ \t\r\n，,|]+"#, options: [])
    private static let nameTrimCharacters = CharacterSet(charactersIn: ",，|:：-").union(.whitespacesAndNewlines)
    private static let urlTrimCharacters = CharacterSet(charactersIn: "\"'()[]<>.,;，。；")
    private static let defaultRoute = TrafficRoute(
        name: "移动云盘",
        url: "https://yun.mcloud.139.com/hongseyunpan/2.43G.zip",
        threads: 4
    )

    @Published var routes: [TrafficRoute] = [] {
        didSet { saveRoutes() }
    }
    @Published var selectedRouteID: UUID? {
        didSet { saveSelectedRoute() }
    }
    @Published var selectedThemeID: String = AppTheme.all[0].id {
        didSet { UserDefaults.standard.set(selectedThemeID, forKey: Keys.themeID) }
    }
    @Published var enhancedConcurrency = true {
        didSet { UserDefaults.standard.set(enhancedConcurrency, forKey: Keys.enhancedConcurrency) }
    }
    @Published var threadCount: Int = 4 {
        didSet { UserDefaults.standard.set(Self.clampedThreads(threadCount), forKey: Keys.threadCount) }
    }
    @Published var trafficLimitBytes: Int64 = 0 {
        didSet { UserDefaults.standard.set(trafficLimitBytes, forKey: Keys.trafficLimitBytes) }
    }
    @Published var rateLimitMbps: Int = 0 {
        didSet { UserDefaults.standard.set(rateLimitMbps, forKey: Keys.rateLimitMbps) }
    }
    @Published var totalBytes: Int64 = 0 {
        didSet { UserDefaults.standard.set(totalBytes, forKey: Keys.totalBytes) }
    }
    @Published private var themeMinuteTick: Int = 0

    var currentTheme: AppTheme {
        _ = themeMinuteTick
        return AppTheme.resolved(id: selectedThemeID)
    }

    var selectedThemeName: String {
        AppTheme.all.first { $0.id == selectedThemeID }?.name ?? AppTheme.all[0].name
    }

    var selectedRoute: TrafficRoute? {
        if let id = selectedRouteID, let route = routes.first(where: { $0.id == id }) {
            return route
        }
        return routes.first
    }

    init() {
        load()
    }

    func refreshDynamicTheme() {
        guard selectedThemeID == AppTheme.timeflowID else { return }
        themeMinuteTick += 1
    }

    func cycleTheme() {
        let currentIndex = AppTheme.all.firstIndex { $0.id == selectedThemeID } ?? 0
        selectedThemeID = AppTheme.all[(currentIndex + 1) % AppTheme.all.count].id
    }

    func select(route: TrafficRoute) {
        selectedRouteID = route.id
        threadCount = Self.clampedThreads(route.threads)
    }

    @discardableResult
    func addRoute(name: String, url: String) -> TrafficRoute {
        let route = TrafficRoute(name: name, url: url)
        routes.append(route)
        selectedRouteID = route.id
        threadCount = Self.clampedThreads(route.threads)
        return route
    }

    func importRoutes(from rawText: String) -> RouteImportResult {
        let lines = rawText.components(separatedBy: .newlines)
        guard lines.contains(where: { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }) else {
            return RouteImportResult(imported: 0, skipped: 0)
        }

        let wasEmpty = routes.isEmpty
        var imported = 0
        var skipped = 0
        var importedFirstID: UUID?
        var updatedRoutes = routes
        var knownURLs = Set(routes.map { Self.duplicateURLKey($0.normalizedURL) }.filter { !$0.isEmpty })

        for line in lines {
            guard let parsed = Self.parseImportLine(line, fallbackIndex: imported + skipped + 1) else {
                if !line.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    skipped += 1
                }
                continue
            }

            let key = Self.duplicateURLKey(parsed.url)
            guard !key.isEmpty, !knownURLs.contains(key) else {
                skipped += 1
                continue
            }

            let route = TrafficRoute(name: parsed.name, url: parsed.url, threads: threadCount, enabled: true)
            updatedRoutes.append(route)
            knownURLs.insert(key)
            importedFirstID = importedFirstID ?? route.id
            imported += 1
        }

        if imported > 0 {
            routes = updatedRoutes
            if wasEmpty {
                selectedRouteID = importedFirstID
            }
        }

        return RouteImportResult(imported: imported, skipped: skipped)
    }

    func updateRoute(_ route: TrafficRoute) {
        guard let index = routes.firstIndex(where: { $0.id == route.id }) else { return }
        var updatedRoutes = routes
        updatedRoutes[index] = route
        routes = updatedRoutes
        if selectedRouteID == route.id {
            threadCount = Self.clampedThreads(route.threads)
        }
    }

    func updateSelectedRouteThreads(_ threads: Int) {
        updateThreadCount(threads)
    }

    func updateThreadCount(_ threads: Int) {
        let clamped = Self.clampedThreads(threads)
        threadCount = clamped
        guard let route = selectedRoute,
              let index = routes.firstIndex(where: { $0.id == route.id }) else { return }
        var updatedRoute = route
        updatedRoute.threads = clamped
        var updatedRoutes = routes
        updatedRoutes[index] = updatedRoute
        routes = updatedRoutes
        selectedRouteID = updatedRoute.id
    }

    func deleteRoute(_ route: TrafficRoute) {
        routes.removeAll { $0.id == route.id }
        if selectedRouteID == route.id {
            selectedRouteID = routes.first?.id
            if let route = selectedRoute {
                threadCount = Self.clampedThreads(route.threads)
            }
        }
    }

    func addTotalBytes(_ bytes: Int64) {
        guard bytes > 0 else { return }
        totalBytes += bytes
    }

    func resetTotalBytes() {
        totalBytes = 0
    }

    private func load() {
        selectedThemeID = UserDefaults.standard.string(forKey: Keys.themeID) ?? AppTheme.all[0].id
        enhancedConcurrency = UserDefaults.standard.object(forKey: Keys.enhancedConcurrency) as? Bool ?? true
        trafficLimitBytes = (UserDefaults.standard.object(forKey: Keys.trafficLimitBytes) as? NSNumber)?.int64Value ?? 0
        rateLimitMbps = UserDefaults.standard.integer(forKey: Keys.rateLimitMbps)
        totalBytes = (UserDefaults.standard.object(forKey: Keys.totalBytes) as? NSNumber)?.int64Value ?? 0

        if let data = UserDefaults.standard.data(forKey: Keys.routes),
           let decoded = try? JSONDecoder().decode([TrafficRoute].self, from: data) {
            routes = decoded
        }
        if routes.isEmpty || isLegacyDefaultOnly(routes) {
            routes = [Self.defaultRoute]
        }
        if let selectedString = UserDefaults.standard.string(forKey: Keys.selectedRouteID),
           let id = UUID(uuidString: selectedString),
           routes.contains(where: { $0.id == id }) {
            selectedRouteID = id
        } else {
            selectedRouteID = routes.first?.id
        }

        let savedThreads = UserDefaults.standard.object(forKey: Keys.threadCount) as? Int
        threadCount = Self.clampedThreads(savedThreads ?? selectedRoute?.threads ?? Self.defaultRoute.threads)
    }

    private func saveRoutes() {
        guard let data = try? JSONEncoder().encode(routes) else { return }
        UserDefaults.standard.set(data, forKey: Keys.routes)
    }

    private func saveSelectedRoute() {
        UserDefaults.standard.set(selectedRouteID?.uuidString, forKey: Keys.selectedRouteID)
    }

    private func isLegacyDefaultOnly(_ routes: [TrafficRoute]) -> Bool {
        guard routes.count == 1, let route = routes.first else { return false }
        return route.name == "Cloudflare" && route.url.contains("speed.cloudflare.com")
    }

    private static func clampedThreads(_ value: Int) -> Int {
        max(1, min(64, value))
    }

    private static func parseImportLine(_ line: String, fallbackIndex: Int) -> ParsedImportRoute? {
        let trimmed = line.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }

        let fullRange = NSRange(trimmed.startIndex..<trimmed.endIndex, in: trimmed)
        var rawURL = ""
        var urlRange: Range<String.Index>?

        if let match = httpURLRegex.firstMatch(in: trimmed, range: fullRange),
           let range = Range(match.range, in: trimmed) {
            rawURL = String(trimmed[range])
            urlRange = range
        } else {
            let matches = importTokenRegex.matches(in: trimmed, range: fullRange)
            for match in matches {
                guard let range = Range(match.range, in: trimmed) else { continue }
                let candidate = trimURLToken(String(trimmed[range]))
                if looksLikeURLCandidate(candidate) {
                    rawURL = candidate
                    urlRange = range
                    break
                }
            }
        }

        let url = normalizeImportURL(rawURL)
        guard !url.isEmpty, let urlRange else { return nil }

        let before = String(trimmed[..<urlRange.lowerBound])
        let after = String(trimmed[urlRange.upperBound...])
        let preferredName = before.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? after : before
        let name = cleanImportName(preferredName)

        return ParsedImportRoute(
            name: name.isEmpty ? importHostName(from: url, fallbackIndex: fallbackIndex) : name,
            url: url
        )
    }

    private static func looksLikeURLCandidate(_ value: String) -> Bool {
        let lower = value.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !lower.isEmpty else { return false }
        if lower.hasPrefix("http://") || lower.hasPrefix("https://") {
            return true
        }
        return lower.contains(".")
            && (lower.hasPrefix("www.")
                || lower.contains("/")
                || lower.range(of: #"[a-z]"#, options: .regularExpression) != nil)
    }

    private static func normalizeImportURL(_ value: String) -> String {
        var trimmed = trimURLToken(value)
        guard !trimmed.isEmpty else { return "" }

        let lower = trimmed.lowercased()
        if !lower.hasPrefix("http://") && !lower.hasPrefix("https://") {
            trimmed = "https://\(trimmed)"
        }

        guard let components = URLComponents(string: trimmed),
              let scheme = components.scheme?.lowercased(),
              scheme == "http" || scheme == "https",
              let host = components.host,
              !host.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              let url = components.url else {
            return ""
        }
        return url.absoluteString
    }

    private static func duplicateURLKey(_ value: String) -> String {
        normalizeImportURL(value).lowercased()
    }

    private static func cleanImportName(_ value: String) -> String {
        var name = value.trimmingCharacters(in: nameTrimCharacters)
        if (name.hasPrefix("\"") && name.hasSuffix("\"")) || (name.hasPrefix("'") && name.hasSuffix("'")) {
            name = String(name.dropFirst().dropLast()).trimmingCharacters(in: nameTrimCharacters)
        }
        return name
    }

    private static func trimURLToken(_ value: String) -> String {
        value.trimmingCharacters(in: .whitespacesAndNewlines)
            .trimmingCharacters(in: urlTrimCharacters)
    }

    private static func importHostName(from url: String, fallbackIndex: Int) -> String {
        guard var host = URL(string: url)?.host, !host.isEmpty else {
            return "导入节点 \(max(1, fallbackIndex))"
        }
        if host.lowercased().hasPrefix("www.") {
            host.removeFirst(4)
        }
        return host
    }

    private struct ParsedImportRoute {
        let name: String
        let url: String
    }

    private enum Keys {
        static let routes = "routes"
        static let selectedRouteID = "selected_route_id"
        static let themeID = "theme_id"
        static let enhancedConcurrency = "enhanced_concurrency"
        static let threadCount = "thread_count"
        static let trafficLimitBytes = "traffic_limit_bytes"
        static let rateLimitMbps = "rate_limit_mbps"
        static let totalBytes = "total_bytes"
    }
}
