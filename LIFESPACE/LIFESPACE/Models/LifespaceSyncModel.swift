//
//  LifespaceSyncModel.swift
//  LIFESPACE
//

import Foundation
import SwiftUI
import FirebaseFirestore

class LifespaceSyncModel: ObservableObject {

    @Published var userShareCode: String = ""
    @Published var sharingEnabled: Bool = false

    private let userShareCodeKey = "lifespaceUserShareCode"
    private let sharingEnabledKey = "lifespaceSharingEnabled"

    private let db = Firestore.firestore()
    private let sharedCollection = "lifespaceSharedData"

    init() {
        loadLocalSharingState()
        generateShareCodeIfNeeded()
    }

    private func loadLocalSharingState() {
        userShareCode = UserDefaults.standard.string(forKey: userShareCodeKey) ?? ""
        sharingEnabled = UserDefaults.standard.bool(forKey: sharingEnabledKey)
    }

    func setSharingEnabled(_ enabled: Bool) {
        sharingEnabled = enabled
        UserDefaults.standard.set(enabled, forKey: sharingEnabledKey)
        updateSharingStatusInFirebase(enabled)
    }

    func generateShareCodeIfNeeded() {
        if !userShareCode.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            createInitialFirebaseShareDocument()
            return
        }

        let newCode = generateShareCode()
        userShareCode = newCode
        UserDefaults.standard.set(newCode, forKey: userShareCodeKey)

        createInitialFirebaseShareDocument()
    }

    private func generateShareCode() -> String {
        let characters = Array("ABCDEFGHJKLMNPQRSTUVWXYZ23456789")
        let randomPart = String((0..<6).compactMap { _ in characters.randomElement() })
        return "LS-\(randomPart)"
    }

    func uploadSharedLifespaceData(
        lifespaceLogModel: LifespaceLogModel,
        userProfile: UserProfileModel
    ) {
        guard !userShareCode.isEmpty else {
            print("No LIFESPACE share code found.")
            return
        }

        let todayPercentages = lifespaceLogModel.todayModulePercentages()
        let lifetimeAverages = lifespaceLogModel.lifetimeModuleAverages()

        let todayModuleData = dictionaryFromModuleScores(todayPercentages)
        let lifetimeModuleData = dictionaryFromModuleScores(lifetimeAverages)

        let currentScores = LifespaceModule.allCases.map { module in
            [
                "module": module.rawValue,
                "score": lifespaceLogModel.score(for: module)
            ] as [String: Any]
        }

        let weakestModules = LifespaceModule.allCases
            .sorted { lifespaceLogModel.score(for: $0) < lifespaceLogModel.score(for: $1) }
            .prefix(3)
            .map { $0.rawValue }

        let strongestModules = LifespaceModule.allCases
            .sorted { lifespaceLogModel.score(for: $0) > lifespaceLogModel.score(for: $1) }
            .prefix(3)
            .map { $0.rawValue }

        let profileData: [String: Any] = [
            "username": userProfile.username,
            "fitnessGoal": userProfile.fitnessGoal,
            "activities": userProfile.activities,
            "expressionOptions": userProfile.expressionOptions,
            "innerWorkOptions": userProfile.innerWorkOptions,
            "purposeOptions": userProfile.purposeOptions
        ]

        let analyticsData: [String: Any] = [
            "todayScore": lifespaceLogModel.todayLifespaceScore(),
            "todayModulePercentages": todayModuleData,
            "lifetimeModuleAverages": lifetimeModuleData,
            "currentModuleScores": currentScores,

            // New chart-ready exports
            "weeklyLifespaceAverages": weeklyLifespaceAverages(from: lifespaceLogModel),
            "monthlyLifespaceAverages": monthlyLifespaceAverages(from: lifespaceLogModel),
            "weeklyModuleAverages": weeklyModuleAverages(from: lifespaceLogModel),
            "monthlyModuleAverages": monthlyModuleAverages(from: lifespaceLogModel)
        ]

        let latestResultData: [String: Any] = [
            "brainOptimizationScore": lifespaceLogModel.todayLifespaceScore(),
            "weakestModules": weakestModules,
            "strongestModules": strongestModules,
            "allModulesAbove80": allModulesAbove80(lifespaceLogModel: lifespaceLogModel)
        ]

        let uploadData: [String: Any] = [
            "userShareCode": userShareCode,
            "sharingEnabled": sharingEnabled,
            "profile": profileData,
            "analytics": analyticsData,
            "latestResult": latestResultData,
            "updatedAt": FieldValue.serverTimestamp()
        ]

        db.collection(sharedCollection)
            .document(userShareCode)
            .setData(uploadData, merge: true) { error in
                if let error = error {
                    print("Error uploading LIFESPACE shared data: \(error.localizedDescription)")
                } else {
                    print("LIFESPACE shared data uploaded successfully.")
                }
            }
    }

    // MARK: - Analytics Export Helpers

    private func weeklyLifespaceAverages(from model: LifespaceLogModel) -> [[String: Any]] {
        let calendar = Calendar.current
        let entries = model.entries.filter { $0.type == .lifespace }

        let grouped = Dictionary(grouping: entries) { entry -> Date in
            let comps = calendar.dateComponents([.year, .month], from: entry.date)
            let monthStart = calendar.date(from: comps)!
            return calendar.date(byAdding: .day, value: monthWeekIndex(for: entry.date) * 7, to: monthStart)!
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"

        return grouped.keys.sorted().map { date in
            let arr = grouped[date] ?? []
            let totalQs = arr.reduce(0) { $0 + $1.questionCount }
            let totalYes = arr.reduce(0) { $0 + $1.yesCount }
            let avg = totalQs > 0 ? (Double(totalYes) / Double(totalQs)) * 100 : 0
            let label = "\(formatter.string(from: date)) W\(monthWeekIndex(for: date) + 1)"

            return [
                "label": label,
                "averageScore": avg
            ]
        }
    }

    private func monthlyLifespaceAverages(from model: LifespaceLogModel) -> [[String: Any]] {
        let calendar = Calendar.current
        let entries = model.entries.filter { $0.type == .lifespace }

        let grouped = Dictionary(grouping: entries) { entry -> Date in
            let comps = calendar.dateComponents([.year, .month], from: entry.date)
            return calendar.date(from: comps)!
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"

        return grouped.keys.sorted().suffix(12).map { date in
            let arr = grouped[date] ?? []
            let totalQs = arr.reduce(0) { $0 + $1.questionCount }
            let totalYes = arr.reduce(0) { $0 + $1.yesCount }
            let avg = totalQs > 0 ? (Double(totalYes) / Double(totalQs)) * 100 : 0

            return [
                "label": formatter.string(from: date),
                "averageScore": avg
            ]
        }
    }

    private func weeklyModuleAverages(from model: LifespaceLogModel) -> [String: [[String: Any]]] {
        var result: [String: [[String: Any]]] = [:]

        for module in LifespaceModule.allCases {
            result[module.rawValue] = moduleWeeklyAverages(for: module, from: model)
        }

        return result
    }

    private func monthlyModuleAverages(from model: LifespaceLogModel) -> [String: [[String: Any]]] {
        var result: [String: [[String: Any]]] = [:]

        for module in LifespaceModule.allCases {
            result[module.rawValue] = moduleMonthlyAverages(for: module, from: model)
        }

        return result
    }

    private func moduleWeeklyAverages(for module: LifespaceModule, from model: LifespaceLogModel) -> [[String: Any]] {
        let calendar = Calendar.current

        let filtered = model.entries.filter {
            $0.type == .lifespace && $0.module == module
        }

        let grouped = Dictionary(grouping: filtered) { entry -> Date in
            let comps = calendar.dateComponents([.year, .month], from: entry.date)
            let monthStart = calendar.date(from: comps)!
            return calendar.date(byAdding: .day, value: monthWeekIndex(for: entry.date) * 7, to: monthStart)!
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"

        return grouped.keys.sorted().map { date in
            let entries = grouped[date] ?? []
            let totalQs = entries.reduce(0) { $0 + $1.questionCount }
            let totalYes = entries.reduce(0) { $0 + $1.yesCount }
            let avg = totalQs > 0 ? (Double(totalYes) / Double(totalQs)) * 100 : 0
            let label = "\(formatter.string(from: date)) W\(monthWeekIndex(for: date) + 1)"

            return [
                "label": label,
                "score": avg
            ]
        }
    }

    private func moduleMonthlyAverages(for module: LifespaceModule, from model: LifespaceLogModel) -> [[String: Any]] {
        let calendar = Calendar.current

        let filtered = model.entries.filter {
            $0.type == .lifespace && $0.module == module
        }

        let grouped = Dictionary(grouping: filtered) { entry -> Date in
            let comps = calendar.dateComponents([.year, .month], from: entry.date)
            return calendar.date(from: comps)!
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"

        return grouped.keys.sorted().suffix(12).map { date in
            let entries = grouped[date] ?? []
            let totalQs = entries.reduce(0) { $0 + $1.questionCount }
            let totalYes = entries.reduce(0) { $0 + $1.yesCount }
            let avg = totalQs > 0 ? (Double(totalYes) / Double(totalQs)) * 100 : 0

            return [
                "label": formatter.string(from: date),
                "score": avg
            ]
        }
    }

    private func monthWeekIndex(for date: Date) -> Int {
        let day = Calendar.current.component(.day, from: date)

        switch day {
        case 1...7:
            return 0
        case 8...14:
            return 1
        case 15...21:
            return 2
        case 22...28:
            return 3
        default:
            return 4
        }
    }

    private func dictionaryFromModuleScores(_ scores: [LifespaceModule: Double]) -> [String: Double] {
        var result: [String: Double] = [:]

        for module in LifespaceModule.allCases {
            result[module.rawValue] = scores[module] ?? 0
        }

        return result
    }

    private func allModulesAbove80(lifespaceLogModel: LifespaceLogModel) -> Bool {
        for module in LifespaceModule.allCases {
            if lifespaceLogModel.score(for: module) < 80 {
                return false
            }
        }

        return true
    }

    private func createInitialFirebaseShareDocument() {
        guard !userShareCode.isEmpty else { return }

        let data: [String: Any] = [
            "userShareCode": userShareCode,
            "sharingEnabled": sharingEnabled,
            "createdAt": FieldValue.serverTimestamp(),
            "updatedAt": FieldValue.serverTimestamp()
        ]

        db.collection(sharedCollection)
            .document(userShareCode)
            .setData(data, merge: true) { error in
                if let error = error {
                    print("Error creating LIFESPACE share document: \(error.localizedDescription)")
                } else {
                    print("LIFESPACE share document created for code: \(self.userShareCode)")
                }
            }
    }

    private func updateSharingStatusInFirebase(_ enabled: Bool) {
        guard !userShareCode.isEmpty else { return }

        let data: [String: Any] = [
            "sharingEnabled": enabled,
            "updatedAt": FieldValue.serverTimestamp()
        ]

        db.collection(sharedCollection)
            .document(userShareCode)
            .setData(data, merge: true) { error in
                if let error = error {
                    print("Error updating sharing status: \(error.localizedDescription)")
                } else {
                    print("Sharing status updated: \(enabled)")
                }
            }
    }
}
