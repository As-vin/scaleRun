import SwiftUI

/// 底部导航 Tab 枚举
enum AppTab: String, CaseIterable {
    case calorie = "热量"
    case fasting = "轻断食"
    case analysis = "分析"
    case settings = "设置"

    var iconName: String {
        switch self {
        case .calorie:  return "flame.fill"
        case .fasting:  return "clock.fill"
        case .analysis: return "chart.bar.fill"
        case .settings: return "gearshape.fill"
        }
    }
}

/// 主内容视图 - 底部导航
struct ContentView: View {
    @State private var selectedTab: AppTab = .calorie
    @State private var showAddSheet = false

    var body: some View {
        ZStack(alignment: .bottom) {
            // Tab 内容区
            Group {
                switch selectedTab {
                case .calorie:
                    DashboardView()
                case .fasting:
                    FastingTimerView()
                case .analysis:
                    AnalysisView()
                case .settings:
                    SettingsView()
                }
            }
            .pageBackground()

            // 自定义底部导航栏
            BottomTabBar(selectedTab: $selectedTab)
                .padding(.bottom, 8)
        }
        .overlay(alignment: .bottomTrailing) {
            // 浮动添加按钮
            FloatingActionButton {
                showAddSheet = true
            }
            .padding(.trailing, 24)
            .padding(.bottom, 90)
        }
        .sheet(isPresented: $showAddSheet) {
            AddMealView()
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [
            UserProfile.self,
            MealRecord.self,
            FoodItem.self,
            WeightRecord.self,
            WaterRecord.self,
            FastingSession.self,
            ExerciseRecord.self,
            AIConfig.self
        ], inMemory: true)
}
