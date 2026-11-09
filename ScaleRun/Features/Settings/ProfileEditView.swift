import SwiftUI
import SwiftData

/// 个人资料编辑页面
struct ProfileEditView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @Query private var profiles: [UserProfile]

    @State private var nickname: String = ""
    @State private var gender: String = "female"
    @State private var height: Double = 165
    @State private var weight: Double = 55
    @State private var birthday: Date = Calendar.current.date(byAdding: .year, value: -25, to: Date()) ?? Date()

    var body: some View {
        Form {
            Section("基本信息") {
                VStack(alignment: .leading, spacing: 8) {
                    Text("昵称")
                        .font(.system(size: 13))
                        .foregroundStyle(Color.textSecondary)
                    TextField("输入昵称", text: $nickname)
                        .font(.system(size: 15))
                }

                Picker("性别", selection: $gender) {
                    Text("女").tag("female")
                    Text("男").tag("male")
                }
                .font(.system(size: 15))

                VStack(alignment: .leading, spacing: 8) {
                    Text("生日")
                        .font(.system(size: 13))
                        .foregroundStyle(Color.textSecondary)
                    DatePicker("", selection: $birthday, displayedComponents: .date)
                        .font(.system(size: 15))
                }
            }

            Section("身体数据") {
                StepperValueRow(title: "身高", value: $height, unit: "cm", range: 100...220, step: 1)
                StepperValueRow(title: "当前体重", value: $weight, unit: "kg", range: 30...200, step: 0.5)
            }

            Section {
                Button {
                    saveProfile()
                } label: {
                    Text("保存资料")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Capsule().fill(Color.brandGradient))
                }
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
            }
        }
        .navigationTitle("个人资料")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { loadProfile() }
    }

    private func loadProfile() {
        guard let profile = profiles.first else { return }
        nickname = profile.nickname
        gender = profile.gender
        height = profile.height
        weight = profile.weight
        birthday = profile.birthday
    }

    private func saveProfile() {
        if let profile = profiles.first {
            profile.nickname = nickname
            profile.gender = gender
            profile.height = height
            profile.weight = weight
            profile.birthday = birthday
        } else {
            let profile = UserProfile(
                nickname: nickname,
                gender: gender,
                birthday: birthday,
                height: height,
                weight: weight
            )
            context.insert(profile)
        }
        dismiss()
    }
}

#Preview {
    NavigationStack {
        ProfileEditView()
    }
    .modelContainer(for: [UserProfile.self], inMemory: true)
}
