import SwiftUI

struct CommunityTipsView: View {
    @EnvironmentObject var navModel: NavigationModel
    @State private var appeared = false

    // Collapse states
    @State private var showBenefits = false
    @State private var showSocialSkills = false
    @State private var showIdeas = false

    var body: some View {
        ZStack(alignment: .topLeading) {

            // 🌊 Background
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
                VStack(alignment: .leading, spacing: 20) {

                    Text("Community Tips")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(radius: 5)
                        .opacity(appeared ? 1 : 0)
                        .animation(.easeInOut(duration: 1.0), value: appeared)

                    // ✅ Subtitle
                    Text("To strengthen your support system")
                        .font(.title3)
                        .italic()
                        .foregroundColor(Color.white.opacity(0.95))
                        .fixedSize(horizontal: false, vertical: true)
                        .opacity(appeared ? 1 : 0)
                        .animation(.easeInOut(duration: 1.0).delay(0.05), value: appeared)
                    
                    Spacer()

                    // 2️⃣ HOW TO MAKE FRIENDS & COMMUNICATE WELL
                    customDisclosureFriends(
                        title: "How to Make Friends & Communicate Well",
                        isExpanded: $showSocialSkills,
                        items: friendshipTips
                    )

                    // 3️⃣ WAYS TO BUILD COMMUNITY
                    customDisclosure(
                        title: "Ways to Build or Strengthen Community",
                        isExpanded: $showIdeas,
                        items: communityIdeas
                    )

                    // 🧽 LIFESPACE MEETUPS
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Community matters!")
                            .font(.custom("Avenir", size: 22))
                            .foregroundColor(.white)
                            .padding(.top, 10)
                        
                        Text("It supports nervous system regulation, lowers stress and anxiety, and reinforces a sense of identity and self-worth.")
                            .font(.custom("Avenir", size: 18))
                            .foregroundColor(.white)
                            .padding(.top, 10)
                        
                        Spacer()

                        // ✅ BIG COMMUNITY ICON (matches TipsView icon style)
                        LargeCommunityIcon()
                            .frame(maxWidth: .infinity)
                            .padding(.top, 26)
                            .padding(.bottom, 18)
                            .opacity(appeared ? 1 : 0)
                            .animation(.easeInOut(duration: 1.0).delay(0.15), value: appeared)
                    }
                    .padding(.bottom, 40)

                    Spacer(minLength: 40)
                }
                .padding(.horizontal, 24)

                // ✅ Keeps title sitting comfortably under back arrow
                .padding(.top, 56)
            }

            // 🔙 Back button
            Button(action: {
                navModel.pop()
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.white)
                    .font(.system(size: 24, weight: .bold))
                    .padding()
            }
        }
        .onAppear { appeared = true }
    }

    // MARK: - Big Icon (TipsView-style)
    private struct LargeCommunityIcon: View {
        var body: some View {
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [.white.opacity(0.30), .clear],
                            center: .center,
                            startRadius: 12,
                            endRadius: 140
                        )
                    )
                    .frame(width: 240, height: 240)

                Image(systemName: "person.3.fill")
                    .font(.system(size: 120))
                    .foregroundColor(.white.opacity(0.95))
                    .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 6)
            }
        }
    }

    // MARK: - Regular DisclosureGroup
    @ViewBuilder
    func customDisclosure(title: String, isExpanded: Binding<Bool>, items: [String]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Button(action: {
                withAnimation { isExpanded.wrappedValue.toggle() }
            }) {
                HStack(spacing: 8) {
                    Image(systemName: isExpanded.wrappedValue ? "chevron.down.circle.fill" : "chevron.right.circle.fill")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)

                    Text(title)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .buttonStyle(PlainButtonStyle())

            if isExpanded.wrappedValue {
                VStack(alignment: .leading, spacing: 6) {
                    ForEach(items, id: \.self) { item in
                        Text("• \(item)")
                            .font(.custom("Avenir", size: 18))
                            .foregroundColor(.white.opacity(0.9))
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .transition(.opacity)
            }
        }
    }

    // MARK: - Friend Tips (with bolded lead text)
    @ViewBuilder
    func customDisclosureFriends(title: String, isExpanded: Binding<Bool>, items: [(String, String)]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Button(action: {
                withAnimation { isExpanded.wrappedValue.toggle() }
            }) {
                HStack(spacing: 8) {
                    Image(systemName: isExpanded.wrappedValue ? "chevron.down.circle.fill" : "chevron.right.circle.fill")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)

                    Text(title)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .buttonStyle(PlainButtonStyle())

            if isExpanded.wrappedValue {
                VStack(alignment: .leading, spacing: 6) {
                    ForEach(items, id: \.0) { tip in
                        (
                            Text("• ").font(.custom("Avenir", size: 18)).foregroundColor(.white.opacity(0.9)) +
                            Text(tip.0).bold().font(.custom("Avenir", size: 18)).foregroundColor(.white) +
                            Text(" - \(tip.1)").font(.custom("Avenir", size: 18)).foregroundColor(.white.opacity(0.9))
                        )
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .transition(.opacity)
            }
        }
    }

    let communityIdeas = [
        "Reconnect with a friend you haven’t spoken to in a long time",
        "Learn a skill and join a group related to it (e.g., music, pottery)",
        "Join an adult sports league",
        "Join an intellectual or professional club",
        "Join a club related to your hobbies (books, chess, gardening)",
        "Make plans and invite others (bowling, escape rooms, indoor skydiving)",
        "Join a dance, improv, or theatre troupe",
        "Try making friends on dating or friend apps",
        "Make after-work plans with coworkers",
        "Go to conferences and strike up conversations",
        "Start a project and find collaborators",
        "Do group therapy or support groups (e.g. AA, NA)",
        "Join a fraternal organization or a female auxiliary",
        "Join a political or social movement",
        "Volunteer for a cause you care about",
        "Talk to your friends online or on the phone at least once a week",
        "Attend a community event or talk",
        "Meet your neighbours"
    ]

    let friendshipTips: [(String, String)] = [
        ("Dress well", "clothes that fit and express your style build silent confidence"),
        ("Be well groomed", "clean hair, nails, and skin show self-respect"),
        ("Smell good", "fresh hygiene or light scent makes you approachable"),
        ("Smile often", "warmth invites connection and lowers barriers"),
        ("Maintain eye contact", "it shows presence and confidence"),
        ("Assume people will like you", "this mindset often becomes reality"),
        ("Be curious", "ask questions and learn about others"),
        ("Compliment sincerely", "point out something specific you genuinely like"),
        ("Be a good listener", "don't give advice or opinions right away"),
        ("Use their name", "people feel seen when you do — pronunciation matters!"),
        ("Cut your losses", "if someone seems disinterested, move on to the next person")
    ]
}
