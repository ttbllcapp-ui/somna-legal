import SwiftUI
import SwiftData

struct SleepStagesView: View {
    @Query(sort: \SleepSession.startDate, order: .reverse) private var sessions: [SleepSession]

    private var latestSession: SleepSession? { sessions.first }

    var body: some View {
        NavigationStack {
            Group {
                if let session = latestSession {
                    content(for: session)
                } else {
                    emptyState
                }
            }
            .padding(20)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .background(Somna.ink.ignoresSafeArea())
            .navigationTitle("Uyku evreleri")
            .toolbarBackground(Somna.ink, for: .navigationBar)
        }
    }

    private var emptyState: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Henüz kayıtlı gece yok")
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(Somna.textPrimary)
            Text("Bu gece sekmesinden \"Uykuya dal\" ile ilk kaydını oluştur.")
                .font(.system(size: 12))
                .foregroundStyle(Somna.textFaint)
        }
        .glassCard(padding: 14)
    }

    private func content(for session: SleepSession) -> some View {
        let total = max(1, session.totalMinutes)
        let timeFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            return formatter
        }()

        return VStack(alignment: .leading, spacing: 18) {
            Text("Bu gece · \(timeFormatter.string(from: session.startDate)) – \(timeFormatter.string(from: session.endDate))")
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

            HStack {
                Text(timeFormatter.string(from: session.startDate))
                Spacer()
                Text(timeFormatter.string(from: session.endDate))
            }
            .font(Somna.Font.mono(9))
            .foregroundStyle(Somna.textFaint)

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
                            Text("\(entry.minutes / 60)s \(entry.minutes % 60)d")
                                .foregroundStyle(Somna.textPrimary)
                            Text("%\(Int(Double(entry.minutes) / Double(total) * 100))")
                                .font(.system(size: 10))
                                .foregroundStyle(Somna.textFaint)
                        }
                        .font(Somna.Font.mono(13))
                    }
                }
            }

            Text("Evre dağılımı, ölçülen toplam süreden tahmin ediliyor — hareket/ses tabanlı gerçek algılama henüz eklenmedi.")
                .font(.system(size: 11))
                .foregroundStyle(Somna.textFaint)

            Spacer()
        }
    }
}

#Preview {
    SleepStagesView()
        .modelContainer(for: [SleepSession.self, Alarm.self], inMemory: true)
        .preferredColorScheme(.dark)
}
