import SwiftUI
import SwiftData

/// 首页仪表盘
struct DashboardView: View {
    @Environment(\.modelContext) private var context
    @Query private var profiles: [UserProfile]
    @Query private var meals: [MealRecord]
    @Query(sort: [SortDescriptor(\.startDate, order: .reverse)]) private var fastingSessions: [FastingSession]

    @State private var selectedDate: Date = Date()
    @State private var weekDates: [Date] = Date.currentWeekDates()

    private var profile: UserProfile? {
        profiles.first
    }

    /// 选中日期的餐次记录
    private var dayMeals: [MealRecord] {
        meals.filter { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }
    }

    /// 当日总摄入
    private var totalIntake: Double {
        dayMeals.reduce(0) { $0 + $1.totalCalories }
    }

    /// 当日总消耗（运动 + 基础代谢估算）
    private var totalBurned: Double {
        let stepCalories = 50.0 // TODO: 接入 HealthKit
        return stepCalories
    }

    /// 剩余热量
    private var remainingCalories: Double {
        let goal = profile?.dailyCalorieGoal ?? 1500
        return max(0, goal - totalIntake + totalBurned)
    }

    /// 三大营养素汇总
    private var totalCarbs: Double {
        dayMeals.flatMap(\.foodItems).reduce(0) { $0 + $1.carbohydrates }
    }
    private var totalProtein: Double {
        dayMeals.flatMap(\.foodItems).reduce(0) { $0 + $1.protein }
    }
    private var totalFat: Double {
        dayMeals.flatMap(\.foodItems).reduce(0) { $0 + $1.fat }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // 周历切换条
                WeeklyCalendarStrip(
                    weekDates: weekDates,
                    selectedDate: $selectedDate
                )
                .padding(.horizontal, 16)

                // 热量圆环
                CalorieRingChart(
                    remaining: remainingCalories,
                    intake: totalIntake,
                    burned: totalBurned
                )
                .padding(.horizontal, 16)

                // 营养素进度卡片
                MacroProgressCards(
                    carbs: totalCarbs,
                    carbsGoal: profile?.dailyCarbGoal ?? 150,
                    protein: totalProtein,
                    proteinGoal: profile?.dailyProteinGoal ?? 75,
                    fat: totalFat,
                    fatGoal: profile?.dailyFatGoal ?? 33
                )
                .padding(.horizontal, 16)

                // 饮食记录列表
                MealRecordList(
                    dayMeals: dayMeals,
                    profile: profile
                )
                .padding(.horizontal, 16)

                // 热量共享卡片
                CalorieShareCard()
                    .padding(.horizontal, 16)

                // 运动消耗
                ExerciseSection(burned: totalBurned)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 100)
            }
        }
        .navigationTitle("秤秤快跑")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    // TODO: 分享功能
                } label: {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 18))
                        .foregroundStyle(Color.brandPrimary)
                        .padding(10)
                        .background(Circle().fill(Color.cardBackground))
                        .shadow(color: .black.opacity(0.06), radius: 4, y: 2)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        DashboardView()
    }
    .modelContainer(for: [
        UserProfile.self, MealRecord.self, FoodItem.self,
        WeightRecord.self, WaterRecord.self, FastingSession.self,
        ExerciseRecord.self, AIConfig.self
    ], inMemory: true)
}
