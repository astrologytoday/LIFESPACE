import SwiftUI

struct PSSDFoodTableView: View {
    @EnvironmentObject var navModel: NavigationModel

    private let testosteroneRows: [(String, String)] = [
        ("Fruits", "Pomegranate"),
        ("Vegetables", "Kale, Swiss chard"),
        ("Dairy", "Greek yogurt"),
        ("Meat", "Beef"),
        ("Beans", "Black beans, kidney beans, lentils"),
        ("Grains", "Quinoa")
    ]

    private let gabaRows: [(String, String)] = [
        ("Fruits", "Mango"),
        ("Vegetables", "Broccoli, sweet potatoes, kimchi"),
        ("Dairy", "Duck eggs"),
        ("Meat", "Salmon, dark meat turkey, duck"),
        ("Beans", "Fava beans"),
        ("Grains", "Brown rice, steel cut oats")
    ]

    private let dopamineRows: [(String, String)] = [
        ("Fruits", "Avocados"),
        ("Vegetables", "Beets, spinach, seaweed"),
        ("Dairy", "Fortified milk"),
        ("Meat", "Lamb, bison, wild game"),
        ("Beans", "Cacao, chickpeas, tempeh"),
        ("Grains", "Sprouted bread")
    ]

    var body: some View {
        VStack(spacing: 16) {

            SingleNutrientTable(title: "TESTOSTERONE", rows: testosteroneRows) {
                navModel.push("TestosteroneView")
            }

            SingleNutrientTable(title: "GABA", rows: gabaRows) {
                navModel.push("GABAView")
            }
            
            SingleNutrientTable(title: "DOPAMINE", rows: dopamineRows) {
                navModel.push("DopamineView")
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 6)
        .padding(.bottom, 4)
    }
}
