import SwiftUI

struct WorkoutPlannerView: View {
    @EnvironmentObject var navModel: NavigationModel

    // Persisted text entries for each day's workout
    @AppStorage("SundayWorkout") var sundayWorkout: String = ""
    @AppStorage("MondayWorkout") var mondayWorkout: String = ""
    @AppStorage("TuesdayWorkout") var tuesdayWorkout: String = ""
    @AppStorage("WednesdayWorkout") var wednesdayWorkout: String = ""
    @AppStorage("ThursdayWorkout") var thursdayWorkout: String = ""
    @AppStorage("FridayWorkout") var fridayWorkout: String = ""
    @AppStorage("SaturdayWorkout") var saturdayWorkout: String = ""

    @State private var showTitle = false
    @State private var showHelpBubble = false

    var body: some View {
        GeometryReader { geometry in
            let safeBottom = geometry.safeAreaInsets.bottom
            let bottomPadding = max(20, safeBottom + 12)

            ZStack(alignment: .topTrailing) {
                // BG
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

                // --- QUESTION BUBBLE in the true top right ---
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        showHelpBubble.toggle()
                    }
                }) {
                    Image(systemName: "questionmark")
                        .font(.system(size: 15))       // Smaller icon
                        .foregroundColor(.white)
                        .padding(9)                                   // Smaller touch target
                        .background(Color.white.opacity(0.06))
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 0.5))
                        .shadow(color: .black.opacity(0.12), radius: 2, x: 0, y: 2)
                }
                .padding(.trailing, 42)    // More space from right edge (moves left)
                .padding(.top, 36)         // Less space from top (moves up)

                VStack(spacing: 24) {
                    Text("Workout Schedule")
                        .font(Font.custom("Avenir", size: 26).weight(.bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.top, 80)
                        .opacity(showTitle ? 1 : 0)
                        .animation(.easeInOut(duration: 1), value: showTitle)

                    ForEach(weekdays, id: \.self) { day in
                        HStack(spacing: 16) {
                            Button(action: {
                                navModel.push("\(day)View")
                            }) {
                                Text(day.uppercased())
                                    .foregroundColor(.white)
                                    .font(Font.custom("Avenir", size: 16).weight(.semibold))
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.75)
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 10)
                                    .background(Color.white.opacity(0.2))
                                    .cornerRadius(10)
                            }

                            TextField("Enter muscle group...", text: binding(for: day))
                                .padding(10)
                                .background(Color.white.opacity(0.15))
                                .cornerRadius(8)
                                .foregroundColor(.white)
                                .font(Font.custom("Avenir", size: 16))
                        }
                        .padding(.horizontal)
                    }

                    // --- Help bubble APPEARS HERE ---
                    if showHelpBubble {
                        Text("Tap any day of the week to start building an exercise plan.")
                            .font(.system(size: 16))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.vertical, 20)
                            .padding(.horizontal, 24)
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.black.opacity(0.08))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(Color.white.opacity(0.7), lineWidth: 1.3)
                                    )
                                    .shadow(color: Color.yellow.opacity(0.12), radius: 6, x: 0, y: 4)
                            )
                            .frame(maxWidth: 320)
                            .padding(.top, 16)
                            .transition(.opacity.combined(with: .move(edge: .bottom)))
                            .animation(.easeInOut(duration: 0.35), value: showHelpBubble)
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 15) {
                                    withAnimation(.easeInOut(duration: 0.5)) {
                                        showHelpBubble = false
                                    }
                                }
                            }
                    }

                    Spacer(minLength: 28)

                    HStack(spacing: 40) {
                        Button(action: {
                            navModel.pop()
                        }) {
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
                                    Image(systemName: "arrow.left")
                                        .font(.system(size: 26, weight: .bold))
                                        .foregroundColor(.black)
                                )
                        }

                        Button(action: {
                            navModel.push("HomeView")
                        }) {
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
                    }
                    .padding(.bottom, bottomPadding)
                }
                .padding(.top, 0)
            }
            .onAppear {
                showTitle = true
            }
        }
    }

    // Days in week
    var weekdays: [String] {
        ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    }

    // Dynamic binding for each day's storage
    func binding(for day: String) -> Binding<String> {
        switch day {
        case "Sunday": return $sundayWorkout
        case "Monday": return $mondayWorkout
        case "Tuesday": return $tuesdayWorkout
        case "Wednesday": return $wednesdayWorkout
        case "Thursday": return $thursdayWorkout
        case "Friday": return $fridayWorkout
        case "Saturday": return $saturdayWorkout
        default: return .constant("")
        }
    }
}
