import SwiftUI

struct ThreadSettingsView: View {
    @EnvironmentObject private var store: AppStore
    @Environment(\.dismiss) private var dismiss
    @State private var threadCount = 4

    var body: some View {
        let theme = store.currentTheme
        NavigationStack {
            ZStack {
                LinearGradient(colors: [theme.backgroundTop.color, theme.backgroundBottom.color], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()

                VStack(spacing: 18) {
                    VStack(spacing: 8) {
                        Text("\(threadCount)")
                            .font(.system(size: 54, weight: .heavy, design: .rounded))
                            .foregroundStyle(theme.text.color)
                        Text("运行线程")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundStyle(theme.muted.color)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(22)
                    .background(RoundedRectangle(cornerRadius: 22, style: .continuous).fill(theme.surface.color).overlay(RoundedRectangle(cornerRadius: 22, style: .continuous).stroke(theme.line.color)))

                    Stepper(value: $threadCount, in: 1...64, step: 1) {
                        Text("线程数")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundStyle(theme.text.color)
                    }
                    .padding(18)
                    .background(RoundedRectangle(cornerRadius: 18, style: .continuous).fill(theme.surface.color).overlay(RoundedRectangle(cornerRadius: 18, style: .continuous).stroke(theme.line.color)))

                    Slider(value: Binding(
                        get: { Double(threadCount) },
                        set: { threadCount = Int($0.rounded()) }
                    ), in: 1...64, step: 1)
                    .tint(theme.primary.color)
                    .padding(.horizontal, 4)

                    Spacer()
                }
                .padding(18)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("取消") { dismiss() }
                        .foregroundStyle(theme.primary.color)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("保存") {
                        store.updateThreadCount(threadCount)
                        dismiss()
                    }
                    .fontWeight(.bold)
                    .foregroundStyle(theme.primary.color)
                }
            }
            .onAppear {
                threadCount = store.threadCount
            }
        }
    }
}
