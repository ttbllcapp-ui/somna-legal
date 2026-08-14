import SwiftUI
import SwiftData

@main
struct SomnaApp: App {
    var body: some Scene {
        WindowGroup {
            RootTabView()
                .preferredColorScheme(.dark)
                .tint(Somna.amber)
        }
        .modelContainer(for: [SleepSession.self, Alarm.self])
    }
}
