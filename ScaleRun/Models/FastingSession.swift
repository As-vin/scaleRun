import Foundation
import SwiftData

/// 断食会话模型
@Model
final class FastingSession {
    var id: UUID
    var startDate: Date
    var endDate: Date?
    var plannedDuration: Double   // 计划断食时长（小时）
    var planType: String          // "16:8", "18:6", "20:4", "custom"
    var isCompleted: Bool
    var note: String

    init(
        id: UUID = UUID(),
        startDate: Date = Date(),
        endDate: Date? = nil,
        plannedDuration: Double = 16,
        planType: String = "16:8",
        isCompleted: Bool = false,
        note: String = ""
    ) {
        self.id = id
        self.startDate = startDate
        self.endDate = endDate
        self.plannedDuration = plannedDuration
        self.planType = planType
        self.isCompleted = isCompleted
        self.note = note
    }

    /// 当前已断食时长（小时）
    var elapsedHours: Double {
        let end = endDate ?? Date()
        return end.timeIntervalSince(startDate) / 3600
    }

    /// 剩余断食时长（小时）
    var remainingHours: Double {
        max(0, plannedDuration - elapsedHours)
    }

    /// 进度 0~1
    var progress: Double {
        min(1.0, elapsedHours / plannedDuration)
    }
}
