import SwiftUI

struct PsychosisFoodTableView: View {
    @EnvironmentObject var navModel: NavigationModel

    private let acetylcholineRows: [(String, String)] = [
        ("Fruits", "Apples, papayas"),
        ("Vegetables", "Cauliflower, capers"),
        ("Dairy", "Egg yolk, duck eggs"),
        ("Meat & Fish", "Dark meat poultry"),
        ("Nuts & Seeds", "Sunflower seeds")
    ]

    private let gabaRows: [(String, String)] = [
        ("Fruits", "Mango"),
        ("Vegetables", "Sweet potatoes, kimchi, sauerkraut"),
        ("Dairy", "Cheese"),
        ("Meat & Fish", "Sardines, mackerel"),
        ("Nuts & Seeds", "Chestnuts")
    ]

    var body: some View {
        VStack(spacing: 16) {
            SingleNutrientTable(title: "ACETYLCHOLINE", rows: acetylcholineRows) {
                navModel.push("AcetylcholineView")
            }
            SingleNutrientTable(title: "GABA", rows: gabaRows) {
                navModel.push("GABAView")
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 6)
        .padding(.bottom, 4)
    }
}
