import SwiftUI

@main
struct NetworkPanelApp: App {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var store = AppStore()
    @StateObject private var runner = TrafficRunner()
    @StateObject private var latencyMonitor = RegionLatencyMonitor()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
                .environmentObject(runner)
                .environmentObject(latencyMonitor)
                .preferredColorScheme(store.currentTheme.dark ? .dark : .light)
                .onChange(of: scenePhase) { _, phase in
                    if phase != .active {
                        runner.pause()
                    }
                }
        }
    }
}
