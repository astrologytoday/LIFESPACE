//
//  MealPrepView.swift
//  LIFESPACE
//
//  Created by Mario Sbardella on 2025-12-20.
//


import SwiftUI

struct MealPrepView: View {
    @EnvironmentObject var navModel: NavigationModel
    @State private var appeared = false

    var body: some View {
        ZStack(alignment: .topLeading) {

            // 🌊 LIFESPACE gradient background
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

            VStack(spacing: 18) {

                // Header
                VStack(alignment: .leading, spacing: 10) {
                    Text("Meal Prep")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(radius: 4)
                        .opacity(appeared ? 1 : 0)
                        .offset(y: appeared ? 0 : 10)
                        .animation(.easeInOut(duration: 0.4), value: appeared)

                    Text("Build rhythm. Reduce friction. Eat like it’s already decided.")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white.opacity(0.9))
                        .opacity(appeared ? 1 : 0)
                        .offset(y: appeared ? 0 : 10)
                        .animation(.easeInOut(duration: 0.4).delay(0.08), value: appeared)
                }
                .padding(.top, 28)
                .padding(.horizontal, 18)

                // Scrollable content container
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 16) {

                        infoCard(title: "How to Meal Prep") {
                            bullet("The LIFESPACE approach is simple: prep 3 days at a time so the food stays fresh and you stay flexible.")
                            bullet("Momentum matters more than perfection. Cook healthy meals that you know you are going to want to eat.")
                            bullet("Cut up the vegetables you know you’ll use in the next 3 days.")
                            bullet("If a meal can be eaten cold or reheated easily, prep it in advance.")
                            bullet("Try cooking lunch for the next day while you’re making dinner.")
                        }

                        infoCard(title: "The LIFESPACE Shortcut: Dinner Becomes Lunch") {
                            bullet("When you cook dinner, automatically create one extra portion.")
                            bullet("That extra portion becomes tomorrow’s lunch or tomorrow night’s leftovers.")
                            bullet("This is the easiest way to meal prep without “meal prepping.”")
                        }

                        infoCard(title: "Using the Meal Planner and Grocery List") {
                            bullet("Meal Planner comes with many pre-loaded randomized meal plans designed for mood support, calming support, focus, and grounding support.")
                            bullet("Once you have meals selected, use the Grocery List to quickly see what to buy.")
                        }

                        infoCard(title: "How to Use the Meal Planner") {
                            bullet("Use the randomized meal plan star button to generate a plan.")
                            bullet("Hold down a recipe to activate the copy, delete, & paste buttons.")
                            bullet("Delete meals you don’t want, then copy & paste meals you do.")
                            bullet("Fill lunches by copying dinners from the previous night and pasting them into lunch as leftovers.")
                            bullet("You can also paste dinners forward as leftovers for the next day to reduce cooking frequency.")
                        }

                        infoCard(title: "Budget Tip: Repeating Meals Saves Money") {
                            bullet("A plan with multiples of the same meal is usually cheaper.")
                            bullet("Buying ingredients in larger amounts reduces waste and lowers cost per meal.")
                            bullet("Repeating meals also makes cooking faster because you reuse the same ingredients and steps.")
                        }

                        infoCard(title: "Prep Strategy: What to Pre-Cut") {
                            bullet("Wash and chop vegetables that show up repeatedly (onions, peppers, carrots, broccoli, etc.).")
                            bullet("Pre-cook slow-digesting carbs (rice, quinoa, sweet potatoes) so meals assemble faster.")
                            bullet("If a protein is used multiple times, consider cooking it once and using it in 2–3 meals.")
                            bullet("Store prepped items clearly so you can “build meals” quickly instead of starting from scratch.")
                        }

                        infoCard(title: "Cooking the Recipes: A Simple System") {
                            bullet("Step 1: Pull out and organize all ingredients needed for the recipe (set them on the counter).")
                            bullet("Step 2: Prep whatever isn’t prepped yet (wash, chop, portion).")
                            bullet("Step 3: Start cooking in the right order (longest steps first).")
                            bullet("Step 4: While it cooks, clean as you go and prep tomorrow’s lunch container.")
                            bullet("Step 5: Save one extra portion if you want effortless lunch tomorrow.")
                        }

                        infoCard(title: "What Success Looks Like") {
                            bullet("You stop asking “What am I going to eat?” because you already know.")
                            bullet("You spend less money because you buy ingredients with intention.")
                            bullet("Your mood and energy become steadier because your meals become consistent.")
                            smallNote("Meal prep is a lifestyle skill. Once you have it, everything gets easier.")
                        }

                        Spacer(minLength: 10)
                    }
                    .padding(16)
                }
                .background(Color.white.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
                .padding(.horizontal, 14)

                // Bottom buttons
                HStack(spacing: 40) {
                    Button {
                        withAnimation(.easeInOut(duration: 0.4)) {
                            navModel.pop()
                        }
                    } label: {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 60, height: 60)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                            .shadow(radius: 4)
                    }

                    Button {
                        withAnimation(.easeInOut(duration: 0.4)) {
                            navModel.selectedScreen = "HomeView"
                        }
                    } label: {
                        Image(systemName: "house.fill")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 60, height: 60)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                            .shadow(radius: 4)
                    }
                }
                .padding(.bottom, 22)
            }
        }
        .onAppear { appeared = true }
        .transition(.opacity)
    }

    // MARK: - Components

    private func infoCard(title: String, @ViewBuilder content: () -> some View) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)

            content()
        }
        .padding(16)
        .background(Color.white.opacity(0.14))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(radius: 4)
    }

    private func bullet(_ text: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Text("•")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white.opacity(0.95))
                .padding(.top, 1)

            Text(text)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white.opacity(0.92))
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private func smallNote(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 14, weight: .semibold))
            .foregroundColor(.white.opacity(0.78))
            .padding(.top, 2)
    }
}
