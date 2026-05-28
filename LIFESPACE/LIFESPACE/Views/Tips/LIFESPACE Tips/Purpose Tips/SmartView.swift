//
//  SmartView.swift
//  LIFESPACE
//
//  Created by Mario Sbardella on 2026-04-29.
//


import SwiftUI

struct SmartView: View {
    @EnvironmentObject var navModel: NavigationModel

    @State private var appeared = false
    @State private var pulse = false
    @State private var cardOffsets: [CGFloat] = [70, 110, 150, 190]

    var body: some View {
        ZStack(alignment: .topLeading) {

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

            ScrollView {
                VStack(alignment: .leading, spacing: 36) {

                    VStack(spacing: 12) {
                        Text("SMART Goals")
                            .font(.system(size: 42, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .shadow(color: .yellow.opacity(0.45), radius: 8, y: 3)

                        Text("Real change takes planning.")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.white.opacity(0.86))
                    }
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
                    .padding(.top, 24)

                    glassCard(offset: $cardOffsets[0]) {
                        VStack(alignment: .leading, spacing: 18) {
                            HStack(spacing: 12) {
                                Image(systemName: "target")
                                    .font(.system(size: 34))
                                    .foregroundColor(.yellow)

                                Text("What Is a SMART Goal?")
                                    .font(.title2.bold())
                                    .foregroundColor(.white)
                                    .scaleEffect(pulse ? 1.025 : 1.0)
                            }

                            Text("A SMART goal is a clear, practical goal that gives your brain a specific target instead of a vague intention.")
                                .foregroundColor(.white.opacity(0.94))
                                .lineSpacing(6)

                            Text("Instead of saying, “I want to be healthier,” a SMART goal turns that desire into something you can actually follow, measure, and complete.")
                                .foregroundColor(.white.opacity(0.9))
                                .lineSpacing(6)
                        }
                    }

                    glassCard(offset: $cardOffsets[1]) {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("SMART Means:")
                                .font(.title2.bold())
                                .foregroundColor(.white)
                                .scaleEffect(pulse ? 1.025 : 1.0)

                            smartRow(letter: "S", title: "Specific", text: "Say exactly what you want to do.")
                            smartRow(letter: "M", title: "Measurable", text: "Make sure you can track it.")
                            smartRow(letter: "A", title: "Achievable", text: "Choose something realistic for your current life.")
                            smartRow(letter: "R", title: "Relevant", text: "Make sure it actually matters to your LIFESPACE.")
                            smartRow(letter: "T", title: "Time-Bound", text: "Give it a deadline or schedule.")
                        }
                    }

                    glassCard(offset: $cardOffsets[2]) {
                        VStack(alignment: .leading, spacing: 18) {
                            HStack(spacing: 12) {
                                Image(systemName: "pencil.and.outline")
                                    .font(.system(size: 32))
                                    .foregroundColor(.orange)

                                Text("How to Set One")
                                    .font(.title2.bold())
                                    .foregroundColor(.white)
                                    .scaleEffect(pulse ? 1.025 : 1.0)
                            }

                            exampleBlock(
                                bad: "I want to exercise more.",
                                good: "I will do a 20-minute workout every Monday, Wednesday, and Friday for the next 4 weeks."
                            )

                            exampleBlock(
                                bad: "I want to eat better.",
                                good: "I will prepare a protein-rich breakfast at home 5 days per week for the next month."
                            )
                        }
                    }

                    glassCard(offset: $cardOffsets[3]) {
                        VStack(alignment: .leading, spacing: 18) {
                            HStack(spacing: 12) {
                                Image(systemName: "sparkles")
                                    .font(.system(size: 32))
                                    .foregroundColor(.white.opacity(0.9))

                                Text("The LIFESPACE Method")
                                    .font(.title2.bold())
                                    .foregroundColor(.white)
                                    .scaleEffect(pulse ? 1.025 : 1.0)
                            }

                            Text("Start with one area of your LIFESPACE that feels low: Light, Inner Work, Fitness, Eating, Sensory Health, Purpose, Activity, Community, or Expression.")
                                .foregroundColor(.white.opacity(0.94))
                                .lineSpacing(6)

                            Text("Then ask: What is one small action I can repeat this week that would make this part of my life stronger?")
                                .foregroundColor(.white.opacity(0.9))
                                .lineSpacing(6)

                            Text("A strong SMART goal should feel clear, doable, and slightly energizing. Not overwhelming.")
                                .font(.body.bold())
                                .foregroundColor(.yellow.opacity(0.95))
                                .scaleEffect(pulse ? 1.02 : 1.0)
                                .lineSpacing(6)
                        }
                    }
                    Button {
                        navModel.push("GoalsView")
                    } label: {
                        Text("Set Goals Now")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(Color(red: 0.10, green: 0.45, blue: 0.45))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.white.opacity(0.9))
                                    .shadow(color: .black.opacity(0.25), radius: 10, y: 6)
                            )
                    }
                    .scaleEffect(pulse ? 1.05 : 1.0)
                    .opacity(pulse ? 1.0 : 0.92)
                    .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: pulse)
                    .padding(.horizontal, 4)
                    .padding(.top, 10)
                    Spacer(minLength: 120)
                }
                .padding(.horizontal, 24)
                .padding(.top, 12)
                .padding(.bottom, 140)
            }

            BackButtonView(customTarget: nil)
                .padding(.top, 4)
                .padding(.leading, 16)
        }
        .onAppear {
            appeared = true

            withAnimation(.easeInOut(duration: 1.25).repeatForever(autoreverses: true)) {
                pulse.toggle()
            }

            withAnimation(.spring(response: 0.7, dampingFraction: 0.78).delay(0.1)) {
                cardOffsets = [0, 0, 0, 0]
            }
        }
    }

    private func glassCard<Content: View>(
        offset: Binding<CGFloat>,
        @ViewBuilder content: () -> Content
    ) -> some View {
        content()
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 26)
                    .fill(Color.white.opacity(0.135))
                    .overlay(
                        RoundedRectangle(cornerRadius: 26)
                            .stroke(Color.white.opacity(0.22), lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.22), radius: 16, y: 8)
            )
            .offset(y: appeared ? 0 : offset.wrappedValue)
            .opacity(appeared ? 1 : 0)
            .animation(.easeOut(duration: 0.75), value: appeared)
    }

    private func smartRow(letter: String, title: String, text: String) -> some View {
        HStack(alignment: .top, spacing: 14) {
            Text(letter)
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundColor(Color(red: 0.10, green: 0.45, blue: 0.45))
                .frame(width: 42, height: 42)
                .background(Circle().fill(Color.white.opacity(0.88)))

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)

                Text(text)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.85))
                    .lineSpacing(3)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.08))
        .cornerRadius(18)
    }

    private func exampleBlock(bad: String, good: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Vague:")
                .font(.headline)
                .foregroundColor(.white.opacity(0.75))

            Text("“\(bad)”")
                .foregroundColor(.white.opacity(0.86))

            Text("SMART:")
                .font(.headline)
                .foregroundColor(.yellow.opacity(0.95))
                .padding(.top, 4)

            Text("“\(good)”")
                .foregroundColor(.white.opacity(0.95))
                .lineSpacing(5)
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.08))
        .cornerRadius(18)
    }
}
