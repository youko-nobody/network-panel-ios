import Foundation
import SwiftUI

struct AppTheme: Identifiable, Codable, Equatable {
    static let timeflowID = "timeflow"
    static let timeflowFixedPrefix = "timeflow-fixed-"

    var id: String
    var name: String
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
        AppTheme(id: "wine", name: "酒红黑", dark: true, backgroundTop: "#10090B", backgroundBottom: "#161013", surface: "#1A1214", surfaceAlt: "#20171A", text: "#F3E7EA", muted: "#B79BA5", primary: "#D46B7A", secondary: "#A58AA0", success: "#C96C7E", danger: "#E58C8C", line: "#2F2328", chip: "#22181D", heroStart: "#27171B", heroEnd: "#140E11", primaryStart: "#D46B7A", primaryEnd: "#C05F6C", onPrimary: "#FAF0F2"),
        AppTheme(id: timeflowID, name: "时景流转", dark: true, backgroundTop: "#121A33", backgroundBottom: "#27204A", surface: "#1D2540", surfaceAlt: "#26304D", text: "#EEF3FF", muted: "#AEB8D8", primary: "#7FA6FF", secondary: "#C38CFF", success: "#72D5C7", danger: "#F1859F", line: "#344063", chip: "#273352", heroStart: "#22305A", heroEnd: "#2C234D", primaryStart: "#7FA6FF", primaryEnd: "#C38CFF", onPrimary: "#F5F8FF")
    ] + timeflowFixedOptions

    static func resolved(id: String, date: Date = Date()) -> AppTheme {
        if id == timeflowID {
            return timeflowTheme(date: date)
        }
        if let slot = timeflowFixedSlot(id: id) {
            return timeflowTheme(slot: slot)
        }
        return all.first { $0.id == id } ?? all[0]
    }

    static func isTimeflowFixed(id: String) -> Bool {
        timeflowFixedSlot(id: id) != nil
    }

    static var primaryOptions: [AppTheme] {
        all.filter { !isTimeflowFixed(id: $0.id) }
    }

    static var fixedTimeflowOptions: [AppTheme] {
        timeflowFixedOptions
    }

    static func timeflowSlot(date: Date = Date()) -> Int {
        return Calendar.current.component(.hour, from: date)
    }

    static func timeflowTheme(date: Date = Date()) -> AppTheme {
        return timeflowTheme(slot: timeflowSlot(date: date))
    }

    static func timeflowTheme(slot: Int) -> AppTheme {
        switch slot {
        case 0:
            return timeflowPalette("子夜", true, "#020617", "#08111F", "#0B1220", "#111827", "#E2E8F0", "#94A3B8", "#818CF8", "#38BDF8", "#5EEAD4", "#FB7185", "#1E293B", "#111C2E", "#111D34", "#050B16", "#818CF8", "#38BDF8", "#F8FAFC")
        case 1:
            return timeflowPalette("星河", true, "#05051A", "#101335", "#12172B", "#1A2140", "#EEF2FF", "#A5B4FC", "#A78BFA", "#60A5FA", "#67E8F9", "#F472B6", "#2A315C", "#1C2448", "#1C2454", "#090B24", "#A78BFA", "#60A5FA", "#F8FAFC")
        case 2:
            return timeflowPalette("静夜", true, "#06101F", "#0D1B2A", "#111B2A", "#17263A", "#E8F3FF", "#9CB3C9", "#4F7BFF", "#22D3EE", "#65D6B6", "#F1798E", "#253A52", "#17283A", "#162C46", "#0B1526", "#4F7BFF", "#22D3EE", "#F6FBFF")
        case 3:
            return timeflowPalette("月隐", true, "#030712", "#111827", "#101827", "#1A2436", "#DDE7F5", "#94A3B8", "#9CA3AF", "#60A5FA", "#67D6B6", "#E4819B", "#273449", "#121C2C", "#0F1A2B", "#08111F", "#9CA3AF", "#60A5FA", "#F2F6FF")
        case 4:
            return timeflowPalette("破晓", true, "#141827", "#2B2444", "#20283A", "#2B3348", "#F3EEFF", "#C4B5FD", "#C4B5FD", "#F0A7B8", "#88D0C5", "#F49AB2", "#453D63", "#2A334B", "#252B4B", "#332543", "#C4B5FD", "#F0A7B8", "#F8F7FF")
        case 5:
            return timeflowPalette("黎明", true, "#111827", "#2D2744", "#20283A", "#263046", "#EEF2FF", "#B8C0D9", "#AEB7FF", "#F0A7B8", "#88D0C5", "#F49AB2", "#343E5A", "#2A334B", "#252B4B", "#332543", "#AEB7FF", "#F0A7B8", "#F6F7FF")
        case 6:
            return timeflowPalette("日出", false, "#FFF1E6", "#FFD5A8", "#FFF8F0", "#FFF0DC", "#30231B", "#806452", "#E88945", "#FFB36B", "#6FA46A", "#C65F4C", "#E8CFB5", "#FFF4E8", "#FFE8BF", "#FFD194", "#FFB36B", "#E88945", "#FFFFFF")
        case 7:
            return timeflowPalette("晨光", false, "#FFF7D6", "#DDF8E9", "#FFFFF8", "#F2FAEF", "#27301F", "#6D7454", "#D9A441", "#82B86E", "#4FA66F", "#C7655C", "#E4E3BE", "#FFF9DE", "#FFF3BC", "#DCF4D0", "#D9A441", "#82B86E", "#FFFFFF")
        case 8:
            return timeflowPalette("清晨", false, "#EEF8EC", "#DCEFD8", "#FBFFF8", "#F2FAEF", "#203020", "#62745B", "#77A96B", "#A7C987", "#4FA66F", "#C7655C", "#D7E9D2", "#F1FAEE", "#E5F5DF", "#D7EECF", "#A7C987", "#77A96B", "#FFFFFF")
        case 9:
            return timeflowPalette("青晨", false, "#EAFBF4", "#D8F1E8", "#FFFFFF", "#F0FBF7", "#14342F", "#557872", "#14B8A6", "#8DD8C5", "#2FAE8C", "#D95B68", "#C6E9E0", "#E8F9F7", "#D7F4EC", "#C4EFE5", "#14B8A6", "#66C7B4", "#FFFFFF")
        case 10:
            return timeflowPalette("晴空", false, "#EAF7FF", "#D5ECFF", "#FFFFFF", "#F1F9FF", "#163047", "#5A7891", "#3D9CEB", "#7BC7FF", "#2FAE8C", "#D95B68", "#C9E1F2", "#EDF8FF", "#DCF2FF", "#BFE6FF", "#7BC7FF", "#3D9CEB", "#FFFFFF")
        case 11:
            return timeflowPalette("明昼", false, "#E6F4FF", "#FFFCEB", "#FFFFFF", "#F8FCFF", "#1E293B", "#64748B", "#0EA5E9", "#FACC15", "#22C55E", "#EF4444", "#D7E7F2", "#F0F9FF", "#DFF4FF", "#FFF5B8", "#0EA5E9", "#FACC15", "#FFFFFF")
        case 12:
            return timeflowPalette("正午", false, "#FFFBE8", "#EAF6FF", "#FFFFFF", "#FBFCF4", "#252A32", "#72746B", "#E5B94E", "#58A6FF", "#46A56D", "#D96B59", "#E8DFC2", "#FFF9DE", "#FFF5C9", "#DFF2FF", "#E5B94E", "#58A6FF", "#FFFFFF")
        case 13:
            return timeflowPalette("金午", false, "#FFF4D6", "#FFE1A8", "#FFF9F0", "#FFF1DE", "#332819", "#82653F", "#F59E0B", "#EAB308", "#65A30D", "#DC2626", "#EAD3A7", "#FFF6DE", "#FFE8A3", "#FFD27A", "#F59E0B", "#D97706", "#FFFFFF")
        case 14:
            return timeflowPalette("午后", false, "#FFF1DD", "#F6D6B1", "#FFF9F2", "#FDF0E2", "#34251A", "#80624C", "#D98242", "#B96A3C", "#698F55", "#B85B49", "#E6CFB8", "#FFF3E6", "#FFE6BD", "#F3C999", "#D98242", "#B96A3C", "#FFFDF8")
        case 15:
            return timeflowPalette("暖阳", false, "#FFE9D6", "#F8C9A2", "#FFF8F1", "#FCEADA", "#392418", "#865B42", "#EA7A3D", "#C45635", "#6B8E50", "#B94E46", "#E7C8B1", "#FFF0E4", "#FFD7B8", "#F2B486", "#EA7A3D", "#9F4A2E", "#FFFDF8")
        case 16:
            return timeflowPalette("斜阳", false, "#FFE2D2", "#DDB7D5", "#FFF5F2", "#F7E5EA", "#35202B", "#7D5B6A", "#C75F5F", "#B06FD3", "#6FA06F", "#B84F5A", "#E1C4CE", "#FFF0F2", "#FFD0C4", "#E3B3DF", "#C75F5F", "#9A5AD0", "#FFFFFF")
        case 17:
            return timeflowPalette("黄昏", true, "#21192B", "#3A2238", "#2B2335", "#342A3E", "#FFF1E8", "#D5B9C6", "#D99A73", "#A98BFF", "#7ED4B5", "#F27A92", "#463750", "#372B42", "#3E2B44", "#2A1F3B", "#D99A73", "#A98BFF", "#FFF8F2")
        case 18:
            return timeflowPalette("暮光", true, "#121A33", "#27204A", "#1D2540", "#26304D", "#EEF3FF", "#AEB8D8", "#7FA6FF", "#C38CFF", "#72D5C7", "#F1859F", "#344063", "#273352", "#22305A", "#2C234D", "#7FA6FF", "#C38CFF", "#F5F8FF")
        case 19:
            return timeflowPalette("蓝暮", true, "#0B1530", "#1C2855", "#162142", "#212E55", "#EEF3FF", "#A8B8E8", "#5B8CFF", "#9B8CFF", "#5EEAD4", "#F1859F", "#31406D", "#202B50", "#1A2A58", "#211D4D", "#5B8CFF", "#9B8CFF", "#F5F8FF")
        case 20:
            return timeflowPalette("夜蓝", true, "#08111F", "#101D30", "#111C2A", "#172436", "#E8F3FF", "#9BB2C9", "#5EA8FF", "#7DD3FC", "#65D6B6", "#F1798E", "#24364B", "#17283A", "#162C46", "#0F1B2E", "#5EA8FF", "#7DD3FC", "#F6FBFF")
        case 21:
            return timeflowPalette("深蓝", true, "#050B18", "#0B1A2E", "#0E1828", "#142338", "#E6F0FF", "#8EA7C3", "#2563EB", "#38BDF8", "#63D2B0", "#ED7F9B", "#1C3148", "#132238", "#102846", "#071426", "#2563EB", "#38BDF8", "#F5F8FF")
        case 22:
            return timeflowPalette("深夜", true, "#050914", "#0B1220", "#101827", "#151F31", "#E6EDFF", "#9CA9C0", "#4F7BFF", "#5AD7FF", "#63D2B0", "#ED7F9B", "#202B40", "#151E2D", "#111D34", "#08101E", "#4F7BFF", "#5AD7FF", "#F5F8FF")
        default:
            return timeflowPalette("午夜", true, "#030712", "#08101C", "#0E1624", "#121C2C", "#DDE7F5", "#909EB0", "#9CA3AF", "#60A5FA", "#67D6B6", "#E4819B", "#1E293B", "#121C2C", "#0F1A2B", "#08111F", "#9CA3AF", "#60A5FA", "#F2F6FF")
        }
    }

    private static func timeflowPalette(_ name: String, _ dark: Bool, _ backgroundTop: String, _ backgroundBottom: String, _ surface: String, _ surfaceAlt: String, _ text: String, _ muted: String, _ primary: String, _ secondary: String, _ success: String, _ danger: String, _ line: String, _ chip: String, _ heroStart: String, _ heroEnd: String, _ primaryStart: String, _ primaryEnd: String, _ onPrimary: String) -> AppTheme {
        AppTheme(id: timeflowID, name: name, dark: dark, backgroundTop: backgroundTop, backgroundBottom: backgroundBottom, surface: surface, surfaceAlt: surfaceAlt, text: text, muted: muted, primary: primary, secondary: secondary, success: success, danger: danger, line: line, chip: chip, heroStart: heroStart, heroEnd: heroEnd, primaryStart: primaryStart, primaryEnd: primaryEnd, onPrimary: onPrimary)
    }

    private static var timeflowFixedOptions: [AppTheme] {
        (0..<24).map { slot in
            var theme = timeflowTheme(slot: slot)
            theme.id = timeflowFixedID(slot)
            theme.name = timeflowFixedName(slot)
            return theme
        }
    }

    private static func timeflowFixedID(_ slot: Int) -> String {
        "\(timeflowFixedPrefix)\(String(format: "%02d", slot))"
    }

    private static func timeflowFixedSlot(id: String) -> Int? {
        guard id.hasPrefix(timeflowFixedPrefix) else { return nil }
        let raw = String(id.dropFirst(timeflowFixedPrefix.count))
        guard let slot = Int(raw), slot >= 0, slot < 24 else { return nil }
        return slot
    }

    private static func timeflowFixedName(_ slot: Int) -> String {
        "时景 \(String(format: "%02d", slot)) \(timeflowTheme(slot: slot).name)"
    }

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
