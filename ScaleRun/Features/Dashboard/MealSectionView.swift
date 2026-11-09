import SwiftUI

/// 饮食记录列表
struct MealRecordList: View {
    let dayMeals: [MealRecord]
    let profile: UserProfile?

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("饮食记录")
                    .font(.system(size: 18, weight: .bold))

                Spacer()

                HStack(spacing: 8) {
                    Image(systemName: "list.bullet")
                        .foregroundStyle(Color.brandPrimary)
                    Image(systemName: "chart.pie.fill")
                        .foregroundStyle(Color.textSecondary)
                }
                .padding(8)
                .background(Capsule().fill(Color.cardBackground))
                .shadow(color: .black.opacity(0.04), radius: 4, y: 1)
            }

            ForEach(MealType.allCases, id: \.self) { mealType in
                MealSectionView(
                    mealType: mealType,
                    meal: dayMeals.first { $0.mealType == mealType },
                    calorieGoal: calorieGoal(for: mealType)
                )
            }
        }
    }

    private func calorieGoal(for mealType: MealType) -> Double {
        let goal = profile?.dailyCalorieGoal ?? 1500
        return goal * mealType.defaultCalorieRatio
    }
}

/// 单个餐次区块
struct MealSectionView: View {
    let mealType: MealType
    let meal: MealRecord?
    let calorieGoal: Double

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                HStack(spacing: 10) {
                    Image(systemName: mealType.iconName)
                        .font(.system(size: 22))
                        .foregroundStyle(.primary)

                    VStack(alignment: .leading, spacing: 2) {
                        Text(mealType.rawValue)
                            .font(.system(size: 16, weight: .semibold))

                        Text("\(Int(meal?.totalCalories ?? 0)) / \(Int(calorieGoal)) kcal")
                            .font(.system(size: 13))
                            .foregroundStyle(Color.textSecondary)
                    }
                }

                Spacer()

                // 添加按钮
                Button {
                    // TODO: 添加食物
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(.primary)
                        .frame(width: 32, height: 32)
                        .background(Circle().fill(Color.appBackground))
                }
            }
            .padding(16)

            // 食物列表
            if let meal = meal, !meal.foodItems.isEmpty {
                Divider()
                    .padding(.leading, 56)

                ForEach(meal.foodItems) { item in
                    FoodItemRow(foodItem: item)
                }
            }
        }
        .background(Color.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.03), radius: 6, x: 0, y: 2)
    }
}

#Preview {
    MealRecordList(dayMeals: [], profile: nil)
        .padding()
}
