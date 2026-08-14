import SwiftUI

struct SoundMixerView: View {
    struct Sound: Identifiable {
        let id = UUID()
        let name: String
        let icon: String
        var level: Double
    }

    struct Category: Identifiable {
        let id = UUID()
        let name: String
        var sounds: [Sound]
    }

    @State private var categories: [Category] = [
        Category(name: "Yağmur ve fırtına", sounds: [
            Sound(name: "Hafif yağmur", icon: "cloud.drizzle", level: 0.7),
            Sound(name: "Sağanak", icon: "cloud.heavyrain", level: 0),
            Sound(name: "Uzak gök gürültüsü", icon: "cloud.bolt", level: 0),
            Sound(name: "Cam damlaları", icon: "drop", level: 0)
        ]),
        Category(name: "Doğa", sounds: [
            Sound(name: "Orman gecesi", icon: "leaf", level: 0.35),
            Sound(name: "Rüzgar", icon: "wind", level: 0),
            Sound(name: "Dalgalar", icon: "water.waves", level: 0),
            Sound(name: "Kamp ateşi", icon: "flame", level: 0),
            Sound(name: "Cırcır böcekleri", icon: "ladybug", level: 0)
        ]),
        Category(name: "Beyaz / pembe gürültü", sounds: [
            Sound(name: "Beyaz gürültü", icon: "waveform", level: 0),
            Sound(name: "Pembe gürültü", icon: "waveform.path", level: 0),
            Sound(name: "Kahverengi gürültü", icon: "waveform.path.ecg", level: 0),
            Sound(name: "Vantilatör", icon: "fanblades", level: 0)
        ]),
        Category(name: "Enstrümantal", sounds: [
            Sound(name: "Piyano ninnisi", icon: "pianokeys", level: 0),
            Sound(name: "Tekil synth pad", icon: "music.note", level: 0),
            Sound(name: "Tibet çanağı", icon: "circle.dotted", level: 0)
        ]),
        Category(name: "Şehir ve mekan", sounds: [
            Sound(name: "Uzak trafik", icon: "car", level: 0),
            Sound(name: "Kafe uğultusu", icon: "cup.and.saucer", level: 0),
            Sound(name: "Tren yolculuğu", icon: "tram", level: 0)
        ])
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    ForEach($categories) { $category in
                        VStack(alignment: .leading, spacing: 10) {
                            Text(category.name.uppercased())
                                .font(.system(size: 11, weight: .medium))
                                .foregroundStyle(Somna.textFaint)

                            ForEach($category.sounds) { $sound in
                                soundRow($sound)
                            }
                        }
                    }
                }
                .padding(20)
            }
            .background(Somna.ink.ignoresSafeArea())
            .navigationTitle("Sesler")
            .toolbarBackground(Somna.ink, for: .navigationBar)
        }
    }

    private func soundRow(_ sound: Binding<Sound>) -> some View {
        HStack {
            Image(systemName: sound.wrappedValue.icon)
                .foregroundStyle(sound.wrappedValue.level > 0 ? Somna.amber : Somna.textFaint)
                .frame(width: 20)
                .animation(.easeInOut, value: sound.wrappedValue.level > 0)
            Text(sound.wrappedValue.name)
                .font(.system(size: 13))
                .foregroundStyle(Somna.textDim)
            Spacer()
            Slider(value: sound.level)
                .tint(Somna.amber)
                .frame(width: 100)
        }
        .glassCard(padding: 10)
    }
}

#Preview {
    SoundMixerView().preferredColorScheme(.dark)
}
