import Foundation
import Combine

final class FiveYearPlanModel: ObservableObject, Codable {
    @Published var vision: String = ""
    @Published var steps5Years: [String] = []
    @Published var steps4Years: [String] = []
    @Published var steps3Years: [String] = []
    @Published var steps2Years: [String] = []
    @Published var steps1Year: [String] = []
    @Published var stepsMonth: [String] = []
    @Published var stepsWeek: [String] = []
    @Published var stepsToday: [String] = []
    @Published var stepsNow: [String] = []
    @Published var completedSteps: Set<String> = []

    enum CodingKeys: String, CodingKey {
        case vision, steps5Years, steps4Years, steps3Years, steps2Years, steps1Year
        case stepsMonth, stepsWeek, stepsToday, stepsNow, completedSteps
    }

    required init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        vision = try c.decode(String.self, forKey: .vision)
        steps5Years = try c.decode([String].self, forKey: .steps5Years)
        steps4Years = try c.decode([String].self, forKey: .steps4Years)
        steps3Years = try c.decode([String].self, forKey: .steps3Years)
        steps2Years = try c.decode([String].self, forKey: .steps2Years)
        steps1Year = try c.decode([String].self, forKey: .steps1Year)
        stepsMonth = try c.decode([String].self, forKey: .stepsMonth)
        stepsWeek = try c.decode([String].self, forKey: .stepsWeek)
        stepsToday = try c.decode([String].self, forKey: .stepsToday)
        stepsNow = try c.decode([String].self, forKey: .stepsNow)
        completedSteps = try c.decode(Set<String>.self, forKey: .completedSteps)
        setupAutoSave()
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(vision, forKey: .vision)
        try c.encode(steps5Years, forKey: .steps5Years)
        try c.encode(steps4Years, forKey: .steps4Years)
        try c.encode(steps3Years, forKey: .steps3Years)
        try c.encode(steps2Years, forKey: .steps2Years)
        try c.encode(steps1Year, forKey: .steps1Year)
        try c.encode(stepsMonth, forKey: .stepsMonth)
        try c.encode(stepsWeek, forKey: .stepsWeek)
        try c.encode(stepsToday, forKey: .stepsToday)
        try c.encode(stepsNow, forKey: .stepsNow)
        try c.encode(completedSteps, forKey: .completedSteps)
    }

    init() {
        setupAutoSave()
    }

    // MARK: - Persistence

    private static let fileKey = "fiveYearPlanData"

    func save() {
        do {
            let data = try JSONEncoder().encode(self)
            UserDefaults.standard.set(data, forKey: Self.fileKey)
        } catch {
            print("❌ Failed to save FiveYearPlanModel:", error)
        }
    }

    static func load() -> FiveYearPlanModel {
        guard let data = UserDefaults.standard.data(forKey: fileKey) else {
            return FiveYearPlanModel()
        }
        do {
            let model = try JSONDecoder().decode(FiveYearPlanModel.self, from: data)
            return model
        } catch {
            print("❌ Failed to load FiveYearPlanModel:", error)
            return FiveYearPlanModel()
        }
    }

    func clearAll() {
        vision = ""
        steps5Years = []
        steps4Years = []
        steps3Years = []
        steps2Years = []
        steps1Year = []
        stepsMonth = []
        stepsWeek = []
        stepsToday = []
        stepsNow = []
        completedSteps = []
        save()
    }

    // MARK: - Auto-save on any change

    private var cancellables: Set<AnyCancellable> = []

    private func setupAutoSave() {
        let publishers: [AnyPublisher<Void, Never>] = [
            $vision.map { _ in }.eraseToAnyPublisher(),
            $steps5Years.map { _ in }.eraseToAnyPublisher(),
            $steps4Years.map { _ in }.eraseToAnyPublisher(),
            $steps3Years.map { _ in }.eraseToAnyPublisher(),
            $steps2Years.map { _ in }.eraseToAnyPublisher(),
            $steps1Year.map { _ in }.eraseToAnyPublisher(),
            $stepsMonth.map { _ in }.eraseToAnyPublisher(),
            $stepsWeek.map { _ in }.eraseToAnyPublisher(),
            $stepsToday.map { _ in }.eraseToAnyPublisher(),
            $stepsNow.map { _ in }.eraseToAnyPublisher(),
            $completedSteps.map { _ in }.eraseToAnyPublisher()
        ]
        Publishers.MergeMany(publishers)
            .sink { [weak self] _ in self?.save() }
            .store(in: &cancellables)
    }
}

