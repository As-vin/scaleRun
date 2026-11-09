import SwiftUI

/// 运动消耗区块
struct ExerciseSection: View {
    let burned: Double

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 14) {
                Image(systemName: "figure.walk")
                    .font(.system(size: 28))
                    .foregroundStyle(.primary)

                VStack(alignment: .leading, spacing: 2) {
                    Text("步数")
                        .font(.system(size: 16, weight: .semibold))

                    Text("来自健康 · 504 步")
                        .font(.system(size: 13))
                        .foregroundStyle(Color.textSecondary)
                }

                Spacer()

                Text("\(burned, specifier: "%.1f") kcal")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
            }
            .padding(16)
        }
        .background(Color.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.03), radius: 6, x: 0, y: 2)
    }
}

#Preview {
    ExerciseSection(burned: 20.2)
        .padding()
}
