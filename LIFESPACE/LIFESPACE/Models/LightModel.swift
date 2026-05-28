import SwiftUI
import Combine

final class LightModel: ObservableObject {
    @Published var selectedKelvin: Int? = nil
}

