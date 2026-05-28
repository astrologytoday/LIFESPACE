import Foundation
import Combine

final class ShadowWorkModel: ObservableObject {

    @Published var shadowTraits: [String] = Array(repeating: "", count: 3) {
        didSet { saveTraits() }
    }

    private let traitsKey = "shadowWork_shadowTraits_v1"

    init() {
        loadTraits()
    }

    // MARK: - Load
    private func loadTraits() {
        guard
            let data = UserDefaults.standard.data(forKey: traitsKey),
            let decoded = try? JSONDecoder().decode([String].self, from: data)
        else {
            shadowTraits = Array(repeating: "", count: 3)
            return
        }

        shadowTraits = normalized3(decoded)
    }

    // MARK: - Save
    private func saveTraits() {
        let normalized = normalized3(shadowTraits)

        // Avoid writing back a resized array into the same @Published property (could cause loops)
        // Just save the normalized version.
        guard let data = try? JSONEncoder().encode(normalized) else { return }
        UserDefaults.standard.set(data, forKey: traitsKey)
    }

    // MARK: - Helpers
    private func normalized3(_ array: [String]) -> [String] {
        if array.count == 3 { return array }

        var fixed = Array(array.prefix(3))
        while fixed.count < 3 { fixed.append("") }
        return fixed
    }

    // Optional: call this if you ever add a "Clear" button
    func clearTraits() {
        shadowTraits = Array(repeating: "", count: 3)
        UserDefaults.standard.removeObject(forKey: traitsKey)
    }
}
