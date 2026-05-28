import SwiftUI
import EventKit

struct ToDoListView: View {
    @EnvironmentObject var navModel: NavigationModel
    @EnvironmentObject var lifespaceLogModel: LifespaceLogModel
    @EnvironmentObject var userProfile: UserProfileModel
    @EnvironmentObject var toDoListModel: ToDoListModel

    @State private var newTask: String = ""
    @State private var selectedUrgentItem: ToDoItem? = nil

    let tasksKey = "userTasks"

    var body: some View {
        ZStack {
            LifespaceBackground()
                .hideKeyboardOnTap()

            VStack(spacing: 16) {
                Text("TO-DO LIST")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
                    .padding(.top)

                HStack {
                    TextField("Add a new task...", text: $newTask)
                        .padding(10)
                        .background(Color.white)
                        .cornerRadius(8)
                        .foregroundColor(.black)
                        .padding(.trailing, 8)

                    Button(action: addTask) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                }

                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(toDoListModel.tasks) { item in
                            ToDoListRow(
                                item: item,
                                onComplete: {
                                    handleCompletion(for: item)
                                },
                                onLongPress: {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        selectedUrgentItem = item
                                    }
                                }
                            )
                        }
                    }
                }

                Spacer()

                HStack(spacing: 16) {
                    Button(action: {
                        navModel.push("ReminderImportListView")
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "arrow.down.doc")
                                .font(.title3)

                            Text("Import Reminders")
                                .fontWeight(.semibold)
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal, 18)
                        .background(tealGradient)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(radius: 4, y: 2)
                    }

                    Button(action: {
                        navModel.push("HomeView")
                    }) {
                        Image(systemName: "house.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding(12)
                            .background(tealGradient)
                            .cornerRadius(12)
                    }
                }
                .padding(.bottom, 20)
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding()

            // 🔥 TRUE TOP-LAYER POPUP (no clipping, no shifting)
            if let selectedItem = selectedUrgentItem {
                ZStack {
                    Color.black.opacity(0.001)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                selectedUrgentItem = nil
                            }
                        }

                    VStack(spacing: 10) {
                        Text("Task urgent?")
                            .foregroundColor(.white)
                            .font(.system(size: 14, weight: .bold))

                        HStack(spacing: 12) {
                            Button("YES") {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    markUrgent(selectedItem)
                                    selectedUrgentItem = nil
                                }
                            }
                            .foregroundColor(.white)
                            .padding(.vertical, 6)
                            .padding(.horizontal, 14)
                            .background(Color.red)
                            .cornerRadius(8)

                            Button("NO") {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    removeUrgent(selectedItem)
                                    selectedUrgentItem = nil
                                }
                            }
                            .foregroundColor(.white)
                            .padding(.vertical, 6)
                            .padding(.horizontal, 14)
                            .background(Color.white.opacity(0.25))
                            .cornerRadius(8)
                        }
                    }
                    .padding(12)
                    .background(Color.black.opacity(0.8))
                    .cornerRadius(14)
                    .shadow(radius: 8)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                    .padding(.top, 260)
                    .padding(.trailing, 40)
                }
                .zIndex(999)
                .transition(.opacity)
            }
        }
        .onAppear {
            autoGenerateLifespaceTasks()
        }
    }

    // MARK: - Logic (unchanged)

    func markUrgent(_ item: ToDoItem) {
        guard let index = toDoListModel.tasks.firstIndex(where: { $0.id == item.id }) else { return }
        toDoListModel.tasks[index].isUrgent = true
        sortTasks()
        saveTasks()
    }

    func removeUrgent(_ item: ToDoItem) {
        guard let index = toDoListModel.tasks.firstIndex(where: { $0.id == item.id }) else { return }
        toDoListModel.tasks[index].isUrgent = false
        sortTasks()
        saveTasks()
    }

    func addTask() {
        let trimmedTask = newTask.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTask.isEmpty else { return }
        toDoListModel.tasks.append(ToDoItem(title: trimmedTask, isCompleted: false))
        newTask = ""
        sortTasks()
        saveTasks()
    }

    func handleCompletion(for item: ToDoItem) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            toDoListModel.tasks.removeAll { $0.id == item.id }
            saveTasks()
        }
    }

    func sortTasks() {
        toDoListModel.tasks.sort {
            if $0.isUrgent != $1.isUrgent {
                return $0.isUrgent && !$1.isUrgent
            } else {
                return $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending
            }
        }
    }

    func saveTasks() {
        if let data = try? JSONEncoder().encode(toDoListModel.tasks) {
            UserDefaults.standard.set(data, forKey: tasksKey)
        }
    }

    func autoGenerateLifespaceTasks() {
        let scores = lifespaceLogModel.lifetimeModuleAverages()
        let under80 = scores.filter { $0.value < 80 }
        guard !under80.isEmpty else { return }

        let sorted = under80.sorted { $0.value < $1.value }
        let lowest = Array(sorted.prefix(3))
        let autoTasks = lowest.map { taskForModule($0.key) }

        for task in autoTasks {
            if !toDoListModel.tasks.contains(where: { $0.title == task }) {
                toDoListModel.tasks.append(ToDoItem(title: task, isCompleted: false))
            }
        }

        sortTasks()
        saveTasks()
    }

    func taskForModule(_ module: LifespaceModule) -> String {
        switch module {
        case .light: return "Get 15 minutes of sunlight"
        case .innerWork: return "Practice meditation"
        case .fitness: return "Work out"
        case .eating: return "Meal prep"
        case .sensory: return "Clean the house"
        case .purpose: return "Set goals"
        case .activity: return "Do a fun activity"
        case .community: return "Meet someone new"
        case .expression: return "Practice creative skill"
        }
    }

    var tealGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(red: 0.35, green: 0.80, blue: 0.75),
                Color(red: 0.20, green: 0.65, blue: 0.60),
                Color(red: 0.10, green: 0.45, blue: 0.45)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}
