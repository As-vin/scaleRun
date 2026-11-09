import Foundation
import SwiftData

/// 饮水记录模型
@Model
final class WaterRecord {
    var id: UUID
    var amount: Double      // ml
    var date: Date

    init(
        id: UUID = UUID(),
        amount: Double,
        date: Date = Date()
    ) {
        self.id = id
        self.amount = amount
        self.date = date
    }
}
