import Foundation
import CloudKit
import SwiftData

/// CloudKit 同步服务 - 双人热量共享
class CloudKitSyncService {
    static let shared = CloudKitSyncService()
    private let container: CKContainer

    private init() {
        container = CKContainer(identifier: AppConfig.cloudKitContainerID)
    }

    // MARK: - 搭子绑定

    /// 生成邀请码
    func generateInviteCode() -> String {
        let chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<6).map { _ in chars.randomElement()! })
    }

    /// 创建共享记录
    func createShareRecord(for userRecordID: CKRecord.ID) async throws -> CKShare {
        let share = CKShare(rootRecord: CKRecord(recordType: "CalorieShare", recordID: userRecordID))
        share[CKShare.SystemFieldKey.title] = "秤秤快跑热量共享" as CKRecordValue
        return share
    }

    /// 接受邀请
    func acceptShare(url: URL) async throws {
        _ = try await container.acceptShareInvitations(from: [url])
    }

    // MARK: - 数据同步

    /// 上传今日热量数据
    func uploadDailyCalories(calories: Double, date: Date) async throws {
        let record = CKRecord(recordType: "DailyCalorie")
        record["calories"] = calories
        record["date"] = date as CKRecordValue
        record["userID"] = UUID().uuidString as CKRecordValue

        _ = try await container.privateCloudDatabase.save(record)
    }

    /// 获取搭子的今日热量
    func getPartnerCalories() async throws -> Double? {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "DailyCalorie", predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]

        let results = try await container.privateCloudDatabase.records(matching: query)
        guard let record = results.matchResults.first?.1.recordValue else { return nil }
        return record["calories"] as? Double
    }
}
