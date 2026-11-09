import Foundation
import SwiftData

/// AI 服务配置模型
@Model
final class AIConfig {
    var id: UUID
    var apiKey: String
    var baseURL: String
    var model: String
    var isEnabled: Bool
    var provider: String      // "openai" / "custom"

    init(
        id: UUID = UUID(),
        apiKey: String = "",
        baseURL: String = "https://api.openai.com/v1",
        model: String = "gpt-4o",
        isEnabled: Bool = false,
        provider: String = "openai"
    ) {
        self.id = id
        self.apiKey = apiKey
        self.baseURL = baseURL
        self.model = model
        self.isEnabled = isEnabled
        self.provider = provider
    }

    var isValid: Bool {
        !apiKey.trimmingCharacters(in: .whitespaces).isEmpty && isEnabled
    }
}
