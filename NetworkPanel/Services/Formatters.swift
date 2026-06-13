import Foundation

enum Formatters {
    static func bytes(_ value: Int64) -> String {
        let units = ["B", "KB", "MB", "GB", "TB"]
        var amount = Double(max(0, value))
        var unitIndex = 0
        while amount >= 1024 && unitIndex < units.count - 1 {
            amount /= 1024
            unitIndex += 1
        }
        if unitIndex == 0 {
            return "\(Int(amount)) \(units[unitIndex])"
        }
        return String(format: "%.2f %@", amount, units[unitIndex])
    }

    static func megabytesPerSecond(_ bytesPerSecond: Int64) -> String {
        String(format: "%.2f MB/s", Double(max(0, bytesPerSecond)) / 1024.0 / 1024.0)
    }

    static func megabitsPerSecond(_ bytesPerSecond: Int64) -> String {
        String(format: "%.2f Mbps", Double(max(0, bytesPerSecond)) * 8.0 / 1_000_000.0)
    }
}
