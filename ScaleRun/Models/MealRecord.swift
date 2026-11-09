import Foundation
import SwiftData

/// 餐次类型
enum MealType: String, Codable, CaseIterable {
    case breakfast = "早餐"
    case lunch = "午餐"
    case dinner = "晚餐"
    case snack = "加餐"

    var iconName: String {
        switch self {
        case .breakfast: return "applelogo"
        case .lunch:     return "fork.knife"
        case .dinner:    return "moon.stars.fill"
        case .snack:     return "cup.and.saucer.fill"
        }
    }

    /// 默认热量目标占比
    var defaultCalorieRatio: Double {
        switch self {
        case .breakfast: return 0.30
        case .lunch:     return 0.40
        case .dinner:    return 0.25
        case .snack:     return 0.05
        }
    }
}

/// 餐次记录模型
@Model
final class MealRecord {
    var id: UUID
    var mealTypeRaw: String
    var date: Date
    var totalCalories: Double
    var note: String

    @Relationship(deleteRule: .cascade, inverse: \FoodItem.mealRecord)
    var foodItems: [FoodItem] = []

    var mealType: MealType {
        get { MealType(rawValue: mealTypeRaw) ?? .breakfast }
        set { mealTypeRaw = newValue.rawValue }
    }

    init(
        id: UUID = UUID(),
        mealType: MealType,
        date: Date = Date(),
        totalCalories: Double = 0,
        note: String = ""
    ) {
        self.id = id
        self.mealTypeRaw = mealType.rawValue
        self.date = date
        self.totalCalories = totalCalories
        self.note = note
    }
}
