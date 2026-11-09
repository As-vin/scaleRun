import Foundation
import SwiftData

/// 用户个人资料模型
@Model
final class UserProfile {
    var id: UUID
    var nickname: String
    var avatarName: String
    var gender: String          // "male" / "female"
    var birthday: Date
    var height: Double          // cm
    var weight: Double          // kg
    var targetWeight: Double    // kg
    var dailyCalorieGoal: Double // kcal
    var dailyCarbGoal: Double   // g
    var dailyProteinGoal: Double // g
    var dailyFatGoal: Double    // g
    var createdAt: Date

    init(
        id: UUID = UUID(),
        nickname: String = "我",
        avatarName: String = "default_avatar",
        gender: String = "female",
        birthday: Date = Calendar.current.date(byAdding: .year, value: -25, to: Date()) ?? Date(),
        height: Double = 165,
        weight: Double = 55,
        targetWeight: Double = 50,
        dailyCalorieGoal: Double = 1500,
        dailyCarbGoal: Double = 150,
        dailyProteinGoal: Double = 75,
        dailyFatGoal: Double = 33,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.nickname = nickname
        self.avatarName = avatarName
        self.gender = gender
        self.birthday = birthday
        self.height = height
        self.weight = weight
        self.targetWeight = targetWeight
        self.dailyCalorieGoal = dailyCalorieGoal
        self.dailyCarbGoal = dailyCarbGoal
        self.dailyProteinGoal = dailyProteinGoal
        self.dailyFatGoal = dailyFatGoal
        self.createdAt = createdAt
    }
}
