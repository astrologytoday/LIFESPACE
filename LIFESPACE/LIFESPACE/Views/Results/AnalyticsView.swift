import SwiftUI
import Charts

enum ChartType: String, CaseIterable {
    case lifespace = "Brain Optimization"
    case weight = "Weight"
}

enum ChartInterval: String, CaseIterable {
    case week = "By Week"
    case month = "By Month"
}

struct WeeklyWeightAverage: Identifiable {
    let id = UUID()
    let label: String
    let averageWeight: Double
}

struct ModuleWeeklyAverage: Identifiable {
    let id = UUID()
    let label: String
    let score: Double
}

struct WeeklyAverage: Identifiable {
    let id = UUID()
    let label: String
    let averageScore: Double
}

struct AnalyticsView: View {

    @EnvironmentObject var navModel: NavigationModel
    @EnvironmentObject var lifespaceLogModel: LifespaceLogModel
    @EnvironmentObject var weightLogModel: WeightLogModel

    @State private var selectedChart: ChartType = .lifespace
    @State private var toggledModules: Set<LifespaceModule> = []
    @State private var chartInterval: ChartInterval = .week
    @State private var animatePulse = false

    let moduleColors: [LifespaceModule: Color] = [
        .light: .gray,
        .innerWork: .orange,
        .fitness: .yellow,
        .eating: .red,
        .sensory: .purple,
        .purpose: .blue,
        .activity: .green,
        .community: .pink,
        .expression: .black
    ]

    var todaysScore: Int {
        lifespaceLogModel.todayLifespaceScore()
    }

    private var averagesTitle: String {
        switch selectedChart {
        case .lifespace: return "Brain Optimization Averages"
        case .weight: return "Weight Averages"
        }
    }

    var body: some View {
        ZStack {
            backgroundView
            content
        }
        .onAppear {
            applyStartTabIfNeeded()
        }
    }

    private func applyStartTabIfNeeded() {
        let start = UserDefaults.standard.string(forKey: "analyticsStartTab")

        if start == "Weight" {
            selectedChart = .weight
            toggledModules.removeAll()
        } else if start == "Brain" {
            selectedChart = .lifespace
        }

        if start != nil {
            UserDefaults.standard.removeObject(forKey: "analyticsStartTab")
        }
    }

    private var backgroundView: some View {
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

    private var content: some View {
        VStack(spacing: 18) {

            BackButtonView()
                .padding(.leading)
                .padding(.top, 10)
                .frame(maxWidth: .infinity, alignment: .leading)

            if selectedChart == .lifespace {
                Text("Today's Brain Optimization Score")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.top, 8)

                Text("\(todaysScore)%")
                    .font(.system(size: 54, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .scaleEffect(animatePulse ? 1.09 : 1.0)
                    .shadow(color: .white.opacity(0.2), radius: 12, x: 0, y: 2)
                    .padding(.bottom, 8)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 0.95).repeatForever(autoreverses: true)) {
                            animatePulse = true
                        }
                    }
            }

            Text(averagesTitle)
                .font(.title2)
                .bold()
                .foregroundColor(.white)
                .padding(.top, 2)
                .padding(.bottom, 2)

            chartIntervalPicker
            chartSection

            if selectedChart == .lifespace {
                moduleButtons
            }

            chartPicker

            Spacer(minLength: 10)
        }
        .padding(.top, 10)
    }

    private var chartIntervalPicker: some View {
        Picker("Interval", selection: $chartInterval) {
            ForEach(ChartInterval.allCases, id: \.self) { interval in
                Text(interval.rawValue).tag(interval)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
        .padding(.bottom, 2)
    }

    @ViewBuilder
    private var chartSection: some View {
        switch selectedChart {
        case .lifespace:
            lifespaceChart
        case .weight:
            weightChart
        }
    }

    func last6(_ all: [WeeklyAverage]) -> [WeeklyAverage] {
        Array(all.suffix(6))
    }

    func last6Weight(_ all: [WeeklyWeightAverage]) -> [WeeklyWeightAverage] {
        Array(all.suffix(6))
    }

    func last12(_ all: [WeeklyAverage]) -> [WeeklyAverage] {
        Array(all.suffix(12))
    }

    func last12Weight(_ all: [WeeklyWeightAverage]) -> [WeeklyWeightAverage] {
        Array(all.suffix(12))
    }

    private var lifespaceChart: some View {
        let weekly = last6(cleanedWeeklyLifespace())
        let monthly = last12(cleanedMonthlyLifespace())
        let data = chartInterval == .week ? weekly : monthly

        let selectedModules = LifespaceModule.allCases.filter { toggledModules.contains($0) }

        let domainNames = LifespaceModule.allCases.map { displayName(for: $0) }
        let rangeColors = LifespaceModule.allCases.map { moduleColors[$0] ?? .white }

        return Chart {
            if toggledModules.isEmpty {
                ForEach(data) { item in
                    LineMark(
                        x: .value(chartInterval == .week ? "Week" : "Month", item.label),
                        y: .value("Score", item.averageScore)
                    )
                    .symbol(Circle())
                    .foregroundStyle(.white)
                    .lineStyle(.init(lineWidth: 3))
                }
            } else {
                ForEach(selectedModules, id: \.self) { module in
                    let aligned = chartInterval == .week
                        ? alignedModuleWeeklyData(for: module)
                        : alignedModuleMonthlyData(for: module)

                    ForEach(aligned) { item in
                        LineMark(
                            x: .value(chartInterval == .week ? "Week" : "Month", item.label),
                            y: .value("Score", item.score)
                        )
                        .symbol(Circle())
                        .foregroundStyle(by: .value("Module", displayName(for: module)))
                        .lineStyle(.init(lineWidth: 3))
                    }
                }
            }
        }
        .chartForegroundStyleScale(domain: domainNames, range: rangeColors)
        .chartLegend(.hidden)
        .chartYScale(domain: 0...100)
        .chartScrollableAxes(.horizontal)
        .chartXVisibleDomain(length: chartInterval == .week ? 6 : 12)
        .id("lifespace-\(chartInterval.rawValue)-\(toggledModules.map { $0.rawValue }.sorted().joined(separator: "-"))")
        .transaction { transaction in
            transaction.animation = nil
        }
        .frame(height: 260)
        .padding(.horizontal)
    }

    private var weightChart: some View {
        let weekly = last6Weight(cleanedWeeklyWeight())
        let monthly = last12Weight(cleanedMonthlyWeight())
        let data = chartInterval == .week ? weekly : monthly

        return Chart(data) { item in
            LineMark(
                x: .value(chartInterval == .week ? "Week" : "Month", item.label),
                y: .value("Weight", item.averageWeight)
            )
            .symbol(Circle())
            .foregroundStyle(.white)
            .lineStyle(.init(lineWidth: 3))
        }
        .chartScrollableAxes(.horizontal)
        .chartXVisibleDomain(length: chartInterval == .week ? 6 : 12)
        .frame(height: 260)
        .padding(.horizontal)
    }

    private func toggleModule(_ module: LifespaceModule) {
        withAnimation(.easeInOut(duration: 0.4)) {
            if toggledModules.contains(module) {
                toggledModules.remove(module)
            } else {
                toggledModules.insert(module)
            }
        }
    }

    private var moduleButtons: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 3), spacing: 14) {
            ForEach(LifespaceModule.allCases, id: \.self) { module in
                Button {
                    toggleModule(module)
                } label: {
                    Text(displayName(for: module))
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 16)
                        .background(
                            toggledModules.contains(module)
                                ? (moduleColors[module] ?? Color.white.opacity(0.25))
                                : Color.white.opacity(0.2)
                        )
                        .cornerRadius(20)
                }
            }
        }
        .padding(.horizontal)
        .padding(.top, -8)
    }

    private var chartPicker: some View {
        Picker("Chart", selection: $selectedChart) {
            ForEach(ChartType.allCases, id: \.self) { chart in
                Text(chart.rawValue).tag(chart)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
        .padding(.bottom, 20)
    }

    func displayName(for module: LifespaceModule) -> String {
        module == .innerWork ? "Inner Work" : module.rawValue.capitalized
    }

    func alignedModuleWeeklyData(for module: LifespaceModule) -> [ModuleWeeklyAverage] {
        let base = last6(cleanedWeeklyLifespace())
        let raw = moduleWeeklyAverages(for: module)

        return base.map { week in
            let match = raw.first { $0.label == week.label }
            return ModuleWeeklyAverage(label: week.label, score: match?.score ?? 0)
        }
    }

    func alignedModuleMonthlyData(for module: LifespaceModule) -> [ModuleWeeklyAverage] {
        let base = last12(cleanedMonthlyLifespace())
        let raw = moduleMonthlyAverages(for: module)

        return base.map { month in
            let match = raw.first { $0.label == month.label }
            return ModuleWeeklyAverage(label: month.label, score: match?.score ?? 0)
        }
    }

    func moduleMonthlyAverages(for module: LifespaceModule) -> [ModuleWeeklyAverage] {
        let calendar = Calendar.current

        let filtered = lifespaceLogModel.entries.filter {
            $0.type == .lifespace && $0.module == module
        }

        let grouped = Dictionary(grouping: filtered) { entry -> Date in
            let comps = calendar.dateComponents([.year, .month], from: entry.date)
            return calendar.date(from: comps)!
        }

        let sorted = grouped.keys.sorted().suffix(12)

        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"

        return sorted.map { monthDate in
            let arr = grouped[monthDate] ?? []
            let totalQs = arr.reduce(0) { $0 + $1.questionCount }
            let totalYes = arr.reduce(0) { $0 + $1.yesCount }
            let avg = totalQs > 0 ? (Double(totalYes) / Double(totalQs)) * 100 : 0

            return ModuleWeeklyAverage(
                label: formatter.string(from: monthDate),
                score: avg
            )
        }
    }

    func moduleWeeklyAverages(for module: LifespaceModule) -> [ModuleWeeklyAverage] {
        let calendar = Calendar.current

        let filtered = lifespaceLogModel.entries.filter {
            $0.type == .lifespace && $0.module == module
        }

        let grouped = Dictionary(grouping: filtered) { entry -> Date in
            let comps = calendar.dateComponents([.year, .month], from: entry.date)
            let monthStart = calendar.date(from: comps)!
            let offset = monthWeekIndex(for: entry.date) * 7
            return calendar.date(byAdding: .day, value: offset, to: monthStart)!
        }

        let sorted = grouped.keys.sorted()

        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"

        return sorted.map { date in
            let entries = grouped[date] ?? []
            let month = formatter.string(from: date)
            let week = monthWeekIndex(for: date) + 1
            let label = "\(month) W\(week)"
            let totalQs = entries.reduce(0) { $0 + $1.questionCount }
            let totalYes = entries.reduce(0) { $0 + $1.yesCount }
            let avg = totalQs > 0 ? (Double(totalYes) / Double(totalQs)) * 100 : 0

            return ModuleWeeklyAverage(label: label, score: avg)
        }
    }

    func monthWeekIndex(for date: Date) -> Int {
        let day = Calendar.current.component(.day, from: date)

        switch day {
        case 1...7:
            return 0
        case 8...14:
            return 1
        case 15...21:
            return 2
        case 22...28:
            return 3
        default:
            return 4
        }
    }

    func cleanedWeeklyLifespace() -> [WeeklyAverage] {
        let calendar = Calendar.current
        let entries = lifespaceLogModel.entries.filter { $0.type == .lifespace }

        let grouped = Dictionary(grouping: entries) { entry -> Date in
            let comps = calendar.dateComponents([.year, .month], from: entry.date)
            let monthStart = calendar.date(from: comps)!

            return calendar.date(
                byAdding: .day,
                value: monthWeekIndex(for: entry.date) * 7,
                to: monthStart
            )!
        }

        let sorted = grouped.keys.sorted()

        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"

        return sorted.map { date in
            let month = formatter.string(from: date)
            let week = monthWeekIndex(for: date) + 1
            let arr = grouped[date]!
            let totalQs = arr.reduce(0) { $0 + $1.questionCount }
            let totalYes = arr.reduce(0) { $0 + $1.yesCount }
            let avg = totalQs > 0 ? (Double(totalYes) / Double(totalQs)) * 100 : 0

            return WeeklyAverage(label: "\(month) W\(week)", averageScore: avg)
        }
    }

    func cleanedMonthlyLifespace() -> [WeeklyAverage] {
        let calendar = Calendar.current
        let entries = lifespaceLogModel.entries.filter { $0.type == .lifespace }

        let grouped = Dictionary(grouping: entries) { entry -> Date in
            let comps = calendar.dateComponents([.year, .month], from: entry.date)
            return calendar.date(from: comps)!
        }

        let sorted = grouped.keys.sorted().suffix(12)

        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"

        return sorted.map { date in
            let arr = grouped[date]!
            let label = formatter.string(from: date)
            let totalQs = arr.reduce(0) { $0 + $1.questionCount }
            let totalYes = arr.reduce(0) { $0 + $1.yesCount }
            let avg = totalQs > 0 ? (Double(totalYes) / Double(totalQs)) * 100 : 0

            return WeeklyAverage(label: label, averageScore: avg)
        }
    }

    func cleanedWeeklyWeight() -> [WeeklyWeightAverage] {
        let calendar = Calendar.current

        let grouped = Dictionary(grouping: weightLogModel.entries) { entry -> Date in
            let comps = calendar.dateComponents([.year, .month], from: entry.date)
            let start = calendar.date(from: comps)!

            return calendar.date(
                byAdding: .day,
                value: monthWeekIndex(for: entry.date) * 7,
                to: start
            )!
        }

        let sorted = grouped.keys.sorted()

        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"

        return sorted.map { date in
            let arr = grouped[date]!
            let month = formatter.string(from: date)
            let week = monthWeekIndex(for: date) + 1
            let avg = arr.map(\.weight).reduce(0, +) / Double(arr.count)

            return WeeklyWeightAverage(label: "\(month) W\(week)", averageWeight: avg)
        }
    }

    func cleanedMonthlyWeight() -> [WeeklyWeightAverage] {
        let calendar = Calendar.current

        let grouped = Dictionary(grouping: weightLogModel.entries) { entry -> Date in
            let comps = calendar.dateComponents([.year, .month], from: entry.date)
            return calendar.date(from: comps)!
        }

        let sorted = grouped.keys.sorted().suffix(12)

        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"

        return sorted.map { date in
            let arr = grouped[date]!
            let avg = arr.map(\.weight).reduce(0, +) / Double(arr.count)

            return WeeklyWeightAverage(
                label: formatter.string(from: date),
                averageWeight: avg
            )
        }
    }
}
