import SwiftUI
import SwiftData
import Charts

/// 数据分析页面
struct AnalysisView: View {
    @Environment(\.modelContext) private var context
    @Query private var meals: [MealRecord]
    @Query private var weights: [WeightRecord]
    @Query private var profiles: [UserProfile]

    @State private var selectedPeriod: String = "周"

    private var profile: UserProfile? { profiles.first }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // 时间周期选择
                HStack(spacing: 12) {
                    ForEach(["日", "周", "月", "年"], id: \.self) { period in
                        Button {
                            selectedPeriod = period
                        } label: {
                            Text(period)
                                .font(.system(size: 14, weight: selectedPeriod == period ? .semibold : .regular))
                                .foregroundStyle(selectedPeriod == period ? .white : .primary)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 8)
                                .background(
                                    Capsule().fill(
                                        selectedPeriod == period ? Color.brandPrimary : Color.cardBackground
                                    )
                                )
                        }
                    }
                }

                // 热量趋势图
                CalorieTrendChart(meals: meals)

                // 营养素分布
                MacroDistributionCard(meals: meals)

                // 体重趋势
                WeightTrendChart(weights: weights, targetWeight: profile?.targetWeight ?? 50)

                // 本周统计摘要
                WeeklySummaryCard(meals: meals)
            }
            .padding(16)
            .padding(.bottom, 100)
        }
        .navigationTitle("分析")
        .navigationBarTitleDisplayMode(.inline)
    }
}

/// 热量趋势折线图
private struct CalorieTrendChart: View {
    let meals: [MealRecord]

    // 模拟数据（实际应从数据库按日期聚合）
    private var chartData: [(date: String, intake: Double, goal: Double)] {
        let dates = ["周一", "周二", "周三", "周四", "周五", "周六", "周日"]
        let intakes: [Double] = [1200, 980, 1450, 1100, 1350, 1600, 890]
        return zip(dates, intakes).map { ($0, $1, 1500) }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("热量趋势")
                .font(.system(size: 18, weight: .bold))

            Chart(chartData, id: \.date) { item in
                LineMark(
                    x: .value("日期", item.date),
                    y: .value("摄入", item.intake)
                )
                .foregroundStyle(Color.brandPrimary)
                .interpolationMethod(.catmullRom)

                AreaMark(
                    x: .value("日期", item.date),
                    y: .value("摄入", item.intake)
                )
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color.brandPrimary.opacity(0.2), Color.brandPrimary.opacity(0.02)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .interpolationMethod(.catmullRom)

                LineMark(
                    x: .value("日期", item.date),
                    y: .value("目标", item.goal)
                )
                .foregroundStyle(Color.textSecondary)
                .lineStyle(StrokeStyle(lineWidth: 1, dash: [4]))
            }
            .frame(height: 200)
        }
        .cardStyle()
    }
}

/// 营养素分布卡片
private struct MacroDistributionCard: View {
    let meals: [MealRecord]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("营养素分布")
                .font(.system(size: 18, weight: .bold))

            HStack(spacing: 20) {
                // 模拟饼图
                ZStack {
                    Circle()
                        .fill(Color.carbColor.opacity(0.2))

                    Circle()
                        .trim(from: 0, to: 0.5)
                        .fill(Color.carbColor)
                        .rotationEffect(.degrees(-90))

                    Circle()
                        .trim(from: 0.5, to: 0.75)
                        .fill(Color.proteinColor)
                        .rotationEffect(.degrees(-90))

                    Circle()
                        .trim(from: 0.75, to: 0.9)
                        .fill(Color.fatColor)
                        .rotationEffect(.degrees(-90))
                }
                .frame(width: 120, height: 120)

                VStack(alignment: .leading, spacing: 10) {
                    LegendItem(color: .carbColor, name: "碳水", value: "50%")
                    LegendItem(color: .proteinColor, name: "蛋白质", value: "25%")
                    LegendItem(color: .fatColor, name: "脂肪", value: "15%")
                    LegendItem(color: .gray, name: "其他", value: "10%")
                }
            }
        }
        .cardStyle()
    }
}

private struct LegendItem: View {
    let color: Color
    let name: String
    let value: String

    var body: some View {
        HStack(spacing: 8) {
            Circle().fill(color).frame(width: 10, height: 10)
            Text(name).font(.system(size: 13)).foregroundStyle(Color.textSecondary)
            Spacer()
            Text(value).font(.system(size: 13, weight: .medium))
        }
    }
}

/// 体重趋势图
private struct WeightTrendChart: View {
    let weights: [WeightRecord]
    let targetWeight: Double

    private var chartData: [(date: String, weight: Double)] {
        let dates = ["11/3", "11/4", "11/5", "11/6", "11/7", "11/8", "11/9"]
        let values: [Double] = [56.2, 55.8, 55.5, 55.9, 55.3, 55.1, 54.8]
        return zip(dates, values).map { ($0, $1) }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("体重趋势")
                    .font(.system(size: 18, weight: .bold))
                Spacer()
                Text("目标 \(targetWeight, specifier: "%.1f") kg")
                    .font(.system(size: 13))
                    .foregroundStyle(Color.textSecondary)
            }

            Chart {
                ForEach(chartData, id: \.date) { item in
                    LineMark(
                        x: .value("日期", item.date),
                        y: .value("体重", item.weight)
                    )
                    .foregroundStyle(Color.brandPrimary)
                    .interpolationMethod(.catmullRom)

                    PointMark(
                        x: .value("日期", item.date),
                        y: .value("体重", item.weight)
                    )
                    .foregroundStyle(Color.brandPrimary)
                }

                RuleMark(y: .value("目标", targetWeight))
                    .foregroundStyle(Color.carbColor)
                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [4]))
            }
            .frame(height: 180)
        }
        .cardStyle()
    }
}

/// 本周统计摘要
private struct WeeklySummaryCard: View {
    let meals: [MealRecord]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("本周摘要")
                .font(.system(size: 18, weight: .bold))

            HStack(spacing: 16) {
                SummaryItem(title: "平均摄入", value: "1,224", unit: "kcal")
                SummaryItem(title: "总消耗", value: "350", unit: "kcal")
                SummaryItem(title: "体重变化", value: "-1.4", unit: "kg")
            }
        }
        .cardStyle()
    }
}

private struct SummaryItem: View {
    let title: String
    let value: String
    let unit: String

    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 22, weight: .bold, design: .rounded))
            Text(unit)
                .font(.system(size: 11))
                .foregroundStyle(Color.textSecondary)
            Text(title)
                .font(.system(size: 12))
                .foregroundStyle(Color.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    NavigationStack {
        AnalysisView()
    }
    .modelContainer(for: [MealRecord.self, FoodItem.self, WeightRecord.self, UserProfile.self], inMemory: true)
}
