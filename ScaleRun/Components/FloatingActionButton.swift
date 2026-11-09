import SwiftUI

/// 浮动添加按钮
struct FloatingActionButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "plus")
                .font(.system(size: 28, weight: .medium))
                .foregroundStyle(.white)
                .frame(width: 60, height: 60)
                .background(
                    Circle()
                        .fill(Color.brandGradient)
                        .shadow(color: Color.brandPrimary.opacity(0.4), radius: 8, x: 0, y: 4)
                )
        }
    }
}

#Preview {
    ZStack {
        Color.appBackground
        FloatingActionButton {}
    }
}
