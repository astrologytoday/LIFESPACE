import SwiftUI
import UIKit

struct FoodPicsView: View {
    @EnvironmentObject var navModel: NavigationModel

    struct FoodPhoto: Identifiable {
        let id = UUID()
        let image: UIImage
        let url: URL
        let date: Date?
        let dishName: String
    }

    @State private var photos: [FoodPhoto] = []
    @State private var selectedPhoto: FoodPhoto? = nil
    @State private var showingDeleteButtonForIndex: Int? = nil
    @State private var showSavedMessage = false

    @State private var showEditTitlePopup = false
    @State private var editedDishName = ""

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
                Text("Food Gallery")
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

                                    VStack(alignment: .leading, spacing: 4) {
                                        if !p.dishName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                            Text(p.dishName)
                                                .font(.system(size: 10, weight: .heavy))
                                                .foregroundColor(.white)
                                                .lineLimit(1)
                                                .padding(.horizontal, 6)
                                                .padding(.vertical, 4)
                                                .background(Color.black.opacity(0.55))
                                                .cornerRadius(6)
                                        }

                                        if let d = p.date {
                                            Text(thumbDateFormatter.string(from: d))
                                                .font(.system(size: 10, weight: .bold))
                                                .foregroundColor(.white)
                                                .padding(.horizontal, 6)
                                                .padding(.vertical, 4)
                                                .background(Color.black.opacity(0.55))
                                                .cornerRadius(6)
                                        }
                                    }
                                    .padding(6)
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

            if showEditTitlePopup {
                editTitlePopup()
                    .zIndex(20)
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

    private func photoViewer(for p: FoodPhoto) -> some View {
        ZStack {
            lifespaceGradient

            VStack {
                Spacer().frame(height: 70)

                HStack(spacing: 10) {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack(spacing: 8) {
                            Text(p.dishName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "Untitled" : p.dishName)
                                .font(.system(size: 14, weight: .heavy))
                                .foregroundColor(.white)
                                .lineLimit(1)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(Color.black.opacity(0.25))
                                .cornerRadius(12)

                            Button(action: {
                                editedDishName = p.dishName
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    showEditTitlePopup = true
                                }
                            }) {
                                Image(systemName: "pencil.circle.fill")
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundColor(.white)
                                    .shadow(radius: 4)
                            }
                        }

                        if let d = p.date {
                            Text(fullDateFormatter.string(from: d))
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(Color.black.opacity(0.25))
                                .cornerRadius(12)
                        }
                    }

                    Spacer()

                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            selectedPhoto = nil
                            showSavedMessage = false
                            showEditTitlePopup = false
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

    private func editTitlePopup() -> some View {
        ZStack {
            Color.black.opacity(0.45)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        showEditTitlePopup = false
                    }
                }

            VStack(spacing: 16) {
                Text("Edit Title")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)

                TextField("Dish name", text: $editedDishName)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.white.opacity(0.18))
                    .cornerRadius(14)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color.white.opacity(0.35), lineWidth: 1)
                    )
                    .autocorrectionDisabled()

                HStack(spacing: 14) {
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            showEditTitlePopup = false
                        }
                    }) {
                        Text("Cancel")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.vertical, 12)
                            .frame(maxWidth: .infinity)
                            .background(Color.white.opacity(0.18))
                            .cornerRadius(14)
                    }

                    Button(action: {
                        saveEditedTitle()
                    }) {
                        Text("Save")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(Color(red: 0.08, green: 0.35, blue: 0.35))
                            .padding(.vertical, 12)
                            .frame(maxWidth: .infinity)
                            .background(Color.white.opacity(0.85))
                            .cornerRadius(14)
                    }
                }
            }
            .padding(22)
            .frame(maxWidth: 320)
            .background(
                RoundedRectangle(cornerRadius: 26)
                    .fill(Color.white.opacity(0.16))
                    .overlay(
                        RoundedRectangle(cornerRadius: 26)
                            .stroke(Color.white.opacity(0.35), lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.35), radius: 18, x: 0, y: 8)
            )
            .padding(.horizontal, 24)
        }
    }

    private func saveEditedTitle() {
        guard let selected = selectedPhoto else { return }

        let filename = selected.url.lastPathComponent
        let cleanedTitle = editedDishName.trimmingCharacters(in: .whitespacesAndNewlines)

        FoodPicsMetadataStore.upsert(filename: filename, dishName: cleanedTitle)

        loadSavedImages()

        if let updated = photos.first(where: { $0.url == selected.url }) {
            selectedPhoto = updated
        }

        withAnimation(.easeInOut(duration: 0.2)) {
            showEditTitlePopup = false
        }
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

    private func loadSavedImages() {
        let fm = FileManager.default
        let documentsURL = fm.urls(for: .documentDirectory, in: .userDomainMask).first!
        let folderURL = documentsURL.appendingPathComponent("FoodPics")

        guard fm.fileExists(atPath: folderURL.path) else {
            photos = []
            return
        }

        let meta = FoodPicsMetadataStore.load()

        do {
            let urls = try fm.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: [.contentModificationDateKey])
                .filter {
                    $0.pathExtension.lowercased() == "jpg" ||
                    $0.pathExtension.lowercased() == "jpeg" ||
                    $0.pathExtension.lowercased() == "png"
                }
                .sorted {
                    fileDate($0) > fileDate($1)
                }

            photos = urls.compactMap { url in
                guard let data = try? Data(contentsOf: url),
                      let img = UIImage(data: data) else { return nil }

                let filename = url.lastPathComponent
                let dt = parseDate(from: filename) ?? fileDate(url)
                let dish = meta[filename] ?? ""

                return FoodPhoto(
                    image: img,
                    url: url,
                    date: dt,
                    dishName: dish
                )
            }
        } catch {
            print("Error loading food pics: \(error)")
        }
    }

    private func fileDate(_ url: URL) -> Date {
        (try? url.resourceValues(forKeys: [.contentModificationDateKey]).contentModificationDate) ?? .distantPast
    }

    private func deleteImage(at index: Int) {
        guard photos.indices.contains(index) else { return }

        let fileURL = photos[index].url
        let filename = fileURL.lastPathComponent

        do {
            try FileManager.default.removeItem(at: fileURL)
            FoodPicsMetadataStore.remove(filename: filename)
            photos.remove(at: index)
        } catch {
            print("Error deleting food pic: \(error)")
        }
    }

    private func parseDate(from filename: String) -> Date? {
        let base = filename
            .replacingOccurrences(of: ".jpg", with: "")
            .replacingOccurrences(of: ".jpeg", with: "")
            .replacingOccurrences(of: ".png", with: "")

        let parts = base.components(separatedBy: "_")

        guard parts.count >= 4, parts[0] == "food" else {
            return nil
        }

        let ts = parts[1] + "_" + parts[2]
        return Self.filenameTimestampFormatter.date(from: ts)
    }
}
