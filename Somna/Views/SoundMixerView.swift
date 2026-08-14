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
        Category(name: "Rain & storm", sounds: [
            Sound(name: "Light rain", icon: "cloud.drizzle", level: 0.7),
            Sound(name: "Heavy rain", icon: "cloud.heavyrain", level: 0),
            Sound(name: "Distant thunder", icon: "cloud.bolt", level: 0),
            Sound(name: "Rain on glass", icon: "drop", level: 0)
        ]),
        Category(name: "Nature", sounds: [
            Sound(name: "Forest night", icon: "leaf", level: 0.35),
            Sound(name: "Wind", icon: "wind", level: 0),
            Sound(name: "Ocean waves", icon: "water.waves", level: 0),
            Sound(name: "Campfire", icon: "flame", level: 0),
            Sound(name: "Crickets", icon: "ladybug", level: 0)
        ]),
        Category(name: "White & pink noise", sounds: [
            Sound(name: "White noise", icon: "waveform", level: 0),
            Sound(name: "Pink noise", icon: "waveform.path", level: 0),
            Sound(name: "Brown noise", icon: "waveform.path.ecg", level: 0),
            Sound(name: "Fan", icon: "fanblades", level: 0)
        ]),
        Category(name: "Instrumental", sounds: [
            Sound(name: "Piano lullaby", icon: "pianokeys", level: 0),
            Sound(name: "Ambient synth pad", icon: "music.note", level: 0),
            Sound(name: "Tibetan bowl", icon: "circle.dotted", level: 0)
        ]),
        Category(name: "City & places", sounds: [
            Sound(name: "Distant traffic", icon: "car", level: 0),
            Sound(name: "Café murmur", icon: "cup.and.saucer", level: 0),
            Sound(name: "Train ride", icon: "tram", level: 0)
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
            .navigationTitle("Sounds")
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
