import SwiftUI

// MARK: - 主题色扩展
extension Color {
    /// 品牌主色 - 橙红色
    static let brandPrimary = Color(red: 1.0, green: 0.27, blue: 0.0)
    /// 品牌渐变起始色
    static let brandGradientStart = Color(red: 1.0, green: 0.35, blue: 0.1)
    /// 品牌渐变结束色
    static let brandGradientEnd = Color(red: 1.0, green: 0.15, blue: 0.0)

    /// 背景色
    static let appBackground = Color(red: 0.973, green: 0.973, blue: 0.973)
    /// 卡片背景色
    static let cardBackground = Color.white
    /// 次要文字色
    static let textSecondary = Color(red: 0.55, green: 0.55, blue: 0.55)
    /// 分割线色
    static let dividerColor = Color(red: 0.92, green: 0.92, blue: 0.92)

    /// 营养素颜色
    static let carbColor = Color(red: 0.3, green: 0.75, blue: 0.2)       // 碳水 - 绿
    static let proteinColor = Color(red: 0.55, green: 0.45, blue: 0.95)  // 蛋白质 - 紫
    static let fatColor = Color(red: 1.0, green: 0.7, blue: 0.1)         // 脂肪 - 橙黄

    /// 品牌渐变
    static let brandGradient = LinearGradient(
        colors: [brandGradientStart, brandGradientEnd],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    /// 共享卡片渐变（粉色系）
    static let shareCardGradient = LinearGradient(
        colors: [
            Color(red: 1.0, green: 0.82, blue: 0.88),
            Color(red: 1.0, green: 0.65, blue: 0.75)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
