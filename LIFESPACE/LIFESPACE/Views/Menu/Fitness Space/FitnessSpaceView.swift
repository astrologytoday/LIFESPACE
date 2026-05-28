import SwiftUI
import UIKit

struct FitnessSpaceView: View {
    @EnvironmentObject var navModel: NavigationModel
    @EnvironmentObject var userProfile: UserProfileModel

    @State private var isVisible = false
    @State private var showProgressCamera = false
    @State private var showProgressPopup = false

    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }

    private var lifescapeButtonGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(red: 0.85, green: 1.0, blue: 0.9),
                Color(red: 0.4, green: 0.9, blue: 0.8)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    var body: some View {
        GeometryReader { geo in
            let h = geo.size.height
            let w = geo.size.width
            let safeTop = geo.safeAreaInsets.top
            let safeBottom = geo.safeAreaInsets.bottom

            let isShortPhone = h < 880 && !isIPad

            let bodyHeight: CGFloat = isShortPhone ? h * 0.68 : 620
            let headerTop: CGFloat = isShortPhone ? safeTop + 0 : safeTop + 8
            let headerBottomSpace: CGFloat = isShortPhone ? -12 : 6
            let footerTopSpace: CGFloat = isShortPhone ? -16 : 8

            let footerSpacing: CGFloat = isShortPhone ? 58 : 80
            let homeSize: CGFloat = isShortPhone ? 92 : 100
            let cameraSize: CGFloat = isShortPhone ? 43 : 46

            let bodyGroupXOffset: CGFloat = -8

            ZStack {
                background

                VStack(spacing: 0) {

                    header(isShortPhone: isShortPhone, headerTop: headerTop)

                    Spacer().frame(height: headerBottomSpace)

                    if isIPad {
                        iPadBodyView(width: w, offset: bodyGroupXOffset)
                    } else {
                        iPhoneBodyView(height: bodyHeight, width: w, offset: bodyGroupXOffset)
                    }

                    Spacer().frame(height: footerTopSpace)

                    footer(homeSize: homeSize,
                           cameraSize: cameraSize,
                           footerSpacing: footerSpacing,
                           safeBottom: safeBottom)
                }
                .opacity(isVisible ? 1 : 0)
                .animation(.easeInOut(duration: 0.6), value: isVisible)

                if showProgressPopup {
                    progressPopup
                        .zIndex(10)
                }
            }
            .onAppear {
                withAnimation { isVisible = true }

                // 🔥 ADD THIS BLOCK
                if navModel.openProgressCameraOnAppear {
                    navModel.openProgressCameraOnAppear = false

                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                        showProgressCamera = true
                    }
                }
            }
        }
        .ignoresSafeArea()
        .sheet(isPresented: $showProgressCamera) {
            ImagePickerView { image in
                if let image = image {
                    saveProgressImageToDocuments(image)
                    navModel.push("ProgressPicsView")
                }
            }
        }
    }

    // MARK: - Background

    private var background: some View {
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
    }

    // MARK: - HEADER

    private func header(isShortPhone: Bool, headerTop: CGFloat) -> some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 2) {
                Text("GOAL:")
                    .font(.system(size: isShortPhone ? 31 : 32))
                    .foregroundColor(.white)

                Text(userProfile.fitnessOptions.first ?? "No goal set")
                    .font(.system(size: 35, weight: .heavy))
                    .foregroundColor(.white)
                    .lineLimit(2)
                    .minimumScaleFactor(0.75)
            }

            Spacer(minLength: 8)

            HStack(spacing: 12) {
                topIconButton(systemName: "chevron.left") {
                    fadeOutThen { navModel.pop() }
                }

                topIconButton(systemName: "timer") {
                    fadeOutThen { navModel.push("TimerView") }
                }

                topIconButton(systemName: "calendar") {
                    fadeOutThen { navModel.push("WeightTrackerView") }
                }
            }
            .padding(.top, isShortPhone ? 18 : 20)
        }
        .padding(.horizontal, 16)
        .padding(.top, headerTop)
    }

    // MARK: - IPHONE BODY (UNCHANGED)

    private func iPhoneBodyView(height: CGFloat, width: CGFloat, offset: CGFloat) -> some View {
        ZStack {
            Image("body_image")
                .resizable()
                .scaledToFit()
                .frame(height: height)

            GeometryReader { geo in
                let bw = geo.size.width
                let bh = geo.size.height

                bubbles(bw: bw, bh: bh)
            }
            .frame(height: height)
        }
        .frame(width: width * 0.98, height: height)
        .offset(x: offset)
    }

    // MARK: - IPAD BODY (FIXED)

    private func iPadBodyView(width: CGFloat, offset: CGFloat) -> some View {
        let bodyWidth = min(width * 0.5, 420)
        let bodyHeight = bodyWidth * 1.9

        return ZStack {
            Image("body_image")
                .resizable()
                .scaledToFit()
                .frame(width: bodyWidth)

            GeometryReader { _ in
                bubbles(bw: bodyWidth, bh: bodyHeight)
                    .frame(width: bodyWidth, height: bodyHeight)
            }
            .frame(width: bodyWidth, height: bodyHeight)
        }
        .frame(width: bodyWidth, height: bodyHeight)
        .offset(x: offset)
    }

    // MARK: - BUBBLES (SHARED)

    private func bubbles(bw: CGFloat, bh: CGFloat) -> some View {
        Group {
            bubbleLink("Chest", target: "ChestView", x: bw * 0.86, y: bh * 0.14)
            bubbleLink("Triceps", target: "TricepsView", x: bw * 0.87, y: bh * 0.25)
            bubbleLink("Forearms", target: "ForearmsView", x: bw * 0.89, y: bh * 0.37)
            bubbleLink("Abs", target: "AbsView", x: bw * 0.86, y: bh * 0.50)
            bubbleLink("Hamstrings", target: "HamstringsView", x: bw * 0.87, y: bh * 0.62)

            bubbleLink("Shoulders", target: "ShouldersView", x: bw * 0.17, y: bh * 0.17)
            bubbleLink("Biceps", target: "BicepsView", x: bw * 0.14, y: bh * 0.25)
            bubbleLink("Glutes", target: "GlutesView", x: bw * 0.14, y: bh * 0.60)
            bubbleLink("Calves", target: "CalvesView", x: bw * 0.18, y: bh * 0.79)
        }
    }

    // MARK: - FOOTER

    private func footer(homeSize: CGFloat, cameraSize: CGFloat, footerSpacing: CGFloat, safeBottom: CGFloat) -> some View {
        HStack(alignment: .bottom, spacing: footerSpacing) {
            VStack(spacing: 12) {
                plannerButton("Workout Planner") {
                    navModel.push("WorkoutPlannerView")
                }

                plannerButton("Meal Planner") {
                    navModel.push("MealPlannerView")
                }
            }

            ZStack(alignment: .topTrailing) {
                Button {
                    fadeOutThen { navModel.push("HomeView") }
                } label: {
                    Circle()
                        .fill(lifescapeButtonGradient)
                        .frame(width: homeSize, height: homeSize)
                        .overlay(
                            Image(systemName: "house.fill")
                                .font(.system(size: 40, weight: .bold))
                                .foregroundColor(.black)
                        )
                }

                Button {
                    withAnimation { showProgressPopup = true }
                } label: {
                    Circle()
                        .fill(lifescapeButtonGradient)
                        .frame(width: cameraSize, height: cameraSize)
                        .overlay(
                            Image(systemName: "camera.fill")
                                .font(.system(size: 17, weight: .bold))
                                .foregroundColor(.black)
                        )
                }
                .offset(x: 26, y: -34)
            }
        }
        .padding(.bottom, safeBottom + 6)
    }

    // MARK: - REUSABLES

    private func plannerButton(_ title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(Font.custom("Avenir-Heavy", size: 16))
                .foregroundColor(.black)
                .padding(.vertical, 12)
                .frame(width: 190)
                .background(lifescapeButtonGradient)
                .cornerRadius(22)
        }
    }

    private func topIconButton(systemName: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Circle()
                .fill(lifescapeButtonGradient)
                .frame(width: 38, height: 38)
                .overlay(
                    Image(systemName: systemName)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black)
                )
        }
    }

    private func bubbleLink(_ title: String, target: String, x: CGFloat, y: CGFloat) -> some View {
        PulsatingBubble(title: title) {
            navModel.push(target)
        }
        .position(x: x, y: y)
    }

    private func fadeOutThen(_ action: @escaping () -> Void) {
        withAnimation(.easeInOut(duration: 0.5)) {
            isVisible = false
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            action()
        }
    }

    private func saveProgressImageToDocuments(_ image: UIImage) {
        guard let data = image.jpegData(compressionQuality: 0.9) else { return }

        let fm = FileManager.default
        let documentsURL = fm.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let folderURL = documentsURL.appendingPathComponent("ProgressPics")

        if !fm.fileExists(atPath: folderURL.path) {
            try? fm.createDirectory(at: folderURL, withIntermediateDirectories: true)
        }

        let ts = ProgressPicsView.filenameTimestampFormatter.string(from: Date())
        let filename = "progress_\(ts)_\(UUID().uuidString).jpg"
        let url = folderURL.appendingPathComponent(filename)

        try? data.write(to: url)
    }

    // MARK: - POPUP

    private var progressPopup: some View {
        ZStack {
            Color.black.opacity(0.45)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation { showProgressPopup = false }
                }

            VStack(spacing: 14) {
                popupActionButton("TAKE PROGRESS PIC") {
                    showProgressPopup = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        showProgressCamera = true
                    }
                }

                popupActionButton("VIEW PROGRESS PICS") {
                    showProgressPopup = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        navModel.push("ProgressPicsView")
                    }
                }
            }
            .padding(18)
            .frame(width: 280)
            .background(.ultraThinMaterial)
            .cornerRadius(26)
        }
    }

    private func popupActionButton(_ title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(Font.custom("Avenir-Heavy", size: 15))
                .foregroundColor(.black)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
                .background(lifescapeButtonGradient)
                .cornerRadius(18)
        }
    }
}

// MARK: - BUBBLE

struct PulsatingBubble: View {
    let title: String
    let action: () -> Void

    @State private var pulse = false

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 13, weight: .bold))
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color(red: 0.10, green: 0.45, blue: 0.45))
                .foregroundColor(.white)
                .clipShape(Capsule())
                .scaleEffect(pulse ? 1.03 : 1.0)
                .animation(.easeInOut(duration: 0.7).repeatForever(autoreverses: true), value: pulse)
        }
        .onAppear { pulse = true }
    }
}
