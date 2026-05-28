import SwiftUI

struct ADHDFoodTableView: View {
    @EnvironmentObject var navModel: NavigationModel

    private let dopamineRows: [(String, String)] = [
        ("Fruits", "Avocados"),
        ("Vegetables", "Beets, spinach, seaweed"),
        ("Dairy", "Fortified milk"),
        ("Meat", "Lamb, bison, wild game"),
        ("Beans", "Cacao, chickpeas, tempeh"),
        ("Grains", "Sprouted bread")
    ]

    private let epinephrineRows: [(String, String)] = [
        ("Fruits", "Oranges, lemons, grapefruit"),
        ("Vegetables", "Bell peppers, lettuce, bok choy"),
        ("Dairy", "Duck eggs"),
        ("Meat", "Duck"),
        ("Beans", "Spirulina, dark chocolate"),
        ("Grains", "Brown rice")
    ]

    var body: some View {
        VStack(spacing: 16) {

            SingleNutrientTable(title: "DOPAMINE", rows: dopamineRows) {
                navModel.push("DopamineView")
            }

            SingleNutrientTable(title: "EPINEPHRINE", rows: epinephrineRows) {
                navModel.push("EpinephrineView")
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 6)
        .padding(.bottom, 4)
    }
}
