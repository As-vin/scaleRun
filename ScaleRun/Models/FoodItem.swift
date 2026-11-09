import Foundation
import SwiftData

/// 食物条目模型
@Model
final class FoodItem {
    var id: UUID
    var name: String
    var weight: Double          // 克
    var calories: Double        // kcal
    var protein: Double         // g
    var carbohydrates: Double   // g
    var fat: Double             // g
    var imageName: String       // 食物图片资源名
    var stickerName: String     // 贴纸资源名
    var createdAt: Date

    @Relationship(inverse: \MealRecord.foodItems)
    var mealRecord: MealRecord?

    init(
        id: UUID = UUID(),
        name: String,
        weight: Double,
        calories: Double,
        protein: Double = 0,
        carbohydrates: Double = 0,
        fat: Double = 0,
        imageName: String = "food_placeholder",
        stickerName: String = "",
        createdAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.weight = weight
        self.calories = calories
        self.protein = protein
        self.carbohydrates = carbohydrates
        self.fat = fat
        self.imageName = imageName
        self.stickerName = stickerName
        self.createdAt = createdAt
    }
}
