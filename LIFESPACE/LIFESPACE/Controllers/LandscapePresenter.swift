import SwiftUI
import UIKit

var landscapeWindow: UIWindow?

// MARK: - Present WeeklyTrackerView Using requestGeometryUpdate (iOS 16+)
func presentWeeklyTrackerView(
    navModel: NavigationModel,
    userProfile: UserProfileModel,
    lifespaceLogModel: LifespaceLogModel,
    budgetModel: BudgetModel
) {
    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }

    // 🔁 Set transition flag
    navModel.isTransitioningToLandscape = true

    // 🔁 Lock and request orientation
    AppDelegate.orientationLock = .landscapeRight
    let preferences = UIWindowScene.GeometryPreferences.iOS(interfaceOrientations: .landscapeRight)
    try? windowScene.requestGeometryUpdate(preferences)

    // 🔁 Setup view controller + UIWindow
    let controller = LandscapeHostingController(
        rootView: WeeklyTrackerView()
            .environmentObject(navModel)
            .environmentObject(userProfile)
            .environmentObject(lifespaceLogModel)
            .environmentObject(budgetModel)
    )

    let newWindow = UIWindow(windowScene: windowScene)
    newWindow.rootViewController = controller
    newWindow.windowLevel = .alert + 1
    newWindow.makeKeyAndVisible()

    landscapeWindow = newWindow

    // ✅ Clear the transition flag after delay
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
        navModel.isTransitioningToLandscape = false
    }
}

func presentMusicCreativeView(
    navModel: NavigationModel,
    userProfile: UserProfileModel,
    lifespaceLogModel: LifespaceLogModel,
    budgetModel: BudgetModel
) {
    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }

    navModel.isTransitioningToLandscape = true

    AppDelegate.orientationLock = .landscapeRight
    let preferences = UIWindowScene.GeometryPreferences.iOS(interfaceOrientations: .landscapeRight)
    try? windowScene.requestGeometryUpdate(preferences)

    let controller = LandscapeHostingController(
        rootView: MusicCreativeView()
            .environmentObject(navModel)
            .environmentObject(userProfile)
            .environmentObject(lifespaceLogModel)
            .environmentObject(budgetModel)
    )

    let newWindow = UIWindow(windowScene: windowScene)
    newWindow.rootViewController = controller
    newWindow.windowLevel = .alert + 1
    newWindow.makeKeyAndVisible()

    landscapeWindow = newWindow

    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
        navModel.isTransitioningToLandscape = false
    }
}


// MARK: - Dismiss Landscape View with Geometry Reset
func dismissLandscapeWindow(to screen: String, navModel: NavigationModel) {
    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
        navModel.push(screen)
        return
    }

    // Reset to portrait using iOS 16 method
    AppDelegate.orientationLock = .portrait
    let preferences = UIWindowScene.GeometryPreferences.iOS(interfaceOrientations: .portrait)
    try? windowScene.requestGeometryUpdate(preferences)

    // Dismiss the landscape window
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
        landscapeWindow?.isHidden = true
        landscapeWindow = nil
        navModel.push(screen)
    }
}

