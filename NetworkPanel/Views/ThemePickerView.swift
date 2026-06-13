import SwiftUI

struct ThemePickerView: View {
    @EnvironmentObject private var store: AppStore
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        let theme = store.currentTheme
        NavigationStack {
            ZStack {
                LinearGradient(colors: [theme.backgroundTop.color, theme.backgroundBottom.color], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(AppTheme.all) { option in
                            Button {
                                store.selectedThemeID = option.id
                                dismiss()
                            } label: {
                                HStack(spacing: 14) {
                                    Circle()
                                        .fill(option.primary.color)
                                        .frame(width: 18, height: 18)
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(option.name)
                                            .font(.system(size: 17, weight: .heavy))
                                            .foregroundStyle(theme.text.color)
                                        Text(option.dark ? "深色专业风" : "浅色清爽风")
                                            .font(.system(size: 13, weight: .semibold))
                                            .foregroundStyle(theme.muted.color)
                                    }
                                    Spacer()
                                    if option.id == store.selectedThemeID {
                                        Text("当前")
                                            .font(.system(size: 13, weight: .bold))
                                            .foregroundStyle(theme.primary.color)
                                    }
                                }
                                .padding(16)
                                .background(RoundedRectangle(cornerRadius: 18, style: .continuous).fill(theme.surface.color).overlay(RoundedRectangle(cornerRadius: 18, style: .continuous).stroke(option.id == store.selectedThemeID ? theme.primary.color : theme.line.color)))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(16)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("关闭") { dismiss() }
                }
            }
        }
    }
}
