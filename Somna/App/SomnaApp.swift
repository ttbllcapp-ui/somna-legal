import SwiftUI
import SwiftData

@main
struct SomnaApp: App {
    var body: some Scene {
        WindowGroup {
            AppRootView()
                .preferredColorScheme(.light)
                .tint(Somna.accent)
        }
        .modelContainer(for: [SleepSession.self, Alarm.self, UserProfile.self])
    }
}
