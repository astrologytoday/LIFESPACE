import SwiftUI
import PencilKit
import UIKit

// MARK: - ArtCreativeView (Doodling Board + Save + Gallery)

struct ArtCreativeView: View {
    @EnvironmentObject var navModel: NavigationModel

    @StateObject private var store = DoodleStore()

    // Drawing state
    @State private var drawing = PKDrawing()
    @State private var currentDoodleID: UUID? = nil

    // Undo
    @State private var canvasUndoManager: UndoManager? = nil
    @State private var canUndo: Bool = false

    // Tool state
    enum Utensil: String, CaseIterable, Identifiable {
        case pencil, marker, brush
        var id: String { rawValue }

        var pkType: PKInkingTool.InkType {
            switch self {
            case .pencil: return .pencil
            case .marker: return .marker
            case .brush:  return .pen
            }
        }

        var icon: String {
            switch self {
            case .pencil: return "pencil"
            case .marker: return "highlighter"
            case .brush:  return "paintbrush"
            }
        }
    }

    @State private var utensil: Utensil = .pencil
    @State private var isEraserOn: Bool = false

    @State private var thickness: CGFloat = 10
    @State private var opacity: CGFloat = 1.0
    @State private var uiColor: UIColor = .black

    // UI
    @State private var showBigColorWheel = false
    @State private var showGallery = false
    @State private var showSavedToast = false

    // Clear confirmation popup
    private enum ClearIntent {
        case back
        case newSketch
    }

    @State private var showClearPopup: Bool = false
    @State private var clearIntent: ClearIntent? = nil

    // Popup text changes depending on which button was tapped
    private var popupTitle: String {
        switch clearIntent {
        case .back:
            return "Back to Tips"
        case .newSketch:
            return "New Drawing"
        case .none:
            return "Confirm"
        }
    }

    private var popupMessage: String {
        switch clearIntent {
        case .back:
            return "Are you sure you want to leave? Any unsaved changes will be lost."
        case .newSketch:
            return "Are you sure you want to start a new drawing? Any unsaved changes will be lost."
        case .none:
            return "Any unsaved changes will be lost."
        }
    }

    // Tool (soft eraser obeys thickness + opacity)
    private var currentTool: PKTool {
        let clampedOpacity = max(0.02, min(1.0, opacity))
        let width = max(1, min(40, thickness))

        if isEraserOn {
            // Draw in background color (white) using sliders
            return PKInkingTool(.pen, color: UIColor.white.withAlphaComponent(clampedOpacity), width: width)
        } else {
            return PKInkingTool(utensil.pkType, color: uiColor.withAlphaComponent(clampedOpacity), width: width)
        }
    }

    var body: some View {
        ZStack {
            // whiteboard canvas
            Color.white.ignoresSafeArea()

            VStack(spacing: 0) {

                // Top controls
                HStack(spacing: 12) {

                    Button {
                        clearIntent = .back
                        withAnimation(.easeInOut(duration: 0.4)) {
                            showClearPopup = true
                        }
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.black)
                            .padding(12)
                            .background(Color.black.opacity(0.06))
                            .clipShape(Circle())
                    }
                    .buttonStyle(.plain)

                    // Undo
                    Button {
                        canvasUndoManager?.undo()
                        canUndo = canvasUndoManager?.canUndo ?? false
                    } label: {
                        Image(systemName: "arrow.uturn.left")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.black)
                            .padding(12)
                            .background(Color.black.opacity(0.06))
                            .clipShape(Circle())
                    }
                    .buttonStyle(.plain)
                    .disabled(!canUndo)
                    .opacity(canUndo ? 1 : 0.35)

                    Spacer()

                    // New Drawing
                    Button {
                        clearIntent = .newSketch
                        withAnimation(.easeInOut(duration: 0.4)) {
                            showClearPopup = true
                        }
                    } label: {
                        Image(systemName: "doc.badge.plus")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.black)
                            .padding(12)
                            .background(Color.black.opacity(0.06))
                            .clipShape(Circle())
                    }
                    .buttonStyle(.plain)

                    // Gallery
                    Button {
                        showGallery = true
                    } label: {
                        Image(systemName: "photo.on.rectangle.angled")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.black)
                            .padding(12)
                            .background(Color.black.opacity(0.06))
                            .clipShape(Circle())
                    }
                    .buttonStyle(.plain)

                    // Save
                    Button {
                        saveCurrent()
                    } label: {
                        Image(systemName: "square.and.arrow.down")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.black)
                            .padding(12)
                            .background(Color.black.opacity(0.06))
                            .clipShape(Circle())
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 14)
                .padding(.top, 10)
                .padding(.bottom, 10)
                .background(Color.white)

                // Canvas
                CanvasRepresentable(
                    drawing: $drawing,
                    tool: currentTool,
                    undoManager: $canvasUndoManager,
                    canUndo: $canUndo
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 0)
                        .stroke(Color.black.opacity(0.06), lineWidth: 1)
                        .allowsHitTesting(false)
                )

                // Bottom tool bar
                VStack(spacing: 10) {

                    HStack(spacing: 12) {

                        Button {
                            showBigColorWheel = true
                        } label: {
                            ZStack {
                                Circle()
                                    .fill(Color(uiColor: uiColor))
                                    .frame(width: 34, height: 34)
                                    .overlay(Circle().stroke(Color.black.opacity(0.15), lineWidth: 1))

                                Image(systemName: "circle.lefthalf.filled")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.white.opacity(0.95))
                                    .shadow(radius: 2)
                            }
                            .padding(6)
                            .background(Color.black.opacity(0.06))
                            .clipShape(Capsule())
                        }
                        .buttonStyle(.plain)

                        // Eraser
                        Button {
                            isEraserOn.toggle()
                        } label: {
                            Image(systemName: "eraser")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.black)
                                .frame(width: 36, height: 36)
                                .background(
                                    Circle().fill(isEraserOn ? Color.black.opacity(0.10) : Color.black.opacity(0.04))
                                )
                                .overlay(
                                    Circle().stroke(Color.black.opacity(isEraserOn ? 0.20 : 0.10), lineWidth: 1)
                                )
                        }
                        .buttonStyle(.plain)

                        // Utensils
                        HStack(spacing: 10) {
                            ForEach(Utensil.allCases) { u in
                                Button {
                                    utensil = u
                                    isEraserOn = false
                                } label: {
                                    Image(systemName: u.icon)
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(.black)
                                        .frame(width: 36, height: 36)
                                        .background(
                                            Circle().fill((!isEraserOn && u == utensil) ? Color.black.opacity(0.10) : Color.black.opacity(0.04))
                                        )
                                        .overlay(
                                            Circle().stroke(Color.black.opacity((!isEraserOn && u == utensil) ? 0.20 : 0.10), lineWidth: 1)
                                        )
                                }
                                .buttonStyle(.plain)
                            }
                        }

                        Spacer()
                    }

                    // Sliders
                    VStack(spacing: 10) {
                        HStack(spacing: 10) {
                            Text("Thickness")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.black.opacity(0.75))
                                .frame(width: 70, alignment: .leading)

                            Slider(value: $thickness, in: 1...40, step: 1)
                        }

                        HStack(spacing: 10) {
                            Text("Opacity")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.black.opacity(0.75))
                                .frame(width: 70, alignment: .leading)

                            Slider(value: $opacity, in: 0.05...1.0)
                        }
                    }
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 18)
                        .fill(Color.white)
                        .shadow(color: Color.black.opacity(0.08), radius: 18, x: 0, y: -2)
                )
                .padding(.horizontal, 12)
                .padding(.bottom, 12)
            }

            // Tiny save toast
            if showSavedToast {
                VStack {
                    Spacer()
                    Text("Saved")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(Color.black.opacity(0.85))
                        .clipShape(Capsule())
                        .padding(.bottom, 110)
                }
                .transition(.opacity)
            }

            // LIFESPACE-style popup overlay
            if showClearPopup {
                Color.black.opacity(0.45)
                    .ignoresSafeArea()
                    .transition(.opacity)
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.4)) {
                            showClearPopup = false
                            clearIntent = nil
                        }
                    }

                ClearDrawingPopup(
                    title: popupTitle,
                    message: popupMessage,
                    onYes: {
                        withAnimation(.easeInOut(duration: 0.4)) {
                            showClearPopup = false
                        }

                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.02) {
                            clearBoard()

                            if clearIntent == .back {
                                withAnimation(.easeInOut(duration: 0.4)) {
                                    navModel.pop()
                                }
                            }

                            clearIntent = nil
                        }
                    },
                    onNo: {
                        withAnimation(.easeInOut(duration: 0.4)) {
                            showClearPopup = false
                            clearIntent = nil
                        }
                    }
                )
                .transition(.scale.combined(with: .opacity))
                .zIndex(10)
            }
        }
        .onAppear {
            withAnimation { navModel.showMenu = false }
        }
        .sheet(isPresented: $showBigColorWheel) {
            BigColorWheelSheet(color: $uiColor, opacity: $opacity)
                .presentationDetents([.medium])
        }
        .sheet(isPresented: $showGallery) {
            ArtGalleryView(store: store) { selected in
                if let loaded = store.loadDrawing(for: selected) {
                    drawing = loaded
                    currentDoodleID = selected.id
                    canvasUndoManager?.removeAllActions()
                    canUndo = false
                }
                showGallery = false
            }
        }
    }

    // Centralized clear logic
    private func clearBoard() {
        drawing = PKDrawing()
        currentDoodleID = nil
        canvasUndoManager?.removeAllActions()
        canUndo = false
    }

    private func saveCurrent() {
        if let id = currentDoodleID,
           let existing = store.doodles.first(where: { $0.id == id }) {
            store.update(doodle: existing, with: drawing)
        } else {
            let new = store.saveNew(drawing: drawing)
            currentDoodleID = new?.id
        }

        withAnimation(.easeInOut(duration: 0.2)) {
            showSavedToast = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
            withAnimation(.easeInOut(duration: 0.2)) {
                showSavedToast = false
            }
        }
    }
}


private struct ClearDrawingPopup: View {
    let title: String
    let message: String
    var onYes: () -> Void
    var onNo: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Text(title)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .shadow(radius: 3)

            Text(message)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.white.opacity(0.92))
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, 8)

            HStack(spacing: 12) {
                Button(action: onNo) {
                    Text("NO")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity)
                        .background(Color.white.opacity(0.14))
                        .cornerRadius(16)
                }
                .buttonStyle(.plain)

                Button(action: onYes) {
                    Text("YES")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity)
                        .background(Color.red.opacity(0.85))
                        .cornerRadius(16)
                }
                .buttonStyle(.plain)
            }
            .padding(.top, 4)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 22)
        .frame(maxWidth: 360)
        .background(
            BlurView(style: .systemUltraThinMaterial)
        )
        .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .stroke(Color.white.opacity(0.22), lineWidth: 1.3)
        )
        .shadow(color: .black.opacity(0.18), radius: 18, y: 6)
        .padding(.horizontal, 24)
    }
}

// MARK: - Canvas Representable (PencilKit)

private struct CanvasRepresentable: UIViewRepresentable {
    @Binding var drawing: PKDrawing
    var tool: PKTool

    @Binding var undoManager: UndoManager?
    @Binding var canUndo: Bool

    func makeUIView(context: Context) -> PKCanvasView {
        let view = PKCanvasView()
        view.drawing = drawing
        view.tool = tool
        view.isOpaque = true
        view.backgroundColor = .white
        view.alwaysBounceVertical = false
        view.alwaysBounceHorizontal = false
        view.bounces = false
        view.delegate = context.coordinator
        view.drawingPolicy = .anyInput

        // CRITICAL FIX: stop dark-mode inversion weirdness in PencilKit
        view.overrideUserInterfaceStyle = .light

        DispatchQueue.main.async {
            undoManager = view.undoManager
            canUndo = view.undoManager?.canUndo ?? false
        }

        return view
    }

    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        if uiView.drawing != drawing {
            uiView.drawing = drawing
        }

        uiView.tool = tool

        DispatchQueue.main.async {
            undoManager = uiView.undoManager
            canUndo = uiView.undoManager?.canUndo ?? false
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(drawing: $drawing, canUndo: $canUndo)
    }

    final class Coordinator: NSObject, PKCanvasViewDelegate {
        @Binding var drawing: PKDrawing
        @Binding var canUndo: Bool

        init(drawing: Binding<PKDrawing>, canUndo: Binding<Bool>) {
            _drawing = drawing
            _canUndo = canUndo
        }

        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            drawing = canvasView.drawing
            canUndo = canvasView.undoManager?.canUndo ?? false
        }
    }
}

// MARK: - Big Color Wheel Sheet

private struct BigColorWheelSheet: View {
    @Binding var color: UIColor
    @Binding var opacity: CGFloat

    @State private var hue: CGFloat = 0
    @State private var saturation: CGFloat = 1
    @State private var brightness: CGFloat = 0

    var body: some View {
        VStack(spacing: 16) {

            Capsule()
                .fill(Color.black.opacity(0.18))
                .frame(width: 44, height: 5)
                .padding(.top, 8)

            Text("Color Wheel")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.black)

            ColorWheel(hue: $hue, saturation: $saturation, brightness: $brightness)
                .frame(width: 240, height: 240)
                .onChange(of: hue) { _ in syncColorOut() }
                .onChange(of: saturation) { _ in syncColorOut() }
                .onChange(of: brightness) { _ in syncColorOut() }
                .onAppear {
                    var h: CGFloat = 0
                    var s: CGFloat = 0
                    var b: CGFloat = 0
                    var a: CGFloat = 0

                    color.getHue(&h, saturation: &s, brightness: &b, alpha: &a)

                    hue = h
                    saturation = s
                    brightness = b
                }

            VStack(spacing: 10) {
                HStack {
                    Text("Saturation")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.black.opacity(0.75))
                        .frame(width: 80, alignment: .leading)

                    Slider(value: $saturation, in: 0...1)
                }

                HStack {
                    Text("Brightness")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.black.opacity(0.75))
                        .frame(width: 80, alignment: .leading)

                    Slider(value: $brightness, in: 0...1)
                }

                HStack {
                    Text("Opacity")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.black.opacity(0.75))
                        .frame(width: 80, alignment: .leading)

                    Slider(value: $opacity, in: 0.05...1.0)
                }
            }
            .padding(.horizontal, 18)

            HStack(spacing: 12) {
                Circle()
                    .fill(Color(uiColor: color.withAlphaComponent(opacity)))
                    .frame(width: 46, height: 46)
                    .overlay(Circle().stroke(Color.black.opacity(0.15), lineWidth: 1))

                Text("Preview")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.black.opacity(0.8))

                Spacer()
            }
            .padding(.horizontal, 18)
            .padding(.bottom, 12)
        }
    }

    private func syncColorOut() {
        color = UIColor(
            hue: hue,
            saturation: saturation,
            brightness: brightness,
            alpha: 1.0
        )
    }
}

private struct ColorWheel: View {
    @Binding var hue: CGFloat
    @Binding var saturation: CGFloat
    @Binding var brightness: CGFloat

    var body: some View {
        GeometryReader { geo in
            let center = CGPoint(
                x: geo.size.width / 2,
                y: geo.size.height / 2
            )

            ZStack {
                // Hue ring
                Circle()
                    .strokeBorder(
                        AngularGradient(
                            gradient: Gradient(
                                colors: stride(from: 0.0, to: 1.0, by: 0.08).map {
                                    Color(hue: $0, saturation: 1, brightness: 1)
                                } + [
                                    Color(hue: 1, saturation: 1, brightness: 1)
                                ]
                            ),
                            center: .center
                        ),
                        lineWidth: 28
                    )

                // Inner preview
                Circle()
                    .fill(Color(uiColor: UIColor(
                        hue: hue,
                        saturation: saturation,
                        brightness: brightness,
                        alpha: 1
                    )))
                    .overlay(Circle().stroke(Color.black.opacity(0.10), lineWidth: 1))
                    .shadow(color: Color.black.opacity(0.10), radius: 12, x: 0, y: 6)
                    .padding(28)

                // Knob
                Circle()
                    .fill(Color.white)
                    .frame(width: 18, height: 18)
                    .overlay(Circle().stroke(Color.black.opacity(0.20), lineWidth: 1))
                    .position(knobPosition(in: geo.size))
                    .shadow(color: Color.black.opacity(0.12), radius: 6, x: 0, y: 4)
            }
            .contentShape(Circle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        let dx = value.location.x - center.x
                        let dy = value.location.y - center.y

                        var angle = atan2(dy, dx)

                        if angle < 0 {
                            angle += 2 * .pi
                        }

                        hue = angle / (2 * .pi)
                    }
            )
        }
    }

    private func knobPosition(in size: CGSize) -> CGPoint {
        let center = CGPoint(
            x: size.width / 2,
            y: size.height / 2
        )

        let radius = min(size.width, size.height) / 2
        let ringRadius = radius - 14
        let angle = hue * 2 * .pi

        return CGPoint(
            x: center.x + cos(angle) * ringRadius,
            y: center.y + sin(angle) * ringRadius
        )
    }
}

// MARK: - Gallery

struct ArtGalleryView: View {
    @ObservedObject var store: DoodleStore
    var onSelect: (Doodle) -> Void

    private let cols = [
        GridItem(.adaptive(minimum: 110), spacing: 12)
    ]

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: cols, spacing: 12) {
                    ForEach(store.doodles.sorted(by: { $0.createdAt > $1.createdAt })) { doodle in
                        Button {
                            onSelect(doodle)
                        } label: {
                            VStack(spacing: 8) {
                                DoodleThumbView(store: store, doodle: doodle)
                                    .frame(height: 110)
                                    .clipShape(RoundedRectangle(cornerRadius: 14))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 14)
                                            .stroke(Color.black.opacity(0.10), lineWidth: 1)
                                    )

                                Text(doodle.createdAt.formatted(date: .abbreviated, time: .omitted))
                                    .font(.system(size: 11, weight: .semibold))
                                    .foregroundColor(.black.opacity(0.7))
                            }
                        }
                        .buttonStyle(.plain)
                        .contextMenu {
                            Button(role: .destructive) {
                                store.delete(doodle: doodle)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                }
                .padding(14)
            }
            .navigationTitle("Doodles")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

private struct DoodleThumbView: View {
    @ObservedObject var store: DoodleStore
    let doodle: Doodle

    var body: some View {
        if let img = store.loadThumbnail(for: doodle) {
            Image(uiImage: img)
                .resizable()
                .scaledToFill()
        } else {
            ZStack {
                Color.black.opacity(0.04)

                Image(systemName: "scribble")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(.black.opacity(0.25))
            }
        }
    }
}

// MARK: - Persistence (Documents directory)

struct Doodle: Identifiable, Codable, Equatable {
    let id: UUID
    var createdAt: Date
    var drawingFilename: String
    var thumbnailFilename: String
}

final class DoodleStore: ObservableObject {
    @Published private(set) var doodles: [Doodle] = []

    private let fm = FileManager.default
    private let folderName = "LIFESPACE_Doodles"
    private let indexFile = "doodles_index.json"

    init() {
        loadIndex()
    }

    @discardableResult
    func saveNew(drawing: PKDrawing) -> Doodle? {
        let id = UUID()
        let drawingName = "drawing_\(id.uuidString).bin"
        let thumbName = "thumb_\(id.uuidString).png"

        guard writeDrawing(drawing, filename: drawingName) else {
            return nil
        }

        _ = writeThumbnail(from: drawing, filename: thumbName)

        let doodle = Doodle(
            id: id,
            createdAt: Date(),
            drawingFilename: drawingName,
            thumbnailFilename: thumbName
        )

        doodles.append(doodle)
        saveIndex()

        return doodle
    }

    func update(doodle: Doodle, with drawing: PKDrawing) {
        _ = writeDrawing(drawing, filename: doodle.drawingFilename)
        _ = writeThumbnail(from: drawing, filename: doodle.thumbnailFilename)
        saveIndex()
        objectWillChange.send()
    }

    func delete(doodle: Doodle) {
        if let url = fileURL(doodle.drawingFilename) {
            try? fm.removeItem(at: url)
        }

        if let url = fileURL(doodle.thumbnailFilename) {
            try? fm.removeItem(at: url)
        }

        doodles.removeAll { $0.id == doodle.id }
        saveIndex()
    }

    func loadDrawing(for doodle: Doodle) -> PKDrawing? {
        guard let url = fileURL(doodle.drawingFilename),
              let data = try? Data(contentsOf: url)
        else {
            return nil
        }

        return try? PKDrawing(data: data)
    }

    func loadThumbnail(for doodle: Doodle) -> UIImage? {
        guard let url = fileURL(doodle.thumbnailFilename),
              let data = try? Data(contentsOf: url)
        else {
            return nil
        }

        return UIImage(data: data)
    }

    private func baseFolderURL() -> URL? {
        guard let docs = fm.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }

        let folder = docs.appendingPathComponent(folderName, isDirectory: true)

        if !fm.fileExists(atPath: folder.path) {
            try? fm.createDirectory(at: folder, withIntermediateDirectories: true)
        }

        return folder
    }

    private func fileURL(_ filename: String) -> URL? {
        baseFolderURL()?.appendingPathComponent(filename)
    }

    private func indexURL() -> URL? {
        fileURL(indexFile)
    }

    private func loadIndex() {
        guard let url = indexURL(),
              let data = try? Data(contentsOf: url),
              let decoded = try? JSONDecoder().decode([Doodle].self, from: data)
        else {
            doodles = []
            return
        }

        doodles = decoded
    }

    private func saveIndex() {
        guard let url = indexURL(),
              let data = try? JSONEncoder().encode(doodles)
        else {
            return
        }

        try? data.write(to: url, options: .atomic)
    }

    private func writeDrawing(_ drawing: PKDrawing, filename: String) -> Bool {
        guard let url = fileURL(filename) else {
            return false
        }

        let data = drawing.dataRepresentation()

        do {
            try data.write(to: url, options: .atomic)
            return true
        } catch {
            return false
        }
    }

    private func writeThumbnail(from drawing: PKDrawing, filename: String) -> Bool {
        guard let url = fileURL(filename) else {
            return false
        }

        let bounds = drawing.bounds.isEmpty
            ? CGRect(x: 0, y: 0, width: 800, height: 800)
            : drawing.bounds.insetBy(dx: -20, dy: -20)

        let img = drawing.image(from: bounds, scale: 0.25)

        guard let png = img.pngData() else {
            return false
        }

        do {
            try png.write(to: url, options: .atomic)
            return true
        } catch {
            return false
        }
    }
}
