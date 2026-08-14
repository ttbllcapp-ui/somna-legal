import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem { Label("Bu gece", systemImage: "moon.stars.fill") }

            StatsView()
                .tabItem { Label("İstatistik", systemImage: "chart.bar.fill") }

            SoundMixerView()
                .tabItem { Label("Sesler", systemImage: "waveform") }

            CoachView()
                .tabItem { Label("Koç", systemImage: "bubble.left.and.bubble.right.fill") }

            SettingsView()
                .tabItem { Label("Ayarlar", systemImage: "gearshape.fill") }
        }
        .background(Somna.ink.ignoresSafeArea())
    }
}

#Preview {
    RootTabView().preferredColorScheme(.dark)
}
