import SwiftUI

struct BPDFoodTableView: View {
    @EnvironmentObject var navModel: NavigationModel

    // MARK: - GABA TABLE ROWS
    private let gabaRows: [(String, String)] = [
        ("Fruits", "Blueberries, mango"),
        ("Vegetables", "Broccoli, sweet potatoes, cabbage"),
        ("Dairy", "Kefir"),
        ("Meat & Fish", "Pork, mackerel, shrimp"),
        ("Nuts & Seeds", "Chia seeds, chestnuts, hemp hearts"),
        ("Grains", "Brown rice, steel cut oats, quinoa")
    ]

    // MARK: - SEROTONIN TABLE ROWS
    private let serotoninRows: [(String, String)] = [
        ("Fruits", "Blackberries, cherries, pineapple, kiwi"),
        ("Vegetables", "Mushrooms, sunchokes, collard greens"),
        ("Dairy", "Egg yolk"),
        ("Meat & Fish", "Chicken"),
        ("Nuts & Seeds", "Hazelnuts, tigernuts, pine nuts"),
        ("Grains", "Millet, raw wild rice, purple corn")
    ]

    // MARK: - ACETYLCHOLINE TABLE ROWS
    private let acetylcholineRows: [(String, String)] = [
        ("Fruits", "Pomegranate"),
        ("Vegetables", "Brussel sprouts, cauliflower, carrots"),
        ("Dairy", "Goat cheese, duck eggs"),
        ("Meat & Fish", "Salmon, tuna, cod, sardines, fish eggs"),
        ("Nuts & Seeds", "Sunflower seeds"),
        ("Grains", "Rye bread, Sprouted bread")
    ]

    // MARK: - BODY
    var body: some View {
        VStack(spacing: 16) {

            // GABA TABLE
            SingleNutrientTable(title: "GABA", rows: gabaRows) {
                navModel.push("GABAView")
            }

            // SEROTONIN TABLE
            SingleNutrientTable(title: "SEROTONIN", rows: serotoninRows) {
                navModel.push("SerotoninView")
            }

            // ACETYLCHOLINE TABLE
            SingleNutrientTable(title: "ACETYLCHOLINE", rows: acetylcholineRows) {
                navModel.push("AcetylcholineView")
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 6)
        .padding(.bottom, 4)
    }
}
