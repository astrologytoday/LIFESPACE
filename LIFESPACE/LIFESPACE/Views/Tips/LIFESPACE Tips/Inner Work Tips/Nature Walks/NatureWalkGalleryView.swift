import SwiftUI
import UIKit

struct NatureWalkGalleryView: View {
    @EnvironmentObject var navModel: NavigationModel

    struct NaturePhoto: Identifiable {
        let id = UUID()
        let image: UIImage
        let url: URL
        let date: Date?
    }

    @State private var photos: [NaturePhoto] = []
    @State private var selectedPhoto: NaturePhoto? = nil
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
                Text("Nature Walk Gallery")
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

    private func photoViewer(for p: NaturePhoto) -> some View {
        ZStack {
            lifespaceGradient

            VStack {
                Spacer().frame(height: 70)

                HStack {
                    if let d = p.date {
                        Text(fullDateFormatter.string(from: d))
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color.black.opacity(0.25))
                            .cornerRadius(12)
                    }

                    Spacer()

                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            selectedPhoto = nil
                            showSavedMessage = false
                        }
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 32))
                            .foregroundColor(.white)
                            .shadow(radius: 4)
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
                    .shadow(color: .black.opacity(0.35), radius: 12, x: 0, y: 8)

                Spacer()
            }

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

    private func saveImageToPhotos(_ image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)

        withAnimation(.easeInOut(duration: 0.2)) {
            showSavedMessage = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation(.easeInOut(duration: 0.2)) {
                showSavedMessage = false
            }
        }
    }

    // MARK: - Use this when saving NEW Nature Walk images into the app
    static func saveNatureWalkImage(_ image: UIImage) {
        let fm = FileManager.default
        let docs = fm.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let folder = docs.appendingPathComponent("NatureWalkPhotos", isDirectory: true)

        if !fm.fileExists(atPath: folder.path) {
            try? fm.createDirectory(at: folder, withIntermediateDirectories: true)
        }

        let timestamp = filenameTimestampFormatter.string(from: Date())
        let filename = "naturewalk_\(timestamp)_\(UUID().uuidString).jpg"
        let fileURL = folder.appendingPathComponent(filename)

        guard let data = image.jpegData(compressionQuality: 0.9) else {
            print("Could not convert Nature Walk image to JPEG.")
            return
        }

        do {
            try data.write(to: fileURL)
            print("Saved Nature Walk photo: \(filename)")
        } catch {
            print("Error saving Nature Walk photo: \(error)")
        }
    }

    private func natureWalkFolderURL() -> URL {
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return docs.appendingPathComponent("NatureWalkPhotos", isDirectory: true)
    }

    private func ensureNatureWalkFolderExists() {
        let folder = natureWalkFolderURL()

        if !FileManager.default.fileExists(atPath: folder.path) {
            try? FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
        }
    }

    private func loadSavedImages() {
        let fm = FileManager.default
        let docs = fm.urls(for: .documentDirectory, in: .userDomainMask).first!

        ensureNatureWalkFolderExists()
        let folder = natureWalkFolderURL()

        func isImageFile(_ url: URL) -> Bool {
            let ext = url.pathExtension.lowercased()
            return ext == "jpg" || ext == "jpeg" || ext == "png"
        }

        func isLegacyNatureWalkFilename(_ url: URL) -> Bool {
            let base = url.deletingPathExtension().lastPathComponent

            if base.hasPrefix("moodboard_element_") {
                return false
            }

            let uuidRegex = #"^[0-9A-Fa-f]{8}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{12}$"#
            return base.range(of: uuidRegex, options: .regularExpression) != nil
        }

        func fileDate(_ url: URL) -> Date {
            (try? url.resourceValues(forKeys: [.contentModificationDateKey]).contentModificationDate) ?? .distantPast
        }

        do {
            var urls: [URL] = []

            let folderContents = try fm.contentsOfDirectory(
                at: folder,
                includingPropertiesForKeys: [.contentModificationDateKey]
            )

            urls.append(contentsOf: folderContents.filter { isImageFile($0) })

            let rootContents = try fm.contentsOfDirectory(
                at: docs,
                includingPropertiesForKeys: [.contentModificationDateKey]
            )

            urls.append(contentsOf: rootContents.filter {
                isImageFile($0) && isLegacyNatureWalkFilename($0)
            })

            urls.sort {
                fileDate($0) > fileDate($1)
            }

            photos = urls.compactMap { url in
                guard let data = try? Data(contentsOf: url),
                      let img = UIImage(data: data) else { return nil }

                let dt = parseDate(from: url.lastPathComponent) ?? fileDate(url)

                return NaturePhoto(
                    image: img,
                    url: url,
                    date: dt
                )
            }

        } catch {
            print("Error loading images: \(error)")
        }
    }

    private func deleteImage(at index: Int) {
        guard photos.indices.contains(index) else { return }

        let fileURL = photos[index].url

        do {
            try FileManager.default.removeItem(at: fileURL)
            photos.remove(at: index)
        } catch {
            print("Error deleting image: \(error)")
        }
    }

    private func parseDate(from filename: String) -> Date? {
        let base = filename
            .replacingOccurrences(of: ".jpg", with: "")
            .replacingOccurrences(of: ".jpeg", with: "")
            .replacingOccurrences(of: ".png", with: "")

        let parts = base.components(separatedBy: "_")

        guard parts.count >= 4 else {
            return nil
        }

        let ts = parts[1] + "_" + parts[2]
        return Self.filenameTimestampFormatter.date(from: ts)
    }
}
