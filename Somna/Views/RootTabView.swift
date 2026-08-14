import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem { Label("Bu gece", systemImage: "moon.stars.fill") }

            SleepStagesView()
                .tabItem { Label("Evreler", systemImage: "chart.bar.fill") }

            SoundMixerView()
                .tabItem { Label("Sesler", systemImage: "waveform") }

            CoachView()
                .tabItem { Label("Koç", systemImage: "bubble.left.and.bubble.right.fill") }

            PlansView()
                .tabItem { Label("Somna+", systemImage: "sparkles") }
        }
        .background(Somna.ink.ignoresSafeArea())
    }
}

#Preview {
    RootTabView().preferredColorScheme(.dark)
}
