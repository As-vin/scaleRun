import WidgetKit
import SwiftUI

/// Widget 扩展入口
@main
struct ScaleRunWidgetBundle: WidgetBundle {
    var body: some Widget {
        DailySummaryWidget()
        PartnerCompareWidget()
        MealStickerWidget()
    }
}
