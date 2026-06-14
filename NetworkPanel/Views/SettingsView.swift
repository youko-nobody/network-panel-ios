import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var store: AppStore
    @EnvironmentObject private var runner: TrafficRunner
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        let theme = store.currentTheme
        NavigationStack {
            ZStack {
                LinearGradient(colors: [theme.backgroundTop.color, theme.backgroundBottom.color], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                Form {
                    Section("运行") {
                        Toggle("增强并发", isOn: $store.enhancedConcurrency)
                        Stepper(value: Binding(
                            get: { store.threadCount },
                            set: { store.updateThreadCount($0) }
                        ), in: 1...64, step: 1) {
                            Text("线程数 \(store.threadCount)")
                        }
                        Stepper("速率上限 \(store.rateLimitMbps == 0 ? "不限" : "\(store.rateLimitMbps) Mbps")", value: $store.rateLimitMbps, in: 0...10000, step: 10)
                    }

                    Section("流量") {
                        Text("累计流量 \(Formatters.bytes(store.totalBytes))")
                        Button("清零累计流量") {
                            store.resetTotalBytes()
                        }
                        Button("清零本次流量") {
                            runner.resetSession()
                        }
                    }

                    Section("软件介绍") {
                        Text("网络面板用于实时查看网络速率、统计数据用量、管理测试线路，并辅助观察地区延迟和连接质量。iPadOS 支持横屏、分屏和多窗口场景。后台持续能力会受系统策略、电量模式和网络环境影响。")
                            .font(.footnote)
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("设置")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("关闭") { dismiss() }
                }
            }
            .tint(theme.primary.color)
        }
    }
}
