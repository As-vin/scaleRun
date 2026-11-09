import WidgetKit
import SwiftUI

/// 食物贴纸 Widget 时间线提供者
struct MealStickerProvider: TimelineProvider {
    func placeholder(in context: Context) -> MealStickerEntry {
        MealStickerEntry(date: Date(), mealName: "午餐", calories: 510, stickerEmoji: "🍱")
    }

    func getSnapshot(in context: Context, completion: @escaping (MealStickerEntry) -> Void) {
        let entry = MealStickerEntry(date: Date(), mealName: "午餐", calories: 510, stickerEmoji: "🍱")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<MealStickerEntry>) -> Void) {
        let entry = MealStickerEntry(date: Date(), mealName: "午餐", calories: 510, stickerEmoji: "🍱")
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}

/// Widget 数据条目
struct MealStickerEntry: TimelineEntry {
    let date: Date
    let mealName: String
    let calories: Double
    let stickerEmoji: String
}

/// 食物贴纸 Widget 视图
struct MealStickerWidgetView: View {
    let entry: MealStickerEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(entry.stickerEmoji)
                    .font(.system(size: 36))
                Spacer()
                HStack(spacing: 4) {
                    Image(systemName: "flame.fill")
                        .foregroundStyle(.orange)
                    Text("\(Int(entry.calories)) kcal")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                }
            }

            Text(entry.mealName)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.secondary)

            Text("秤秤快跑")
                .font(.system(size: 10))
                .foregroundStyle(.tertiary)
        }
        .padding(16)
        .containerBackground(.fill.tertiary, for: .widget)
    }
}

/// 食物贴纸 Widget
struct MealStickerWidget: Widget {
    let kind: String = "MealStickerWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: MealStickerProvider()) { entry in
            MealStickerWidgetView(entry: entry)
        }
        .configurationDisplayName("食物贴纸")
        .description("显示最近一餐的食物贴纸和热量")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

#Preview(as: .systemSmall) {
    MealStickerWidget()
} timeline: {
    MealStickerEntry(date: Date(), mealName: "午餐", calories: 510, stickerEmoji: "🍱")
}
