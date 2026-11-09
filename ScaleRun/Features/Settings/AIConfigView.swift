import SwiftUI
import SwiftData

/// AI 服务配置页面
struct AIConfigView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @Query private var aiConfigs: [AIConfig]

    @State private var apiKey: String = ""
    @State private var baseURL: String = "https://api.openai.com/v1"
    @State private var model: String = "gpt-4o"
    @State private var isEnabled: Bool = false
    @State private var showSaveSuccess = false

    var body: some View {
        Form {
            Section("OpenAI 配置") {
                Toggle("启用 AI 识别", isOn: $isEnabled)
                    .font(.system(size: 15))

                VStack(alignment: .leading, spacing: 8) {
                    Text("API Key")
                        .font(.system(size: 13))
                        .foregroundStyle(Color.textSecondary)
                    TextField("输入你的 OpenAI API Key", text: $apiKey)
                        .font(.system(size: 15))
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Base URL")
                        .font(.system(size: 13))
                        .foregroundStyle(Color.textSecondary)
                    TextField("https://api.openai.com/v1", text: $baseURL)
                        .font(.system(size: 15))
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("模型")
                        .font(.system(size: 13))
                        .foregroundStyle(Color.textSecondary)
                    TextField("gpt-4o", text: $model)
                        .font(.system(size: 15))
                }
            }

            Section {
                Button {
                    saveConfig()
                } label: {
                    Text("保存配置")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Capsule().fill(Color.brandGradient))
                }
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
            }

            Section("说明") {
                Text("1. 配置后，拍照识别食物时将使用 AI 自动估算热量和营养素")
                    .font(.system(size: 13))
                    .foregroundStyle(Color.textSecondary)
                Text("2. 未配置时将使用模拟数据演示功能流程")
                    .font(.system(size: 13))
                    .foregroundStyle(Color.textSecondary)
                Text("3. API 调用会产生费用，请注意用量")
                    .font(.system(size: 13))
                    .foregroundStyle(Color.textSecondary)
            }
        }
        .navigationTitle("AI 服务配置")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { loadConfig() }
        .alert("保存成功", isPresented: $showSaveSuccess) {
            Button("确定") { dismiss() }
        }
    }

    private func loadConfig() {
        if let config = aiConfigs.first {
            apiKey = config.apiKey
            baseURL = config.baseURL
            model = config.model
            isEnabled = config.isEnabled
        }
    }

    private func saveConfig() {
        if let existing = aiConfigs.first {
            existing.apiKey = apiKey
            existing.baseURL = baseURL
            existing.model = model
            existing.isEnabled = isEnabled
        } else {
            let config = AIConfig(
                apiKey: apiKey,
                baseURL: baseURL,
                model: model,
                isEnabled: isEnabled
            )
            context.insert(config)
        }
        showSaveSuccess = true
    }
}

#Preview {
    NavigationStack {
        AIConfigView()
    }
    .modelContainer(for: [AIConfig.self], inMemory: true)
}
