import SwiftUI

struct RateLimitView: View {
    @EnvironmentObject private var store: AppStore
    @Environment(\.dismiss) private var dismiss
    @State private var value = ""

    var body: some View {
        LimitInputPage(
            title: "速率上限",
            subtitle: "输入 Mbps，填 0 或留空表示不限。",
            placeholder: "例如 100",
            unitOptions: ["Mbps"],
            selectedUnit: .constant(0),
            value: $value,
            theme: store.currentTheme,
            onSave: {
                store.rateLimitMbps = max(0, Int(value.trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0)
                dismiss()
            },
            onCancel: { dismiss() }
        )
        .onAppear {
            value = store.rateLimitMbps > 0 ? String(store.rateLimitMbps) : ""
        }
    }
}

struct TrafficLimitView: View {
    @EnvironmentObject private var store: AppStore
    @Environment(\.dismiss) private var dismiss
    @State private var value = ""
    @State private var unitIndex = 1

    private let units = ["MB", "GB", "TB"]

    var body: some View {
        LimitInputPage(
            title: "本次流量上限",
            subtitle: "设置本次最多消耗的流量，填 0 或留空表示不限。",
            placeholder: "例如 10",
            unitOptions: units,
            selectedUnit: $unitIndex,
            value: $value,
            theme: store.currentTheme,
            onSave: {
                let amount = Double(value.trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0
                store.trafficLimitBytes = bytes(amount: amount, unitIndex: unitIndex)
                dismiss()
            },
            onCancel: { dismiss() }
        )
        .onAppear {
            let current = store.trafficLimitBytes
            guard current > 0 else {
                value = ""
                unitIndex = 1
                return
            }
            let gb = Double(current) / 1024.0 / 1024.0 / 1024.0
            if gb >= 1024 {
                unitIndex = 2
                value = cleanNumber(gb / 1024.0)
            } else if gb >= 1 {
                unitIndex = 1
                value = cleanNumber(gb)
            } else {
                unitIndex = 0
                value = cleanNumber(Double(current) / 1024.0 / 1024.0)
            }
        }
    }

    private func bytes(amount: Double, unitIndex: Int) -> Int64 {
        guard amount > 0 else { return 0 }
        let multiplier: Double
        switch unitIndex {
        case 2:
            multiplier = 1024 * 1024 * 1024 * 1024
        case 1:
            multiplier = 1024 * 1024 * 1024
        default:
            multiplier = 1024 * 1024
        }
        return Int64(amount * multiplier)
    }

    private func cleanNumber(_ value: Double) -> String {
        if value.rounded() == value {
            return String(Int(value))
        }
        return String(format: "%.2f", value)
    }
}

private struct LimitInputPage: View {
    let title: String
    let subtitle: String
    let placeholder: String
    let unitOptions: [String]
    @Binding var selectedUnit: Int
    @Binding var value: String
    let theme: AppTheme
    let onSave: () -> Void
    let onCancel: () -> Void

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [theme.backgroundTop.color, theme.backgroundBottom.color], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()

                VStack(alignment: .leading, spacing: 18) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(title)
                            .font(.system(size: 26, weight: .heavy))
                            .foregroundStyle(theme.text.color)
                        Text(subtitle)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(theme.muted.color)
                    }

                    VStack(spacing: 14) {
                        TextField(placeholder, text: $value)
                            .keyboardType(.decimalPad)
                            .font(.system(size: 28, weight: .heavy, design: .rounded))
                            .foregroundStyle(theme.text.color)
                            .padding(18)
                            .background(RoundedRectangle(cornerRadius: 20, style: .continuous).fill(theme.surface.color).overlay(RoundedRectangle(cornerRadius: 20, style: .continuous).stroke(theme.line.color)))

                        if unitOptions.count > 1 {
                            HStack(spacing: 10) {
                                ForEach(unitOptions.indices, id: \.self) { index in
                                    Button(unitOptions[index]) {
                                        selectedUnit = index
                                    }
                                    .font(.system(size: 15, weight: .heavy))
                                    .foregroundStyle(index == selectedUnit ? theme.onPrimary.color : theme.text.color)
                                    .frame(maxWidth: .infinity, minHeight: 44)
                                    .background(RoundedRectangle(cornerRadius: 16, style: .continuous).fill(index == selectedUnit ? theme.primary.color : theme.surface.color).overlay(RoundedRectangle(cornerRadius: 16, style: .continuous).stroke(theme.line.color)))
                                }
                            }
                        }
                    }

                    Spacer()
                }
                .padding(18)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("取消", action: onCancel)
                        .foregroundStyle(theme.primary.color)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("保存", action: onSave)
                        .fontWeight(.bold)
                        .foregroundStyle(theme.primary.color)
                }
            }
        }
    }
}
