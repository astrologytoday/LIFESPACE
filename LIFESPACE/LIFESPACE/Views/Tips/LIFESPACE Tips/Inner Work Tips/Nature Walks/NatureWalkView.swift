import SwiftUI
import PhotosUI
import UIKit

struct NatureWalkView: View {
    @EnvironmentObject var navModel: NavigationModel
    @State private var showCamera = false
    @State private var appeared = false

    var body: some View {
        ZStack(alignment: .topLeading) {

            // Background
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

            // Subtle glow overlay
            RadialGradient(
                gradient: Gradient(colors: [
                    Color.white.opacity(0.16),
                    Color.white.opacity(0.00)
                ]),
                center: .topLeading,
                startRadius: 30,
                endRadius: 620
            )
            .ignoresSafeArea()
            .blendMode(.screen)

            ScrollView(showsIndicators: false) {
                VStack(spacing: 18) {

                    // Header
                    VStack(spacing: 8) {
                        Text("NATURE WALK")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(.white)
                            .shadow(color: .white.opacity(0.28), radius: 10, x: 0, y: 0)
                            .shadow(color: .black.opacity(0.30), radius: 3, x: 0, y: 2)
                            .shadow(color: .white.opacity(0.7), radius: 10)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 22)
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 10)
                    .animation(.easeInOut(duration: 0.6), value: appeared)

                    // Cards
                    GlassCard(
                        icon: "sun.max.fill",
                        iconGlow: true,
                        title: "The Benefits of Sunlight",
                        message: "Sunlight helps regulate your circadian rhythm, supports serotonin activity, and enables vitamin D production. Regular natural light exposure supports both mental and physical health."
                    )
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 10)
                    .animation(.easeInOut(duration: 0.6).delay(0.05), value: appeared)

                    GlassCard(
                        icon: "leaf.fill",
                        iconGlow: true,
                        title: "The Power of the Forest",
                        message: "Time in forest environments, often called forest bathing (shinrin-yoku), is linked with lower stress, better mood, and improved overall regulation in the body."
                    )
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 10)
                    .animation(.easeInOut(duration: 0.6).delay(0.10), value: appeared)

                    GlassCard(
                        icon: "camera.fill",
                        iconGlow: false,
                        title: "Connect Through the Lens of Presence",
                        message: """
Every walk is a conversation with the Earth.

Try this:
1) Find something alive you have never noticed before.
2) Pause, breathe, and observe it with appreciation.
3) Take a photo using the LIFESPACE Camera.

Your image will be saved to your Nature Album so you can revisit later.
"""
                    )
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 10)
                    .animation(.easeInOut(duration: 0.6).delay(0.15), value: appeared)

                    // Action buttons
                    HStack(spacing: 12) {
                        ActionCapsuleButton(
                            title: "Open Camera",
                            systemImage: "camera.circle.fill"
                        ) {
                            showCamera = true
                        }

                        ActionCapsuleButton(
                            title: "Photo Gallery",
                            systemImage: "photo.on.rectangle.angled"
                        ) {
                            withAnimation(.easeInOut(duration: 0.4)) {
                                navModel.push("NatureWalkGalleryView")
                            }
                        }
                    }
                    .padding(.top, 6)
                    .padding(.horizontal, 18)
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 10)
                    .animation(.easeInOut(duration: 0.6).delay(0.20), value: appeared)
                }
                .padding(.top, 54)
                .padding(.bottom, 28)
            }

            // Top back button (fixed)
            Button {
                withAnimation(.easeInOut(duration: 0.4)) {
                    navModel.pop()
                }
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                    .padding(12)
                    .background(Color.white.opacity(0.16))
                    .clipShape(Circle())
                    .overlay(
                        Circle().stroke(Color.white.opacity(0.18), lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.25), radius: 10, x: 0, y: 8)
            }
            .padding(.leading, 16)
            .padding(.top, 14)
        }
        .onAppear { appeared = true }
        .sheet(isPresented: $showCamera) {
            ImagePickerView { image in
                showCamera = false

                if let image = image {
                    saveNatureWalkImage(image)

                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                        withAnimation(.easeInOut(duration: 0.4)) {
                            navModel.push("NatureWalkGalleryView")
                        }
                    }
                }
            }
        }
    }

    // MARK: - NatureWalk Folder
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

    // MARK: - Save into NatureWalk folder (keeps galleries separate)
    private func saveNatureWalkImage(_ image: UIImage) {
        ensureNatureWalkFolderExists()
        guard let data = image.jpegData(compressionQuality: 0.9) else { return }

        let filename = "naturewalk_\(UUID().uuidString).jpg"
        let url = natureWalkFolderURL().appendingPathComponent(filename)

        do {
            try data.write(to: url, options: [.atomic])
            print("✅ Saved NatureWalk image at: \(url)")
        } catch {
            print("❌ Error saving NatureWalk image: \(error)")
        }
    }
}

// MARK: - UI Components

private struct GlassCard: View {
    let icon: String
    let iconGlow: Bool
    let title: String
    let message: String

    private var messageView: some View {
        Text(message)
            .font(.system(size: 15, weight: .medium))
            .foregroundColor(.white.opacity(0.92))
            .fixedSize(horizontal: false, vertical: true)
            .lineSpacing(3)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                    .shadow(color: iconGlow ? .white.opacity(0.25) : .clear, radius: 10, x: 0, y: 0)

                Text(title)
                    .font(.system(size: 18, weight: .heavy))
                    .foregroundColor(.white)

                Spacer()
            }

            messageView
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.white.opacity(0.12))
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(Color.white.opacity(0.16), lineWidth: 1)
                )
        )
        .shadow(color: .black.opacity(0.18), radius: 18, x: 0, y: 12)
        .padding(.horizontal, 18)
    }
}

private struct ActionCapsuleButton: View {
    let title: String
    let systemImage: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                Image(systemName: systemImage)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                    .shadow(color: .white.opacity(0.20), radius: 10, x: 0, y: 0)

                Text(title)
                    .font(.system(size: 15, weight: .heavy))
                    .foregroundColor(.white)

                Spacer(minLength: 0)
            }
            .padding(.vertical, 14)
            .padding(.horizontal, 14)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color.white.opacity(0.16))
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(Color.white.opacity(0.18), lineWidth: 1)
                    )
            )
            .shadow(color: .black.opacity(0.20), radius: 16, x: 0, y: 10)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Image Picker Component (embedded inside same file)
struct ImagePickerView: UIViewControllerRepresentable {
    var completion: (UIImage?) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(completion: completion)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator

        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }

        picker.allowsEditing = false
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var completion: (UIImage?) -> Void

        init(completion: @escaping (UIImage?) -> Void) {
            self.completion = completion
        }

        func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
        ) {
            let image = info[.originalImage] as? UIImage
            picker.dismiss(animated: true) {
                self.completion(image)
            }
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true) {
                self.completion(nil)
            }
        }
    }
}
