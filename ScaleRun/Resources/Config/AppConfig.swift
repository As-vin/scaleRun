import Foundation
import SwiftUI

/// 应用全局配置 - 所有图片资源和可配置项集中管理
enum AppConfig {

    // MARK: - 图片资源配置（方便后续自行替换）
    enum Images {
        static let foodPlaceholder = "food_placeholder"
        static let defaultAvatar = "default_avatar"
        static let appLogo = "app_logo"

        // 食物贴纸素材
        static let stickers = [
            "sticker_rice", "sticker_noodle", "sticker_salad",
            "sticker_fruit", "sticker_meat", "sticker_bread",
            "sticker_egg", "sticker_soup", "sticker_drink"
        ]

        // 食物分类图标
        static let foodCategoryIcons: [String: String] = [
            "主食": "bag.fill",
            "蛋白质": "fish.fill",
            "蔬菜": "leaf.fill",
            "水果": "applelogo",
            "饮品": "cup.and.saucer.fill",
            "零食": "cookie.fill"
        ]
    }

    // MARK: - 断食方案
    enum FastingPlans {
        static let all: [(name: String, hours: Double, description: String)] = [
            ("12:12", 12, "新手友好，适合入门"),
            ("14:10", 14, "轻度断食，容易坚持"),
            ("16:8",  16, "最受欢迎，效果明显"),
            ("18:6",  18, "进阶断食，需要适应"),
            ("20:4",  20, "高强度断食，谨慎使用")
        ]
    }

    // MARK: - 每日饮水目标
    static let dailyWaterGoalML: Double = 2000

    // MARK: - 步数热量换算系数（kcal/步）
    static let caloriesPerStep: Double = 0.04

    // MARK: - App Group（Widget 共享数据）
    static let appGroupID = "group.com.scalerun.health"

    // MARK: - CloudKit Container
    static let cloudKitContainerID = "iCloud.com.scalerun.health"
}
