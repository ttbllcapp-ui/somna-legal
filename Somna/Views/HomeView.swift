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

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    header
                    integrationRow

                    Group {
                        if let session = latestSession {
                            scoreRing(for: session)
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
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text("Somna")
                    .font(Somna.Font.serif(15))
                    .foregroundStyle(Somna.textDim)
                Spacer()
                Button {
                    showAlarmSheet = true
                } label: {
                    Image(systemName: "alarm")
                        .foregroundStyle(Somna.textDim)
                        .font(.system(size: 17))
                        .minTapTarget()
                }
                .buttonStyle(PressableButtonStyle())
            }
            Text("Good evening")
                .font(.system(size: 12))
                .foregroundStyle(Somna.textFaint)
        }
    }

    private var integrationRow: some View {
        HStack(spacing: 8) {
            IntegrationPill(label: "Health synced")
            IntegrationPill(label: "Watch connected")
            Spacer()
        }
    }

    private var emptyState: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("No nights logged yet")
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(Somna.textPrimary)
            Text("Tap the button below before you sleep, then tap it again when you wake up. Your goal: \(SleepGoalCalculator.formatted(goalMinutes)).")
                .font(.system(size: 12))
                .foregroundStyle(Somna.textFaint)
        }
        .glassCard(padding: 14)
    }

    private func scoreRing(for session: SleepSession) -> some View {
        let score = SleepScoreCalculator.score(for: session, goalMinutes: goalMinutes)
        return HStack(spacing: 18) {
            ZStack {
                Circle()
                    .stroke(Somna.hair, lineWidth: 8)
                Circle()
                    .trim(from: 0, to: CGFloat(score) / 100)
                    .stroke(Somna.scoreGradient, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .animation(.easeOut(duration: 0.6), value: score)
                Text("\(score)")
                    .font(Somna.Font.serif(22))
                    .foregroundStyle(Somna.textPrimary)
            }
            .frame(width: 92, height: 92)
            .amberGlow(radius: 16, opacity: 0.15)

            VStack(alignment: .leading, spacing: 2) {
                Text(SleepScoreCalculator.label(for: score))
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(Somna.textPrimary)
                Text("Goal: \(SleepGoalCalculator.formatted(goalMinutes))")
                    .font(.system(size: 12))
                    .foregroundStyle(Somna.textFaint)
            }
        }
    }

    private func statRow(for session: SleepSession) -> some View {
        let hours = session.asleepMinutes / 60
        let minutes = session.asleepMinutes % 60
        let efficiencyPercent = Int((session.efficiency * 100).rounded())
        return HStack(spacing: 10) {
            StatCard(label: "Time asleep", value: "\(hours)h \(minutes)m")
            StatCard(label: "Efficiency", value: "\(efficiencyPercent)%")
        }
    }

    private var trackingButton: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.3)) {
                toggleTracking()
            }
        } label: {
            Text(isTracking ? "I'm awake" : "Going to sleep")
                .font(.system(size: 14, weight: .medium))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .foregroundStyle(isTracking ? Somna.ink : Somna.textPrimary)
                .background(isTracking ? Somna.amber : Somna.card)
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .strokeBorder(isTracking ? .clear : Somna.hair, lineWidth: 0.5)
                )
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                .amberGlow(opacity: isTracking ? 0.2 : 0)
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

private struct IntegrationPill: View {
    let label: String
    var body: some View {
        HStack(spacing: 4) {
            Circle().fill(Somna.free).frame(width: 5, height: 5)
            Text(label)
                .font(.system(size: 10))
                .foregroundStyle(Somna.textFaint)
        }
        .padding(.horizontal, 9)
        .padding(.vertical, 4)
        .overlay(Capsule().strokeBorder(Somna.hair, lineWidth: 0.5))
    }
}

private struct StatCard: View {
    let label: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label.uppercased())
                .font(.system(size: 9.5, weight: .medium))
                .foregroundStyle(Somna.textFaint)
            Text(value)
                .font(Somna.Font.mono(16))
                .foregroundStyle(Somna.textPrimary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassCard(padding: 12)
    }
}

#Preview {
    HomeView()
        .modelContainer(for: [SleepSession.self, Alarm.self, UserProfile.self], inMemory: true)
        .preferredColorScheme(.dark)
}
