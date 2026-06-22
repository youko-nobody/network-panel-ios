import SwiftUI

struct ThemePickerView: View {
    @EnvironmentObject private var store: AppStore
    @Environment(\.dismiss) private var dismiss
    @State private var showingFixedTimeflow = false

    var body: some View {
        let theme = store.currentTheme
        NavigationStack {
            ZStack {
                LinearGradient(colors: [theme.backgroundTop.color, theme.backgroundBottom.color], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(AppTheme.primaryOptions) { option in
                            themeButton(option, theme: theme, dismissAfterSelect: true)
                        }
                        timeflowManualButton(theme: theme)
                    }
                    .padding(16)
                }
            }
            .navigationDestination(isPresented: $showingFixedTimeflow) {
                TimeflowFixedThemePickerView {
                    dismiss()
                }
                    .environmentObject(store)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("关闭") { dismiss() }
                }
            }
        }
    }

    private func timeflowManualButton(theme: AppTheme) -> some View {
        Button {
            showingFixedTimeflow = true
        } label: {
            HStack(spacing: 14) {
                Circle()
                    .fill((store.selectedThemeID == AppTheme.timeflowID || AppTheme.isTimeflowFixed(id: store.selectedThemeID) ? store.currentTheme.primary : AppTheme.timeflowTheme(slot: 18).primary).color)
                    .frame(width: 18, height: 18)
                VStack(alignment: .leading, spacing: 4) {
                    Text("时景手动")
                        .font(.system(size: 17, weight: .heavy))
                        .foregroundStyle(theme.text.color)
                    Text(AppTheme.isTimeflowFixed(id: store.selectedThemeID) ? "\(store.selectedThemeName) · 固定小时配色" : "选择 00-23 小时固定配色")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(theme.muted.color)
                }
                Spacer()
                if AppTheme.isTimeflowFixed(id: store.selectedThemeID) {
                    Text("当前")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(theme.primary.color)
                }
                Text("›")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(theme.muted.color)
            }
            .padding(16)
            .background(RoundedRectangle(cornerRadius: 18, style: .continuous).fill(theme.surface.color).overlay(RoundedRectangle(cornerRadius: 18, style: .continuous).stroke(AppTheme.isTimeflowFixed(id: store.selectedThemeID) ? theme.primary.color : theme.line.color)))
        }
        .buttonStyle(.plain)
    }

    private func themeButton(_ option: AppTheme, theme: AppTheme, dismissAfterSelect: Bool) -> some View {
        Button {
            store.selectedThemeID = option.id
            if dismissAfterSelect {
                dismiss()
            }
        } label: {
            ThemeOptionRow(option: option, selected: option.id == store.selectedThemeID, detail: themeDescription(option), theme: theme)
        }
        .buttonStyle(.plain)
    }

    private func themeDescription(_ option: AppTheme) -> String {
        if option.id == AppTheme.timeflowID {
            return "24 小时逐时自动流转"
        }
        if AppTheme.isTimeflowFixed(id: option.id) {
            return "固定使用该小时配色，不随时间变化"
        }
        return option.dark ? "深色专业风" : "浅色清爽风"
    }
}

private struct TimeflowFixedThemePickerView: View {
    @EnvironmentObject private var store: AppStore
    @Environment(\.dismiss) private var dismiss
    let onSelect: () -> Void

    var body: some View {
        let theme = store.currentTheme
        ZStack {
            LinearGradient(colors: [theme.backgroundTop.color, theme.backgroundBottom.color], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(AppTheme.fixedTimeflowOptions) { option in
                        Button {
                            store.selectedThemeID = option.id
                            onSelect()
                        } label: {
                            ThemeOptionRow(option: option, selected: option.id == store.selectedThemeID, detail: "固定使用该小时配色，不随时间变化", theme: theme)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(16)
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("关闭") { dismiss() }
            }
        }
    }
}

private struct ThemeOptionRow: View {
    let option: AppTheme
    let selected: Bool
    let detail: String
    let theme: AppTheme

    var body: some View {
        HStack(spacing: 14) {
            Circle()
                .fill(option.primary.color)
                .frame(width: 18, height: 18)
            VStack(alignment: .leading, spacing: 4) {
                Text(option.name)
                    .font(.system(size: 17, weight: .heavy))
                    .foregroundStyle(theme.text.color)
                Text(detail)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(theme.muted.color)
            }
            Spacer()
            if selected {
                Text("当前")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(theme.primary.color)
            }
        }
        .padding(16)
        .background(RoundedRectangle(cornerRadius: 18, style: .continuous).fill(theme.surface.color).overlay(RoundedRectangle(cornerRadius: 18, style: .continuous).stroke(selected ? theme.primary.color : theme.line.color)))
    }
}
