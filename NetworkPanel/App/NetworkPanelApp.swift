import SwiftUI

@main
struct NetworkPanelApp: App {
    @StateObject private var store = AppStore()
    @StateObject private var runner = TrafficRunner()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
                .environmentObject(runner)
                .preferredColorScheme(store.currentTheme.dark ? .dark : .light)
        }
    }
}
