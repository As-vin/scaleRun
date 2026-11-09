import SwiftUI

// MARK: - 通用 View 修饰符
extension View {

    /// 卡片样式
    func cardStyle(padding: CGFloat = 16) -> some View {
        self
            .padding(padding)
            .background(Color.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
    }

    /// 页面背景
    func pageBackground() -> some View {
        self
            .background(Color.appBackground.ignoresSafeArea())
    }
}
