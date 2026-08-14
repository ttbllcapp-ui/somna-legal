import SwiftUI
import SwiftData

struct AppRootView: View {
    @Query private var profiles: [UserProfile]

    private var hasCompletedOnboarding: Bool {
        profiles.first?.onboardingCompleted ?? false
    }

    var body: some View {
        Group {
            if hasCompletedOnboarding {
                RootTabView()
                    .transition(.opacity)
            } else {
                OnboardingView()
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.4), value: hasCompletedOnboarding)
    }
}

#Preview {
    AppRootView()
        .modelContainer(for: [UserProfile.self, SleepSession.self, Alarm.self], inMemory: true)
        .preferredColorScheme(.dark)
}
