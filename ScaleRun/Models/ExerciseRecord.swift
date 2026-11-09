import Foundation
import SwiftData

/// 运动记录模型
@Model
final class ExerciseRecord {
    var id: UUID
    var name: String
    var duration: Double      // 分钟
    var caloriesBurned: Double // kcal
    var date: Date
    var source: String        // "manual" / "healthkit"

    init(
        id: UUID = UUID(),
        name: String,
        duration: Double,
        caloriesBurned: Double,
        date: Date = Date(),
        source: String = "manual"
    ) {
        self.id = id
        self.name = name
        self.duration = duration
        self.caloriesBurned = caloriesBurned
        self.date = date
        self.source = source
    }
}
