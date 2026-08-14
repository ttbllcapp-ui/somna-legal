import SwiftUI

struct SoundMixerView: View {
    struct Sound: Identifiable {
        let id = UUID()
        let name: String
        var level: Double
    }

    @State private var sounds: [Sound] = [
        Sound(name: "Yağmur", level: 0.7),
        Sound(name: "Beyaz gürültü", level: 0.35),
        Sound(name: "Orman gecesi", level: 0)
    ]

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 12) {
                Text("Uyku ortamı")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(Somna.textFaint)
                    .textCase(.uppercase)

                ForEach($sounds) { $sound in
                    HStack {
                        Image(systemName: "waveform")
                            .foregroundStyle(Somna.amber)
                            .frame(width: 20)
                        Text(sound.name)
                            .font(.system(size: 13))
                            .foregroundStyle(Somna.textDim)
                        Spacer()
                        Slider(value: $sound.level)
                            .tint(Somna.amber)
                            .frame(width: 100)
                    }
                    .glassCard()
                }

                Text("+ 47 ses daha · Somna+")
                    .font(.system(size: 12))
                    .foregroundStyle(Somna.textFaint)
                    .padding(.top, 8)

                Spacer()
            }
            .padding(20)
            .background(Somna.ink.ignoresSafeArea())
            .navigationTitle("Sesler")
            .toolbarBackground(Somna.ink, for: .navigationBar)
        }
    }
}

#Preview {
    SoundMixerView().preferredColorScheme(.dark)
}
