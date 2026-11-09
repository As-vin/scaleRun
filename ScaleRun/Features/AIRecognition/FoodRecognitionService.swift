import Foundation
import UIKit

/// OpenAI Vision API 食物识别服务
struct FoodRecognitionService {
    let config: AIConfig

    /// 识别食物图片，返回食物列表
    func recognize(image: UIImage) async throws -> [FoodItem] {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw RecognitionError.imageEncodingFailed
        }

        let base64Image = imageData.base64EncodedString()
        let url = URL(string: "\(config.baseURL)/chat/completions")!

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(config.apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let systemPrompt = """
        你是一个专业的食物营养分析AI。请分析图片中的食物，识别每种食物并估算其重量、热量和营养素。
        必须严格按照以下JSON格式返回，不要返回其他内容：
        {
          "foods": [
            {
              "name": "食物名称（中文）",
              "weight_grams": 重量数值,
              "calories": 热量kcal,
              "protein_g": 蛋白质克数,
              "carbs_g": 碳水克数,
              "fat_g": 脂肪克数
            }
          ]
        }
        """

        let body: [String: Any] = [
            "model": config.model,
            "messages": [
                ["role": "system", "content": systemPrompt],
                ["role": "user", "content": [
                    ["type": "text", "text": "请识别这张图片中的食物，分析每种食物的名称、重量、热量和营养素（蛋白质、碳水、脂肪）。"],
                    ["type": "image_url", "image_url": ["url": "data:image/jpeg;base64,\(base64Image)"]]
                ]]
            ],
            "max_tokens": 1000,
            "temperature": 0.3
        ]

        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw RecognitionError.apiRequestFailed
        }

        guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
              let choices = json["choices"] as? [[String: Any]],
              let firstChoice = choices.first,
              let message = firstChoice["message"] as? [String: Any],
              let content = message["content"] as? String else {
            throw RecognitionError.invalidResponse
        }

        // 解析返回的 JSON
        let foods = try parseFoodResponse(content)
        return foods
    }

    private func parseFoodResponse(_ content: String) throws -> [FoodItem] {
        // 提取 JSON 内容（可能在 markdown 代码块中）
        var jsonStr = content
        if let start = content.range(of: "```json")?.upperBound {
            if let end = content.range(of: "```", range: start..<content.endIndex) {
                jsonStr = String(content[start..<end.lowerBound])
            }
        } else if let start = content.range(of: "```")?.upperBound {
            if let end = content.range(of: "```", range: start..<content.endIndex) {
                jsonStr = String(content[start..<end.lowerBound])
            }
        }

        guard let jsonData = jsonStr.data(using: .utf8),
              let json = try JSONSerialization.jsonObject(with: jsonData) as? [String: Any],
              let foods = json["foods"] as? [[String: Any]] else {
            throw RecognitionError.parseFailed
        }

        return foods.compactMap { food in
            guard let name = food["name"] as? String else { return nil }
            return FoodItem(
                name: name,
                weight: (food["weight_grams"] as? Double) ?? 100,
                calories: (food["calories"] as? Double) ?? 0,
                protein: (food["protein_g"] as? Double) ?? 0,
                carbohydrates: (food["carbs_g"] as? Double) ?? 0,
                fat: (food["fat_g"] as? Double) ?? 0
            )
        }
    }
}

/// 识别错误
enum RecognitionError: LocalizedError {
    case imageEncodingFailed
    case apiRequestFailed
    case invalidResponse
    case parseFailed

    var errorDescription: String? {
        switch self {
        case .imageEncodingFailed: return "图片编码失败"
        case .apiRequestFailed:    return "API 请求失败"
        case .invalidResponse:     return "响应格式错误"
        case .parseFailed:         return "解析结果失败"
        }
    }
}
