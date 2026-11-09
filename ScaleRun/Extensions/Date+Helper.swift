import Foundation

// MARK: - Date 工具扩展
extension Date {

    /// 是否为今天
    var isToday: Bool {
        Calendar.current.isDateInToday(self)
    }

    /// 日期显示文本（周几）
    var weekdayLabel: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        let weekday = Calendar.current.component(.weekday, from: self)
        let labels = ["日", "一", "二", "三", "四", "五", "六"]
        return labels[weekday - 1]
    }

    /// 日期的"今天"标签
    var todayLabel: String {
        isToday ? "今天" : weekdayLabel
    }

    /// 短日期格式 (MM/dd)
    var shortDateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        return formatter.string(from: self)
    }

    /// 时间格式 (HH:mm)
    var timeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self)
    }

    /// 同一天的开始时间
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }

    /// 获取本周的日期数组（周日到周六）
    static func currentWeekDates() -> [Date] {
        let calendar = Calendar.current
        let today = Date()
        guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: today) else {
            return []
        }
        return (0..<7).compactMap {
            calendar.date(byAdding: .day, value: $0, to: weekInterval.start)
        }
    }

    /// 格式化断食时长
    static func formatFastingDuration(hours: Double) -> String {
        let h = Int(hours)
        let m = Int((hours - Double(h)) * 60)
        return String(format: "%d小时%d分钟", h, m)
    }
}
