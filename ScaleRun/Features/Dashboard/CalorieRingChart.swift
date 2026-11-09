import SwiftUI

/// 热量圆环图表
struct CalorieRingChart: View {
    let remaining: Double
    let intake: Double
    let burned: Double

    private var goal: Double {
        remaining + intake - burned
    }

    private var progress: Double {
        guard goal > 0 else { return 0 }
        return min(1.0, intake / goal)
    }

    var body: some View {
        ZStack {
            // 背景圆环
            Circle()
                .stroke(Color.brandPrimary.opacity(0.08), lineWidth: 18)

            // 进度圆环
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    AngularGradient(
                        colors: [Color.brandGradientStart, Color.brandGradientEnd, Color.brandGradientStart],
                        center: .center
                    ),
                    style: StrokeStyle(lineWidth: 18, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.8), value: progress)

            // 中心文字
            VStack(spacing: 4) {
                Text("\(Int(remaining))")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundStyle(.primary)

                Text("剩余热量")
                    .font(.system(size: 14))
                    .foregroundStyle(Color.textSecondary)
            }

            // 左侧 - 已摄入
            VStack(spacing: 2) {
                Text("\(Int(intake))")
                    .font(.system(size: 22, weight: .semibold, design: .rounded))
                Text("已摄入")
                    .font(.system(size: 12))
                    .foregroundStyle(Color.textSecondary)
            }
            .offset(x: -90)

            // 右侧 - 已消耗
            VStack(spacing: 2) {
                Text("\(Int(burned))")
                    .font(.system(size: 22, weight: .semibold, design: .rounded))
                Text("已消耗")
                    .font(.system(size: 12))
                    .foregroundStyle(Color.textSecondary)
            }
            .offset(x: 90)
        }
        .frame(height: 220)
        .cardStyle(padding: 24)
    }
}

#Preview {
    CalorieRingChart(remaining: 1008, intake: 242, burned: 50)
        .padding()
}
