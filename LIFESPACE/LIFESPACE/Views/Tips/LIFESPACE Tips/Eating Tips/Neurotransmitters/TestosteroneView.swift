import SwiftUI

struct TestosteroneView: View {
    @EnvironmentObject var navModel: NavigationModel
    @State private var appeared = false

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
                VStack(alignment: .leading, spacing: 24) {
                    Text("Serotonin")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(radius: 4)

                    Group {
                        headline("What It Is & What It Does")

                        paragraph(Text("Serotonin is the brain’s neurotransmitter responsible for our ") + Text("mood, sleep and appetite.").bold())

                        paragraph(Text("The foundational ingredient for serotonin production is called ") + Text("tryptophan.").bold())

                        paragraph("Tryptophan-rich meals that also include slow-digesting carbohydrates are particularly effective at enhancing serotonin synthesis.")

                        paragraph(Text("What are slow-digesting carbohydrates?").bold().underline() + Text("\nSome examples include: Whole grains, root vegetables, legumes, fruits, and seeds."))

                        paragraph(Text("Magnesium and zinc are also essential players in serotonin signaling. ") + Text("Magnesium helps regulate serotonin receptor function and also plays a ").bold() + Text("calming role").underline() + Text(" by modulating the activity of the HPA (hypothalamic-pituitary-adrenal) axis, the body’s central stress response system. ") + Text("In low-magnesium states, the brain becomes more excitable and vulnerable to stress,").bold() + Text(" which helps explain why magnesium deficiency is associated with increased risk of anxiety and depressive symptoms."))

                        paragraph(Text("Zinc, meanwhile, is involved in serotonin receptor sensitivity and neuronal plasticity, i.e., how your brain adapts and responds to new stimuli. It also helps maintain the structure of serotonin receptors and acts as a cofactor in enzymes involved in neurotransmitter metabolism. Several studies have found that ") + Text("individuals with major depressive disorder have significantly lower serum zinc levels").bold() + Text(" compared to healthy controls."))

                        paragraph(Text("Low serotonin is linked to ") + Text("depression, anxiety, irritability, low self-esteem, obsessive thoughts, and increased sensitivity to pain.").bold())

                        paragraph("Too much serotonin may lead to agitation, restlessness, or confusion.")
                    }

                    Group {
                        headline("Food That Support Serotonin Production")

                        paragraph(Text("Fruits: ").bold() + Text("Banana, dark berries, tart cherries, pineapple, kiwi, durian, ackee"))
                        paragraph(Text("Vegetables: ").bold() + Text("Mustard greens, Malabar spinach, red cabbage, mushrooms, sunchokes, Collard greens"))
                        paragraph(Text("Dairy: ").bold() + Text("Kefir, eggs"))
                        paragraph(Text("Grains: ").bold() + Text("Oats, flax, teff, finer millet (Ragi), raw wild rice, purple corn"))
                        paragraph(Text("Oils & Butters: ").bold() + Text("Pumpkin-seed butter, hemp seed oil"))
                        paragraph(Text("Meat: ").bold() + Text("Turkey, chicken, liver"))
                        paragraph(Text("Fish: ").bold() + Text("All fish!"))
                        paragraph(Text("Sauces & Broth: ").bold() + Text("miso, bone broth"))
                        paragraph(Text("Nuts, Seeds & Beans: ").bold() + Text("Pumpkin seeds, sesame seeds, sunflower seeds, tofu, soybeans, edamame, dark chocolate, Amaranth, Millet, Tahini, watermelon seeds, sacha inchi seeds, pili nuts, hemp hearts, hazelnuts, perilla seeds, sweet basil seeds, tigernuts, pine nuts"))
                    }

                    Group {
                        headline("LIFESPACE Serotonin Meals & Snack Ideas!")

                        bullet("Greek yogurt (plain, full-fat) with banana slices, pumpkin seeds, and a drizzle of raw honey")
                        bullet("Herbal tea with chamomile + lemon balm")
                        bullet("Wild salmon salad with leafy greens, roasted beets, avocado, and tahini-lemon dressing")
                        bullet("Roasted sweet potato with a pinch of sea salt")
                        bullet("Pineapple + a square of 85% dark chocolate")
                        bullet("Handful of Brazilian nuts")
                        bullet("Lentil + turmeric stew with spinach, carrots, and miso paste")
                        bullet("Quinoa cooked in bone broth")
                        bullet("Glass of tart cherry juice before bed (melatonin support)")
                    }

                    Group {
                        headline("Serotonin Smoothie Recipes")

                        paragraph(Text("Sweet Potato Pie Smoothie").bold().underline() + Text("\nBoosts: Serotonin + dopamine\nIngredients:\n1/2 cup cooked sweet potato\n1/2 banana\n1/2 tsp cinnamon\n1 tbsp tahini\n1/2 cup oat or almond milk\n🧠 Complex carbs + B vitamins + tyrosine-rich tahini = balanced bliss"))

                        paragraph(Text("Gut-Brain Glow").bold().underline() + Text("\nBoosts: Serotonin via gut support\nIngredients:\n1/2 cup pineapple\n1 tbsp Greek yogurt or kefir\n1 tsp flaxseed\n1/2 cup frozen fruit mix\nWater or kombucha to blend\n🧠 Fiber + probiotics + enzymes = microbiome + mood magic"))

                        paragraph(Text("Citrus Calm Smoothie").bold().underline() + Text("\nBoosts: Serotonin (mood + sleep)\nIngredients:\n1 banana\n1/2 cup Greek yogurt (plain, full-fat)\n1 orange, peeled\n1 tsp tahini or pumpkin seed butter\nDash of cinnamon\nWater or almond milk to blend\nOptional: 1 tsp flax or chia seeds\n🧠 Tryptophan + B6 + healthy fats = mood fuel"))

                        paragraph(Text("Cherry Sleep Elixir").bold().underline() + Text("\nBoosts: Melatonin + serotonin\nIngredients:\n1/2 cup tart cherry (frozen or fresh)\n1 banana\n1/2 cup full-fat milk or coconut milk\n1 tsp flaxseed\n1/2 tsp vanilla extract\n🧠 Natural sleep smoothie—best 60–90 mins before bed"))
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 64)
                .padding(.bottom, 160)
                .opacity(appeared ? 1 : 0)
                .animation(.easeInOut(duration: 0.6), value: appeared)
            }

            BackButtonView(customTarget: "EatingTipsView")
                .padding(.top, 12)
                .padding(.leading, 56)

            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        navModel.push("HomeView")
                    }) {
                        ZStack {
                            Circle()
                                .fill(LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.white.opacity(0.9),
                                        Color.white.opacity(0.6)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ))
                                .frame(width: 60, height: 60)
                                .shadow(color: .black.opacity(0.25), radius: 8, x: 0, y: 6)

                            Image(systemName: "house.fill")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(Color(red: 0.10, green: 0.45, blue: 0.45))
                        }
                    }
                    .padding(.trailing, 22)
                    .padding(.bottom, 22)
                }
            }
        }
        .onAppear { appeared = true }
        .transition(.opacity)
    }

    private func paragraph(_ text: Text) -> some View {
        text
            .foregroundColor(.white.opacity(0.95))
            .font(.body)
            .fixedSize(horizontal: false, vertical: true)
    }

    private func paragraph(_ string: String) -> some View {
        Text(string)
            .foregroundColor(.white.opacity(0.95))
            .font(.body)
            .fixedSize(horizontal: false, vertical: true)
    }

    private func headline(_ text: String) -> some View {
        Text(text)
            .font(.title)
            .bold()
            .foregroundColor(.white)
    }

    private func bullet(_ text: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Text("•")
                .foregroundColor(.white)
                .font(.title3)

            Text(text)
                .foregroundColor(.white.opacity(0.95))
                .font(.body)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

