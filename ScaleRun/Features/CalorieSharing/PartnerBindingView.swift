import SwiftUI

/// 搭子绑定页面
struct PartnerBindingView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var inviteCode: String = ""
    @State private var showLoginSheet = false
    @State private var isLoggedIn = false

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            // 头像区域
            HStack(spacing: -16) {
                Circle()
                    .fill(Color.pink.opacity(0.2))
                    .frame(width: 80, height: 80)
                    .overlay {
                        Text("🐶")
                            .font(.system(size: 40))
                    }

                Circle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 80, height: 80)
                    .overlay {
                        Image(systemName: "person.fill.questionmark")
                            .font(.system(size: 36))
                            .foregroundStyle(.secondary)
                    }
            }

            Text("找到你的热量好友")
                .font(.system(size: 22, weight: .bold))

            Text("登陆后，绑定 TA，开始共享你们的每日热量。")
                .font(.system(size: 14))
                .foregroundStyle(Color.textSecondary)
                .multilineTextAlignment(.center)

            Spacer()

            if isLoggedIn {
                // 已登录 - 输入邀请码
                VStack(spacing: 12) {
                    TextField("输入搭子的邀请码", text: $inviteCode)
                        .font(.system(size: 16))
                        .textInputAutocapitalization(.characters)
                        .autocorrectionDisabled()
                        .padding(14)
                        .background(Color.appBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                    Button {
                        // TODO: 绑定搭子
                    } label: {
                        Text("绑定搭子")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Capsule().fill(Color.black))
                    }
                }
            } else {
                // 未登录 - Apple 登录
                Button {
                    showLoginSheet = true
                } label: {
                    HStack {
                        Image(systemName: "applelogo")
                            .font(.system(size: 18))
                        Text("使用Apple登陆")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Capsule().fill(Color.black))
                }
            }

            Text("登陆即表示你同意《隐私政策》&《服务条款》")
                .font(.system(size: 11))
                .foregroundStyle(Color.textSecondary)
                .padding(.bottom, 20)
        }
        .padding(.horizontal, 24)
        .navigationTitle("绑定搭子")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showLoginSheet) {
            // Apple 登录（需要真机测试）
            VStack(spacing: 20) {
                Text("Apple 登录")
                    .font(.system(size: 20, weight: .bold))
                Text("请在真机上使用 Sign in with Apple")
                    .font(.system(size: 14))
                    .foregroundStyle(Color.textSecondary)
                Button("模拟登录成功") {
                    isLoggedIn = true
                    showLoginSheet = false
                }
                .font(.system(size: 14))
                .foregroundStyle(Color.brandPrimary)
            }
            .padding()
        }
    }
}

#Preview {
    NavigationStack {
        PartnerBindingView()
    }
}
