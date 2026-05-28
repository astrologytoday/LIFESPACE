import SwiftUI
import UIKit

struct ProgressPicsView: View {
    @EnvironmentObject var navModel: NavigationModel

    struct ProgressPhoto: Identifiable {
        let id = UUID()
        let image: UIImage
        let url: URL
        let date: Date?
    }

    @State private var photos: [ProgressPhoto] = []
    @State private var selectedPhoto: ProgressPhoto? = nil
    @State private var showingDeleteButtonForIndex: Int? = nil
    @State private var showSavedMessage = false

    static let filenameTimestampFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyyMMdd_HHmmss"
        return df
    }()

    private let thumbDateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "MMM d, yyyy"
        return df
    }()

    private let fullDateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "MMM d, yyyy • h:mm a"
        return df
    }()

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        ZStack {
            lifespaceGradient

            VStack(spacing: 16) {
                Text("Progress Pics")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.top, 20)

                ScrollView {
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(photos.indices, id: \.self) { index in
                            let p = photos[index]

                            ZStack(alignment: .topTrailing) {
                                ZStack(alignment: .bottomLeading) {
                                    Image(uiImage: p.image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 110, height: 110)
                                        .clipped()
                                        .cornerRadius(8)
                                        .onTapGesture {
                                            withAnimation(.easeInOut(duration: 0.25)) {
                                                selectedPhoto = p
                                            }
                                        }
                                        .onLongPressGesture {
                                            showingDeleteButtonForIndex = index
                                        }

                                    if let d = p.date {
                                        Text(thumbDateFormatter.string(from: d))
                                            .font(.system(size: 10, weight: .bold))
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 6)
                                            .padding(.vertical, 4)
                                            .background(Color.black.opacity(0.55))
                                            .cornerRadius(6)
                                            .padding(6)
                                    }
                                }

                                if showingDeleteButtonForIndex == index {
                                    Button(action: {
                                        deleteImage(at: index)
                                        showingDeleteButtonForIndex = nil
                                    }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.red)
                                            .background(Color.white.clipShape(Circle()))
                                            .font(.system(size: 20))
                                            .padding(6)
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                }

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
                .padding(.bottom, 30)
            }

            if let p = selectedPhoto {
                photoViewer(for: p)
                    .transition(.opacity)
                    .zIndex(10)
            }
        }
        .onAppear {
            loadSavedImages()
        }
    }

    private var lifespaceGradient: some View {
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

    // MARK: - VIEWER
    private func photoViewer(for p: ProgressPhoto) -> some View {
        ZStack {
            lifespaceGradient

            VStack {
                Spacer().frame(height: 70) // lowered header

                HStack {
                    if let d = p.date {
                        Text(fullDateFormatter.string(from: d))
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(Color.black.opacity(0.25))
                            .cornerRadius(14)
                    }

                    Spacer()

                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            selectedPhoto = nil
                        }
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 32))
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal, 20)

                Spacer()

                Image(uiImage: p.image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: UIScreen.main.bounds.width - 10)
                    .frame(maxHeight: UIScreen.main.bounds.height * 0.75)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    .shadow(radius: 12)

                Spacer()
            }

            // SAVE BUTTON (bottom right, icon only)
            VStack {
                Spacer()
                HStack {
                    Spacer()

                    Button(action: {
                        saveImageToPhotos(p.image)
                    }) {
                        Image(systemName: "square.and.arrow.down.fill")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                            .padding(18)
                            .background(Color.white.opacity(0.25))
                            .clipShape(Circle())
                            .shadow(radius: 8)
                    }
                    .padding(.trailing, 24)
                    .padding(.bottom, 40)
                }
            }

            // SAVED TO PHOTOS POPUP
            if showSavedMessage {
                VStack {
                    Spacer()

                    Text("Saved")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(Color.black.opacity(0.6))
                        .cornerRadius(12)
                        .padding(.bottom, 120)
                }
                .transition(.opacity)
            }
        }
        .ignoresSafeArea()
    }

    // MARK: - SAVE
    private func saveImageToPhotos(_ image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)

        withAnimation {
            showSavedMessage = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation {
                showSavedMessage = false
            }
        }
    }

    // MARK: - LOAD
    private func loadSavedImages() {
        let fm = FileManager.default
        let documentsURL = fm.urls(for: .documentDirectory, in: .userDomainMask).first!
        let folderURL = documentsURL.appendingPathComponent("ProgressPics")

        guard fm.fileExists(atPath: folderURL.path) else {
            photos = []
            return
        }

        do {
            let urls = try fm.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil)
                .filter {
                    $0.pathExtension.lowercased() == "jpg" ||
                    $0.pathExtension.lowercased() == "png"
                }
                .sorted(by: { $0.lastPathComponent > $1.lastPathComponent })

            photos = urls.compactMap { url in
                guard let data = try? Data(contentsOf: url),
                      let img = UIImage(data: data) else { return nil }

                let dt = parseDate(from: url.lastPathComponent)
                return ProgressPhoto(image: img, url: url, date: dt)
            }
        } catch {
            print("Error loading progress pics: \(error)")
        }
    }

    private func deleteImage(at index: Int) {
        guard photos.indices.contains(index) else { return }

        let fileURL = photos[index].url

        do {
            try FileManager.default.removeItem(at: fileURL)
            photos.remove(at: index)
        } catch {
            print("Error deleting progress pic: \(error)")
        }
    }

    private func parseDate(from filename: String) -> Date? {
        let base = filename
            .replacingOccurrences(of: ".jpg", with: "")
            .replacingOccurrences(of: ".png", with: "")

        let parts = base.components(separatedBy: "_")

        guard parts.count >= 4, parts[0] == "progress" else { return nil }

        let ts = parts[1] + "_" + parts[2]
        return ProgressPicsView.filenameTimestampFormatter.date(from: ts)
    }
}
