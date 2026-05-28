import SwiftUI

struct DepressionFoodTableView: View {
    @EnvironmentObject var navModel: NavigationModel

    private let dopamineRows: [(String, String)] = [
        ("Fruits", "Avocados, bananas"),
        ("Vegetables", "Beets, spinach"),
        ("Dairy", "Eggs"),
        ("Meat & Fish", "Beef, lamb, salmon, shrimp"),
        ("Beans", "Chickpeas, lentils")
    ]

    private let serotoninRows: [(String, String)] = [
        ("Fruits", "Cherries, pineapple"),
        ("Vegetables", "Red cabbage, mushrooms"),
        ("Dairy", "Kefir"),
        ("Meat & Fish", "Turkey, chicken, liver"),
        ("Beans", "Tofu, soybeans, edamame")
    ]

    private let acetylcholineRows: [(String, String)] = [
        ("Fruits", "Pomegranate, blueberries"),
        ("Vegetables", "Brussel sprouts, cauliflower, carrots"),
        ("Dairy", "Goat cheese, duck eggs"),
        ("Meat & Fish", "Pork, cod"),
        ("Beans", "Lima beans, black beans")
    ]

    private let gabaRows: [(String, String)] = [
        ("Fruits", "Mango"),
        ("Vegetables", "Broccoli, kale, sweet potatoes"),
        ("Dairy", "Yogurt, cheese"),
        ("Meat & Fish", "Sardines, mackerel"),
        ("Beans", "Fava beans")
    ]

    var body: some View {
        VStack(spacing: 16) {
            SingleNutrientTable(title: "DOPAMINE", rows: dopamineRows) {
                navModel.push("DopamineView")
            }
            SingleNutrientTable(title: "SEROTONIN", rows: serotoninRows) {
                navModel.push("SerotoninView")
            }
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
