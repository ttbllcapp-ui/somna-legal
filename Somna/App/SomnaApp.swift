import SwiftUI

@main
struct SomnaApp: App {
    var body: some Scene {
        WindowGroup {
            RootTabView()
                .preferredColorScheme(.dark)
                .tint(Somna.amber)
        }
    }
}
