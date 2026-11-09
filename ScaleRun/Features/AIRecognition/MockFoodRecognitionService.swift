import Foundation
import UIKit

/// 模拟食物识别服务（开发调试用）
enum MockFoodRecognitionService {

    /// 模拟识别结果
    static func recognize(image: UIImage) -> [FoodItem] {
        // 随机返回一组模拟食物数据
        let mockFoods: [[FoodItem]] = [
            [
                FoodItem(name: "茶叶蛋", weight: 50, calories: 69, protein: 6, carbohydrates: 2, fat: 5),
                FoodItem(name: "白粥", weight: 200, calories: 92, protein: 2, carbohydrates: 20, fat: 0.5)
            ],
            [
                FoodItem(name: "牛排", weight: 150, calories: 271, protein: 26, carbohydrates: 0, fat: 18),
                FoodItem(name: "西兰花", weight: 100, calories: 34, protein: 3, carbohydrates: 7, fat: 0.4),
                FoodItem(name: "煎蛋", weight: 50, calories: 72, protein: 6, carbohydrates: 0.5, fat: 5)
            ],
            [
                FoodItem(name: "牛油果吐司", weight: 120, calories: 234, protein: 6, carbohydrates: 22, fat: 14),
                FoodItem(name: "水煮蛋", weight: 50, calories: 69, protein: 6, carbohydrates: 0.5, fat: 5)
            ],
            [
                FoodItem(name: "米饭", weight: 200, calories: 232, protein: 5, carbohydrates: 51, fat: 0.5),
                FoodItem(name: "红烧肉", weight: 100, calories: 249, protein: 14, carbohydrates: 3, fat: 20),
                FoodItem(name: "炒青菜", weight: 150, calories: 45, protein: 2, carbohydrates: 6, fat: 1.5)
            ],
            [
                FoodItem(name: "红薯", weight: 150, calories: 135, protein: 2, carbohydrates: 31, fat: 0.2)
            ]
        ]

        return mockFoods.randomElement() ?? []
    }
}
