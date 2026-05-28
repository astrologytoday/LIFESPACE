//
//  CookingCreativeView.swift
//  LIFESPACE
//
//  Created by Mario Sbardella on 2025-12-23.
//

import SwiftUI
import UIKit

struct CookingCreativeView: View {
    @EnvironmentObject var navModel: NavigationModel

    @State private var isVisible = false

    // Camera + naming flow
    @State private var showFoodCamera = false
    @State private var capturedFoodImage: UIImage? = nil
    @State private var dishName: String = ""
    @State private var showDishNamePrompt = false

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

    private func topIconButton(systemName: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Circle()
                .fill(lifescapeButtonGradient)
                .frame(width: 40, height: 40)
                .overlay(
                    Image(systemName: systemName)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black)
                )
        }
        .buttonStyle(.plain)
    }

    private func bigActionButton(systemName: String, title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Image(systemName: systemName)
                    .font(.system(size: 24, weight: .heavy))
                    .foregroundColor(.black)
                    .frame(width: 34)

                Text(title)
                    .font(Font.custom("Avenir-Heavy", size: 18))
                    .foregroundColor(.black)

                Spacer()
            }
            .padding(.vertical, 18)
            .padding(.horizontal, 18)
            .frame(maxWidth: .infinity)
            .background(lifescapeButtonGradient)
            .cornerRadius(24)
            .shadow(color: .black.opacity(0.18), radius: 10, x: 0, y: 6)
        }
        .buttonStyle(.plain)
    }

    var body: some View {
        ZStack {
            // 🌊 Teal Gradient Background
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

            VStack(spacing: 16) {

                // ✅ Only back button (no title, no home)
                HStack {
                    topIconButton(systemName: "chevron.left") {
                        fadeOutThen { navModel.pop() }
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 10)

                // ✅ Tips card (lowered + larger text)
                VStack(alignment: .leading, spacing: 14) {
                    Text("Creative Kitchen Prompts")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.bottom, 2)

                    VStack(alignment: .leading, spacing: 14) {
                        tipRow("Treat ingredients like colors in a palette.")
                        tipRow("Try one new ingredient each week.")
                        tipRow("Cook without measuring to spark intuition.")
                        tipRow("Use music to create a creative kitchen mood.")
                        tipRow("Plate food creatively and photograph it.")
                    }
                }
                .padding(18)
                .background(
                    RoundedRectangle(cornerRadius: 26)
                        .fill(Color.white.opacity(0.12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 26)
                                .stroke(Color.white.opacity(0.20), lineWidth: 1.2)
                        )
                        .shadow(color: .black.opacity(0.18), radius: 12, x: 0, y: 8)
                )
                .padding(.horizontal)
                .padding(.top, 28) // ✅ pushes the bubble lower

                // ✅ Two big buttons UNDER the bubble
                VStack(spacing: 14) {
                    bigActionButton(systemName: "camera.fill", title: "Take a Food Pic") {
                        showFoodCamera = true
                    }

                    bigActionButton(systemName: "photo.on.rectangle.angled", title: "View Food Gallery") {
                        navModel.push("FoodPicsView")
                    }
                }
                .padding(.horizontal, 26)
                .padding(.top, 6)

                Spacer()
            }
            .opacity(isVisible ? 1 : 0)
            .animation(.easeInOut(duration: 0.6), value: isVisible)
            .onAppear {
                withAnimation { isVisible = true }
            }
        }
        // Camera sheet
        .sheet(isPresented: $showFoodCamera) {
            ImagePickerView { image in
                guard let image = image else { return }
                capturedFoodImage = image
                dishName = ""

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                    showDishNamePrompt = true
                }
            }
        }
        // Name prompt
        .alert("Name your dish", isPresented: $showDishNamePrompt) {
            TextField("Dish name", text: $dishName)

            Button("Save") {
                guard let img = capturedFoodImage else { return }

                let finalName =
                dishName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                ? "Untitled"
                : dishName.trimmingCharacters(in: .whitespacesAndNewlines)

                let stamped = img.lifespaceWatermark(text: finalName)
                saveFoodImageToDocuments(img, dishName: finalName)

                capturedFoodImage = nil
                dishName = ""
                navModel.push("FoodPicsView")
            }

            Button("Cancel", role: .cancel) {
                capturedFoodImage = nil
                dishName = ""
            }
        } message: {
            Text("This name will appear on the saved photo.")
        }
    }

    private func tipRow(_ text: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Circle()
                .fill(Color.white.opacity(0.95))
                .frame(width: 9, height: 9)
                .padding(.top, 7)

            Text(text)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private func fadeOutThen(_ action: @escaping () -> Void) {
        withAnimation(.easeInOut(duration: 0.5)) {
            isVisible = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            action()
        }
    }

    // MARK: - Save Food Pic to Documents/FoodPics (+ metadata)
    private func saveFoodImageToDocuments(_ image: UIImage, dishName: String) {
        guard let data = image.jpegData(compressionQuality: 0.92) else { return }

        let fm = FileManager.default
        let documentsURL = fm.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let folderURL = documentsURL.appendingPathComponent("FoodPics")

        if !fm.fileExists(atPath: folderURL.path) {
            do {
                try fm.createDirectory(at: folderURL, withIntermediateDirectories: true)
            } catch {
                print("❌ Could not create FoodPics folder: \(error)")
                return
            }
        }

        let ts = FoodPicsView.filenameTimestampFormatter.string(from: Date())
        let filename = "food_\(ts)_\(UUID().uuidString).jpg"
        let url = folderURL.appendingPathComponent(filename)

        do {
            try data.write(to: url)
            FoodPicsMetadataStore.upsert(filename: filename, dishName: dishName)
            print("✅ Saved food pic at: \(url)")
        } catch {
            print("❌ Error saving food pic: \(error)")
        }
    }
}

// MARK: - Watermark helper (writes the dish name onto the photo)
extension UIImage {
    func lifespaceWatermark(text: String) -> UIImage {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return self }

        let scale = self.scale
        let size = CGSize(width: self.size.width, height: self.size.height)

        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer { UIGraphicsEndImageContext() }

        self.draw(in: CGRect(origin: .zero, size: size))

        let padding: CGFloat = max(18, size.width * 0.03)
        let fontSize: CGFloat = max(28, size.width * 0.055)

        let font = UIFont.systemFont(ofSize: fontSize, weight: .heavy)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.white
        ]

        let textSize = (trimmed as NSString).size(withAttributes: attributes)

        let bgPaddingX: CGFloat = 18
        let bgPaddingY: CGFloat = 12

        let bgRect = CGRect(
            x: padding,
            y: size.height - padding - (textSize.height + bgPaddingY * 2),
            width: textSize.width + bgPaddingX * 2,
            height: textSize.height + bgPaddingY * 2
        )

        let bgPath = UIBezierPath(roundedRect: bgRect, cornerRadius: 18)
        UIColor.black.withAlphaComponent(0.55).setFill()
        bgPath.fill()

        let textPoint = CGPoint(
            x: bgRect.minX + bgPaddingX,
            y: bgRect.minY + bgPaddingY
        )
        (trimmed as NSString).draw(at: textPoint, withAttributes: attributes)

        return UIGraphicsGetImageFromCurrentImageContext() ?? self
    }
}
