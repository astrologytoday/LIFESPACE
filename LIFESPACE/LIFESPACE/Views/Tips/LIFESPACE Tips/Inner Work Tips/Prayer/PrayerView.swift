import SwiftUI

struct PrayerView: View {
    @EnvironmentObject var navModel: NavigationModel
    @State private var contentOpacity: Double = 0.0

    var body: some View {
        ZStack {
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
                    Spacer(minLength: 20)

                    Text("PRAYER")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(color: .white.opacity(0.28), radius: 10, x: 0, y: 0) // mystical glow
                        .shadow(color: .black.opacity(0.30), radius: 3, x: 0, y: 2)  // depth
                        .shadow(color: .white.opacity(0.7), radius: 10)              // your original title glow (optional)
                        .frame(maxWidth: .infinity, alignment: .center)

                    Text("Methods of prayer have been laid down by various spiritual teachers, but generally speaking they follow a similar basic pattern:")
                        .foregroundColor(.white)
                        .font(.system(size: 17))
                        .padding(.horizontal)

                    Group {
                        prayerBubble(index: "I.", title: "Preparation", description: "Through sacred reading, contemplation, or silent reflection.")
                        prayerBubble(index: "II.", title: "Vocal Prayer", description: "Spontaneous or prescribed, spoken aloud quietly or sometimes with great vigor.")
                        prayerBubble(index: "III.", title: "Fervent Meditation", description: "The voiceless aspiration of the heart, formed silently within the mind.")
                    }
                    .padding(.horizontal)

                    Text("These are the principles of prayer to God in whatever form the Divine is conceived; the Christian God and biblical prayers are especially powerful, and are recommended for this section.")
                        .foregroundColor(.white)
                        .font(.system(size: 17))
                        .padding(.horizontal)

                    Group {
                        Text("The Lord's Prayer")
                            .font(.headline)
                            .foregroundColor(.white)

                        VStack(alignment: .leading, spacing: 10) {
                            Text("Luke 11:1–4")
                                .font(.subheadline)
                                .foregroundColor(.white)

                            Text("11 And it came to pass, that, as he was praying in a certain place, when he ceased, one of his disciples said unto him, Lord, teach us to pray, as John also taught his disciples.\n\n2 And he said unto them, When ye pray, say:")
                                .foregroundColor(.white)

                            Text("Our Father who art in heaven,\nHallowed be thy name.\nThy kingdom come.\nThy will be done, on earth as it is in heaven.\n\nGive us this day, our daily bread.\n\nAnd forgive us our trespasses; as we forgive those who trespass against us.\n\nAnd lead us not into temptation; but deliver us from evil. Amen.")
                                .foregroundColor(.white)
                                .shadow(color: .white.opacity(0.6), radius: 5)
                        }
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)

                    // ✅ Spiced-up section (no giant container around the whole thing)
                    Group {
                        Text("How to Structure a Personal Prayer")
                            .font(.system(size: 20, weight: .bold))
                            .underline()
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .center)

                        Text("You can allocate 2–3 minutes for each section while praying.")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .multilineTextAlignment(.center)
                            .padding(.top, 2)

                        VStack(spacing: 14) {
                            personalPrayerStep(
                                title: "Repentance",
                                icon: "arrow.uturn.left.circle.fill",
                                time: "2–3 min",
                                description: "Ask God for forgiveness for sins committed against others, yourself, Him, or the Earth."
                            )

                            personalPrayerStep(
                                title: "Thanksgiving",
                                icon: "hands.sparkles.fill",
                                time: "2–3 min",
                                description: "Thank God for what you are grateful for, both big and small, to open your heart in appreciation."
                            )

                            personalPrayerStep(
                                title: "Asking God for Help",
                                icon: "lifepreserver.fill",
                                time: "2–3 min",
                                description: "Ask for what you want or need, whether that is better health, financial help, emotional healing, or strength in difficulty."
                            )

                            personalPrayerStep(
                                title: "Praying for Others",
                                icon: "person.2.fill",
                                time: "2–3 min",
                                description: "Pray for friends, family, your community, those suffering around the world, and those in need."
                            )
                        }
                        .padding(.top, 6)
                    }
                    .padding(.horizontal)

                    Divider()
                        .background(Color.white.opacity(0.3))
                        .padding(.horizontal)

                    Group {
                        Text("Reading Psalms")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)

                        Text("Psalms are powerful, ancient prayers from the Bible. They give voice to joy, anguish, longing, and trust.\n\nWhen you pray the Psalms, speak in a strong voice and with conviction, and be sure that God is listening.")
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal)

                    Text("🙏 Try These Psalms")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding([.top, .horizontal])

                    VStack(spacing: 16) {
                        psalmLink(title: "Psalm for Repentance", destination: "RepentanceView")
                        psalmLink(title: "Psalm for Assistance", destination: "AssistanceView")
                        psalmLink(title: "Psalm for Deliverance", destination: "DeliveranceView")
                        psalmLink(title: "Psalm to Attack Enemies", destination: "ProtectionView")
                    }
                    .padding(.horizontal)

                    HStack {
                        Spacer()
                        Button(action: {
                            navModel.pop()
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 28, weight: .medium))
                                .foregroundColor(.white)
                                .padding(24)
                                .background(Color.white.opacity(0.2))
                                .clipShape(Circle())
                                .shadow(radius: 8)
                        }
                        Spacer()
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 30)
                }
                .opacity(contentOpacity)
                .onAppear {
                    withAnimation(.easeInOut(duration: 0.6)) {
                        contentOpacity = 1.0
                    }
                }
            }
        }
    }

    // MARK: - Links / Bubbles

    func psalmLink(title: String, destination: String) -> some View {
        Button(action: {
            navModel.push(destination)
        }) {
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.white.opacity(0.15))
                .cornerRadius(12)
        }
    }

    func prayerBubble(index: String, title: String, description: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Text(index)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
                .padding(10)
                .background(Color.white.opacity(0.2))
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                Text(description)
                    .foregroundColor(.white)
            }
        }
    }

    // MARK: - Spiced-up Prayer Steps (small cards per item, not one big container)

    func personalPrayerStep(title: String, icon: String, time: String, description: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.18))
                    .frame(width: 44, height: 44)
                    .overlay(
                        Circle().stroke(Color.white.opacity(0.22), lineWidth: 1)
                    )

                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white.opacity(0.95))
            }

            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 10) {
                    Text(title)
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.white)

                    Spacer(minLength: 10)

                    Text(time)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.white.opacity(0.92))
                        .padding(.vertical, 5)
                        .padding(.horizontal, 10)
                        .background(Color.white.opacity(0.12))
                        .overlay(
                            Capsule().stroke(Color.white.opacity(0.18), lineWidth: 1)
                        )
                        .cornerRadius(999)
                }

                Text(description)
                    .font(.system(size: 16))
                    .foregroundColor(.white.opacity(0.95))
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(14)
        .background(Color.white.opacity(0.10))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.16), lineWidth: 1)
        )
        .cornerRadius(16)
    }
}
