import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem { Label("Tonight", systemImage: "moon.stars.fill") }

            StatsView()
                .tabItem { Label("Stats", systemImage: "chart.bar.fill") }

            SoundMixerView()
                .tabItem { Label("Sounds", systemImage: "waveform") }

            CoachView()
                .tabItem { Label("Coach", systemImage: "bubble.left.and.bubble.right.fill") }

            SettingsView()
                .tabItem { Label("Settings", systemImage: "gearshape.fill") }
        }
        .tint(Somna.amber)
        .background(Somna.ink.ignoresSafeArea())
    }
}

#Preview {
    RootTabView().preferredColorScheme(.dark)
}
