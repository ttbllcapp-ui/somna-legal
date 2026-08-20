import SwiftUI
import SwiftData
import Charts

private enum StatsPeriod: String, CaseIterable {
    case day = "Day"
    case week = "Week"
    case month = "Month"
}

struct StatsView: View {
    @Query(sort: \SleepSession.startDate, order: .reverse) private var sessions: [SleepSession]
    @State private var period: StatsPeriod = .day

    private var latestSession: SleepSession? { sessions.first }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Picker("Period", selection: $period.animation(.easeInOut)) {
                        ForEach(StatsPeriod.allCases, id: \.self) { Text($0.rawValue) }
                    }
                    .pickerStyle(.segmented)

                    Group {
                        switch period {
                        case .day: dayContent
                        case .week: aggregateChart(days: 7)
                        case .month: aggregateChart(days: 30)
                        }
                    }
                    .transition(.opacity)
                }
                .padding(20)
            }
            .background(Somna.backdrop)
            .navigationTitle("Stats")
            .toolbarColorScheme(.light, for: .navigationBar)
        }
    }

    // MARK: Day — latest night stage breakdown

    @ViewBuilder
    private var dayContent: some View {
        if let session = latestSession {
            stageBreakdown(for: session)
        } else {
            emptyState
        }
    }

    private var emptyState: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("No nights logged yet")
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(Somna.textPrimary)
            Text("Start your first record from the Tonight tab with \"Going to sleep\".")
                .font(.system(size: 12))
                .foregroundStyle(Somna.textFaint)
        }
        .glassCard(padding: 14)
    }

    private func stageBreakdown(for session: SleepSession) -> some View {
        let total = max(1, session.totalMinutes)
        let timeFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            return formatter
        }()

        return VStack(alignment: .leading, spacing: 18) {
            Text("Last night · \(timeFormatter.string(from: session.startDate)) – \(timeFormatter.string(from: session.endDate))")
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(Somna.textFaint)
                .textCase(.uppercase)

            HStack(spacing: 2) {
                ForEach(session.stageMinutes, id: \.stage) { entry in
                    Rectangle()
                        .fill(entry.stage.color)
                        .frame(width: CGFloat(entry.minutes) / CGFloat(total) * 300)
                }
            }
            .frame(height: 24)
            .clipShape(RoundedRectangle(cornerRadius: 7))
            .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)

            VStack(spacing: 10) {
                ForEach(session.stageMinutes, id: \.stage) { entry in
                    HStack {
                        HStack(spacing: 8) {
                            RoundedRectangle(cornerRadius: 3)
                                .fill(entry.stage.color)
                                .frame(width: 9, height: 9)
                            Text(entry.stage.label)
                                .foregroundStyle(Somna.textDim)
                        }
                        Spacer()
                        HStack(spacing: 6) {
                            Text("\(entry.minutes / 60)h \(entry.minutes % 60)m")
                                .foregroundStyle(Somna.textPrimary)
                            Text("\(Int(Double(entry.minutes) / Double(total) * 100))%")
                                .font(.system(size: 10))
                                .foregroundStyle(Somna.textFaint)
                        }
                        .font(Somna.Font.mono(13))
                    }
                }
            }

            Text("Stage breakdown is estimated from total measured duration — real motion/audio-based detection isn't built yet.")
                .font(.system(size: 11))
                .foregroundStyle(Somna.textFaint)
        }
        .glassCard(padding: 18)
    }

    // MARK: Week / Month — aggregate bar chart

    private struct DailyPoint: Identifiable {
        let id = UUID()
        let day: Date
        let asleepMinutes: Int
    }

    private func aggregateChart(days: Int) -> some View {
        let calendar = Calendar.current
        let cutoff = calendar.date(byAdding: .day, value: -days, to: .now) ?? .now
        let recent = sessions.filter { $0.startDate >= cutoff }

        var byDay: [Date: Int] = [:]
        for session in recent {
            let day = calendar.startOfDay(for: session.startDate)
            byDay[day, default: 0] += session.asleepMinutes
        }
        let points = byDay
            .map { DailyPoint(day: $0.key, asleepMinutes: $0.value) }
            .sorted { $0.day < $1.day }

        let average = points.isEmpty ? 0 : points.reduce(0) { $0 + $1.asleepMinutes } / points.count

        return VStack(alignment: .leading, spacing: 14) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Average sleep")
                        .font(.system(size: 11))
                        .foregroundStyle(Somna.textFaint)
                    Text(SleepGoalCalculator.formatted(average))
                        .font(Somna.Font.heavy(24))
                        .foregroundStyle(Somna.textPrimary)
                }
                Spacer()
                Text("\(points.count) nights logged")
                    .font(.system(size: 11))
                    .foregroundStyle(Somna.textFaint)
            }

            if points.isEmpty {
                emptyState
            } else {
                Chart(points) { point in
                    BarMark(
                        x: .value("Day", point.day, unit: .day),
                        y: .value("Minutes", point.asleepMinutes)
                    )
                    .foregroundStyle(
                        LinearGradient(colors: [Somna.amber, Somna.amberDeep], startPoint: .top, endPoint: .bottom)
                    )
                    .cornerRadius(4)
                }
                .frame(height: 180)
                .chartYAxis {
                    AxisMarks { _ in
                        AxisGridLine().foregroundStyle(Somna.hair)
                        AxisValueLabel().foregroundStyle(Somna.textFaint)
                    }
                }
                .chartXAxis {
                    AxisMarks { _ in
                        AxisValueLabel().foregroundStyle(Somna.textFaint)
                    }
                }
            }
        }
        .glassCard(padding: 18)
    }
}

#Preview {
    StatsView()
        .modelContainer(for: [SleepSession.self, Alarm.self], inMemory: true)
        .preferredColorScheme(.light)
}
