import SwiftUI
import SwiftData

@main
struct SomnaApp: App {
    var body: some Scene {
        WindowGroup {
            AppRootView()
                .preferredColorScheme(.dark)
                .tint(Somna.amber)
        }
        .modelContainer(for: [SleepSession.self, Alarm.self, UserProfile.self])
    }
}
