import WidgetKit
import SwiftUI

/// 日摄入摘要 Widget
struct DailySummaryProvider: TimelineProvider {
    func placeholder(in context: Context) -> DailySummaryEntry {
        DailySummaryEntry(date: Date(), intake: 1260, goal: 2107, progress: 0.6)
    }

    func getSnapshot(in context: Context, completion: @escaping (DailySummaryEntry) -> Void) {
        let entry = DailySummaryEntry(date: Date(), intake: 1260, goal: 2107, progress: 0.6)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<DailySummaryEntry>) -> Void) {
        let entry = DailySummaryEntry(date: Date(), intake: 1260, goal: 2107, progress: 0.6)
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}

struct DailySummaryEntry: TimelineEntry {
    let date: Date
    let intake: Double
    let goal: Double
    let progress: Double
}

struct DailySummaryWidgetView: View {
    let entry: DailySummaryEntry

    var body: some View {
        ZStack {
            // 圆环
            ZStack {
                Circle()
                    .stroke(Color.brandPrimary.opacity(0.1), lineWidth: 10)

                Circle()
                    .trim(from: 0, to: entry.progress)
                    .stroke(Color.brandGradient, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                    .rotationEffect(.degrees(-90))
            }
            .frame(width: 100, height: 100)

            VStack(spacing: 2) {
                Text("\(Int(entry.goal - entry.intake))")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                Text("剩余")
                    .font(.system(size: 10))
                    .foregroundStyle(.secondary)
            }
        }

        VStack(alignment: .leading, spacing: 6) {
            Text("今日摄入")
                .font(.system(size: 12))
                .foregroundStyle(.secondary)

            Text("\(Int(entry.intake)) / \(Int(entry.goal))")
                .font(.system(size: 18, weight: .bold, design: .rounded))

            Text("kcal")
                .font(.system(size: 11))
                .foregroundStyle(.secondary)
        }

        Text("秤秤快跑")
            .font(.system(size: 10))
            .foregroundStyle(.tertiary)
    }
    .padding(16)
    .containerBackground(.fill.tertiary, for: .widget)
}

struct DailySummaryWidget: Widget {
    let kind: String = "DailySummaryWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: DailySummaryProvider()) { entry in
            DailySummaryWidgetView(entry: entry)
        }
        .configurationDisplayName("每日热量摘要")
        .description("显示今日热量摄入和剩余量")
        .supportedFamilies([.systemSmall])
    }
}

#Preview(as: .systemSmall) {
    DailySummaryWidget()
} timeline: {
    DailySummaryEntry(date: Date(), intake: 1260, goal: 2107, progress: 0.6)
}
