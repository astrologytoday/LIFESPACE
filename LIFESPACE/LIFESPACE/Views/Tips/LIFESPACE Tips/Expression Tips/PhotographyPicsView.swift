import SwiftUI
import UIKit

struct PhotographyPicsView: View {
    @EnvironmentObject var navModel: NavigationModel

    struct PhotoItem: Identifiable {
        let id = UUID()
        let image: UIImage
        let url: URL
        let date: Date?
        let photoName: String
    }

    @State private var photos: [PhotoItem] = []
    @State private var selectedPhoto: PhotoItem? = nil
    @State private var showingDeleteButtonForIndex: Int? = nil
    @State private var showSavedMessage = false

    @State private var showEditTitlePopup = false
    @State private var editedPhotoName = ""

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
                Text("Photo Gallery")
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
                                        if !p.photoName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                            Text(p.photoName)
                                                .font(.system(size: 10, weight: .heavy))
                                                .foregroundColor(.white)
                                                .lineLimit(1)
                                                .padding(6)
                                                .background(Color.black.opacity(0.55))
                                                .cornerRadius(6)
                                        }

                                        if let d = p.date {
                                            Text(thumbDateFormatter.string(from: d))
                                                .font(.system(size: 10, weight: .bold))
                                                .foregroundColor(.white)
                                                .padding(6)
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

    private func photoViewer(for p: PhotoItem) -> some View {
        ZStack {
            lifespaceGradient

            VStack {
                Spacer().frame(height: 55)

                HStack(spacing: 10) {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack(spacing: 8) {
                            Text(p.photoName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "Untitled" : p.photoName)
                                .font(.system(size: 14, weight: .heavy))
                                .foregroundColor(.white)
                                .lineLimit(1)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(Color.black.opacity(0.25))
                                .cornerRadius(12)

                            Button {
                                editedPhotoName = p.photoName
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    showEditTitlePopup = true
                                }
                            } label: {
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

                    Button {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            selectedPhoto = nil
                            showSavedMessage = false
                            showEditTitlePopup = false
                        }
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 32))
                            .foregroundColor(.white)
                            .shadow(radius: 4)
                    }
                }
                .padding(.horizontal, 20)

                Spacer().frame(height: 14)

                Image(uiImage: p.image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: UIScreen.main.bounds.width - 10)
                    .frame(maxHeight: UIScreen.main.bounds.height * 0.68)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    .shadow(color: .black.opacity(0.35), radius: 12, x: 0, y: 8)

                Spacer()
            }

            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        saveImageToPhotos(p.image)
                    } label: {
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
            Color.black.opacity(0.45).ignoresSafeArea()

            VStack(spacing: 16) {
                Text("Edit Title")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)

                TextField("Photo name", text: $editedPhotoName)
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(12)

                Button("Save") {
                    saveEditedTitle()
                }
            }
            .padding()
        }
    }

    private func saveEditedTitle() {
        guard let selected = selectedPhoto else { return }

        let filename = selected.url.lastPathComponent
        let cleaned = editedPhotoName.trimmingCharacters(in: .whitespacesAndNewlines)

        PhotographyPicsMetadataStore.upsert(filename: filename, photoName: cleaned)

        loadSavedImages()

        if let updated = photos.first(where: { $0.url == selected.url }) {
            selectedPhoto = updated
        }

        showEditTitlePopup = false
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
        let folderURL = fm.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("PhotographyPics")

        let meta = PhotographyPicsMetadataStore.load()

        guard let urls = try? fm.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: [.contentModificationDateKey]) else {
            return
        }

        photos = urls.compactMap { url in
            guard let data = try? Data(contentsOf: url),
                  let img = UIImage(data: data) else { return nil }

            let filename = url.lastPathComponent
            let date = parseDate(from: filename)
            let name = meta[filename] ?? ""

            return PhotoItem(image: img, url: url, date: date, photoName: name)
        }
    }

    private func deleteImage(at index: Int) {
        let fileURL = photos[index].url
        let filename = fileURL.lastPathComponent

        try? FileManager.default.removeItem(at: fileURL)
        PhotographyPicsMetadataStore.remove(filename: filename)

        photos.remove(at: index)
    }

    private func parseDate(from filename: String) -> Date? {
        let base = filename.replacingOccurrences(of: ".jpg", with: "")
        let parts = base.components(separatedBy: "_")

        guard parts.count >= 4 else { return nil }

        let ts = parts[1] + "_" + parts[2]
        return Self.filenameTimestampFormatter.date(from: ts)
    }
}
