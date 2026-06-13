import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var store: AppStore
    @EnvironmentObject private var runner: TrafficRunner
    @EnvironmentObject private var latencyMonitor: RegionLatencyMonitor
    @State private var showingSettings = false
    @State private var showingThemes = false
    @State private var showingRoutes = false

    var body: some View {
        let theme = store.currentTheme
        NavigationStack {
            ZStack {
                LinearGradient(colors: [theme.backgroundTop.color, theme.backgroundBottom.color], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 14) {
                        header(theme)
                        SpeedHero(theme: theme)
                        ControlDeck(theme: theme, showingRoutes: $showingRoutes)
                        if latencyMonitor.isChecking || !latencyMonitor.results.isEmpty {
                            RegionLatencyCard(theme: theme)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 24)
                }
            }
            .toolbar(.hidden, for: .navigationBar)
            .sheet(isPresented: $showingSettings) {
                SettingsView()
                    .environmentObject(store)
                    .environmentObject(runner)
                    .environmentObject(latencyMonitor)
            }
            .sheet(isPresented: $showingThemes) {
                ThemePickerView()
                    .environmentObject(store)
            }
            .sheet(isPresented: $showingRoutes) {
                RoutePickerView()
                    .environmentObject(store)
            }
            .task {
                latencyMonitor.start()
            }
            .onDisappear {
                latencyMonitor.stop()
            }
        }
    }

    private func header(_ theme: AppTheme) -> some View {
        HStack(spacing: 10) {
            Text("网络面板")
                .font(.system(size: 24, weight: .heavy))
                .foregroundStyle(theme.text.color)

            Spacer()

            Button(store.currentTheme.name) {
                store.cycleTheme()
            }
            .contextMenu {
                ForEach(AppTheme.all) { option in
                    Button(option.name) {
                        store.selectedThemeID = option.id
                    }
                }
            }
            .buttonStyle(ChipButtonStyle(theme: theme, minWidth: 118))

            Button("设置") {
                showingSettings = true
            }
            .buttonStyle(ChipButtonStyle(theme: theme, minWidth: 58))
        }
        .padding(.top, 14)
    }
}

struct SpeedHero: View {
    @EnvironmentObject private var store: AppStore
    @EnvironmentObject private var runner: TrafficRunner
    let theme: AppTheme

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(LinearGradient(colors: [theme.heroStart.color, theme.heroEnd.color], startPoint: .topLeading, endPoint: .bottomTrailing))
                .overlay(GridOverlay(color: theme.line.color).clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous)))
                .overlay(RoundedRectangle(cornerRadius: 28, style: .continuous).stroke(theme.line.color, lineWidth: 1))

            VStack(spacing: 22) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("线上体感")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundStyle(theme.onPrimary.color)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Capsule().fill(theme.secondary.color))
                        Text("频次、带宽、联通度")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(theme.muted.color)
                    }
                    Spacer()
                    Text(rateLimitText)
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(theme.onPrimary.color)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 9)
                        .background(Capsule().fill(theme.primary.color))
                }

                HStack(alignment: .firstTextBaseline, spacing: 20) {
                    Text(Formatters.megabytesPerSecond(runner.bytesPerSecond))
                        .font(.system(size: 54, weight: .heavy, design: .rounded))
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                        .foregroundStyle(theme.text.color)
                    Rectangle()
                        .fill(theme.line.color)
                        .frame(width: 1, height: 48)
                    Text(Formatters.megabitsPerSecond(runner.bytesPerSecond))
                        .font(.system(size: 18, weight: .bold))
                        .minimumScaleFactor(0.7)
                        .lineLimit(1)
                        .foregroundStyle(theme.muted.color)
                }
                .frame(maxWidth: .infinity)

                HStack(spacing: 0) {
                    MetricValue(title: "总消耗", value: Formatters.bytes(store.totalBytes), theme: theme)
                    Rectangle().fill(theme.line.color).frame(width: 1, height: 56)
                    MetricValue(title: "本次", value: Formatters.bytes(runner.sessionBytes), theme: theme)
                }
                .padding(.vertical, 14)
                .background(RoundedRectangle(cornerRadius: 22, style: .continuous).fill(theme.surface.color).overlay(RoundedRectangle(cornerRadius: 22, style: .continuous).stroke(theme.line.color)))
            }
            .padding(20)
        }
        .frame(minHeight: 340)
    }

    private var rateLimitText: String {
        store.rateLimitMbps > 0 ? "速率上限 \(store.rateLimitMbps) Mbps" : "速率上限 不限"
    }
}

struct ControlDeck: View {
    @EnvironmentObject private var store: AppStore
    @EnvironmentObject private var runner: TrafficRunner
    let theme: AppTheme
    @Binding var showingRoutes: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("控制台")
                    .font(.system(size: 22, weight: .heavy))
                    .foregroundStyle(theme.text.color)
                Spacer()
                Text("一键运行")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(theme.onPrimary.color)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Capsule().fill(theme.secondary.color))
            }

            HStack(spacing: 12) {
                ControlTile(title: "线路", value: store.selectedRoute?.displayName ?? "暂无线路", action: "选择", theme: theme) {
                    showingRoutes = true
                }
                ControlTile(title: "线程", value: "\(store.selectedRoute?.threads ?? 0) 线程", action: "设置", theme: theme) {
                    showingRoutes = true
                }
            }

            Button {
                if runner.isRunning {
                    runner.pause()
                } else if let route = store.selectedRoute {
                    runner.start(route: route, store: store)
                }
            } label: {
                Text(runner.isRunning ? "暂停" : "开始")
                    .font(.system(size: 24, weight: .heavy))
                    .frame(maxWidth: .infinity, minHeight: 72)
            }
            .buttonStyle(RunButtonStyle(theme: theme, running: runner.isRunning))
        }
        .padding(18)
        .background(RoundedRectangle(cornerRadius: 24, style: .continuous).fill(theme.surfaceAlt.color).overlay(RoundedRectangle(cornerRadius: 24, style: .continuous).stroke(theme.line.color)))
    }
}

struct RegionLatencyCard: View {
    @EnvironmentObject private var latencyMonitor: RegionLatencyMonitor
    let theme: AppTheme

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("地区延迟")
                    .font(.system(size: 18, weight: .heavy))
                    .foregroundStyle(theme.text.color)
                Spacer()
                if latencyMonitor.isChecking {
                    ProgressView()
                        .tint(theme.primary.color)
                        .scaleEffect(0.85)
                }
            }

            if latencyMonitor.results.isEmpty && latencyMonitor.isChecking {
                Text("正在检测")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(theme.muted.color)
                    .frame(maxWidth: .infinity, alignment: .leading)
            } else if !latencyMonitor.results.isEmpty {
                VStack(spacing: 10) {
                    ForEach(latencyMonitor.results) { result in
                        LatencyResultRow(result: result, theme: theme)
                    }
                }
            }
        }
        .padding(18)
        .background(RoundedRectangle(cornerRadius: 22, style: .continuous).fill(theme.surface.color).overlay(RoundedRectangle(cornerRadius: 22, style: .continuous).stroke(theme.line.color)))
    }
}

struct LatencyResultRow: View {
    let result: RegionLatencyResult
    let theme: AppTheme

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text(result.label)
                .font(.system(size: 15, weight: .bold))
                .foregroundStyle(theme.text.color)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
            Spacer(minLength: 12)
            Text("\(result.latencyMillis)ms")
                .font(.system(size: 14, weight: .heavy, design: .rounded))
                .foregroundStyle(theme.success.color)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Capsule().fill(theme.success.color.opacity(0.14)).overlay(Capsule().stroke(theme.success.color.opacity(0.35))))
        }
    }
}

struct MetricValue: View {
    let title: String
    let value: String
    let theme: AppTheme

    var body: some View {
        VStack(spacing: 5) {
            Text(title)
                .font(.system(size: 13, weight: .bold))
                .foregroundStyle(theme.muted.color)
            Text(value)
                .font(.system(size: 20, weight: .heavy, design: .rounded))
                .foregroundStyle(theme.text.color)
                .minimumScaleFactor(0.65)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity)
    }
}

struct ControlTile: View {
    let title: String
    let value: String
    let action: String
    let theme: AppTheme
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 18) {
                HStack {
                    Text(title)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(theme.muted.color)
                    Spacer()
                    Text(action)
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(theme.onPrimary.color)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Capsule().fill(theme.primary.color))
                }
                Text(value)
                    .font(.system(size: 26, weight: .heavy))
                    .foregroundStyle(theme.text.color)
                    .frame(maxWidth: .infinity)
                    .lineLimit(1)
                    .minimumScaleFactor(0.55)
            }
            .padding(18)
            .frame(maxWidth: .infinity, minHeight: 132)
            .background(RoundedRectangle(cornerRadius: 22, style: .continuous).fill(theme.surface.color).overlay(RoundedRectangle(cornerRadius: 22, style: .continuous).stroke(theme.line.color)))
        }
        .buttonStyle(.plain)
    }
}

struct GridOverlay: View {
    let color: Color

    var body: some View {
        GeometryReader { proxy in
            Path { path in
                let spacing: CGFloat = 42
                var x: CGFloat = 0
                while x <= proxy.size.width {
                    path.move(to: CGPoint(x: x, y: 0))
                    path.addLine(to: CGPoint(x: x, y: proxy.size.height))
                    x += spacing
                }
                var y: CGFloat = 0
                while y <= proxy.size.height {
                    path.move(to: CGPoint(x: 0, y: y))
                    path.addLine(to: CGPoint(x: proxy.size.width, y: y))
                    y += spacing
                }
            }
            .stroke(color.opacity(0.55), lineWidth: 1)
        }
    }
}
