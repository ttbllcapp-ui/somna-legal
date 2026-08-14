import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \SleepSession.startDate, order: .reverse) private var sessions: [SleepSession]
    @AppStorage("activeSleepStart") private var activeSleepStartRaw: Double = 0
    @State private var showAlarmSheet = false

    private var latestSession: SleepSession? { sessions.first }
    private var isTracking: Bool { activeSleepStartRaw > 0 }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    header
                    integrationRow

                    if let session = latestSession {
                        scoreRing(for: session)
                        statRow(for: session)
                    } else {
                        emptyState
                    }

                    trackingButton
                }
                .padding(20)
            }
            .background(Somna.ink.ignoresSafeArea())
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
                }
                FreeTag()
            }
            Text("İyi geceler, Tayfun")
                .font(.system(size: 12))
                .foregroundStyle(Somna.textFaint)
        }
    }

    private var integrationRow: some View {
        HStack(spacing: 8) {
            IntegrationPill(label: "Health senkron")
            IntegrationPill(label: "Watch bağlı")
            Spacer()
        }
    }

    private var emptyState: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Henüz kayıtlı gece yok")
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(Somna.textPrimary)
            Text("Uyumadan önce aşağıdaki düğmeye dokun, uyandığında tekrar dokun.")
                .font(.system(size: 12))
                .foregroundStyle(Somna.textFaint)
        }
        .glassCard(padding: 14)
    }

    private func scoreRing(for session: SleepSession) -> some View {
        let score = SleepScoreCalculator.score(for: session)
        return HStack(spacing: 18) {
            ZStack {
                Circle()
                    .stroke(Somna.hair, lineWidth: 8)
                Circle()
                    .trim(from: 0, to: CGFloat(score) / 100)
                    .stroke(Somna.amber, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                Text("\(score)")
                    .font(Somna.Font.serif(22))
                    .foregroundStyle(Somna.textPrimary)
            }
            .frame(width: 92, height: 92)

            VStack(alignment: .leading, spacing: 2) {
                Text(SleepScoreCalculator.label(for: score))
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(Somna.textPrimary)
                Text("Son kaydedilen gece")
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
            StatCard(label: "Uyku süresi", value: "\(hours)s \(minutes)d")
            StatCard(label: "Verimlilik", value: "%\(efficiencyPercent)")
        }
    }

    private var trackingButton: some View {
        Button {
            toggleTracking()
        } label: {
            Text(isTracking ? "Uyandım" : "Uykuya dal")
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
        }
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

private struct FreeTag: View {
    var body: some View {
        Text("ÜCRETSİZ")
            .font(.system(size: 10, weight: .medium))
            .foregroundStyle(Somna.free)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(Somna.free.opacity(0.12))
            .overlay(Capsule().strokeBorder(Somna.free.opacity(0.3), lineWidth: 0.5))
            .clipShape(Capsule())
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
        .modelContainer(for: [SleepSession.self, Alarm.self], inMemory: true)
        .preferredColorScheme(.dark)
}
