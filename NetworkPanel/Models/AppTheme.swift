import SwiftUI

struct AppTheme: Identifiable, Codable, Equatable {
    static let timeflowID = "timeflow"

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
        AppTheme(id: "wine", name: "酒红黑", dark: true, backgroundTop: "#10090B", backgroundBottom: "#161013", surface: "#1A1214", surfaceAlt: "#20171A", text: "#F3E7EA", muted: "#B79BA5", primary: "#D46B7A", secondary: "#A58AA0", success: "#C96C7E", danger: "#E58C8C", line: "#2F2328", chip: "#22181D", heroStart: "#27171B", heroEnd: "#140E11", primaryStart: "#D46B7A", primaryEnd: "#C05F6C", onPrimary: "#FAF0F2"),
        AppTheme(id: timeflowID, name: "时景流转", dark: true, backgroundTop: "#121A33", backgroundBottom: "#27204A", surface: "#1D2540", surfaceAlt: "#26304D", text: "#EEF3FF", muted: "#AEB8D8", primary: "#7FA6FF", secondary: "#C38CFF", success: "#72D5C7", danger: "#F1859F", line: "#344063", chip: "#273352", heroStart: "#22305A", heroEnd: "#2C234D", primaryStart: "#7FA6FF", primaryEnd: "#C38CFF", onPrimary: "#F5F8FF")
    ]

    static func resolved(id: String, date: Date = Date()) -> AppTheme {
        if id == timeflowID {
            return timeflowTheme(date: date)
        }
        return all.first { $0.id == id } ?? all[0]
    }

    static func timeflowSlot(date: Date = Date()) -> Int {
        let hour = Calendar.current.component(.hour, from: date)
        if hour >= 4 && hour < 6 { return 0 }
        if hour >= 6 && hour < 8 { return 1 }
        if hour >= 8 && hour < 10 { return 2 }
        if hour >= 10 && hour < 12 { return 3 }
        if hour >= 12 && hour < 13 { return 4 }
        if hour >= 13 && hour < 16 { return 5 }
        if hour >= 16 && hour < 18 { return 6 }
        if hour >= 18 && hour < 20 { return 7 }
        if hour >= 20 && hour < 22 { return 8 }
        if hour >= 22 { return 9 }
        return 10
    }

    static func timeflowTheme(date: Date = Date()) -> AppTheme {
        switch timeflowSlot(date: date) {
        case 0:
            return AppTheme(id: timeflowID, name: "黎明", dark: true, backgroundTop: "#111827", backgroundBottom: "#1E2540", surface: "#20283A", surfaceAlt: "#263046", text: "#EEF2FF", muted: "#B8C0D9", primary: "#AEB7FF", secondary: "#F0A7B8", success: "#88D0C5", danger: "#F49AB2", line: "#343E5A", chip: "#2A334B", heroStart: "#252B4B", heroEnd: "#332543", primaryStart: "#AEB7FF", primaryEnd: "#F0A7B8", onPrimary: "#F6F7FF")
        case 1:
            return AppTheme(id: timeflowID, name: "日出", dark: false, backgroundTop: "#FFF3E6", backgroundBottom: "#FFE0B8", surface: "#FFF9F1", surfaceAlt: "#FFF2E2", text: "#30231B", muted: "#806452", primary: "#E88945", secondary: "#FFB36B", success: "#6FA46A", danger: "#C65F4C", line: "#E8CFB5", chip: "#FFF4E8", heroStart: "#FFE8BF", heroEnd: "#FFD194", primaryStart: "#FFB36B", primaryEnd: "#E88945", onPrimary: "#FFFFFF")
        case 2:
            return AppTheme(id: timeflowID, name: "清晨", dark: false, backgroundTop: "#EEF8EC", backgroundBottom: "#DCEFD8", surface: "#FBFFF8", surfaceAlt: "#F2FAEF", text: "#203020", muted: "#62745B", primary: "#77A96B", secondary: "#A7C987", success: "#4FA66F", danger: "#C7655C", line: "#D7E9D2", chip: "#F1FAEE", heroStart: "#E5F5DF", heroEnd: "#D7EECF", primaryStart: "#A7C987", primaryEnd: "#77A96B", onPrimary: "#FFFFFF")
        case 3:
            return AppTheme(id: timeflowID, name: "上午", dark: false, backgroundTop: "#EAF7FF", backgroundBottom: "#D5ECFF", surface: "#FFFFFF", surfaceAlt: "#F1F9FF", text: "#163047", muted: "#5A7891", primary: "#3D9CEB", secondary: "#7BC7FF", success: "#2FAE8C", danger: "#D95B68", line: "#C9E1F2", chip: "#EDF8FF", heroStart: "#DCF2FF", heroEnd: "#BFE6FF", primaryStart: "#7BC7FF", primaryEnd: "#3D9CEB", onPrimary: "#FFFFFF")
        case 4:
            return AppTheme(id: timeflowID, name: "正午", dark: false, backgroundTop: "#FFFBE8", backgroundBottom: "#EAF6FF", surface: "#FFFFFF", surfaceAlt: "#FBFCF4", text: "#252A32", muted: "#72746B", primary: "#E5B94E", secondary: "#58A6FF", success: "#46A56D", danger: "#D96B59", line: "#E8DFC2", chip: "#FFF9DE", heroStart: "#FFF5C9", heroEnd: "#DFF2FF", primaryStart: "#E5B94E", primaryEnd: "#58A6FF", onPrimary: "#FFFFFF")
        case 5:
            return AppTheme(id: timeflowID, name: "午后", dark: false, backgroundTop: "#FFF1DD", backgroundBottom: "#F6D6B1", surface: "#FFF9F2", surfaceAlt: "#FDF0E2", text: "#34251A", muted: "#80624C", primary: "#D98242", secondary: "#B96A3C", success: "#698F55", danger: "#B85B49", line: "#E6CFB8", chip: "#FFF3E6", heroStart: "#FFE6BD", heroEnd: "#F3C999", primaryStart: "#D98242", primaryEnd: "#B96A3C", onPrimary: "#FFFDF8")
        case 6:
            return AppTheme(id: timeflowID, name: "黄昏", dark: true, backgroundTop: "#21192B", backgroundBottom: "#3A2238", surface: "#2B2335", surfaceAlt: "#342A3E", text: "#FFF1E8", muted: "#D5B9C6", primary: "#D99A73", secondary: "#A98BFF", success: "#7ED4B5", danger: "#F27A92", line: "#463750", chip: "#372B42", heroStart: "#3E2B44", heroEnd: "#2A1F3B", primaryStart: "#D99A73", primaryEnd: "#A98BFF", onPrimary: "#FFF8F2")
        case 7:
            return AppTheme(id: timeflowID, name: "暮光", dark: true, backgroundTop: "#121A33", backgroundBottom: "#27204A", surface: "#1D2540", surfaceAlt: "#26304D", text: "#EEF3FF", muted: "#AEB8D8", primary: "#7FA6FF", secondary: "#C38CFF", success: "#72D5C7", danger: "#F1859F", line: "#344063", chip: "#273352", heroStart: "#22305A", heroEnd: "#2C234D", primaryStart: "#7FA6FF", primaryEnd: "#C38CFF", onPrimary: "#F5F8FF")
        case 8:
            return AppTheme(id: timeflowID, name: "夜晚", dark: true, backgroundTop: "#08111F", backgroundBottom: "#101D30", surface: "#111C2A", surfaceAlt: "#172436", text: "#E8F3FF", muted: "#9BB2C9", primary: "#5EA8FF", secondary: "#7DD3FC", success: "#65D6B6", danger: "#F1798E", line: "#24364B", chip: "#17283A", heroStart: "#162C46", heroEnd: "#0F1B2E", primaryStart: "#5EA8FF", primaryEnd: "#7DD3FC", onPrimary: "#F6FBFF")
        case 9:
            return AppTheme(id: timeflowID, name: "深夜", dark: true, backgroundTop: "#050914", backgroundBottom: "#0B1220", surface: "#101827", surfaceAlt: "#151F31", text: "#E6EDFF", muted: "#9CA9C0", primary: "#4F7BFF", secondary: "#5AD7FF", success: "#63D2B0", danger: "#ED7F9B", line: "#202B40", chip: "#151E2D", heroStart: "#111D34", heroEnd: "#08101E", primaryStart: "#4F7BFF", primaryEnd: "#5AD7FF", onPrimary: "#F5F8FF")
        default:
            return AppTheme(id: timeflowID, name: "午夜", dark: true, backgroundTop: "#030712", backgroundBottom: "#08101C", surface: "#0E1624", surfaceAlt: "#121C2C", text: "#DDE7F5", muted: "#909EB0", primary: "#9CA3AF", secondary: "#60A5FA", success: "#67D6B6", danger: "#E4819B", line: "#1E293B", chip: "#121C2C", heroStart: "#0F1A2B", heroEnd: "#08111F", primaryStart: "#9CA3AF", primaryEnd: "#60A5FA", onPrimary: "#F2F6FF")
        }
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
