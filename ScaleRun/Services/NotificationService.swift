import Foundation
import UserNotifications

/// 本地通知服务
class NotificationService {
    static let shared = NotificationService()

    /// 请求通知权限
    func requestAuthorization() async {
        let center = UNUserNotificationCenter.current()
        _ = try? await center.requestAuthorization(options: [.alert, .badge, .sound])
    }

    /// 安排断食结束提醒
    func scheduleFastingEndReminder(hours: Double) {
        let content = UNMutableNotificationContent()
        content.title = "断食结束啦！"
        content.body = "你已经完成了 \(Int(hours)) 小时断食，可以开始进食了"
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: hours * 3600,
            repeats: false
        )

        let request = UNNotificationRequest(
            identifier: "fasting_end_\(UUID().uuidString)",
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request)
    }

    /// 安排每日饮食记录提醒
    func scheduleDailyMealReminder(hour: Int = 12, minute: Int = 0) {
        let content = UNMutableNotificationContent()
        content.title = "该记录饮食了"
        content.body = "别忘了记录今天的饮食，保持热量平衡"
        content.sound = .default

        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute

        let trigger = UNCalendarNotificationTrigger(
            dateMatching: dateComponents,
            repeats: true
        )

        let request = UNNotificationRequest(
            identifier: "daily_meal_reminder",
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request)
    }

    /// 取消所有通知
    func cancelAll() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
