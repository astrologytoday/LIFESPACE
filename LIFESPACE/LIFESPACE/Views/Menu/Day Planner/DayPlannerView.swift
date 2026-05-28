import SwiftUI
import Combine
import UIKit

struct DayPlannerView: View {
    @EnvironmentObject var navModel: NavigationModel
    @EnvironmentObject var toDoListModel: ToDoListModel

    @State private var hourSlots: [String: String] = [:] {
        didSet { savePlanner() }
    }

    @State private var showHelp = false
    @State private var isToDoCollapsed = true
    @State private var showClearConfirm = false

    @State private var contextMenuHour: String? = nil
    @State private var contextMenuFrame: CGRect = .zero
    @State private var showContextMenu = false

    @State private var contextMenuToDoItem: ToDoItem? = nil
    @State private var contextMenuToDoFrame: CGRect = .zero
    @State private var showToDoContextMenu = false

    @State private var keyboardHeight: CGFloat = 0
    @FocusState private var focusedHour: String?

    private let lateHours: Set<String> = ["3PM", "4PM", "5PM", "6PM", "7PM", "8PM"]

    let plannerKey = "userPlanner"

    let hours: [String] = (6...20).map { hour in
        let ampm = hour < 12 ? "AM" : "PM"
        let hour12 = hour == 12 ? 12 : hour % 12
        return "\(hour12)\(ampm)"
    }

    private var isLateFocus: Bool {
        guard let h = focusedHour else { return false }
        return lateHours.contains(h)
    }

    var body: some View {
        ZStack {
            LifespaceBackground()
                .hideKeyboardOnTap()

            GeometryReader { geo in
                let totalW = geo.size.width
                let totalH = geo.size.height
                let safeBottom = geo.safeAreaInsets.bottom
                let usableH = max(320, totalH - safeBottom)
                let pinch: CGFloat = 6
                let spacing: CGFloat = 12 + pinch
                let cardPad: CGFloat = 14
                let timeColW: CGFloat = 56
                let rowSpacing: CGFloat = 10
                let scheduleNudgeRight: CGFloat = pinch * 1
                let todoOpenW = min(260, totalW * 0.40) - (pinch * 2)
                let sideControlsW: CGFloat = 56
                let todoW = isToDoCollapsed ? sideControlsW : todoOpenW
                let plannerW = totalW - todoW - spacing - 32 + scheduleNudgeRight
                let innerPlannerW = plannerW - (cardPad * 2)
                let fieldW = max(80, innerPlannerW - timeColW - rowSpacing)

                VStack(spacing: 0) {
                    Spacer().frame(height: 10)

                    HStack(alignment: .top, spacing: spacing) {
                        glassCard {
                            VStack(alignment: .leading, spacing: 10) {
                                HStack(spacing: 10) {
                                    Text("Schedule")
                                        .font(.system(size: 16, weight: .heavy))
                                        .foregroundColor(.white.opacity(0.97))
                                        .shadow(color: Color.black.opacity(0.22), radius: 3, x: 0, y: 1)
                                        .lineLimit(1)
                                        .fixedSize(horizontal: true, vertical: false)
                                        .layoutPriority(100)

                                    Spacer(minLength: 8)

                                    Button(action: {
                                        focusedHour = nil
                                        showContextMenu = false
                                        showToDoContextMenu = false
                                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)

                                        withAnimation(.easeInOut(duration: 0.25)) {
                                            showClearConfirm = true
                                        }
                                    }) {
                                        Text("Clear")
                                            .font(.system(size: 13, weight: .bold))
                                            .foregroundColor(.white)
                                            .lineLimit(1)
                                            .frame(height: 30)
                                            .padding(.horizontal, 12)
                                            .background(Color.white.opacity(0.12))
                                            .clipShape(Capsule())
                                            .overlay(Capsule().stroke(Color.white.opacity(0.35), lineWidth: 1))
                                    }
                                    .fixedSize(horizontal: true, vertical: false)

                                    Button(action: {
                                        showContextMenu = false
                                        showToDoContextMenu = false

                                        withAnimation(.easeInOut(duration: 0.4)) {
                                            isToDoCollapsed.toggle()
                                        }
                                    }) {
                                        Image(systemName: "sidebar.right")
                                            .font(.system(size: 14, weight: .heavy))
                                            .foregroundColor(.white.opacity(0.9))
                                            .frame(height: 30)
                                            .padding(.horizontal, 12)
                                            .background(Color.white.opacity(0.12))
                                            .clipShape(Capsule())
                                            .overlay(Capsule().stroke(Color.white.opacity(0.35), lineWidth: 1))
                                    }
                                    .fixedSize(horizontal: true, vertical: false)
                                }

                                ScrollViewReader { proxy in
                                    ScrollView(showsIndicators: false) {
                                        LazyVStack(alignment: .leading, spacing: 10) {
                                            ForEach(hours, id: \.self) { hour in
                                                plannerRow(hour: hour, timeColW: timeColW, fieldW: fieldW)
                                                    .id(hour)
                                            }
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.top, 2)
                                        .padding(.bottom, (isLateFocus && keyboardHeight > 0) ? (keyboardHeight + 70) : 10)
                                    }
                                    .onChange(of: focusedHour) { newValue in
                                        guard let h = newValue else { return }
                                        let isLate = lateHours.contains(h)

                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.02) {
                                            if isLate && keyboardHeight == 0 {
                                                var t = Transaction()
                                                t.animation = nil
                                                withTransaction(t) {
                                                    proxy.scrollTo(h, anchor: .center)
                                                }
                                            } else {
                                                withAnimation(.easeInOut(duration: 0.25)) {
                                                    proxy.scrollTo(h, anchor: isLate ? .bottom : .top)
                                                }
                                            }
                                        }
                                    }
                                    .onChange(of: keyboardHeight) { _ in
                                        guard isLateFocus, let h = focusedHour, keyboardHeight > 0 else { return }

                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.04) {
                                            withAnimation(.easeInOut(duration: 0.25)) {
                                                proxy.scrollTo(h, anchor: .bottom)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        .frame(width: plannerW, height: totalH - 18)
                        .offset(x: scheduleNudgeRight, y: 0)

                        if isToDoCollapsed {
                            VStack(spacing: 12) {
                                toDoPill()
                                    .frame(width: sideControlsW, height: 98)

                                smallCircleIcon(system: "chevron.left") {
                                    showContextMenu = false
                                    showToDoContextMenu = false

                                    withAnimation(.easeInOut(duration: 0.4)) {
                                        navModel.pop()
                                    }
                                }

                                smallCircleIcon(system: "questionmark") {
                                    showContextMenu = false
                                    showToDoContextMenu = false

                                    withAnimation(.easeInOut(duration: 0.35)) {
                                        showHelp = true
                                    }
                                }

                                smallCircleIcon(system: "house.fill") {
                                    showContextMenu = false
                                    showToDoContextMenu = false

                                    withAnimation(.easeInOut(duration: 0.4)) {
                                        navModel.push("HomeView")
                                    }
                                }

                                Spacer(minLength: 0)
                            }
                            .frame(width: sideControlsW)
                            .padding(.top, 2)
                            .transition(.move(edge: .trailing).combined(with: .opacity))
                        } else {
                            VStack(spacing: 12) {
                                let bottomButtonsH: CGFloat = 54
                                let todoCardH = (totalH - 18) - bottomButtonsH - 12 - (pinch * 3)
                                let todoTextW = max(80, todoOpenW - 94)

                                glassCard {
                                    VStack(alignment: .leading, spacing: 10) {
                                        Text("To-Do")
                                            .font(.system(size: 14, weight: .heavy))
                                            .foregroundColor(.white.opacity(0.95))
                                            .lineLimit(1)

                                        ScrollView(showsIndicators: false) {
                                            LazyVStack(alignment: .leading, spacing: 12) {
                                                ForEach(toDoListModel.tasks) { item in
                                                    GeometryReader { rowGeo in
                                                        PlannerToDoRow(item: item) {
                                                            handleCompletion(for: item)
                                                        }
                                                        .simultaneousGesture(
                                                            LongPressGesture(minimumDuration: 0.35)
                                                                .onEnded { _ in
                                                                    focusedHour = nil
                                                                    showContextMenu = false

                                                                    contextMenuToDoItem = item
                                                                    contextMenuToDoFrame = rowGeo.frame(in: .global)

                                                                    withAnimation(.easeInOut(duration: 0.18)) {
                                                                        showToDoContextMenu = true
                                                                    }

                                                                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                                                                }
                                                        )
                                                    }
                                                    .frame(height: toDoRowHeight(for: item.title, availableTextWidth: todoTextW))
                                                }
                                            }
                                            .padding(.leading, 6)
                                            .padding(.top, 2)
                                            .padding(.bottom, 10)
                                        }
                                    }
                                }
                                .frame(width: todoOpenW, height: todoCardH)

                                HStack(spacing: 16) {
                                    smallCircleIcon(system: "chevron.left") {
                                        showContextMenu = false
                                        showToDoContextMenu = false

                                        withAnimation(.easeInOut(duration: 0.4)) {
                                            navModel.pop()
                                        }
                                    }

                                    smallCircleIcon(system: "questionmark") {
                                        showContextMenu = false
                                        showToDoContextMenu = false

                                        withAnimation(.easeInOut(duration: 0.35)) {
                                            showHelp = true
                                        }
                                    }

                                    smallCircleIcon(system: "house.fill") {
                                        showContextMenu = false
                                        showToDoContextMenu = false

                                        withAnimation(.easeInOut(duration: 0.4)) {
                                            navModel.push("HomeView")
                                        }
                                    }
                                }
                                .frame(width: todoOpenW, height: bottomButtonsH)
                                .padding(.bottom, 4)
                            }
                            .frame(width: todoOpenW)
                            .offset(x: pinch * 0.5, y: 0)
                            .transition(.move(edge: .trailing).combined(with: .opacity))
                        }
                    }
                    .padding(.horizontal, 16)
                    .animation(.easeInOut(duration: 0.4), value: isToDoCollapsed)

                    Spacer(minLength: 10)
                }
            }

            if showContextMenu, let hour = contextMenuHour, contextMenuFrame != .zero {
                Color.black.opacity(0.001)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.18)) {
                            showContextMenu = false
                        }
                    }

                HStack(spacing: 24) {
                    Button(action: {
                        UIPasteboard.general.string = hourSlots[hour, default: ""]
                        showContextMenu = false
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    }) {
                        contextMenuButton(system: "doc.on.doc", title: "Copy", color: .black)
                    }

                    Button(action: {
                        if let clipboard = UIPasteboard.general.string {
                            hourSlots[hour] = clipboard
                            savePlanner()
                        }

                        showContextMenu = false
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    }) {
                        contextMenuButton(system: "doc.on.clipboard", title: "Paste", color: .green)
                    }

                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            hourSlots[hour] = ""
                            savePlanner()
                            showContextMenu = false
                        }

                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    }) {
                        contextMenuButton(system: "trash", title: "Delete", color: .red)
                    }
                }
                .padding(12)
                .background(
                    Capsule()
                        .fill(Color.white.opacity(0.96))
                        .shadow(radius: 10)
                )
                .position(
                    x: contextMenuFrame.midX,
                    y: max(contextMenuFrame.minY - 85, 90)
                )
                .transition(.scale)
                .zIndex(4000)
            }

            if showToDoContextMenu, let item = contextMenuToDoItem, contextMenuToDoFrame != .zero {
                Color.black.opacity(0.001)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.18)) {
                            showToDoContextMenu = false
                        }
                    }

                HStack(spacing: 0) {
                    Button(action: {
                        UIPasteboard.general.string = item.title
                        showToDoContextMenu = false
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    }) {
                        contextMenuButton(system: "doc.on.doc", title: "Copy", color: .black)
                    }
                }
                .padding(8)
                .background(
                    Capsule()
                        .fill(Color.white.opacity(0.96))
                        .shadow(radius: 10)
                )
                .position(
                    x: contextMenuToDoFrame.midX,
                    y: max(contextMenuToDoFrame.minY - 72, 90)
                )
                .transition(.scale)
                .zIndex(4000)
            }

            if showClearConfirm {
                ZStack {
                    Color.black.opacity(0.60)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                showClearConfirm = false
                            }
                        }

                    VStack(spacing: 14) {
                        Text("Clear Schedule")
                            .font(.system(size: 18, weight: .heavy))
                            .foregroundColor(.white)

                        Text("Are you sure you want to clear your schedule?")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.white.opacity(0.95))
                            .multilineTextAlignment(.center)

                        HStack(spacing: 14) {
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    showClearConfirm = false
                                }
                            }) {
                                Text("NO")
                                    .font(.system(size: 14, weight: .heavy))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 10)
                                    .background(Color.white.opacity(0.14))
                                    .clipShape(Capsule())
                                    .overlay(Capsule().stroke(Color.white.opacity(0.70), lineWidth: 1))
                            }

                            Button(action: {
                                clearPlanner()

                                withAnimation(.easeInOut(duration: 0.2)) {
                                    showClearConfirm = false
                                }
                            }) {
                                Text("YES")
                                    .font(.system(size: 14, weight: .heavy))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 10)
                                    .background(Color.white.opacity(0.22))
                                    .clipShape(Capsule())
                                    .overlay(Capsule().stroke(Color.white.opacity(0.85), lineWidth: 1))
                            }
                        }
                        .padding(.top, 4)
                    }
                    .padding(20)
                    .frame(maxWidth: 320)
                    .background(
                        ZStack {
                            RoundedRectangle(cornerRadius: 22)
                                .fill(Color.yellow.opacity(0.25))
                                .blur(radius: 24)

                            RoundedRectangle(cornerRadius: 18)
                                .fill(Color.white.opacity(0.10))

                            RoundedRectangle(cornerRadius: 18)
                                .stroke(Color.white.opacity(0.75), lineWidth: 1.5)
                        }
                    )
                    .padding(.horizontal, 34)
                    .transition(.opacity.combined(with: .scale(scale: 0.98)))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .zIndex(999)
            }

            if showHelp {
                ZStack {
                    Color.black.opacity(0.55)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.25)) {
                                showHelp = false
                            }
                        }

                    VStack(spacing: 14) {
                        Text("How to Plan Fast")
                            .font(.system(size: 18, weight: .heavy))
                            .foregroundColor(.white)

                        Text("Press and hold a To-Do item to copy it.\n\nPress and hold a schedule row to Copy, Paste, or Delete.")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.white.opacity(0.95))
                            .multilineTextAlignment(.center)

                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.25)) {
                                showHelp = false
                            }
                        }) {
                            Text("Got it")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 18)
                                .background(Color.white.opacity(0.20))
                                .clipShape(Capsule())
                                .overlay(Capsule().stroke(Color.white.opacity(0.8), lineWidth: 1))
                        }
                    }
                    .padding(20)
                    .background(
                        ZStack {
                            RoundedRectangle(cornerRadius: 22)
                                .fill(Color.yellow.opacity(0.25))
                                .blur(radius: 22)

                            RoundedRectangle(cornerRadius: 18)
                                .fill(Color.white.opacity(0.10))

                            RoundedRectangle(cornerRadius: 18)
                                .stroke(Color.white.opacity(0.75), lineWidth: 1.5)
                        }
                    )
                    .padding(.horizontal, 34)
                    .transition(.opacity.combined(with: .scale(scale: 0.98)))
                }
            }
        }
        .onAppear {
            loadPlanner()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillChangeFrameNotification)) { note in
            keyboardHeight = keyboardHeightFrom(note)
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
            keyboardHeight = 0
        }
    }

    private func plannerRow(hour: String, timeColW: CGFloat, fieldW: CGFloat) -> some View {
        GeometryReader { geo in
            HStack(spacing: 10) {
                Text(hour)
                    .foregroundColor(.white.opacity(0.92))
                    .font(.system(size: 13, weight: .heavy))
                    .frame(width: timeColW, alignment: .leading)

                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.08))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white.opacity(0.55), lineWidth: 1)
                        )
                        .frame(width: fieldW, height: 40)

                    TextField(
                        "",
                        text: Binding(
                            get: { hourSlots[hour, default: ""] },
                            set: { hourSlots[hour] = $0 }
                        )
                    )
                    .focused($focusedHour, equals: hour)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .frame(width: fieldW, height: 40, alignment: .leading)
                    .onTapGesture {
                        showContextMenu = false
                        showToDoContextMenu = false
                        focusedHour = hour
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    showContextMenu = false
                    showToDoContextMenu = false
                    focusedHour = hour
                }
            }
            .contentShape(Rectangle())
            .highPriorityGesture(
                LongPressGesture(minimumDuration: 0.35)
                    .onEnded { _ in
                        focusedHour = nil
                        showToDoContextMenu = false

                        contextMenuHour = hour
                        contextMenuFrame = geo.frame(in: .global)

                        withAnimation(.easeInOut(duration: 0.18)) {
                            showContextMenu = true
                        }

                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    }
            )
        }
        .frame(height: 40)
    }

    private func toDoPill() -> some View {
        VStack(spacing: 8) {
            Image(systemName: "checklist")
                .font(.system(size: 16, weight: .heavy))
                .foregroundColor(.white)

            Text("TO\nDO")
                .font(.system(size: 10, weight: .heavy))
                .foregroundColor(.white.opacity(0.95))
                .multilineTextAlignment(.center)
                .lineSpacing(1)
        }
        .padding(.vertical, 14)
        .frame(maxWidth: .infinity)
        .background(
            Capsule()
                .fill(Color.white.opacity(0.12))
                .overlay(
                    Capsule()
                        .stroke(Color.white.opacity(0.35), lineWidth: 1)
                )
        )
    }

    private func glassCard<Content: View>(@ViewBuilder _ content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            content()
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.white.opacity(0.12))
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(Color.white.opacity(0.35), lineWidth: 1)
                )
        )
    }

    private func smallCircleIcon(system: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: system)
                .font(.system(size: 15, weight: .heavy))
                .foregroundColor(.white)
                .frame(width: 44, height: 44)
                .background(Color.white.opacity(0.18))
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white.opacity(0.65), lineWidth: 1))
        }
    }

    private func contextMenuButton(system: String, title: String, color: Color) -> some View {
        VStack(spacing: 2) {
            Image(systemName: system)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(color)

            Text(title)
                .font(.caption.bold())
                .foregroundColor(color)
        }
        .padding(14)
        .background(Color.white)
        .clipShape(Circle())
        .shadow(radius: 2)
    }

    private func toDoRowHeight(for title: String, availableTextWidth: CGFloat) -> CGFloat {
        let font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        let text = title as NSString

        let boundingRect = text.boundingRect(
            with: CGSize(width: availableTextWidth, height: .greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [.font: font],
            context: nil
        )

        let textHeight = ceil(boundingRect.height)
        let verticalPadding: CGFloat = 12
        let checkboxHeight: CGFloat = 28

        return max(42, max(textHeight + verticalPadding, checkboxHeight + verticalPadding))
    }

    private func keyboardHeightFrom(_ note: Notification) -> CGFloat {
        guard
            let info = note.userInfo,
            let frame = info[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        else {
            return 0
        }

        let screenH = UIScreen.main.bounds.height
        return max(0, screenH - frame.origin.y)
    }

    func handleCompletion(for item: ToDoItem) {
        if let idx = toDoListModel.tasks.firstIndex(where: { $0.id == item.id }) {
            toDoListModel.tasks[idx].isCompleted = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            toDoListModel.tasks.removeAll { $0.id == item.id }
        }
    }

    func savePlanner() {
        if let data = try? JSONEncoder().encode(hourSlots) {
            UserDefaults.standard.set(data, forKey: plannerKey)
        }
    }

    func loadPlanner() {
        if let data = UserDefaults.standard.data(forKey: plannerKey),
           let loaded = try? JSONDecoder().decode([String: String].self, from: data) {
            hourSlots = loaded
        }
    }

    func clearPlanner() {
        hourSlots = [:]
    }
}

private struct PlannerToDoRow: View {
    let item: ToDoItem
    var onComplete: () -> Void

    @State private var isAnimatingCompletion: Bool = false

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Button(action: {
                isAnimatingCompletion = true
                onComplete()
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.white, lineWidth: 2)
                        .background(
                            isAnimatingCompletion || item.isCompleted
                            ? AnyView(
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(Color(red: 0.85, green: 1.0, blue: 0.85))
                            )
                            : AnyView(Color.clear)
                        )
                        .frame(width: 28, height: 28)

                    if isAnimatingCompletion || item.isCompleted {
                        Image(systemName: "checkmark")
                            .foregroundColor(Color(red: 0.0, green: 0.4, blue: 0.2))
                            .font(.system(size: 16, weight: .bold))
                    }
                }
            }
            .buttonStyle(.plain)

            Text(item.title)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.leading)
        }
        .contentShape(Rectangle())
        .padding(.vertical, 2)
        .transition(.opacity)
    }
}
