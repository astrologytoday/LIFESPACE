import SwiftUI
import UIKit

struct MenuContainerView: View {
    @EnvironmentObject var navModel: NavigationModel
    @EnvironmentObject var userProfile: UserProfileModel
    @EnvironmentObject var lifespaceLogModel: LifespaceLogModel
    @EnvironmentObject var goalsViewModel: GoalsViewModel
    @EnvironmentObject var toDoListModel: ToDoListModel
    @EnvironmentObject var userRecipeStore: UserRecipeStore

    @StateObject var budgetModel = BudgetModel()
    @StateObject var weightLogModel = WeightLogModel()
    @StateObject var dreamJournalModel = DreamJournalModel()
    @StateObject var lightModel = LightModel()
    @StateObject var shadowModel = ShadowWorkModel()
    @StateObject var personalJournalModel = PersonalJournalModel()
    @StateObject var creativeWritingModel = CreativeWritingModel()

    private var menuPrioritySwipeGesture: some Gesture {
        DragGesture(minimumDistance: 8)
            .onEnded { value in
                let horizontal = value.translation.width
                let absHorizontal = abs(value.translation.width)
                let absVertical = abs(value.translation.height)

                let shouldTreatAsMenuSwipe =
                    absHorizontal > 22 &&
                    absHorizontal >= absVertical * 0.45

                if shouldTreatAsMenuSwipe {
                    withAnimation(.easeInOut(duration: 0.4)) {
                        if horizontal > 0 {
                            navModel.showMenu = true
                        } else {
                            navModel.showMenu = false
                        }
                    }
                }
            }
    }

    var body: some View {
        ZStack {
            ZStack {
                getViewForScreen(navModel.selectedScreen)
                    .transition(.opacity)
            }
            .animation(.easeInOut(duration: 0.4), value: navModel.selectedScreen)
            .disabled(navModel.showMenu)
            .blur(radius: navModel.showMenu ? 5 : 0)
                .if(
                    navModel.selectedScreen != "ArtCreativeView" &&
                    navModel.selectedScreen != "WordSearchView" &&
                    navModel.selectedScreen != "LightTipsView" &&
                    navModel.selectedScreen != "DesignCreativeView" &&
                    navModel.selectedScreen != "MoodBoardView" &&
                    navModel.selectedScreen != "MoodBoardGalleryView" &&
                    !navModel.selectedScreen.contains("CheckView")
                ) { view in
                    view.simultaneousGesture(menuPrioritySwipeGesture)
                }

            if navModel.showMenu {
                Color(red: 0.0, green: 0.3, blue: 0.2, opacity: 0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.4)) {
                            navModel.showMenu = false
                        }
                    }

                HStack(spacing: 0) {
                    SideMenuView { selection in
                        withAnimation(.easeInOut(duration: 0.4)) {
                            navModel.selectedScreen = selection
                            navModel.showMenu = false
                        }
                    }
                    .frame(width: 240)
                    .background(Color(red: 0.0, green: 0.2, blue: 0.15))
                    .gesture(
                        DragGesture()
                            .onEnded { value in
                                if value.translation.width < -50 {
                                    withAnimation(.easeInOut(duration: 0.4)) {
                                        navModel.showMenu = false
                                    }
                                }
                            }
                    )

                    Spacer()
                }
                .transition(.move(edge: .leading))
            }

            if navModel.isTransitioningToLandscape {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.35, green: 0.80, blue: 0.75),
                        Color(red: 0.20, green: 0.65, blue: 0.60),
                        Color(red: 0.10, green: 0.45, blue: 0.45)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .transition(.opacity)
                .ignoresSafeArea()
            }
        }
        .hideKeyboardOnTap()
    }
    
    
    // MARK: - View Resolver
    func getViewForScreen(_ screen: String) -> AnyView {
        // ---- DYNAMIC ROUTES ----
        if screen.starts(with: "EntryView:") {
            let entryID = screen.replacingOccurrences(of: "EntryView:", with: "")
            return AnyView(
                EntryView(entryID: entryID)
                    .environmentObject(navModel)
                    .environmentObject(userProfile)
                    .environmentObject(lifespaceLogModel)
                    .environmentObject(budgetModel)
                    .environmentObject(weightLogModel)
                    .environmentObject(dreamJournalModel)
                    .environmentObject(personalJournalModel)
                    .environmentObject(creativeWritingModel)
                    .environmentObject(lightModel)
                    .environmentObject(shadowModel)
                    .environmentObject(goalsViewModel)
            )
        }
        
        if screen.starts(with: "JournalEntryView:") {
            let entryID = screen.replacingOccurrences(of: "JournalEntryView:", with: "")
            return AnyView(
                JournalEntryView(entryID: entryID)
                    .environmentObject(navModel)
                    .environmentObject(userProfile)
                    .environmentObject(lifespaceLogModel)
                    .environmentObject(budgetModel)
                    .environmentObject(weightLogModel)
                    .environmentObject(dreamJournalModel)
                    .environmentObject(personalJournalModel)
                    .environmentObject(creativeWritingModel)
                    .environmentObject(lightModel)
                    .environmentObject(shadowModel)
                    .environmentObject(goalsViewModel)
            )
        }
        
        // ---- LIFESTYLE SURVEY LOADING DYNAMIC ROUTE ----
        if screen.starts(with: "LifestyleSurveyLoadingView_") {
            let countString = screen.replacingOccurrences(of: "LifestyleSurveyLoadingView_", with: "")
            let count = Int(countString) ?? 18

            return AnyView(
                LifestyleSurveyLoadingView(questionCount: count)
                    .environmentObject(navModel)
                    .environmentObject(userProfile)
                    .environmentObject(lifespaceLogModel)
                    .environmentObject(budgetModel)
                    .environmentObject(weightLogModel)
                    .environmentObject(dreamJournalModel)
                    .environmentObject(personalJournalModel)
                    .environmentObject(creativeWritingModel)
                    .environmentObject(lightModel)
                    .environmentObject(shadowModel)
                    .environmentObject(goalsViewModel)
                    .environmentObject(userRecipeStore)
            )
        }
        
        if screen.starts(with: "CreativeEntryView:") {
            let entryID = screen.replacingOccurrences(of: "CreativeEntryView:", with: "")
            return AnyView(
                CreativeEntryView(entryID: entryID)
                    .environmentObject(navModel)
                    .environmentObject(userProfile)
                    .environmentObject(lifespaceLogModel)
                    .environmentObject(budgetModel)
                    .environmentObject(weightLogModel)
                    .environmentObject(dreamJournalModel)
                    .environmentObject(personalJournalModel)
                    .environmentObject(creativeWritingModel)
                    .environmentObject(lightModel)
                    .environmentObject(shadowModel)
                    .environmentObject(goalsViewModel)
            )
        }
        
        if screen.starts(with: "GoalPlannerView:") {
            let idString = screen.replacingOccurrences(of: "GoalPlannerView:", with: "")
            if let uuid = UUID(uuidString: idString),
               let idx = goalsViewModel.goals.firstIndex(where: { $0.id == uuid }) {
                return AnyView(
                    GoalPlannerView(goal: $goalsViewModel.goals[idx])
                        .environmentObject(navModel)
                        .environmentObject(userProfile)
                        .environmentObject(lifespaceLogModel)
                        .environmentObject(budgetModel)
                        .environmentObject(weightLogModel)
                        .environmentObject(dreamJournalModel)
                        .environmentObject(personalJournalModel)
                        .environmentObject(creativeWritingModel)
                        .environmentObject(lightModel)
                        .environmentObject(shadowModel)
                        .environmentObject(goalsViewModel)
                )
            }
            return AnyView(Text("Goal Not Found"))
        }
        
        if screen.starts(with: "GoalStepsView:") {
            let idString = screen.replacingOccurrences(of: "GoalStepsView:", with: "")
            if let uuid = UUID(uuidString: idString),
               let idx = goalsViewModel.goals.firstIndex(where: { $0.id == uuid }) {
                return AnyView(
                    GoalStepsView(goal: $goalsViewModel.goals[idx])
                        .environmentObject(navModel)
                        .environmentObject(userProfile)
                        .environmentObject(lifespaceLogModel)
                        .environmentObject(budgetModel)
                        .environmentObject(weightLogModel)
                        .environmentObject(dreamJournalModel)
                        .environmentObject(personalJournalModel)
                        .environmentObject(creativeWritingModel)
                        .environmentObject(lightModel)
                        .environmentObject(shadowModel)
                        .environmentObject(goalsViewModel)
                )
            }
            return AnyView(Text("Goal Not Found"))
        }
        
        // ---- REMINDERS DYNAMIC ROUTE ----
        if screen.starts(with: "ReminderImportItemView_") {
            let calendarID = screen.replacingOccurrences(of: "ReminderImportItemView_", with: "")
            let store = ReminderManagerSingleton.shared.store

            if let calendar = store.calendar(withIdentifier: calendarID) {
                return AnyView(
                    ReminderImportItemView(
                        calendar: calendar,
                        tasks: $toDoListModel.tasks
                    )
                    .environmentObject(navModel)
                )
            } else {
                return AnyView(Text("Calendar not found"))
            }
        }
        
        if screen.starts(with: "GoalView:") {
            let idString = screen.replacingOccurrences(of: "GoalView:", with: "")
            if let uuid = UUID(uuidString: idString),
               let idx = goalsViewModel.goals.firstIndex(where: { $0.id == uuid }) {
                return AnyView(
                    GoalView(goal: $goalsViewModel.goals[idx])
                        .environmentObject(navModel)
                        .environmentObject(userProfile)
                        .environmentObject(lifespaceLogModel)
                        .environmentObject(budgetModel)
                        .environmentObject(weightLogModel)
                        .environmentObject(dreamJournalModel)
                        .environmentObject(personalJournalModel)
                        .environmentObject(creativeWritingModel)
                        .environmentObject(lightModel)
                        .environmentObject(shadowModel)
                        .environmentObject(goalsViewModel)
                )
            }
            return AnyView(Text("Goal Not Found"))
        }
        
        if screen.starts(with: "RecipeModel:") {
            let recipeID = screen.replacingOccurrences(of: "RecipeModel:", with: "")
            if let recipe = modelRecipes.first(where: { $0.id == recipeID }) {
                return AnyView(
                    RecipeDetailView(recipe: recipe)
                        .environmentObject(navModel)
                        .environmentObject(userProfile)
                        .environmentObject(lifespaceLogModel)
                        .environmentObject(budgetModel)
                        .environmentObject(weightLogModel)
                        .environmentObject(dreamJournalModel)
                        .environmentObject(personalJournalModel)
                        .environmentObject(creativeWritingModel)
                        .environmentObject(lightModel)
                        .environmentObject(shadowModel)
                        .environmentObject(goalsViewModel)
                )
            }
            return AnyView(Text("Recipe not found"))
        }
        
        if screen.starts(with: "UserRecipeDetailView:") {
            let id = screen.replacingOccurrences(of: "UserRecipeDetailView:", with: "")
            return AnyView(
                UserRecipeDetailView(recipeID: id)
                    .environmentObject(navModel)
                    .environmentObject(userProfile)
                    .environmentObject(lifespaceLogModel)
                    .environmentObject(budgetModel)
                    .environmentObject(weightLogModel)
                    .environmentObject(dreamJournalModel)
                    .environmentObject(personalJournalModel)
                    .environmentObject(creativeWritingModel)
                    .environmentObject(lightModel)
                    .environmentObject(shadowModel)
                    .environmentObject(goalsViewModel)
                    .environmentObject(userRecipeStore)
            )
        }
        
        if screen.starts(with: "RecipePlannerView:") {
            let id = screen.replacingOccurrences(of: "RecipePlannerView:", with: "")

            return AnyView(
                RecipePlannerView(recipeID: id)
                    .environmentObject(navModel)
                    .environmentObject(userProfile)
                    .environmentObject(lifespaceLogModel)
                    .environmentObject(budgetModel)
                    .environmentObject(weightLogModel)
                    .environmentObject(dreamJournalModel)
                    .environmentObject(personalJournalModel)
                    .environmentObject(creativeWritingModel)
                    .environmentObject(lightModel)
                    .environmentObject(shadowModel)
                    .environmentObject(goalsViewModel)
                    .environmentObject(userRecipeStore)
            )
        }
        
        // ---- STATIC ROUTES ----
        var view: AnyView
        switch screen {
            case "HomeView": view = AnyView(HomeView())
            case "LifestyleSurveyView": view = AnyView(LifestyleSurveyView())
            case "FitnessSpaceView": view = AnyView(FitnessSpaceView())
            case "DayPlannerView": view = AnyView(DayPlannerView())
            case "BudgetPlannerView": view = AnyView(BudgetPlannerView())
            case "JournalView": view = AnyView(JournalView())
            case "GoalsView": view = AnyView(GoalsView())
            case "FiveYearPlanView": view = AnyView(FiveYearPlanView())
            case "PhotographyCreativeView": view = AnyView(PhotographyCreativeView())
            case "PhotographyPicsView": view = AnyView(PhotographyPicsView())
            case "MusicView": view = AnyView(MusicView())
            case "SettingsView": view = AnyView(SettingsView())
            case "MenuTutorialView": view = AnyView(MenuTutorialView())
            case "OptimizationInfoView": view = AnyView(OptimizationInfoView())
            case "DesignCreativeView": view = AnyView(DesignCreativeView())
            case "LifespaceInfoView": view = AnyView(LifespaceInfoView())
            case "DemoView": view = AnyView(DemoView())
            case "StartView": view = AnyView(StartView())
            case "MoodBoardView": view = AnyView(MoodBoardView())
            case "ActivitySetupView": view = AnyView(ActivitySetupView())
            case "ExpressionSetupView": view = AnyView(ExpressionSetupView())
            case "FitnessSetupView": view = AnyView(FitnessSetupView())
            case "InnerWorkSetupView": view = AnyView(InnerWorkSetupView())
            case "InnerWorkInfoView": view = AnyView(InnerWorkInfoView())
            case "PurposeSetupView": view = AnyView(PurposeSetupView())
            case "SetupCompletionView": view = AnyView(SetupCompletionView())
            case "ActivityCheckView": view = AnyView(ActivityCheckView())
            case "EatingCheckView": view = AnyView(EatingCheckView())
            case "FitnessCheckView": view = AnyView(FitnessCheckView())
            case "LightCheckView": view = AnyView(LightCheckView())
            case "PurposeCheckView": view = AnyView(PurposeCheckView())
            case "SensoryCheckView": view = AnyView(SensoryCheckView())
            case "NotificationsView": view = AnyView(NotificationsView())
            case "DreamPasswordView": view = AnyView(DreamPasswordView())
            case "CreateDreamPasswordView": view = AnyView(CreateDreamPasswordView())
            case "AbsView": view = AnyView(AbsView())
            case "GlutesView": view = AnyView(GlutesView())
            case "CalvesView": view = AnyView(CalvesView())
            case "BicepsView": view = AnyView(BicepsView())
            case "ChestView": view = AnyView(ChestView())
            case "HamstringsView": view = AnyView(HamstringsView())
            case "ShouldersView": view = AnyView(ShouldersView())
            case "TricepsView": view = AnyView(TricepsView())
            case "ForearmsView": view = AnyView(ForearmsView())
            case "PushUpsView": view = AnyView(PushUpsView())
            case "SitUpsView": view = AnyView(SitUpsView())
            case "ElbowPlankView": view = AnyView(ElbowPlankView())
            case "LyingTuckCrunchView": view = AnyView(LyingTuckCrunchView())
            case "HammerCurlsView": view = AnyView(HammerCurlsView())
            case "BentOverShoulderPullsView": view = AnyView(BentOverShoulderPullsView())
            case "ArnoldPressView": view = AnyView(ArnoldPressView())
            case "EmptyTheCanView": view = AnyView(EmptyTheCanView())
            case "LateralShoulderRaiseView": view = AnyView(LateralShoulderRaiseView())
            case "ShoulderCrossRaiseView": view = AnyView(ShoulderCrossRaiseView())
            case "ComplexShoulderRaiseView": view = AnyView(ComplexShoulderRaiseView())
            case "WristPushUpView": view = AnyView(WristPushUpView())
            case "BurpeeJumpPushUpView": view = AnyView(BurpeeJumpPushUpView())
            case "KettlebellSwingSquatView": view = AnyView(KettlebellSwingSquatView())
            case "ElevatedSquatsView": view = AnyView(ElevatedSquatsView())
            case "ReverseLungeView": view = AnyView(ReverseLungeView())
            case "SquatsView": view = AnyView(SquatsView())
            case "NarrowLungeSquatView": view = AnyView(NarrowLungeSquatView())
            case "GobletSquatsView": view = AnyView(GobletSquatsView())
            case "NeutralWristCurlsView": view = AnyView(NeutralWristCurlsView())
            case "RotatedWristCurlsView": view = AnyView(RotatedWristCurlsView())
            case "ReverseWristCurlsView": view = AnyView(ReverseWristCurlsView())
            case "HammerWristCurlsView": view = AnyView(HammerWristCurlsView())
            case "ForearmRotationView": view = AnyView(ForearmRotationView())
            case "NegativePushUpsView": view = AnyView(NegativePushUpsView())
            case "GluteBridgeChestPressView": view = AnyView(GluteBridgeChestPressView())
            case "FloorSqueezeChestPressView": view = AnyView(FloorSqueezeChestPressView())
            case "ChestCrossRaiseView": view = AnyView(ChestCrossRaiseView())
            case "AnkleCirclesView": view = AnyView(AnkleCirclesView())
            case "LyingCalfStretchView": view = AnyView(LyingCalfStretchView())
            case "WallCalfStretchView": view = AnyView(WallCalfStretchView())
            case "RollingCalvesView": view = AnyView(RollingCalvesView())
            case "StandingCalfRaiseView": view = AnyView(StandingCalfRaiseView())
            case "CrucifixCurlsView": view = AnyView(CrucifixCurlsView())
            case "InnerBicepCurlsView": view = AnyView(InnerBicepCurlsView())
            case "BentOverCurlsView": view = AnyView(BentOverCurlsView())
            case "FishPoseMatsyasanaView": view = AnyView(FishPoseMatsyasanaView())
            case "CrissCrossLegRaiseView": view = AnyView(CrissCrossLegRaiseView())
            case "WeightTrackerView": view = AnyView(WeightTrackerView())
            case "WorkoutPlannerView": view = AnyView(WorkoutPlannerView())
            case "MealPlannerView": view = AnyView(MealPlannerView())
            case "TimerView": view = AnyView(TimerView())
            case "ADHDTipsView": view = AnyView(ADHDTipsView())
            case "ADHDTwentyFiveView": view = AnyView(ADHDTwentyFiveView())
            case "ADHDDiagnosticView": view = AnyView(ADHDDiagnosticView())
            case "AnxietyTipsView": view = AnyView(AnxietyTipsView())
            case "AutismResetView": view = AnyView(AutismResetView())
            case "BPDResetView": view = AnyView(BPDResetView())
            case "CPTSDResetView": view = AnyView(CPTSDResetView())
            case "CPTSDDiagnosticView": view = AnyView(CPTSDDiagnosticView())
            case "CPTSDTipsView": view = AnyView(CPTSDTipsView())
            case "CPTSDTwentyFiveView": view = AnyView(CPTSDTwentyFiveView())
            case "ADHDResetView": view = AnyView(ADHDResetView())
            case "AnxietyResetView": view = AnyView(AnxietyResetView())
            case "DiagnosticReminderView": view = AnyView(DiagnosticReminderView())
            case "AnxietyResultView": view = AnyView(AnxietyResultView())
            case "DepressionResultView": view = AnyView(DepressionResultView())
            case "ADHDResultView": view = AnyView(ADHDResultView())
            case "AutismResultView": view = AnyView(AutismResultView())
            case "BPDResultView": view = AnyView(BPDResultView())
            case "PsychosisResultView": view = AnyView(PsychosisResultView())
            case "PSSDResultView": view = AnyView(PSSDResultView())
            case "CPTSDResultView": view = AnyView(CPTSDResultView())
            case "PSSDTipsView": view = AnyView(PSSDTipsView())
            case "GutBrainView": view = AnyView(GutBrainView())
            case "CircadianRhythmView": view = AnyView(CircadianRhythmView())
            case "MealPrepView": view = AnyView(MealPrepView())
            case "SleepHygieneView": view = AnyView(SleepHygieneView())
            case "SleepHygieneInfoView": view = AnyView(SleepHygieneInfoView())
            case "LIFESPACEGamesView": view = AnyView(LIFESPACEGamesView())
            case "WordSearchView": view = AnyView(WordSearchView())
            case "CheckersView": view = AnyView(CheckersView())
            case "ChessView": view = AnyView(ChessView())
            case "HangmanView": view = AnyView(HangmanView())
            case "OrthomolecularView": view = AnyView(OrthomolecularView())
            case "TestosteroneView": view = AnyView(TestosteroneView())
            case "PSSDDiagnosticView": view = AnyView(PSSDDiagnosticView())
            case "PSSDTwentyFiveView": view = AnyView(PSSDTwentyFiveView())
            case "PSSDResetView": view = AnyView(PSSDResetView())
            case "AnxietyDiagnosticView": view = AnyView(AnxietyDiagnosticView())
            case "AnxietyTwentyFiveView": view = AnyView(AnxietyTwentyFiveView())
            case "AutismTipsView": view = AnyView(AutismTipsView())
            case "AutismDiagnosticView": view = AnyView(AutismDiagnosticView())
            case "AutismTwentyFiveView": view = AnyView(AutismTwentyFiveView())
            case "DepressionTipsView": view = AnyView(DepressionTipsView())
            case "DepressionDiagnosticView": view = AnyView(DepressionDiagnosticView())
            case "DepressionTwentyFiveView": view = AnyView(DepressionTwentyFiveView())
            case "BPDTipsView": view = AnyView(BPDTipsView())
            case "BPDDiagnosticView": view = AnyView(BPDDiagnosticView())
            case "BPDTwentyFiveView": view = AnyView(BPDTwentyFiveView())
            case "PsychosisTipsView": view = AnyView(PsychosisTipsView())
            case "PsychosisDiagnosticView": view = AnyView(PsychosisDiagnosticView())
            case "PsychosisTwentyFiveView": view = AnyView(PsychosisTwentyFiveView())
            case "ActivityTipsView": view = AnyView(ActivityTipsView())
            case "NewYearView": view = AnyView(NewYearView())
            case "SmartView": view = AnyView(SmartView())
            case "FinalWordView": view = AnyView(FinalWordView())
            case "DailyGoalView": view = AnyView(DailyGoalView())
            case "LightTipsView": view = AnyView(LightTipsView())
            case "InnerWorkTipsView": view = AnyView(InnerWorkTipsView())
            case "FitnessTipsView": view = AnyView(FitnessTipsView())
            case "EatingTipsView": view = AnyView(EatingTipsView())
            case "SensoryTipsView": view = AnyView(SensoryTipsView())
            case "PurposeTipsView": view = AnyView(PurposeTipsView())
            case "RecipeIndexView": view = AnyView(RecipeIndexView())
            case "CommunityTipsView": view = AnyView(CommunityTipsView())
            case "ExpressionTipsView": view = AnyView(ExpressionTipsView())
            case "FashionPicsView": view = AnyView(FashionPicsView())
            case "FashionCreativeView": view = AnyView(FashionCreativeView())
            case "FengShuiView": view = AnyView(FengShuiView())
            case "DopamineView": view = AnyView(DopamineView())
            case "MeetupsProfileView": view = AnyView(MeetupsProfileView())
            case "EatingInformationView": view = AnyView(EatingInformationView())
            case "MeetupsView": view = AnyView(MeetupsView())
            case "DepressionResetView": view = AnyView(DepressionResetView())
            case "PsychosisResetView": view = AnyView(PsychosisResetView())
            case "ChooseJournalView": view = AnyView(ChooseJournalView())
            case "PersonalJournalView": view = AnyView(PersonalJournalView())
            case "CreativeWritingView": view = AnyView(CreativeWritingView())
            case "SerotoninView": view = AnyView(SerotoninView())
            case "GABAView": view = AnyView(GABAView())
            case "GlutamateView": view = AnyView(GlutamateView())
            case "AcetylcholineView": view = AnyView(AcetylcholineView())
            case "EpinephrineView": view = AnyView(EpinephrineView())
            case "PyramidView": view = AnyView(PyramidView())
            case "LifespacePyramidView": view = AnyView(LifespacePyramidView())
            case "BigLifespacePyramidView": view = AnyView(BigLifespacePyramidView())
            case "BigMaslowPyramidView": view = AnyView(BigMaslowPyramidView())
            case "TipsView": view = AnyView(TipsView())
            case "SundayView": view = AnyView(SundayView())
            case "MondayView": view = AnyView(MondayView())
            case "TuesdayView": view = AnyView(TuesdayView())
            case "WednesdayView": view = AnyView(WednesdayView())
            case "ThursdayView": view = AnyView(ThursdayView())
            case "FridayView": view = AnyView(FridayView())
            case "SaturdayView": view = AnyView(SaturdayView())
            case "AnalyticsView": view = AnyView(AnalyticsView())
            case "ResultsView": view = AnyView(ResultsView())
            case "CommunityCheckView": view = AnyView(CommunityCheckView())
            case "ExpressionCheckView": view = AnyView(ExpressionCheckView())
            case "InnerWorkCheckView": view = AnyView(InnerWorkCheckView())
            case "CustomActivityView": view = AnyView(CustomActivityView())
            case "CustomCreativeView": view = AnyView(CustomCreativeView())
            case "StatsSetupView": view = AnyView(StatsSetupView())
            case "SetupConfirmationView": view = AnyView(SetupConfirmationView())
            case "LoadingView": view = AnyView(LoadingView())
            case "SetupConfirmationView2": view = AnyView(SetupConfirmationView2())
            case "CustomInnerWorkView": view = AnyView(CustomInnerWorkView())
            case "DisclaimerView": view = AnyView(DisclaimerView())
            case "WarmLightView":
                return AnyView(WarmLightView()
                    .environmentObject(lightModel))
            case "CoolLightView": view = AnyView(CoolLightView())
            case "NeutralLightView": view = AnyView(NeutralLightView())
            case "RedView": view = AnyView(RedView())
            case "OrangeView": view = AnyView(OrangeView())
            case "YellowView": view = AnyView(YellowView())
            case "GreenView": view = AnyView(GreenView())
            case "BlueView": view = AnyView(BlueView())
            case "IndigoView": view = AnyView(IndigoView())
            case "VioletView": view = AnyView(VioletView())
            case "ToDoListView": view = AnyView(ToDoListView())
            case "WeeklyTrackerView": view = AnyView(EmptyView())
            case "SpendingView": view = AnyView(SpendingView())
            case "YogaView": view = AnyView(YogaView())
            case "PrayerView": view = AnyView(PrayerView())
            case "RepentanceView": view = AnyView(RepentanceView())
            case "RecipeResultsView": view = AnyView(RecipeResultsView())
            case "AssistanceView": view = AnyView(AssistanceView())
            case "ProtectionView": view = AnyView(ProtectionView())
            case "DeliveranceView": view = AnyView(DeliveranceView())
            case "FastingView": view = AnyView(FastingView())
            case "AromatherapyView": view = AnyView(AromatherapyView())
            case "MeditationView": view = AnyView(MeditationView())
            case "MirrorWorkView": view = AnyView(MirrorWorkView())
            case "DreamJournalView": view = AnyView(DreamJournalView())
            case "BreathworkView": view = AnyView(BreathworkView())
            case "TarotView": view = AnyView(TarotView())
            case "TarotStudyView": view = AnyView(TarotStudyView())
            case "FullDeckView": view = AnyView(FullDeckView())
            case "MajorArcanaView": view = AnyView(MajorArcanaView())
            case "MinorArcanaView": view = AnyView(MinorArcanaView())
            case "RoyalsView": view = AnyView(RoyalsView())
            case "CupsView": view = AnyView(CupsView())
            case "SwordsView": view = AnyView(SwordsView())
            case "PentaclesView": view = AnyView(PentaclesView())
            case "WandsView": view = AnyView(WandsView())
            case "SoundBathView": view = AnyView(SoundBathView())
            case "NatureWalkView": view = AnyView(NatureWalkView())
            case "SingingView": view = AnyView(SingingView())
            case "ShadowWorkView": view = AnyView(ShadowWorkView())
            case "ColdShowerView": view = AnyView(ColdShowerView())
            case "NatureWalkGalleryView": view = AnyView(NatureWalkGalleryView())
            case "MoodBoardGalleryView": view = AnyView(MoodBoardGalleryView())
            case "ProgressPicsView": view = AnyView(ProgressPicsView())
            case "CookingCreativeView": view = AnyView(CookingCreativeView())
            case "WritingCreativeView": view = AnyView(WritingCreativeView())
            case "FoodPicsView": view = AnyView(FoodPicsView())
            case "RecipePlannerView": view = AnyView(RecipePlannerView())
            case "MyRecipesView": view = AnyView(MyRecipesView())
            case "MusicCreativeView": view = AnyView(MusicCreativeView())
            case "DanceCreativeView": view = AnyView(DanceCreativeView())
            case "ArtCreativeView": view = AnyView(ArtCreativeView())
            case "AstrologyView": view = AnyView(AstrologyView())
            case "AriesView": view = AnyView(AriesView())
            case "TaurusView": view = AnyView(TaurusView())
            case "GeminiView": view = AnyView(GeminiView())
            case "CancerView": view = AnyView(CancerView())
            case "LeoView": view = AnyView(LeoView())
            case "VirgoView": view = AnyView(VirgoView())
            case "LibraView": view = AnyView(LibraView())
            case "ScorpioView": view = AnyView(ScorpioView())
            case "SagittariusView": view = AnyView(SagittariusView())
            case "FiveYearGoalView": view = AnyView(FiveYearGoalView())
            case "CapricornView": view = AnyView(CapricornView())
            case "AquariusView": view = AnyView(AquariusView())
            case "PiscesView": view = AnyView(PiscesView())
            case "CandleWorkView": view = AnyView(CandleWorkView())
            case "TaiChiView": view = AnyView(TaiChiView())
            case "ReminderImportListView": view = AnyView(ReminderImportListView())
            case "GroceryListView": view = AnyView(GroceryListView())
            case "FavoriteRecipesView": view = AnyView(FavoriteRecipesView())
            case "LifestyleSurveyQuestionView_18": view = AnyView(LifestyleSurveyQuestionView(questionCount: 18))
            case "LifestyleSurveyQuestionView_36": view = AnyView(LifestyleSurveyQuestionView(questionCount: 36))
            case "LifestyleSurveyQuestionView_72": view = AnyView(LifestyleSurveyQuestionView(questionCount: 72))
            case "LifestyleSurveyQuestionView_54": view = AnyView(LifestyleSurveyQuestionView(questionCount: 54))                     default: view = AnyView(Text("Unknown View"))
        }
        
        return AnyView(
            view
                .environmentObject(navModel)
                .environmentObject(userProfile)
                .environmentObject(lifespaceLogModel)
                .environmentObject(budgetModel)
                .environmentObject(weightLogModel)
                .environmentObject(dreamJournalModel)
                .environmentObject(personalJournalModel)
                .environmentObject(creativeWritingModel)
                .environmentObject(lightModel)
                .environmentObject(shadowModel)
                .environmentObject(goalsViewModel)
                .environmentObject(userRecipeStore)
        )
    }
}
