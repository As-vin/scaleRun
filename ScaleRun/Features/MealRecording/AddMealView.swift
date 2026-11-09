import SwiftUI
import SwiftData
import PhotosUI

/// 添加餐次视图（浮动按钮弹出的 Sheet）
struct AddMealView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @Query private var aiConfigs: [AIConfig]

    @State private var selectedMealType: MealType = .breakfast
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var photoImage: UIImage?
    @State private var isRecognizing = false
    @State private var recognizedItems: [FoodItem] = []
    @State private var showCamera = false
    @State private var manualName: String = ""
    @State private var manualWeight: String = ""
    @State private var manualCalories: String = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // 餐次选择
                    VStack(alignment: .leading, spacing: 12) {
                        Text("选择餐次")
                            .font(.system(size: 16, weight: .semibold))

                        HStack(spacing: 10) {
                            ForEach(MealType.allCases, id: \.self) { type in
                                Button {
                                    selectedMealType = type
                                } label: {
                                    Text(type.rawValue)
                                        .font(.system(size: 14, weight: selectedMealType == type ? .semibold : .regular))
                                        .foregroundStyle(selectedMealType == type ? .white : .primary)
                                        .padding(.horizontal, 18)
                                        .padding(.vertical, 10)
                                        .background(
                                            Capsule().fill(
                                                selectedMealType == type ? Color.brandPrimary : Color.cardBackground
                                            )
                                        )
                                }
                            }
                        }
                    }

                    // 拍照/选图区域
                    VStack(spacing: 12) {
                        Text("拍照识别食物")
                            .font(.system(size: 16, weight: .semibold))

                        if let image = photoImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(height: 200)
                                .clipped()
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .overlay(alignment: .bottomTrailing) {
                                    Button {
                                        photoImage = nil
                                        selectedPhoto = nil
                                        recognizedItems = []
                                    } label: {
                                        Image(systemName: "xmark.circle.fill")
                                            .font(.system(size: 24))
                                            .foregroundStyle(.white, Color.black.opacity(0.5))
                                            .padding(8)
                                    }
                                }
                        } else {
                            Button {
                                // 打开相机
                                showCamera = true
                            } label: {
                                VStack(spacing: 8) {
                                    Image(systemName: "camera.fill")
                                        .font(.system(size: 32))
                                        .foregroundStyle(Color.brandPrimary)
                                    Text("拍照识别")
                                        .font(.system(size: 14))
                                        .foregroundStyle(Color.textSecondary)
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 160)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [6]))
                                        .foregroundStyle(Color.dividerColor)
                                )
                            }

                            // 相册选择
                            PhotosPicker(selection: $selectedPhoto, matching: .images) {
                                HStack {
                                    Image(systemName: "photo.on.rectangle")
                                    Text("从相册选择")
                                }
                                .font(.system(size: 14))
                                .foregroundStyle(Color.textSecondary)
                                .padding(.horizontal, 18)
                                .padding(.vertical, 10)
                                .background(Capsule().fill(Color.cardBackground))
                            }
                        }
                    }

                    // AI 识别中
                    if isRecognizing {
                        HStack(spacing: 8) {
                            ProgressView()
                            Text("AI 正在识别食物...")
                                .font(.system(size: 14))
                                .foregroundStyle(Color.textSecondary)
                        }
                        .padding()
                    }

                    // 识别结果
                    if !recognizedItems.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("识别结果")
                                .font(.system(size: 16, weight: .semibold))

                            ForEach(recognizedItems) { item in
                                HStack {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(item.name)
                                            .font(.system(size: 14, weight: .medium))
                                        Text("\(Int(item.weight))g · \(Int(item.calories)) kcal")
                                            .font(.system(size: 12))
                                            .foregroundStyle(Color.textSecondary)
                                    }
                                    Spacer()
                                    Text("+ 添加")
                                        .font(.system(size: 13, weight: .medium))
                                        .foregroundStyle(.white)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(Capsule().fill(Color.brandPrimary))
                                }
                                .padding(12)
                                .background(Color.cardBackground)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                        }
                    }

                    // 手动添加
                    VStack(alignment: .leading, spacing: 12) {
                        Text("或手动添加")
                            .font(.system(size: 16, weight: .semibold))

                        TextField("食物名称", text: $manualName)
                            .font(.system(size: 15))
                            .padding(12)
                            .background(Color.cardBackground)
                            .clipShape(RoundedRectangle(cornerRadius: 10))

                        HStack(spacing: 10) {
                            TextField("重量(g)", text: $manualWeight)
                                .keyboardType(.numberPad)
                                .font(.system(size: 15))
                                .padding(12)
                                .background(Color.cardBackground)
                                .clipShape(RoundedRectangle(cornerRadius: 10))

                            TextField("热量(kcal)", text: $manualCalories)
                                .keyboardType(.numberPad)
                                .font(.system(size: 15))
                                .padding(12)
                                .background(Color.cardBackground)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }

                    // 保存按钮
                    Button {
                        saveMeal()
                    } label: {
                        Text("保存")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Capsule().fill(Color.brandGradient))
                    }
                    .padding(.top, 8)
                }
                .padding(16)
            }
            .navigationTitle("添加饮食")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("取消") { dismiss() }
                        .foregroundStyle(Color.textSecondary)
                }
            }
            .onChange(of: selectedPhoto) { _, newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self),
                       let image = UIImage(data: data) {
                        photoImage = image
                        await recognizeFood(image: image)
                    }
                }
            }
            .sheet(isPresented: $showCamera) {
                CameraCaptureView { image in
                    photoImage = image
                    Task { await recognizeFood(image: image) }
                }
            }
        }
    }

    /// AI 识别食物
    private func recognizeFood(image: UIImage) async {
        isRecognizing = true
        defer { isRecognizing = false }

        // 检查 AI 配置
        let config = aiConfigs.first
        if config?.isValid == true {
            let service = FoodRecognitionService(config: config!)
            if let items = try? await service.recognize(image: image) {
                recognizedItems = items
                return
            }
        }

        // 使用 Mock 数据
        try? await Task.sleep(nanoseconds: 1_500_000_000)
        recognizedItems = MockFoodRecognitionService.recognize(image: image)
    }

    /// 保存餐次记录
    private func saveMeal() {
        var items: [FoodItem] = recognizedItems

        // 手动添加的食物
        if !manualName.isEmpty, let weight = Double(manualWeight), let calories = Double(manualCalories) {
            let item = FoodItem(
                name: manualName,
                weight: weight,
                calories: calories
            )
            items.append(item)
        }

        guard !items.isEmpty else {
            dismiss()
            return
        }

        // 查找或创建当天的餐次记录
        let today = Date()
        let mealTypeRaw = selectedMealType.rawValue
        let existingMeal = try? context.fetch(
            FetchDescriptor<MealRecord>(
                predicate: #Predicate { meal in
                    meal.mealTypeRaw == mealTypeRaw
                }
            )
        ).first { Calendar.current.isDate($0.date, inSameDayAs: today) }

        let meal: MealRecord
        if let existing = existingMeal {
            meal = existing
        } else {
            meal = MealRecord(mealType: selectedMealType, date: today)
            context.insert(meal)
        }

        // 添加食物条目
        for item in items {
            item.mealRecord = meal
            context.insert(item)
        }

        // 更新餐次总热量
        meal.totalCalories = meal.foodItems.reduce(0) { $0 + $1.calories }

        dismiss()
    }
}

#Preview {
    AddMealView()
        .modelContainer(for: [MealRecord.self, FoodItem.self, AIConfig.self], inMemory: true)
}
