import Foundation
import HealthKit

/// HealthKit 健康数据服务
class HealthKitService {
    static let shared = HealthKitService()
    private let healthStore = HKHealthStore()

    var isAvailable: Bool {
        HKHealthStore.isHealthDataAvailable()
    }

    /// 请求健康数据权限
    func requestAuthorization() async throws {
        guard isAvailable else { return }

        let stepType = HKQuantityType(.stepCount)
        let activeEnergyType = HKQuantityType(.activeEnergyBurned)

        try await healthStore.requestAuthorization(toShare: [], read: [stepType, activeEnergyType])
    }

    /// 获取今日步数
    func getTodaySteps() async throws -> Int {
        guard isAvailable else { return 0 }

        let stepType = HKQuantityType(.stepCount)
        let startOfDay = Calendar.current.startOfDay(for: Date())

        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: Date())
        let descriptor = HKStatisticsQueryDescriptor(
            predicate: predicate,
            options: .cumulativeSum
        )

        let result = try await descriptor.result(for: healthStore)
        return Int(result?.sumQuantity()?.doubleValue(for: .count()) ?? 0)
    }

    /// 获取今日运动消耗（kcal）
    func getTodayActiveEnergy() async throws -> Double {
        guard isAvailable else { return 0 }

        let energyType = HKQuantityType(.activeEnergyBurned)
        let startOfDay = Calendar.current.startOfDay(for: Date())

        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: Date())
        let descriptor = HKStatisticsQueryDescriptor(
            predicate: predicate,
            options: .cumulativeSum
        )

        let result = try await descriptor.result(for: healthStore)
        return result?.sumQuantity()?.doubleValue(for: .kilocalorie()) ?? 0
    }

    /// 步数换算热量
    func stepsToCalories(steps: Int) -> Double {
        Double(steps) * AppConfig.caloriesPerStep
    }
}
