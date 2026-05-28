import SwiftUI
import PhotosUI
import Photos

// MARK: - MoodBoard Keys

enum MoodBoardKeys {
    static let selectedID = "moodBoards_selectedID"
    static let editingID  = "moodBoards_editingID"
}

// MARK: - MoodBoard Models + Storage

struct MoodBoard: Identifiable, Codable, Equatable {
    var id: String
    var title: String
    var createdAt: Date
    var elements: [MoodBoardElement]
}

struct MoodBoardElement: Identifiable, Codable, Equatable {
    var id: String
    var imageFilename: String
    var normalizedX: Double
    var normalizedY: Double
    var scale: Double
    var rotationRadians: Double
}

enum MoodBoardStorage {
    static let boardsKey = "moodBoards_v1"

    static func loadBoards(from json: String) -> [MoodBoard] {
        guard let data = json.data(using: .utf8) else { return [] }
        return (try? JSONDecoder().decode([MoodBoard].self, from: data)) ?? []
    }

    static func saveBoards(_ boards: [MoodBoard]) -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.withoutEscapingSlashes]
        guard let data = try? encoder.encode(boards) else { return "[]" }
        return String(data: data, encoding: .utf8) ?? "[]"
    }

    static func documentsURL() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    static func imageURL(filename: String) -> URL {
        documentsURL().appendingPathComponent(filename)
    }

    static func writeImage(_ image: UIImage, filename: String) throws {
        guard let data = image.jpegData(compressionQuality: 0.9) else { return }
        try data.write(to: imageURL(filename: filename), options: [.atomic])
    }

    static func readImage(filename: String) -> UIImage? {
        let url = imageURL(filename: filename)
        guard let data = try? Data(contentsOf: url) else { return nil }
        return UIImage(data: data)
    }
}

// MARK: - MoodBoardView

struct MoodBoardView: View {

    @EnvironmentObject var navModel: NavigationModel
    @AppStorage(MoodBoardStorage.boardsKey) private var moodBoardsJSON: String = "[]"

    // Title
    @State private var title: String = "MOOD BOARD TITLE"
    @State private var isEditingTitle: Bool = false
    @FocusState private var titleFocused: Bool

    // Canvas
    @State private var canvasSize: CGSize = .zero

    // Elements (live editing state)
    @State private var elements: [EditableElement] = []

    // Photo picker
    @State private var photoItem: PhotosPickerItem? = nil

    // Toast
    @State private var showToast: Bool = false
    @State private var toastMessage: String = "Saved!"

    // Delete mode
    @State private var deleteMode: Bool = false

    // New board confirmation
    @State private var showNewBoardConfirm: Bool = false

    // Edit mode
    @State private var isEditingExisting: Bool = false
    @State private var editingBoardID: String? = nil

    // Delayed load
    @State private var pendingLoadElements: [MoodBoardElement]? = nil
    @State private var didApplyPendingLoad: Bool = false

    // Photos permission alert
    @State private var showPhotosPermissionAlert: Bool = false

    // Styling
    private let canvasCorner: CGFloat = 18

    struct EditableElement: Identifiable, Equatable {
        var id: String
        var image: UIImage
        var filename: String
        var offset: CGSize
        var scale: CGFloat
        var rotation: Angle
    }

    var body: some View {
        ZStack {
            // 🌊 LIFESPACE gradient background
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

            VStack(spacing: 14) {

                // Title (tap to edit)
                VStack(spacing: 8) {
                    if isEditingTitle {
                        TextField("", text: $title)
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .textInputAutocapitalization(.characters)
                            .disableAutocorrection(true)
                            .focused($titleFocused)
                            .padding(.horizontal, 18)
                            .onSubmit { finishTitleEdit() }
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                                    titleFocused = true
                                }
                            }
                    } else {
                        Text(title.isEmpty ? "MOOD BOARD TITLE" : title)
                            .font(.system(size: 30, weight: .bold))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 18)
                            .onTapGesture {
                                isEditingTitle = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                                    titleFocused = true
                                }
                            }
                    }

                    Rectangle()
                        .fill(Color.white.opacity(0.85))
                        .frame(height: 2)
                        .padding(.horizontal, 34)
                }
                .padding(.top, 18)

                // Canvas
                GeometryReader { geo in
                    let size = geo.size

                    ZStack {
                        RoundedRectangle(cornerRadius: canvasCorner)
                            .fill(Color.white.opacity(0.96))
                            .shadow(color: Color.black.opacity(0.20), radius: 14, x: 0, y: 8)
                            .overlay(
                                RoundedRectangle(cornerRadius: canvasCorner)
                                    .stroke(Color.white.opacity(0.75), lineWidth: 2)
                                    .shadow(color: Color.white.opacity(0.22), radius: 10, x: 0, y: 0)
                            )

                        ForEach($elements) { $el in
                            MoodBoardCanvasElementView(
                                element: $el,
                                deleteMode: deleteMode,
                                onBringToFront: { bringToFront(el.id) },
                                onDelete: { deleteElement(el.id) }
                            )
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: canvasCorner))
                    .contentShape(RoundedRectangle(cornerRadius: canvasCorner))
                    .onAppear {
                        canvasSize = size
                        applyPendingLoadIfNeeded()
                    }
                    .onChange(of: size) { _, newSize in
                        canvasSize = newSize
                        applyPendingLoadIfNeeded()
                    }
                    // absorb canvas swipes without stealing element drags
                    .gesture(
                        DragGesture(minimumDistance: 18, coordinateSpace: .local)
                            .onChanged { _ in },
                        including: .gesture
                    )
                }
                .padding(.horizontal, 18)
                .padding(.top, 6)
                .padding(.bottom, 6)

                // Bigger (+) button for adding photos to the current board
                PhotosPicker(selection: $photoItem, matching: .images, photoLibrary: .shared()) {
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.96))
                            .shadow(color: Color.black.opacity(0.18), radius: 12, x: 0, y: 7)
                            .overlay(
                                Circle()
                                    .stroke(Color.white.opacity(0.85), lineWidth: 2)
                                    .shadow(color: Color.white.opacity(0.25), radius: 8)
                            )
                            .frame(width: 74, height: 74)

                        Image(systemName: "plus")
                            .font(.system(size: 30, weight: .bold))
                            .foregroundColor(Color(red: 0.06, green: 0.30, blue: 0.30))
                    }
                }
                .buttonStyle(.plain)
                .padding(.bottom, 2)
                .onChange(of: photoItem) { _, newItem in
                    guard let newItem else { return }
                    addPickedPhoto(newItem)
                }

                // Bottom controls
                HStack {
                    Button {
                        navModel.push("ExpressionTipsView")
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 26, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 8)
                    }
                    .buttonStyle(.plain)

                    Spacer()

                    // 4 square buttons: new board / delete / download / gallery(save+go)
                    HStack(spacing: 10) {

                        // New Board button
                        SquareIconButton(
                            systemName: "plus.square.fill",
                            isActive: false,
                            activeTint: .white,
                            inactiveTint: Color(red: 0.10, green: 0.25, blue: 0.25)
                        ) {
                            finishTitleEdit()
                            showNewBoardConfirm = true
                        }

                        SquareIconButton(
                            systemName: "trash.fill",
                            isActive: deleteMode,
                            activeTint: Color(red: 0.90, green: 0.15, blue: 0.15),
                            inactiveTint: Color(red: 0.10, green: 0.25, blue: 0.25)
                        ) {
                            withAnimation(.easeInOut(duration: 0.18)) {
                                deleteMode.toggle()
                            }
                        }

                        // Download to iPhone Photos (does NOT save to gallery)
                        SquareIconButton(
                            systemName: "square.and.arrow.down.fill",
                            isActive: false,
                            activeTint: .white,
                            inactiveTint: Color(red: 0.10, green: 0.25, blue: 0.25)
                        ) {
                            exportCanvasToPhotos()
                        }

                        // Gallery button auto-saves to gallery, then goes to gallery
                        SquareIconButton(
                            systemName: "photo.on.rectangle.angled",
                            isActive: false,
                            activeTint: .white,
                            inactiveTint: Color(red: 0.10, green: 0.25, blue: 0.25)
                        ) {
                            saveMoodBoardAndGoToGallery()
                        }
                    }
                    .padding(.trailing, 10)
                    .padding(.top, 18)
                }
                .padding(.horizontal, 18)
                .padding(.bottom, 18)
            }

            if showToast {
                VStack {
                    Spacer()
                    Text(toastMessage)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 18)
                        .padding(.vertical, 10)
                        .background(Capsule().fill(Color.black.opacity(0.55)))
                        .padding(.bottom, 94)
                }
                .transition(.opacity)
            }
        }
        .onTapGesture {
            if isEditingTitle { finishTitleEdit() }
        }
        .onAppear {
            loadIfEditing()
        }
        .alert("Start a New Mood Board?", isPresented: $showNewBoardConfirm) {
            Button("Cancel", role: .cancel) { }

            Button("Start New Board", role: .destructive) {
                startNewMoodBoard()
            }
        } message: {
            Text("Are you sure you want to start a new Mood Board? Any unsaved changes will be lost.")
        }
        .alert("Allow Photos Access", isPresented: $showPhotosPermissionAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Please allow Photo Library access so LIFESPACE can save your mood board image.")
        }
    }

    // MARK: - Title

    private func finishTitleEdit() {
        titleFocused = false
        isEditingTitle = false

        let cleaned = title.trimmingCharacters(in: .whitespacesAndNewlines)
        if cleaned.isEmpty {
            title = "MOOD BOARD TITLE"
        } else {
            title = cleaned.uppercased()
        }
    }

    // MARK: - New Board

    private func startNewMoodBoard() {
        finishTitleEdit()

        UserDefaults.standard.removeObject(forKey: MoodBoardKeys.editingID)

        isEditingExisting = false
        editingBoardID = nil
        pendingLoadElements = nil
        didApplyPendingLoad = false
        deleteMode = false

        withAnimation(.easeInOut(duration: 0.25)) {
            title = "MOOD BOARD TITLE"
            elements = []
        }

        showToastNow("New Mood Board")
    }

    // MARK: - Z Order

    private func bringToFront(_ id: String) {
        guard let idx = elements.firstIndex(where: { $0.id == id }) else { return }
        let item = elements.remove(at: idx)
        elements.append(item)
    }

    // MARK: - Delete

    private func deleteElement(_ id: String) {
        withAnimation(.easeInOut(duration: 0.18)) {
            elements.removeAll(where: { $0.id == id })
        }
    }

    // MARK: - Edit Mode Load

    private func loadIfEditing() {
        guard let editID = UserDefaults.standard.string(forKey: MoodBoardKeys.editingID) else {
            isEditingExisting = false
            editingBoardID = nil
            pendingLoadElements = nil
            didApplyPendingLoad = false
            return
        }

        let boards = MoodBoardStorage.loadBoards(from: moodBoardsJSON)
        guard let existing = boards.first(where: { $0.id == editID }) else {
            UserDefaults.standard.removeObject(forKey: MoodBoardKeys.editingID)
            isEditingExisting = false
            editingBoardID = nil
            pendingLoadElements = nil
            didApplyPendingLoad = false
            return
        }

        isEditingExisting = true
        editingBoardID = existing.id
        title = existing.title

        pendingLoadElements = existing.elements
        didApplyPendingLoad = false
        applyPendingLoadIfNeeded()
    }

    private func applyPendingLoadIfNeeded() {
        guard !didApplyPendingLoad else { return }
        guard let pending = pendingLoadElements else { return }
        guard canvasSize.width > 1, canvasSize.height > 1 else { return }

        let w = canvasSize.width
        let h = canvasSize.height

        var loaded: [EditableElement] = []
        for el in pending {
            guard let img = MoodBoardStorage.readImage(filename: el.imageFilename) else { continue }

            let offset = CGSize(
                width: CGFloat(el.normalizedX) * w,
                height: CGFloat(el.normalizedY) * h
            )

            loaded.append(
                EditableElement(
                    id: el.id,
                    image: img,
                    filename: el.imageFilename,
                    offset: offset,
                    scale: CGFloat(el.scale),
                    rotation: .radians(el.rotationRadians)
                )
            )
        }

        elements = loaded
        didApplyPendingLoad = true
    }

    // MARK: - Photo Picking

    private func addPickedPhoto(_ item: PhotosPickerItem) {
        Task {
            if let data = try? await item.loadTransferable(type: Data.self),
               let uiImage = UIImage(data: data) {

                let id = UUID().uuidString
                let filename = "moodboard_element_\(id).jpg"
                do { try MoodBoardStorage.writeImage(uiImage, filename: filename) } catch { }

                let newEl = EditableElement(
                    id: id,
                    image: uiImage,
                    filename: filename,
                    offset: .zero,
                    scale: 0.65,
                    rotation: .zero
                )

                await MainActor.run {
                    elements.append(newEl)
                    photoItem = nil
                }
            } else {
                await MainActor.run {
                    photoItem = nil
                }
            }
        }
    }

    // MARK: - Gallery Save (NEW vs EDIT) no duplicates + go to Gallery

    private func saveMoodBoardAndGoToGallery() {
        finishTitleEdit()
        deleteMode = false

        let w = max(canvasSize.width, 1)
        let h = max(canvasSize.height, 1)

        let savedElements: [MoodBoardElement] = elements.map { el in
            MoodBoardElement(
                id: el.id,
                imageFilename: el.filename,
                normalizedX: Double(el.offset.width / w),
                normalizedY: Double(el.offset.height / h),
                scale: Double(el.scale),
                rotationRadians: el.rotation.radians
            )
        }

        var boards = MoodBoardStorage.loadBoards(from: moodBoardsJSON)

        if isEditingExisting, let editID = editingBoardID {
            // Update in place. No duplicates.
            if let idx = boards.firstIndex(where: { $0.id == editID }) {
                boards[idx] = MoodBoard(
                    id: editID,
                    title: title.isEmpty ? "MOOD BOARD TITLE" : title,
                    createdAt: boards[idx].createdAt,
                    elements: savedElements
                )
            }

            UserDefaults.standard.set(editID, forKey: MoodBoardKeys.selectedID)
            UserDefaults.standard.removeObject(forKey: MoodBoardKeys.editingID)
            moodBoardsJSON = MoodBoardStorage.saveBoards(boards)

            showToastNow("Saved to Gallery!")

            withAnimation(.easeInOut(duration: 0.4)) {
                navModel.push("MoodBoardGalleryView")
            }

        } else {
            // New board only happens after user taps New Board, edits, then saves.
            let newID = UUID().uuidString
            boards.append(
                MoodBoard(
                    id: newID,
                    title: title.isEmpty ? "MOOD BOARD TITLE" : title,
                    createdAt: Date(),
                    elements: savedElements
                )
            )

            UserDefaults.standard.set(newID, forKey: MoodBoardKeys.selectedID)
            UserDefaults.standard.removeObject(forKey: MoodBoardKeys.editingID)
            moodBoardsJSON = MoodBoardStorage.saveBoards(boards)

            showToastNow("Saved to Gallery!")

            withAnimation(.easeInOut(duration: 0.4)) {
                navModel.push("MoodBoardGalleryView")
            }
        }
    }

    // MARK: - Download: Export canvas to Photos (flattened image)

    private func exportCanvasToPhotos() {
        guard canvasSize.width > 1, canvasSize.height > 1 else { return }
        guard let image = renderCanvasImage() else { return }

        let status = PHPhotoLibrary.authorizationStatus(for: .addOnly)

        if status == .authorized {
            saveImageToPhotos(image)
            return
        }

        if status == .notDetermined {
            PHPhotoLibrary.requestAuthorization(for: .addOnly) { newStatus in
                DispatchQueue.main.async {
                    if newStatus == .authorized {
                        saveImageToPhotos(image)
                    } else {
                        showPhotosPermissionAlert = true
                    }
                }
            }
            return
        }

        // denied / restricted
        showPhotosPermissionAlert = true
    }

    private func saveImageToPhotos(_ image: UIImage) {
        guard let data = image.jpegData(compressionQuality: 0.92) else { return }

        PHPhotoLibrary.shared().performChanges({
            let request = PHAssetCreationRequest.forAsset()
            request.addResource(with: .photo, data: data, options: nil)
        }) { success, _ in
            DispatchQueue.main.async {
                if success {
                    showToastNow("Saved to iPhone Photos!")
                }
            }
        }
    }

    private func renderCanvasImage() -> UIImage? {
        let size = canvasSize
        let rect = CGRect(origin: .zero, size: size)

        let renderer = UIGraphicsImageRenderer(size: size)
        let img = renderer.image { ctx in
            // Background
            UIColor.white.setFill()
            ctx.fill(rect)

            // Clip to canvas shape
            let path = UIBezierPath(roundedRect: rect, cornerRadius: canvasCorner)
            path.addClip()

            // Draw elements in order, same stacking as on-screen
            for el in elements {
                let baseW: CGFloat = 240
                let aspect = (el.image.size.width > 0) ? (el.image.size.height / el.image.size.width) : 1
                let baseH: CGFloat = baseW * aspect

                let drawW = baseW * el.scale
                let drawH = baseH * el.scale

                let center = CGPoint(x: size.width / 2, y: size.height / 2)
                let pos = CGPoint(x: center.x + el.offset.width, y: center.y + el.offset.height)

                ctx.cgContext.saveGState()
                ctx.cgContext.translateBy(x: pos.x, y: pos.y)
                ctx.cgContext.rotate(by: CGFloat(el.rotation.radians))

                let drawRect = CGRect(
                    x: -drawW / 2,
                    y: -drawH / 2,
                    width: drawW,
                    height: drawH
                )

                el.image.draw(in: drawRect)

                ctx.cgContext.restoreGState()
            }
        }

        return img
    }

    // MARK: - Toast

    private func showToastNow(_ msg: String) {
        toastMessage = msg
        withAnimation(.easeInOut(duration: 0.25)) {
            showToast = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
            withAnimation(.easeInOut(duration: 0.25)) {
                showToast = false
            }
        }
    }
}

// MARK: - Canvas Element (drag + pinch + rotate + tap-to-delete)

private struct MoodBoardCanvasElementView: View {

    @Binding var element: MoodBoardView.EditableElement
    let deleteMode: Bool
    var onBringToFront: () -> Void
    var onDelete: () -> Void

    @GestureState private var dragDelta: CGSize = .zero
    @GestureState private var pinchDelta: CGFloat = 1.0
    @GestureState private var rotationDelta: Angle = .zero

    private var liveOffset: CGSize {
        CGSize(
            width: element.offset.width + dragDelta.width,
            height: element.offset.height + dragDelta.height
        )
    }

    private var liveScale: CGFloat {
        let s = element.scale * pinchDelta
        return min(max(s, 0.15), 4.0)
    }

    private var liveRotation: Angle {
        element.rotation + rotationDelta
    }

    var body: some View {
        Image(uiImage: element.image)
            .resizable()
            .scaledToFit()
            .frame(width: 240)
            .scaleEffect(liveScale)
            .rotationEffect(liveRotation)
            .offset(liveOffset)
            .shadow(color: Color.black.opacity(0.22), radius: 8, x: 0, y: 5)
            .onTapGesture {
                if deleteMode {
                    onDelete()
                } else {
                    onBringToFront()
                }
            }
            .highPriorityGesture(dragGesture)
            .simultaneousGesture(pinchGesture)
            .simultaneousGesture(rotateGesture)
    }

    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 2)
            .updating($dragDelta) { value, state, _ in
                state = value.translation
            }
            .onChanged { _ in
                onBringToFront()
            }
            .onEnded { value in
                element.offset = CGSize(
                    width: element.offset.width + value.translation.width,
                    height: element.offset.height + value.translation.height
                )
            }
    }

    private var pinchGesture: some Gesture {
        MagnificationGesture()
            .updating($pinchDelta) { value, state, _ in
                state = value
            }
            .onChanged { _ in
                onBringToFront()
            }
            .onEnded { value in
                let newScale = element.scale * value
                element.scale = min(max(newScale, 0.15), 4.0)
            }
    }

    private var rotateGesture: some Gesture {
        RotationGesture()
            .updating($rotationDelta) { value, state, _ in
                state = value
            }
            .onChanged { _ in
                onBringToFront()
            }
            .onEnded { value in
                element.rotation += value
            }
    }
}

// MARK: - Reusable Square Icon Button

private struct SquareIconButton: View {

    let systemName: String
    let isActive: Bool
    let activeTint: Color
    let inactiveTint: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.96))
                    .shadow(color: Color.black.opacity(0.16), radius: 10, x: 0, y: 6)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                isActive ? activeTint.opacity(0.85) : Color.white.opacity(0.85),
                                lineWidth: isActive ? 3 : 2
                            )
                            .shadow(
                                color: isActive ? activeTint.opacity(0.25) : Color.white.opacity(0.20),
                                radius: 10
                            )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(isActive ? activeTint.opacity(0.12) : Color.clear)
                    )
                    .frame(width: 48, height: 48)

                Image(systemName: systemName)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(isActive ? activeTint : inactiveTint)
            }
        }
        .buttonStyle(.plain)
    }
}
