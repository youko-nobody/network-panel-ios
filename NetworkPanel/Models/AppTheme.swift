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
        AppTheme(id: "night", name: "暗夜蓝", dark: true, backgroundTop: "#0B1220", backgroundBottom: "#111827", surface: "#111827", surfaceAlt: "#172033", text: "#E8EEF7", muted: "#A7B4C7", primary: "#60A5FA", secondary: "#22D3EE", success: "#4ADE80", danger: "#F87171", line: "#27344A", chip: "#172033", heroStart: "#172033", heroEnd: "#101A2C", primaryStart: "#4F46E5", primaryEnd: "#38BDF8", onPrimary: "#F8FAFC"),
        AppTheme(id: "shadow", name: "暖影米棕", dark: false, backgroundTop: "#FBF5EC", backgroundBottom: "#EFE2D2", surface: "#FFFCF6", surfaceAlt: "#F6EBDD", text: "#302B27", muted: "#8E8071", primary: "#B85F3D", secondary: "#56756F", success: "#56756F", danger: "#A8452F", line: "#E4D4C0", chip: "#FFF7EA", heroStart: "#FFF9EE", heroEnd: "#EBD7BD", primaryStart: "#B85F3D", primaryEnd: "#713A2B", onPrimary: "#FFFDF8"),
        AppTheme(id: "pink", name: "樱粉蓝", dark: false, backgroundTop: "#FFF3F6", backgroundBottom: "#EEF5FF", surface: "#FFFFFF", surfaceAlt: "#FBF7FA", text: "#1E293B", muted: "#667085", primary: "#D85C8A", secondary: "#5B8FC9", success: "#4C9F70", danger: "#D95B68", line: "#E7DDE5", chip: "#FFF8FB", heroStart: "#FFFFFF", heroEnd: "#F0F6FF", primaryStart: "#D85C8A", primaryEnd: "#6F9FD8", onPrimary: "#FFFFFF"),
        AppTheme(id: "autumn", name: "秋日落叶", dark: false, backgroundTop: "#FFF7E6", backgroundBottom: "#FDEDD3", surface: "#FFFFFF", surfaceAlt: "#FFF8ED", text: "#2D2218", muted: "#7C6A55", primary: "#B7791F", secondary: "#C0842B", success: "#5F8A45", danger: "#C75A45", line: "#E8D7BE", chip: "#FFF9EB", heroStart: "#FFF1C7", heroEnd: "#F8D98A", primaryStart: "#F6B45C", primaryEnd: "#D98A2B", onPrimary: "#FFFFFF"),
        AppTheme(id: "sea", name: "夏海浅蓝", dark: false, backgroundTop: "#EAFBFF", backgroundBottom: "#DFF7EF", surface: "#FFFFFF", surfaceAlt: "#F2FCFA", text: "#123038", muted: "#5C7880", primary: "#0E7490", secondary: "#0D9488", success: "#16A34A", danger: "#E11D48", line: "#CBEAF0", chip: "#E8F9F7", heroStart: "#CCFBF1", heroEnd: "#BAE6FD", primaryStart: "#06B6D4", primaryEnd: "#14B8A6", onPrimary: "#FFFFFF"),
        AppTheme(id: "tide", name: "深海潮汐", dark: true, backgroundTop: "#061A24", backgroundBottom: "#082F3A", surface: "#0B2430", surfaceAlt: "#103342", text: "#E6FFFB", muted: "#95C9D4", primary: "#22D3EE", secondary: "#2DD4BF", success: "#34D399", danger: "#FB7185", line: "#1B5160", chip: "#113944", heroStart: "#0E7490", heroEnd: "#0F766E", primaryStart: "#06B6D4", primaryEnd: "#2DD4BF", onPrimary: "#ECFEFF"),
        AppTheme(id: "polar", name: "极地蓝", dark: true, backgroundTop: "#07111F", backgroundBottom: "#0E1B2A", surface: "#0F2233", surfaceAlt: "#162C3E", text: "#EAF6FF", muted: "#A9C2D8", primary: "#7DD3FC", secondary: "#A7F3D0", success: "#4ADE80", danger: "#FDA4AF", line: "#27445B", chip: "#172F43", heroStart: "#164E63", heroEnd: "#1D4ED8", primaryStart: "#0EA5E9", primaryEnd: "#22D3EE", onPrimary: "#F8FAFC"),
        AppTheme(id: "dawn", name: "曜石灰绿", dark: true, backgroundTop: "#1C2024", backgroundBottom: "#262D32", surface: "#242A2E", surfaceAlt: "#2E363C", text: "#F9FAFC", muted: "#C6D2D8", primary: "#8DA7B4", secondary: "#9BD8BE", success: "#76D7A5", danger: "#FF8A8A", line: "#3B4044", chip: "#313A40", heroStart: "#2F3B42", heroEnd: "#7190A1", primaryStart: "#8DA7B4", primaryEnd: "#9BD8BE", onPrimary: "#101418"),
        AppTheme(id: "carbon", name: "碳灰青绿", dark: true, backgroundTop: "#0B0F14", backgroundBottom: "#11161D", surface: "#151C22", surfaceAlt: "#1A2128", text: "#E8F0F4", muted: "#9BA8B2", primary: "#2ED7B2", secondary: "#92B8AD", success: "#43C9A0", danger: "#DA6A73", line: "#29343C", chip: "#1A232A", heroStart: "#172028", heroEnd: "#0F141A", primaryStart: "#2ED7B2", primaryEnd: "#59E0C4", onPrimary: "#F4FAFC"),
        AppTheme(id: "graphite", name: "石墨蓝银", dark: true, backgroundTop: "#090D12", backgroundBottom: "#11161D", surface: "#151A21", surfaceAlt: "#1A2028", text: "#E7EDF4", muted: "#A0ACB8", primary: "#6EA8FF", secondary: "#A7BACF", success: "#7DB0FF", danger: "#E2E8F0", line: "#2A3540", chip: "#1B2129", heroStart: "#182029", heroEnd: "#10161D", primaryStart: "#6EA8FF", primaryEnd: "#84B6FF", onPrimary: "#F5F8FC"),
        AppTheme(id: "purple", name: "暗紫电光", dark: true, backgroundTop: "#0A0712", backgroundBottom: "#120D1C", surface: "#171321", surfaceAlt: "#1D182A", text: "#EFEAFB", muted: "#B2A9C6", primary: "#8B7CFF", secondary: "#6E8DFF", success: "#C47CFF", danger: "#F27A92", line: "#2B243E", chip: "#1E192E", heroStart: "#1D1830", heroEnd: "#11101A", primaryStart: "#9A8CFF", primaryEnd: "#7A7CFF", onPrimary: "#F7F3FF"),
        AppTheme(id: "gold", name: "琥珀黑金", dark: true, backgroundTop: "#0D0B09", backgroundBottom: "#15110E", surface: "#1A1712", surfaceAlt: "#201B16", text: "#F5E7C9", muted: "#BFA98A", primary: "#E0A84A", secondary: "#C8A15A", success: "#DCA24B", danger: "#E58E7A", line: "#33281E", chip: "#211B14", heroStart: "#2A231A", heroEnd: "#15110C", primaryStart: "#E0A84A", primaryEnd: "#D9B15A", onPrimary: "#FFF5DD"),
        AppTheme(id: "mint-black", name: "薄荷黑", dark: true, backgroundTop: "#09110F", backgroundBottom: "#101916", surface: "#121B18", surfaceAlt: "#17211D", text: "#E5FBF5", muted: "#A3CDBF", primary: "#63E6C7", secondary: "#86DCC8", success: "#4CBD9E", danger: "#DF6B7A", line: "#23312D", chip: "#17231F", heroStart: "#17241F", heroEnd: "#0F1613", primaryStart: "#63E6C7", primaryEnd: "#7EEAD1", onPrimary: "#F3FFFB"),
        AppTheme(id: "mist", name: "雾蓝灰", dark: true, backgroundTop: "#0C1117", backgroundBottom: "#111720", surface: "#151B22", surfaceAlt: "#1A212A", text: "#EAF0F6", muted: "#A9B9C7", primary: "#8DB8D8", secondary: "#9DB3CA", success: "#4BB7A7", danger: "#DC6B77", line: "#27323E", chip: "#17202A", heroStart: "#18212B", heroEnd: "#10161C", primaryStart: "#8DB8D8", primaryEnd: "#A5C9E6", onPrimary: "#F5FAFE"),
        AppTheme(id: "wine", name: "酒红黑", dark: true, backgroundTop: "#10090B", backgroundBottom: "#161013", surface: "#1A1214", surfaceAlt: "#20171A", text: "#F3E7EA", muted: "#B79BA5", primary: "#D46B7A", secondary: "#A58AA0", success: "#C96C7E", danger: "#E58C8C", line: "#2F2328", chip: "#22181D", heroStart: "#27171B", heroEnd: "#140E11", primaryStart: "#D46B7A", primaryEnd: "#C05F6C", onPrimary: "#FAF0F2")
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
