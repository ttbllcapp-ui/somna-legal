import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \SleepSession.startDate, order: .reverse) private var sessions: [SleepSession]
    @Query private var profiles: [UserProfile]
    @AppStorage("activeSleepStart") private var activeSleepStartRaw: Double = 0
    @State private var showAlarmSheet = false

    private var latestSession: SleepSession? { sessions.first }
    private var isTracking: Bool { activeSleepStartRaw > 0 }
    private var goalMinutes: Int {
        SleepGoalCalculator.targetMinutes(forAge: profiles.first?.ageYears ?? 30)
    }
    private var streak: Int { SleepSession.currentStreak(sessions: sessions) }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    header
                    weekRow

                    Group {
                        if let session = latestSession {
                            tonightCard(for: session)
                            statRow(for: session)
                        } else {
                            emptyState
                        }
                    }
                    .transition(.opacity.combined(with: .scale(scale: 0.97)))
                    .id(latestSession?.id)

                    trackingButton
                }
                .padding(20)
                .animation(.easeInOut(duration: 0.3), value: latestSession?.id)
            }
            .background(Somna.backdrop)
            .navigationBarHidden(true)
            .sheet(isPresented: $showAlarmSheet) {
                AlarmSetupView()
            }
        }
    }

    private var header: some View {
        HStack {
            Text("SOMNA")
                .font(Somna.Font.heavy(22))
                .foregroundStyle(Somna.textPrimary)

            Spacer()

            HStack(spacing: 8) {
                badge(icon: "flame.fill", value: "\(streak)", tint: Somna.coral)
                Button {
                    showAlarmSheet = true
                } label: {
                    ZStack {
                        Circle().fill(Somna.card)
                        Image(systemName: "alarm.fill")
                            .font(.system(size: 15))
                            .foregroundStyle(Somna.textPrimary)
                    }
                    .frame(width: 38, height: 38)
                    .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 3)
                }
                .buttonStyle(PressableButtonStyle())
            }
        }
    }

    private func badge(icon: String, value: String, tint: Color) -> some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 13))
                .foregroundStyle(tint)
            Text(value)
                .font(Somna.Font.bold(14))
                .foregroundStyle(Somna.textPrimary)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Somna.card)
        .clipShape(Capsule())
        .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 3)
    }

    private var weekRow: some View {
        let calendar = Calendar.current
        let loggedDays = Set(sessions.map { calendar.startOfDay(for: $0.startDate) })
        let today = calendar.startOfDay(for: .now)
        let weekdaySymbols = ["S", "M", "T", "W", "T", "F", "S"]
        let startOfWeek = calendar.date(
            byAdding: .day,
            value: -(calendar.component(.weekday, from: today) - 1),
            to: today
        ) ?? today

        return HStack(spacing: 10) {
            ForEach(0..<7, id: \.self) { offset in
                let day = calendar.date(byAdding: .day, value: offset, to: startOfWeek) ?? today
                let logged = loggedDays.contains(day)
                let isToday = calendar.isDate(day, inSameDayAs: today)
                let isFuture = day > today

                VStack(spacing: 6) {
                    ZStack {
                        Circle()
                            .fill(logged ? Somna.success : Somna.card)
                        if isToday {
                            Circle().strokeBorder(Somna.accent, lineWidth: 2)
                        }
                        if logged {
                            Image(systemName: "checkmark")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundStyle(.white)
                        } else if isFuture {
                            Circle().fill(Somna.hair)
                        }
                    }
                    .frame(width: 30, height: 30)

                    Text(weekdaySymbols[offset])
                        .font(Somna.Font.bold(10))
                        .foregroundStyle(Somna.textFaint)
                }
                .frame(maxWidth: .infinity)
            }
        }
    }

    private var emptyState: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("No nights logged yet")
                .font(Somna.Font.bold(16))
                .foregroundStyle(Somna.textPrimary)
            Text("Tap the button below before you sleep, then tap it again when you wake up. Your goal: \(SleepGoalCalculator.formatted(goalMinutes)).")
                .font(.system(size: 13))
                .foregroundStyle(Somna.textDim)
        }
        .glassCard(padding: 16)
    }

    private func tonightCard(for session: SleepSession) -> some View {
        let score = SleepScoreCalculator.score(for: session, goalMinutes: goalMinutes)
        return HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text("SLEEP SCORE")
                    .font(Somna.Font.bold(11))
                    .foregroundStyle(Somna.textFaint)
                Text("\(score)")
                    .font(Somna.Font.heavy(56))
                    .foregroundStyle(Somna.textPrimary)
                Text(SleepScoreCalculator.label(for: score))
                    .font(Somna.Font.bold(14))
                    .foregroundStyle(Somna.accent)
                Text("Goal: \(SleepGoalCalculator.formatted(goalMinutes))")
                    .font(.system(size: 12))
                    .foregroundStyle(Somna.textFaint)
            }
            Spacer()
            ZStack {
                Circle().stroke(Somna.hair, lineWidth: 10)
                Circle()
                    .trim(from: 0, to: CGFloat(score) / 100)
                    .stroke(Somna.accent, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .animation(.easeOut(duration: 0.6), value: score)
                Image(systemName: "moon.stars.fill")
                    .font(.system(size: 22))
                    .foregroundStyle(Somna.accent)
            }
            .frame(width: 84, height: 84)
        }
        .glassCard(padding: 20)
    }

    private func statRow(for session: SleepSession) -> some View {
        let hours = session.asleepMinutes / 60
        let minutes = session.asleepMinutes % 60
        let efficiencyPercent = Int((session.efficiency * 100).rounded())
        return HStack(spacing: 10) {
            StatCard(label: "Time asleep", value: "\(hours)h \(minutes)m", tint: Somna.mint)
            StatCard(label: "Efficiency", value: "\(efficiencyPercent)%", tint: Somna.lavender)
        }
    }

    private var trackingButton: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.3)) {
                toggleTracking()
            }
        } label: {
            Text(isTracking ? "I'M AWAKE" : "GOING TO SLEEP")
                .font(Somna.Font.bold(15))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .foregroundStyle(.white)
                .background(isTracking ? Somna.success : Somna.accent)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                .shadow(color: (isTracking ? Somna.success : Somna.accent).opacity(0.35), radius: 16, x: 0, y: 8)
        }
        .buttonStyle(PressableButtonStyle())
    }

    private func toggleTracking() {
        if isTracking {
            let start = Date(timeIntervalSince1970: activeSleepStartRaw)
            let session = SleepSession.estimatingStages(startDate: start, endDate: .now)
            modelContext.insert(session)
            activeSleepStartRaw = 0
        } else {
            activeSleepStartRaw = Date.now.timeIntervalSince1970
        }
    }
}

private struct StatCard: View {
    let label: String
    let value: String
    let tint: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Circle().fill(tint).frame(width: 8, height: 8)
            Text(value)
                .font(Somna.Font.heavy(20))
                .foregroundStyle(Somna.textPrimary)
            Text(label.uppercased())
                .font(Somna.Font.bold(10))
                .foregroundStyle(Somna.textFaint)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassCard(padding: 14)
    }
}

#Preview {
    HomeView()
        .modelContainer(for: [SleepSession.self, Alarm.self, UserProfile.self], inMemory: true)
        .preferredColorScheme(.light)
}
