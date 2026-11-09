import SwiftUI

/// 三大营养素进度卡片
struct MacroProgressCards: View {
    let carbs: Double
    let carbsGoal: Double
    let protein: Double
    let proteinGoal: Double
    let fat: Double
    let fatGoal: Double

    var body: some View {
        HStack(spacing: 12) {
            MacroCard(
                title: "碳水",
                current: carbs,
                goal: carbsGoal,
                color: .carbColor
            )

            MacroCard(
                title: "蛋白质",
                current: protein,
                goal: proteinGoal,
                color: .proteinColor
            )

            MacroCard(
                title: "脂肪",
                current: fat,
                goal: fatGoal,
                color: .fatColor
            )
        }
    }
}

/// 单个营养素卡片
private struct MacroCard: View {
    let title: String
    let current: Double
    let goal: Double
    let color: Color

    private var progress: Double {
        guard goal > 0 else { return 0 }
        return min(1.0, current / goal)
    }

    var body: some View {
        VStack(spacing: 10) {
            Text(title)
                .font(.system(size: 14))
                .foregroundStyle(Color.textSecondary)

            // 进度条
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(color.opacity(0.15))
                        .frame(height: 6)

                    Capsule()
                        .fill(color)
                        .frame(width: geo.size.width * progress, height: 6)
                }
            }
            .frame(height: 6)

            Text("\(Int(current))/\(Int(goal))g")
                .font(.system(size: 14, weight: .semibold, design: .rounded))
        }
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity)
        .cardStyle(padding: 16)
    }
}

#Preview {
    MacroProgressCards(
        carbs: 36, carbsGoal: 150,
        protein: 16, proteinGoal: 75,
        fat: 10, fatGoal: 33
    )
    .padding()
}
