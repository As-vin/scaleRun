import SwiftUI
import SwiftData

@main
struct ScaleRunApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [
            UserProfile.self,
            MealRecord.self,
            FoodItem.self,
            WeightRecord.self,
            WaterRecord.self,
            FastingSession.self,
            ExerciseRecord.self,
            AIConfig.self
        ])
    }
}
