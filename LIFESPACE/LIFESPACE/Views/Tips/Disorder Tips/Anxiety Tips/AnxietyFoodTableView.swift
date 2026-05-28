import SwiftUI
import UIKit

    // Table layout constants
    private let corner: CGFloat = 20
    private let headerH: CGFloat = 52

    private var totalWidth: CGFloat {
        min(UIScreen.main.bounds.width, 900) - 20
    }
    private var labelWidth: CGFloat {
        let proposed = totalWidth * 0.28
        return min(150, max(110, proposed))
    }
    private var valueWidth: CGFloat {
        totalWidth - labelWidth
    }

// -----------------------------------------------------------------------------
// MARK: - FULL AnxietyFoodTableView (FINAL COMPLETE VIEW)
// -----------------------------------------------------------------------------
struct AnxietyFoodTableView: View {
    @EnvironmentObject var navModel: NavigationModel

    private let serotoninRows: [(String, String)] = [
        ("Fruits", "Cherries, pineapple"),
        ("Vegetables", "Mustard greens, sunchokes"),
        ("Dairy", "Milk"),
        ("Meat & Fish", "Turkey, chicken"),
        ("Beans", "Tofu, soybeans, edamame")
    ]

    private let gabaRows: [(String, String)] = [
        ("Fruits", "Mango"),
        ("Vegetables", "Sweet potatoes, seaweed"),
        ("Dairy", "Cheese"),
        ("Meat & Fish", "Pork"),
        ("Beans", "Fava beans")
    ]

    var body: some View {
        VStack(spacing: 16) {

            // SEROTONIN TABLE
            SingleNutrientTable(title: "SEROTONIN", rows: serotoninRows) {
                navModel.push("SerotoninView")
            }

            // GABA TABLE
            SingleNutrientTable(title: "GABA", rows: gabaRows) {
                navModel.push("GABAView")
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 6)
        .padding(.bottom, 4)
    }
}
