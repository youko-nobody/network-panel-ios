import SwiftUI
import UIKit

@main
struct NetworkPanelApp: App {
    @StateObject private var store = AppStore()
    @StateObject private var runner = TrafficRunner()
    @StateObject private var latencyMonitor = RegionLatencyMonitor()
    @Environment(\.scenePhase) private var scenePhase

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
                .environmentObject(runner)
                .environmentObject(latencyMonitor)
                .preferredColorScheme(store.currentTheme.dark ? .dark : .light)
        }
        .onChange(of: scenePhase) { phase in
            UIApplication.shared.isIdleTimerDisabled = phase == .active
        }
    }
}
