import SwiftUI

struct AppTheme: Identifiable, Codable, Equatable {
    let id: String
    let name: String
    let dark: Bool
    let backgroundTop: ColorValue
    let backgroundBottom: ColorValue
    let surface: ColorValue
    let surfaceAlt: ColorValue
    let text: ColorValue
    let muted: ColorValue
    let primary: ColorValue
    let secondary: ColorValue
    let success: ColorValue
    let danger: ColorValue
    let line: ColorValue
    let chip: ColorValue
    let heroStart: ColorValue
    let heroEnd: ColorValue
    let primaryStart: ColorValue
    let primaryEnd: ColorValue
    let onPrimary: ColorValue

    static let all: [AppTheme] = [
        AppTheme(id: "glacier", name: "冰川蓝", dark: false, backgroundTop: "#F3FAFF", backgroundBottom: "#E6F0FF", surface: "#FFFFFF", surfaceAlt: "#F7FBFF", text: "#102A43", muted: "#627D98", primary: "#2563EB", secondary: "#0891B2", success: "#059669", danger: "#DC2626", line: "#D8E7F8", chip: "#EEF7FF", heroStart: "#DBEAFE", heroEnd: "#E0F2FE", primaryStart: "#3B82F6", primaryEnd: "#06B6D4", onPrimary: "#FFFFFF"),
        AppTheme(id: "night", name: "暗夜", dark: true, backgroundTop: "#0B1220", backgroundBottom: "#111827", surface: "#111827", surfaceAlt: "#172033", text: "#E8EEF7", muted: "#A7B4C7", primary: "#60A5FA", secondary: "#22D3EE", success: "#4ADE80", danger: "#F87171", line: "#27344A", chip: "#172033", heroStart: "#172033", heroEnd: "#101A2C", primaryStart: "#4F46E5", primaryEnd: "#38BDF8", onPrimary: "#F8FAFC"),
        AppTheme(id: "mint-black", name: "薄荷黑", dark: true, backgroundTop: "#09110F", backgroundBottom: "#101916", surface: "#121B18", surfaceAlt: "#17211D", text: "#E5FBF5", muted: "#A3CDBF", primary: "#63E6C7", secondary: "#86DCC8", success: "#4CBD9E", danger: "#DF6B7A", line: "#23312D", chip: "#17231F", heroStart: "#17241F", heroEnd: "#0F1613", primaryStart: "#63E6C7", primaryEnd: "#7EEAD1", onPrimary: "#F3FFFB"),
        AppTheme(id: "graphite", name: "石墨蓝银", dark: true, backgroundTop: "#090D12", backgroundBottom: "#11161D", surface: "#151A21", surfaceAlt: "#1A2028", text: "#E7EDF4", muted: "#A0ACB8", primary: "#6EA8FF", secondary: "#A7BACF", success: "#7DB0FF", danger: "#E2E8F0", line: "#2A3540", chip: "#1B2129", heroStart: "#182029", heroEnd: "#10161D", primaryStart: "#6EA8FF", primaryEnd: "#84B6FF", onPrimary: "#F5F8FC")
    ]

    init(id: String, name: String, dark: Bool, backgroundTop: String, backgroundBottom: String, surface: String, surfaceAlt: String, text: String, muted: String, primary: String, secondary: String, success: String, danger: String, line: String, chip: String, heroStart: String, heroEnd: String, primaryStart: String, primaryEnd: String, onPrimary: String) {
        self.id = id
        self.name = name
        self.dark = dark
        self.backgroundTop = ColorValue(backgroundTop)
        self.backgroundBottom = ColorValue(backgroundBottom)
        self.surface = ColorValue(surface)
        self.surfaceAlt = ColorValue(surfaceAlt)
        self.text = ColorValue(text)
        self.muted = ColorValue(muted)
        self.primary = ColorValue(primary)
        self.secondary = ColorValue(secondary)
        self.success = ColorValue(success)
        self.danger = ColorValue(danger)
        self.line = ColorValue(line)
        self.chip = ColorValue(chip)
        self.heroStart = ColorValue(heroStart)
        self.heroEnd = ColorValue(heroEnd)
        self.primaryStart = ColorValue(primaryStart)
        self.primaryEnd = ColorValue(primaryEnd)
        self.onPrimary = ColorValue(onPrimary)
    }
}

struct ColorValue: Codable, Equatable {
    let hex: String

    init(_ hex: String) {
        self.hex = hex
    }

    var color: Color {
        Color(hex: hex)
    }
}

extension Color {
    init(hex: String) {
        let sanitized = hex.trimmingCharacters(in: CharacterSet(charactersIn: "#"))
        var value: UInt64 = 0
        Scanner(string: sanitized).scanHexInt64(&value)
        let red = Double((value >> 16) & 0xFF) / 255.0
        let green = Double((value >> 8) & 0xFF) / 255.0
        let blue = Double(value & 0xFF) / 255.0
        self.init(red: red, green: green, blue: blue)
    }
}
