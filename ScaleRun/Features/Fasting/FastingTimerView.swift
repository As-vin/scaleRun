import SwiftUI
import SwiftData

/// 轻断食计时器页面
struct FastingTimerView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: [SortDescriptor<FastingSession>(\.startDate, order: .reverse)]) private var sessions: [FastingSession]

    @State private var selectedPlan: String = "16:8"
    @State private var isFasting = false
    @State private var timer: Timer?
    @State private var elapsed: Double = 0

    private var activeSession: FastingSession? {
        sessions.first { $0.endDate == nil }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // 断食方案选择
                VStack(alignment: .leading, spacing: 12) {
                    Text("断食方案")
                        .font(.system(size: 18, weight: .bold))

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(AppConfig.FastingPlans.all, id: \.name) { plan in
                                FastingPlanChip(
                                    name: plan.name,
                                    description: plan.description,
                                    isSelected: selectedPlan == plan.name
                                ) {
                                    selectedPlan = plan.name
                                }
                            }
                        }
                    }
                }

                // 计时器圆环
                FastingTimerRing(
                    progress: activeSession?.progress ?? 0,
                    elapsedHours: activeSession?.elapsedHours ?? elapsed,
                    remainingHours: activeSession?.remainingHours ?? max(0, 16 - elapsed),
                    isFasting: isFasting || activeSession != nil
                )

                // 操作按钮
                if activeSession != nil {
                    Button {
                        endFasting()
                    } label: {
                        Text("结束断食")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Capsule().fill(Color.brandGradient))
                    }
                } else {
                    Button {
                        startFasting()
                    } label: {
                        Text("开始断食")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Capsule().fill(Color.brandGradient))
                    }
                }

                // 断食历史
                FastingHistoryList(sessions: sessions.filter { $0.isCompleted })
            }
            .padding(16)
            .padding(.bottom, 100)
        }
        .navigationTitle("轻断食")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func startFasting() {
        let plan = AppConfig.FastingPlans.all.first { $0.name == selectedPlan }
        let session = FastingSession(
            plannedDuration: plan?.hours ?? 16,
            planType: selectedPlan
        )
        context.insert(session)
        isFasting = true
    }

    private func endFasting() {
        guard let session = activeSession else { return }
        session.endDate = Date()
        session.isCompleted = true
        isFasting = false
    }
}

/// 断食方案选择芯片
private struct FastingPlanChip: View {
    let name: String
    let description: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text(name)
                    .font(.system(size: 16, weight: isSelected ? .bold : .medium))
                    .foregroundStyle(isSelected ? .white : .primary)

                Text(description)
                    .font(.system(size: 11))
                    .foregroundStyle(isSelected ? .white.opacity(0.8) : Color.textSecondary)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(isSelected ? Color.brandPrimary : Color.cardBackground)
            )
        }
    }
}

/// 断食计时圆环
private struct FastingTimerRing: View {
    let progress: Double
    let elapsedHours: Double
    let remainingHours: Double
    let isFasting: Bool

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.brandPrimary.opacity(0.08), lineWidth: 14)

            Circle()
                .trim(from: 0, to: progress)
                .stroke(Color.brandGradient, style: StrokeStyle(lineWidth: 14, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 1), value: progress)

            VStack(spacing: 6) {
                if isFasting {
                    Text("断食中")
                        .font(.system(size: 14))
                        .foregroundStyle(Color.brandPrimary)

                    Text(formatTime(hours: elapsedHours))
                        .font(.system(size: 40, weight: .bold, design: .rounded))

                    Text("剩余 \(Date.formatFastingDuration(hours: remainingHours))")
                        .font(.system(size: 13))
                        .foregroundStyle(Color.textSecondary)
                } else {
                    Text("准备开始")
                        .font(.system(size: 16))
                        .foregroundStyle(Color.textSecondary)

                    Text("0:00")
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                }
            }
        }
        .frame(height: 220)
        .cardStyle(padding: 24)
    }

    private func formatTime(hours: Double) -> String {
        let h = Int(hours)
        let m = Int((hours - Double(h)) * 60)
        return String(format: "%d:%02d", h, m)
    }
}

/// 断食历史列表
private struct FastingHistoryList: View {
    let sessions: [FastingSession]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("历史记录")
                .font(.system(size: 18, weight: .bold))

            if sessions.isEmpty {
                Text("暂无断食记录")
                    .font(.system(size: 14))
                    .foregroundStyle(Color.textSecondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 30)
            } else {
                ForEach(sessions.prefix(5)) { session in
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(session.planType)
                                .font(.system(size: 15, weight: .medium))
                            Text(session.startDate.shortDateString)
                                .font(.system(size: 12))
                                .foregroundStyle(Color.textSecondary)
                        }
                        Spacer()
                        Text(Date.formatFastingDuration(hours: session.elapsedHours))
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .padding(14)
                    .background(Color.cardBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        FastingTimerView()
    }
    .modelContainer(for: [FastingSession.self], inMemory: true)
}
