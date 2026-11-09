import Foundation
import UIKit

/// 食物贴纸生成服务
class ImageStickerService {
    static let shared = ImageStickerService()

    /// 根据食物名称生成贴纸 Emoji
    func getStickerEmoji(for foodName: String) -> String {
        let emojiMap: [String: String] = [
            "米饭": "🍚", "粥": "🥣", "面条": "🍜", "面包": "🍞",
            "牛排": "🥩", "鸡肉": "🍗", "鱼": "🐟", "虾": "🦐",
            "鸡蛋": "🥚", "蛋": "🥚",
            "苹果": "🍎", "香蕉": "🍌", "橙子": "🍊", "葡萄": "🍇",
            "西兰花": "🥦", "胡萝卜": "🥕", "番茄": "🍅", "沙拉": "🥗",
            "蛋糕": "🍰", "饼干": "🍪", "巧克力": "🍫",
            "牛奶": "🥛", "咖啡": "☕️", "茶": "🍵", "果汁": "🧃",
            "披萨": "🍕", "汉堡": "🍔", "薯条": "🍟", "热狗": "🌭",
            "寿司": "🍣", "便当": "🍱", "红薯": "🍠"
        ]

        for (keyword, emoji) in emojiMap {
            if foodName.contains(keyword) {
                return emoji
            }
        }
        return "🍽️"
    }

    /// 生成食物贴纸图片（带热量标签）
    func generateStickerImage(foodName: String, calories: Double, size: CGSize = CGSize(width: 120, height: 120)) -> UIImage? {
        let emoji = getStickerEmoji(for: foodName)
        let renderer = UIGraphicsImageRenderer(size: size)

        return renderer.image { context in
            // 背景圆
            UIColor.systemBackground.setFill()
            let rect = CGRect(origin: .zero, size: size)
            context.cgContext.fillEllipse(in: rect)

            // Emoji
            let emojiText = emoji as NSString
            let emojiSize = CGSize(width: size.width * 0.6, height: size.height * 0.6)
            let emojiRect = CGRect(
                x: (size.width - emojiSize.width) / 2,
                y: (size.height - emojiSize.height) / 2 - 10,
                width: emojiSize.width,
                height: emojiSize.height
            )
            emojiText.draw(in: emojiRect, withAttributes: [
                .font: UIFont.systemFont(ofSize: size.width * 0.5)
            ])

            // 热量标签
            let calText = "\(Int(calories)) kcal" as NSString
            let calSize = calText.size(withAttributes: [.font: UIFont.systemFont(ofSize: 11, weight: .bold)])
            let calRect = CGRect(
                x: (size.width - calSize.width) / 2,
                y: size.height - 28,
                width: calSize.width,
                height: calSize.height
            )
            calText.draw(in: calRect, withAttributes: [
                .font: UIFont.systemFont(ofSize: 11, weight: .bold),
                .foregroundColor: UIColor.systemOrange
            ])
        }
    }
}
