import WidgetKit
import SwiftUI

/// 双人对比 Widget
struct PartnerCompareProvider: TimelineProvider {
    func placeholder(in context: Context) -> PartnerCompareEntry {
        PartnerCompareEntry(date: Date(), myCalories: 510, myGoal: 1200, partnerCalories: 135, partnerGoal: 1423)
    }

    func getSnapshot(in context: Context, completion: @escaping (PartnerCompareEntry) -> Void) {
        let entry = PartnerCompareEntry(date: Date(), myCalories: 510, myGoal: 1200, partnerCalories: 135, partnerGoal: 1423)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<PartnerCompareEntry>) -> Void) {
        let entry = PartnerCompareEntry(date: Date(), myCalories: 510, myGoal: 1200, partnerCalories: 135, partnerGoal: 1423)
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}

struct PartnerCompareEntry: TimelineEntry {
    let date: Date
    let myCalories: Double
    let myGoal: Double
    let partnerCalories: Double
    let partnerGoal: Double
}

struct PartnerCompareWidgetView: View {
    let entry: PartnerCompareEntry

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("我")
                    .font(.system(size: 14, weight: .medium))
                Spacer()
                Text("VS")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(Color.brandPrimary.opacity(0.3))
                Spacer()
                Text("搭子")
                    .font(.system(size: 14, weight: .medium))
            }

            HStack {
                VStack(spacing: 4) {
                    Text("\(Int(entry.myCalories))")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                    Text("/ \(Int(entry.myGoal)) kcal")
                        .font(.system(size: 11))
                        .foregroundStyle(.secondary)
                    Text("≈\(entry.myCalories / 230, specifier: "%.1f")碗")
                        .font(.system(size: 11, weight: .medium))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Capsule().fill(Color.black))
                        .foregroundStyle(.white)
                }

                Divider()

                VStack(spacing: 4) {
                    Text("\(Int(entry.partnerCalories))")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                    Text("/ \(Int(entry.partnerGoal)) kcal")
                        .font(.system(size: 11))
                        .foregroundStyle(.secondary)
                    Text("≈\(entry.partnerCalories / 230, specifier: "%.1f")碗")
                        .font(.system(size: 11, weight: .medium))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Capsule().fill(Color.black))
                        .foregroundStyle(.white)
                }
            }

            Text("秤秤快跑")
                .font(.system(size: 10))
                .foregroundStyle(.tertiary)
        }
        .padding(16)
        .containerBackground(.fill.tertiary, for: .widget)
    }
}

struct PartnerCompareWidget: Widget {
    let kind: String = "PartnerCompareWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: PartnerCompareProvider()) { entry in
            PartnerCompareWidgetView(entry: entry)
        }
        .configurationDisplayName("双人热量对比")
        .description("与搭子实时对比今日热量摄入")
        .supportedFamilies([.systemMedium])
    }
}

#Preview(as: .systemMedium) {
    PartnerCompareWidget()
} timeline: {
    PartnerCompareEntry(date: Date(), myCalories: 510, myGoal: 1200, partnerCalories: 135, partnerGoal: 1423)
}
