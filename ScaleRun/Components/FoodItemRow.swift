import SwiftUI

/// 食物条目行
struct FoodItemRow: View {
    let foodItem: FoodItem

    var body: some View {
        HStack(spacing: 12) {
            // 食物图片
            Image(foodItem.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 48, height: 48)
                .clipShape(RoundedRectangle(cornerRadius: 10))

            // 食物信息
            VStack(alignment: .leading, spacing: 2) {
                Text(foodItem.name)
                    .font(.system(size: 15, weight: .medium))

                Text("\(Int(foodItem.weight))g · \(foodItem.createdAt.timeString)")
                    .font(.system(size: 12))
                    .foregroundStyle(Color.textSecondary)
            }

            Spacer()

            // 热量
            Text("\(Int(foodItem.calories)) kcal")
                .font(.system(size: 16, weight: .semibold, design: .rounded))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }
}

#Preview {
    FoodItemRow(foodItem: FoodItem(
        name: "茶叶蛋",
        weight: 50,
        calories: 69,
        protein: 6,
        carbohydrates: 2,
        fat: 5
    ))
}
