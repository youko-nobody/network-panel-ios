import SwiftUI

struct ChipButtonStyle: ButtonStyle {
    let theme: AppTheme
    let minWidth: CGFloat
    var minHeight: CGFloat = 46
    var fontSize: CGFloat = 15
    var horizontalPadding: CGFloat = 12

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: fontSize, weight: .heavy))
            .foregroundStyle(theme.primary.color)
            .lineLimit(1)
            .minimumScaleFactor(0.55)
            .frame(minWidth: minWidth, minHeight: minHeight)
            .padding(.horizontal, horizontalPadding)
            .background(RoundedRectangle(cornerRadius: 18, style: .continuous).fill(theme.chip.color).overlay(RoundedRectangle(cornerRadius: 18, style: .continuous).stroke(theme.line.color)))
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
    }
}

struct RunButtonStyle: ButtonStyle {
    let theme: AppTheme
    let running: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(theme.onPrimary.color)
            .background(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(LinearGradient(colors: running ? [Color(hex: "#FF3D5A"), Color(hex: "#FFB14A")] : [theme.primaryStart.color, theme.primaryEnd.color], startPoint: .leading, endPoint: .trailing))
                    .overlay {
                        if running {
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .stroke(Color(hex: "#FFEA9E"), lineWidth: 1)
                                .padding(2)
                        }
                    }
            )
            .scaleEffect(configuration.isPressed ? 0.99 : 1.0)
    }
}
