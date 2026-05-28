import Foundation

enum GoalDuration: String, Codable, CaseIterable {
    case week = "Week"
    case month = "Month"
    case year = "Year"
}

struct Goal: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var title: String
    var steps: [String] = []
    var duration: GoalDuration = .week
    var hasStarted: Bool = false
    var startDate: Date? = nil
    var goalStepsSet: Bool = false
    var completedStepIDs: Set<String> = []
    var stepsNext3Days: [String] = []
    var stepsToday: [String] = []
    var stepsRightNow: [String] = []
    var stepsNext2Weeks: [String] = []
    var stepsNextWeek: [String] = []
    var stepsNext6Months: [String] = []
    var stepsNextMonth: [String] = []
    var reflection: String = ""
    var yearlyReflection: String = ""
    // No storage needed for "RIGHT NOW" unless you want to track it.
}
