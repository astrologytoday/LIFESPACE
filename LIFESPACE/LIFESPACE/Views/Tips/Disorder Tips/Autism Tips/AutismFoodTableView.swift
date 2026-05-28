import SwiftUI

struct AutismFoodTableView: View {
    @EnvironmentObject var navModel: NavigationModel

    private let gabaRows: [(String, String)] = [
        ("Fruits", "Mango"),
        ("Vegetables", "Broccoli, kale, sweet potatoes"),
        ("Dairy", "Yogurt, cheese"),
        ("Meat", "Salmon, shrimp, mackerel"),
        ("Beans", "Cacao, chickpeas, tempeh"),
        ("Grains", "Sprouted bread")
    ]

    var body: some View {
        VStack(spacing: 16) {
            SingleNutrientTable(title: "GABA", rows: gabaRows) {
                navModel.push("GABAView")
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 6)
        .padding(.bottom, 4)
    }
}
