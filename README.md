# 秤秤快跑 (ScaleRun)

一款主打"拍照识别热量"的饮食记录与减脂管理 iOS App。

## 功能特性

- **拍照识别热量** - 拍照或选图，AI 自动识别食物并估算热量/蛋白质/碳水/脂肪
- **饮食记录** - 早/午/晚/加餐四时段记录，食物卡片展示
- **热量仪表盘** - 圆环进度、三大营养素追踪、周历切换
- **双人热量共享** - 绑定搭子，VS 对比卡片，CloudKit 实时同步
- **轻断食** - 5 种断食方案，计时器，历史记录
- **数据分析** - 热量趋势、体重曲线、营养素分布（Swift Charts）
- **桌面小组件** - 食物贴纸、双人对比、日摄入摘要
- **食物贴纸** - 自动 Emoji 贴纸生成

## 技术栈

- Swift 5.9+ / SwiftUI
- iOS 17.0+
- SwiftData（本地存储）
- CloudKit（双人共享）
- OpenAI Vision API（AI 识别，可配置）
- HealthKit（步数/运动）
- WidgetKit（桌面小组件）
- XcodeGen（项目生成）

## 快速开始

### 方式一：本地 Xcode 开发

1. 在 macOS 上打开终端，进入项目目录
2. 安装 XcodeGen：`brew install xcodegen`
3. 生成 Xcode 项目：`cd ScaleRun && xcodegen generate`
4. 打开 `ScaleRun.xcodeproj`
5. 在 Project Settings 中填写你的 **Development Team**
6. 选择模拟器，Cmd+R 运行

### 方式二：GitHub Actions 自动构建

1. Fork 或推送本仓库到 GitHub
2. 进入 Actions 页面，workflow 会自动触发
3. 构建产物可在 Actions 页面下载

### 配置 AI 识别

在 App 内"设置 → AI 服务配置"中填写：
- **API Key**: 你的 OpenAI API Key
- **Base URL**: `https://api.openai.com/v1`（或自定义）
- **Model**: `gpt-4o`（或其他视觉模型）

未配置时使用 Mock 数据演示。

## 项目结构

```
ScaleRun/
├── .github/workflows/build.yml   # GitHub Actions 自动构建
├── project.yml                    # XcodeGen 项目配置
├── ScaleRun/
│   ├── ScaleRunApp.swift          # App 入口
│   ├── ContentView.swift          # 底部导航
│   ├── Models/                    # 8 个 SwiftData 数据模型
│   ├── Features/                  # 功能模块
│   │   ├── Dashboard/             # 首页仪表盘
│   │   ├── MealRecording/         # 拍照识别 + 饮食记录
│   │   ├── AIRecognition/         # OpenAI Vision 服务
│   │   ├── CalorieSharing/        # 双人热量共享
│   │   ├── Fasting/               # 轻断食
│   │   ├── Analysis/              # 数据分析
│   │   └── Settings/              # 设置
│   ├── Services/                  # 外部服务
│   ├── Components/                # 通用 UI 组件
│   ├── Widgets/                   # 3 个桌面小组件
│   ├── Resources/Config/          # 全局配置（图片路径等）
│   └── Extensions/                # 主题色/工具扩展
```

## 图片资源替换

所有图片资源路径集中在 `Resources/Config/AppConfig.swift` 中配置，修改 `Images` 枚举中的值即可替换：

```swift
enum Images {
    static let foodPlaceholder = "food_placeholder"  // 替换为你的图片名
    static let defaultAvatar = "default_avatar"
    // ...
}
```

在 Xcode 的 `Assets.xcassets` 中添加对应图片即可。

## 注意事项

- 需要 iOS 17.0+ 设备或模拟器
- CloudKit 共享功能需要 Apple Developer 账号 + 真机测试
- HealthKit 需要在 Capabilities 中开启
- AI 识别功能需要配置 OpenAI API Key（会产生费用）
