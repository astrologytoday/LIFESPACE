//
//  FashionCreativeView.swift
//  LIFESPACE
//
//  Created by Mario Sbardella on 2025-12-23.
//


//
//  FashionCreativeView.swift
//  LIFESPACE
//
//  Created by Mario Sbardella on 2025-12-23.
//

import SwiftUI
import UIKit

struct FashionCreativeView: View {
    @EnvironmentObject var navModel: NavigationModel

    @State private var isVisible = false

    // Camera + naming flow
    @State private var showFashionCamera = false
    @State private var capturedFashionImage: UIImage? = nil
    @State private var outfitName: String = ""
    @State private var showOutfitNamePrompt = false

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
                    Text("Creative Fashion Prompts")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.bottom, 2)

                    VStack(alignment: .leading, spacing: 14) {
                        tipRow("Build outfits that make you feel good about yourself.")
                        tipRow("Use accessories as creative accents or focal points.")
                        tipRow("Study the styles of people that inspire you.")
                        tipRow("Thrift to discover unique, story-filled pieces.")
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
                .padding(.top, 28)

                // ✅ Two big buttons UNDER the bubble
                VStack(spacing: 14) {
                    bigActionButton(systemName: "camera.fill", title: "Take an Outfit Pic") {
                        showFashionCamera = true
                    }

                    bigActionButton(systemName: "photo.on.rectangle.angled", title: "View Outfit Gallery") {
                        navModel.push("FashionPicsView")
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
        .sheet(isPresented: $showFashionCamera) {
            ImagePickerView { image in
                guard let image = image else { return }
                capturedFashionImage = image
                outfitName = ""

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                    showOutfitNamePrompt = true
                }
            }
        }
        // Name prompt
        .alert("Name your outfit", isPresented: $showOutfitNamePrompt) {
            TextField("Outfit name", text: $outfitName)

            Button("Save") {
                guard let img = capturedFashionImage else { return }

                let finalName =
                outfitName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                ? "Untitled"
                : outfitName.trimmingCharacters(in: .whitespacesAndNewlines)

                // Uses your existing UIImage.lifespaceWatermark extension
                let stamped = img.lifespaceWatermark(text: finalName)
                saveFashionImageToDocuments(img, outfitName: finalName)

                capturedFashionImage = nil
                outfitName = ""
                navModel.push("FashionPicsView")
            }

            Button("Cancel", role: .cancel) {
                capturedFashionImage = nil
                outfitName = ""
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

    // MARK: - Save Outfit Pic to Documents/FashionPics (+ metadata)
    private func saveFashionImageToDocuments(_ image: UIImage, outfitName: String) {
        guard let data = image.jpegData(compressionQuality: 0.92) else { return }

        let fm = FileManager.default
        let documentsURL = fm.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let folderURL = documentsURL.appendingPathComponent("FashionPics")

        if !fm.fileExists(atPath: folderURL.path) {
            do {
                try fm.createDirectory(at: folderURL, withIntermediateDirectories: true)
            } catch {
                print("❌ Could not create FashionPics folder: \(error)")
                return
            }
        }

        let ts = FashionPicsView.filenameTimestampFormatter.string(from: Date())
        let filename = "fashion_\(ts)_\(UUID().uuidString).jpg"
        let url = folderURL.appendingPathComponent(filename)

        do {
            try data.write(to: url)
            FashionPicsMetadataStore.upsert(filename: filename, outfitName: outfitName)
            print("✅ Saved outfit pic at: \(url)")
        } catch {
            print("❌ Error saving outfit pic: \(error)")
        }
    }
}
