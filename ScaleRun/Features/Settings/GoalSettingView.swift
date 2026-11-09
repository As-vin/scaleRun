import SwiftUI
import SwiftData

/// 目标设置页面
struct GoalSettingView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @Query private var profiles: [UserProfile]

    @State private var dailyCalorie: Double = 1500
    @State private var dailyCarb: Double = 150
    @State private var dailyProtein: Double = 75
    @State private var dailyFat: Double = 33
    @State private var targetWeight: Double = 50

    var body: some View {
        Form {
            Section("每日热量目标") {
                StepperValueRow(title: "热量", value: $dailyCalorie, unit: "kcal", range: 800...3000, step: 50)
            }

            Section("营养素目标") {
                StepperValueRow(title: "碳水", value: $dailyCarb, unit: "g", range: 50...400, step: 5)
                StepperValueRow(title: "蛋白质", value: $dailyProtein, unit: "g", range: 20...200, step: 5)
                StepperValueRow(title: "脂肪", value: $dailyFat, unit: "g", range: 10...100, step: 5)
            }

            Section("体重目标") {
                StepperValueRow(title: "目标体重", value: $targetWeight, unit: "kg", range: 35...120, step: 0.5)
            }

            Section {
                Button {
                    saveGoals()
                } label: {
                    Text("保存目标")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Capsule().fill(Color.brandGradient))
                }
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
            }
        }
        .navigationTitle("每日目标")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { loadGoals() }
    }

    private func loadGoals() {
        guard let profile = profiles.first else { return }
        dailyCalorie = profile.dailyCalorieGoal
        dailyCarb = profile.dailyCarbGoal
        dailyProtein = profile.dailyProteinGoal
        dailyFat = profile.dailyFatGoal
        targetWeight = profile.targetWeight
    }

    private func saveGoals() {
        if let profile = profiles.first {
            profile.dailyCalorieGoal = dailyCalorie
            profile.dailyCarbGoal = dailyCarb
            profile.dailyProteinGoal = dailyProtein
            profile.dailyFatGoal = dailyFat
            profile.targetWeight = targetWeight
        } else {
            let profile = UserProfile(
                dailyCalorieGoal: dailyCalorie,
                dailyCarbGoal: dailyCarb,
                dailyProteinGoal: dailyProtein,
                dailyFatGoal: dailyFat,
                targetWeight: targetWeight
            )
            context.insert(profile)
        }
        dismiss()
    }
}

/// 带步进器的数值行
struct StepperValueRow: View {
    let title: String
    @Binding var value: Double
    let unit: String
    let range: ClosedRange<Double>
    let step: Double

    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 15))
            Spacer()
            Text("\(value, specifier: step < 1 ? "%.1f" : "%.0f") \(unit)")
                .font(.system(size: 15, weight: .medium, design: .rounded))
                .foregroundStyle(Color.brandPrimary)
            Stepper("", value: $value, in: range, step: step)
                .labelsHidden()
        }
    }
}

#Preview {
    NavigationStack {
        GoalSettingView()
    }
    .modelContainer(for: [UserProfile.self], inMemory: true)
}
