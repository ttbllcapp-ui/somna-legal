import SwiftUI

struct SleepStagesView: View {
    let stages: [(stage: Somna.SleepStage, minutes: Int)] = [
        (.deep, 108), (.light, 225), (.rem, 89), (.awake, 26)
    ]

    private var total: Int { stages.reduce(0) { $0 + $1.minutes } }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 18) {
                Text("Bu gece · 23:24 – 06:52")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(Somna.textFaint)
                    .textCase(.uppercase)

                HStack(spacing: 2) {
                    ForEach(stages, id: \.stage) { entry in
                        Rectangle()
                            .fill(entry.stage.color)
                            .frame(width: CGFloat(entry.minutes) / CGFloat(total) * 300)
                    }
                }
                .frame(height: 24)
                .clipShape(RoundedRectangle(cornerRadius: 7))

                HStack {
                    Text("23:24")
                    Spacer()
                    Text("06:52")
                }
                .font(Somna.Font.mono(9))
                .foregroundStyle(Somna.textFaint)

                VStack(spacing: 10) {
                    ForEach(stages, id: \.stage) { entry in
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

                Spacer()
            }
            .padding(20)
            .background(Somna.ink.ignoresSafeArea())
            .navigationTitle("Uyku evreleri")
            .toolbarBackground(Somna.ink, for: .navigationBar)
        }
    }
}

#Preview {
    SleepStagesView().preferredColorScheme(.dark)
}
