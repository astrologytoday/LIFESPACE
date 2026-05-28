import SwiftUI

struct MondayView: View {
    @EnvironmentObject var navModel: NavigationModel

    @AppStorage("MondayWorkout") var mondayWorkout: String = "Legs / Abs"
    @AppStorage("MondayWorkoutList") private var savedWorkoutData: String = ""

    @State private var workout: [String] = Array(repeating: "", count: 10)
    @State private var showTitle = false

    @State private var showClearConfirm = false
    @FocusState private var focusedIndex: Int?

    var body: some View {
        ZStack {
            // 🌊 LIFESPACE Teal Gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.35, green: 0.80, blue: 0.75),
                    Color(red: 0.20, green: 0.65, blue: 0.60),
                    Color(red: 0.10, green: 0.45, blue: 0.45)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            ScrollViewReader { proxy in
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {

                        // 🧠 Title
                        Text("MONDAY – \(mondayWorkout.uppercased())")
                            .font(.custom("Avenir-Heavy", size: 26))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.top, 60)
                            .opacity(showTitle ? 1 : 0)
                            .animation(.easeInOut(duration: 0.8), value: showTitle)

                        // 🔢 10 Editable Workouts
                        VStack(spacing: 12) {
                            ForEach(0..<10, id: \.self) { index in
                                HStack(alignment: .center) {
                                    Text("\(index + 1).")
                                        .foregroundColor(.white)
                                        .font(.custom("Avenir", size: 18))
                                        .frame(width: 28, alignment: .leading)

                                    TextField("Enter workout \(index + 1)...", text: $workout[index])
                                        .padding(10)
                                        .background(Color.white.opacity(0.15))
                                        .cornerRadius(10)
                                        .foregroundColor(.white)
                                        .font(.custom("Avenir", size: 16))
                                        .focused($focusedIndex, equals: index)
                                        .submitLabel(.done)
                                        .onSubmit { focusedIndex = nil }
                                        .onChange(of: workout[index]) { _ in
                                            saveWorkoutList()
                                        }
                                        .id(index)
                                }
                                .padding(.horizontal)
                            }
                        }

                        // ✅ Bigger spacer since buttons no longer lift above keyboard
                        Spacer(minLength: 320)
                    }
                }
                .onChange(of: focusedIndex) { idx in
                    guard let idx else { return }

                    // ✅ If typing in top rows, DON'T move the screen.
                    if idx <= 1 { return }

                    // ✅ If typing lower rows, scroll them into view.
                    let anchor: UnitPoint = (idx >= 7) ? .bottom : .center
                    withAnimation(.easeInOut(duration: 0.25)) {
                        proxy.scrollTo(idx, anchor: anchor)
                    }
                }
            }
        }
        // ✅ Buttons stay pinned at true bottom (keyboard can cover them)
        .safeAreaInset(edge: .bottom) {
            HStack(spacing: 40) {

                // ⬅️ Back
                Button(action: { navModel.pop() }) {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(red: 0.85, green: 1.0, blue: 0.9),
                                    Color(red: 0.4, green: 0.9, blue: 0.8)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 60, height: 60)
                        .overlay(
                            Image(systemName: "chevron.left")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.black)
                        )
                }

                // 🏠 Home
                Button(action: { navModel.push("HomeView") }) {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(red: 0.85, green: 1.0, blue: 0.9),
                                    Color(red: 0.4, green: 0.9, blue: 0.8)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 60, height: 60)
                        .overlay(
                            Image(systemName: "house.fill")
                                .font(.system(size: 26, weight: .bold))
                                .foregroundColor(.black)
                        )
                }

                // 🗑️ Trash (same background, red icon)
                Button(action: { showClearConfirm = true }) {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(red: 0.85, green: 1.0, blue: 0.9),
                                    Color(red: 0.4, green: 0.9, blue: 0.8)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 60, height: 60)
                        .overlay(
                            Image(systemName: "trash.fill")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(Color(red: 0.75, green: 0.10, blue: 0.12))
                        )
                }
                .alert("Clear Workouts?", isPresented: $showClearConfirm) {
                    Button("No", role: .cancel) { }
                    Button("Yes", role: .destructive) {
                        workout = Array(repeating: "", count: 10)
                        savedWorkoutData = ""
                        focusedIndex = nil
                    }
                } message: {
                    Text("Are you sure you want to clear workouts?")
                }
            }
            .padding(.top, 10)
            .padding(.bottom, 16)
            .frame(maxWidth: .infinity)
            .background(Color.clear)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)

        .onAppear {
            showTitle = true
            loadWorkoutList()
        }
    }

    // MARK: - Persistence Functions
    func saveWorkoutList() {
        if let data = try? JSONEncoder().encode(workout),
           let jsonString = String(data: data, encoding: .utf8) {
            savedWorkoutData = jsonString
        }
    }

    func loadWorkoutList() {
        if let data = savedWorkoutData.data(using: .utf8),
           let decoded = try? JSONDecoder().decode([String].self, from: data),
           decoded.count == 10 {
            workout = decoded
        }
    }
}
