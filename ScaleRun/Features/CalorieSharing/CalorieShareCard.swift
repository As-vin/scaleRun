import SwiftUI

/// 热量共享卡片
struct CalorieShareCard: View {
    @State private var isDismissed = false

    var body: some View {
        if !isDismissed {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("和TA一起")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(.primary)

                        Text("共享每餐，也分享每一天")
                            .font(.system(size: 13))
                            .foregroundStyle(.white.opacity(0.85))
                    }

                    Spacer()

                    Button {
                        withAnimation { isDismissed = true }
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(.white.opacity(0.7))
                    }
                }

                // 热量对比
                HStack(spacing: 16) {
                    // 我的热量
                    VStack(spacing: 4) {
                        Text("我:720 kcal")
                            .font(.system(size: 12, weight: .medium))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(Capsule().fill(.white.opacity(0.3)))
                    }

                    // 好友热量
                    VStack(spacing: 4) {
                        Text("好友:845 kcal")
                            .font(.system(size: 12, weight: .medium))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(Capsule().fill(.white.opacity(0.3)))
                    }
                }

                // 邀请按钮
                Button {
                    // TODO: 邀请好友
                } label: {
                    Text("邀请好友")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 10)
                        .background(Capsule().fill(Color.black))
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.shareCardGradient)
            )
        }
    }
}

#Preview {
    CalorieShareCard()
        .padding()
}
