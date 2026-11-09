import SwiftUI
import SwiftData

/// 设置页面
struct SettingsView: View {
    @Environment(\.modelContext) private var context
    @Query private var profiles: [UserProfile]
    @Query private var aiConfigs: [AIConfig]

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // 个人资料
                ProfileCard(profile: profiles.first)

                // 设置分组
                SettingsGroup(title: "AI 识别") {
                    NavigationLink {
                        AIConfigView()
                    } label: {
                        SettingsRow(icon: "cpu.fill", title: "AI 服务配置", subtitle: aiConfigs.first?.isValid == true ? "已配置" : "未配置")
                    }
                }

                SettingsGroup(title: "健康目标") {
                    NavigationLink {
                        GoalSettingView()
                    } label: {
                        SettingsRow(icon: "target", title: "每日目标", subtitle: "\(Int(profiles.first?.dailyCalorieGoal ?? 1500)) kcal")
                    }

                    NavigationLink {
                        ProfileEditView()
                    } label: {
                        SettingsRow(icon: "person.fill", title: "个人资料", subtitle: "身高、体重等")
                    }
                }

                SettingsGroup(title: "数据管理") {
                    SettingsRow(icon: "icloud.fill", title: "iCloud 同步", subtitle: "已开启")
                    SettingsRow(icon: "applewatch", title: "健康数据", subtitle: "步数同步中")
                }

                SettingsGroup(title: "关于") {
                    SettingsRow(icon: "doc.text", title: "隐私政策")
                    SettingsRow(icon: "doc.text", title: "服务条款")
                    SettingsRow(icon: "info.circle", title: "版本", subtitle: "1.0.0")
                }
            }
            .padding(16)
            .padding(.bottom, 100)
        }
        .navigationTitle("设置")
        .navigationBarTitleDisplayMode(.inline)
    }
}

/// 个人资料卡片
private struct ProfileCard: View {
    let profile: UserProfile?

    var body: some View {
        HStack(spacing: 14) {
            Circle()
                .fill(Color.brandPrimary.opacity(0.1))
                .frame(width: 56, height: 56)
                .overlay {
                    Image(systemName: "person.fill")
                        .font(.system(size: 26))
                        .foregroundStyle(Color.brandPrimary)
                }

            VStack(alignment: .leading, spacing: 4) {
                Text(profile?.nickname ?? "我")
                    .font(.system(size: 18, weight: .semibold))

                Text("目标 \(Int(profile?.dailyCalorieGoal ?? 1500)) kcal/天")
                    .font(.system(size: 13))
                    .foregroundStyle(Color.textSecondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 14))
                .foregroundStyle(Color.textSecondary)
        }
        .cardStyle()
    }
}

/// 设置分组
private struct SettingsGroup<Content: View>: View {
    let title: String
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(.system(size: 13))
                .foregroundStyle(Color.textSecondary)
                .padding(.bottom, 8)

            VStack(spacing: 0) {
                content()
            }
            .background(Color.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
    }
}

/// 设置行
struct SettingsRow: View {
    let icon: String
    let title: String
    var subtitle: String? = nil

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundStyle(Color.brandPrimary)
                .frame(width: 24)

            Text(title)
                .font(.system(size: 15))

            Spacer()

            if let subtitle = subtitle {
                Text(subtitle)
                    .font(.system(size: 13))
                    .foregroundStyle(Color.textSecondary)
            }

            Image(systemName: "chevron.right")
                .font(.system(size: 12))
                .foregroundStyle(Color.textSecondary.opacity(0.5))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
    .modelContainer(for: [UserProfile.self, AIConfig.self], inMemory: true)
}
