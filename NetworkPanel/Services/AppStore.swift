import Foundation
import Combine

@MainActor
final class AppStore: ObservableObject {
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

    var currentTheme: AppTheme {
        AppTheme.all.first { $0.id == selectedThemeID } ?? AppTheme.all[0]
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

    func cycleTheme() {
        let currentIndex = AppTheme.all.firstIndex { $0.id == selectedThemeID } ?? 0
        selectedThemeID = AppTheme.all[(currentIndex + 1) % AppTheme.all.count].id
    }

    func select(route: TrafficRoute) {
        selectedRouteID = route.id
    }

    func addRoute(name: String, url: String) {
        let route = TrafficRoute(name: name, url: url)
        routes.append(route)
        selectedRouteID = route.id
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
