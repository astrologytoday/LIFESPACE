import SwiftUI

struct HierarchyInfoView: View {
    @EnvironmentObject var navModel: NavigationModel
    @State private var showingLifespace = false
    @State private var returnToLifespace = false
    
    var body: some View {
        ZStack {
            // Background teal gradient (optional, for consistency)
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
            
            if !returnToLifespace {
                ZStack {
                    // Maslow Triangle
                    if !showingLifespace {
                        Image("maslow2")
                            .resizable()
                            .scaledToFit()
                            .padding()
                            .transition(.opacity)
                            .onTapGesture {
                                withAnimation(.easeInOut(duration: 0.6)) {
                                    showingLifespace = true
                                }
                            }
                    }
                    
                    // LIFESPACE Triangle
                    if showingLifespace {
                        Image("lifespace_pyramid")
                            .resizable()
                            .scaledToFit()
                            .padding()
                            .transition(.opacity)
                            .onTapGesture {
                                withAnimation(.easeInOut(duration: 0.6)) {
                                    returnToLifespace = true
                                }
                            }
                    }
                }
            } else {
                LifespaceInfoView()
                    .environmentObject(navModel) // ✅ Preserve menu + navigation
                    .transition(.opacity)
            }
        }
    }
    
}
