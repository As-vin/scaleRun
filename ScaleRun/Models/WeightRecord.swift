import Foundation
import SwiftData

/// 体重记录模型
@Model
final class WeightRecord {
    var id: UUID
    var weight: Double      // kg
    var date: Date
    var note: String

    init(
        id: UUID = UUID(),
        weight: Double,
        date: Date = Date(),
        note: String = ""
    ) {
        self.id = id
        self.weight = weight
        self.date = date
        self.note = note
    }
}
