import SwiftUI

class UserProfileModel: ObservableObject {
    // Simple values (auto-persist with AppStorage)
    @AppStorage("username") var username: String = ""
    @AppStorage("gender") var gender: String = ""
    @AppStorage("height") var height: String = ""
    @AppStorage("weight") var weight: String = ""
    @AppStorage("age") var age: String = ""
    @AppStorage("drinksPerWeek") var drinksPerWeek: String = ""
    @AppStorage("smokingStatus") var smokingStatus: String = ""
    @AppStorage("cameFromConfirmationExpression") var cameFromConfirmationExpression: Bool = false

    // Custom entries (manual persistence for reactivity)
    @Published var customActivity: String? {
        didSet {
            UserDefaults.standard.set(customActivity, forKey: "customActivity")
        }
    }
    
    @Published var customExpression: String? {
        didSet {
            UserDefaults.standard.set(customExpression, forKey: "customExpression")
        }
    }

    @Published var customInnerWork: String? {
        didSet {
            UserDefaults.standard.set(customInnerWork, forKey: "customInnerWork")
        }
    }

    // Arrays (manual persistence)
    @Published var activityOptions: [String] = [] {
        didSet { saveArray(activityOptions, key: "activityOptions") }
    }
    
    @Published var expressionOptions: [String] = [] {
        didSet { saveArray(expressionOptions, key: "expressionOptions") }
    }

    @Published var fitnessOptions: [String] = [] {
        didSet { saveArray(fitnessOptions, key: "fitnessOptions") }
    }

    @Published var innerWorkOptions: [String] = [] {
        didSet { saveArray(innerWorkOptions, key: "innerWorkOptions") }
    }

    @Published var purposeOptions: [String] = [] {
        didSet { saveArray(purposeOptions, key: "purposeOptions") }
    }

    // Temporary (non-persistent) values
    @Published var pendingCustomInnerWork: String? = nil
    @Published var pendingInnerWorkSelections: [String] = []

    // MARK: - Init
    init() {
        // Load arrays
        activityOptions = loadArray(key: "activityOptions")
        expressionOptions = loadArray(key: "expressionOptions")
        fitnessOptions = loadArray(key: "fitnessOptions")
        innerWorkOptions = loadArray(key: "innerWorkOptions")
        purposeOptions = loadArray(key: "purposeOptions")

        // Load custom strings manually
        customActivity = UserDefaults.standard.string(forKey: "customActivity")
        customExpression = UserDefaults.standard.string(forKey: "customExpression")
        customInnerWork = UserDefaults.standard.string(forKey: "customInnerWork")
    }

    // MARK: - Computed Helpers (NEW)

    /// Returns the selected fitness goal (SetupView stores it as an array of one)
    var fitnessGoal: String {
        fitnessOptions.first ?? ""
    }

    /// Returns the user's selected activities (normally 3 choices)
    var activities: [String] {
        activityOptions
    }

    // MARK: - Persistence Helpers
    private func saveArray(_ array: [String], key: String) {
        if let data = try? JSONEncoder().encode(array) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    private func loadArray(key: String) -> [String] {
        if let data = UserDefaults.standard.data(forKey: key),
           let array = try? JSONDecoder().decode([String].self, from: data) {
            return array
        }
        return []
    }

    // MARK: - Reset
    func reset() {
        username = ""
        gender = ""
        height = ""
        weight = ""
        age = ""
        drinksPerWeek = ""
        smokingStatus = ""
        
        customActivity = nil
        customExpression = nil
        customInnerWork = nil

        activityOptions = []
        expressionOptions = []
        fitnessOptions = []
        innerWorkOptions = []
        purposeOptions = []

        // Remove from UserDefaults
        let keys = [
            "customActivity", "customExpression", "customInnerWork",
            "activityOptions", "expressionOptions", "fitnessOptions",
            "innerWorkOptions", "purposeOptions"
        ]
        for key in keys {
            UserDefaults.standard.removeObject(forKey: key)
        }
    }
}

