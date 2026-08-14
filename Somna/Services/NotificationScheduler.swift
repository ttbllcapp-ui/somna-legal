import Foundation
import UserNotifications

@MainActor
final class NotificationScheduler: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationScheduler()

    private override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }

    @discardableResult
    func requestAuthorization() async -> Bool {
        let granted = try? await UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge])
        return granted ?? false
    }

    /// Schedules a repeating daily alarm notification at the alarm's hour/minute.
    /// This is a plain local notification, not yet the sensor-driven "smart wake"
    /// described in the design concept — waking early inside the window requires
    /// motion/audio sensing that isn't built yet.
    func schedule(_ alarm: Alarm) async {
        cancel(alarm)
        guard alarm.isEnabled else { return }

        let granted = await requestAuthorization()
        guard granted else { return }

        let content = UNMutableNotificationContent()
        content.title = "Somna"
        content.body = alarm.missionEnabled
            ? "Uyanma vakti. Alarmı susturmak için görevi tamamla."
            : "Uyanma vakti."
        content.sound = .default

        var components = Calendar.current.dateComponents([.hour, .minute], from: alarm.time)
        components.second = 0
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)

        let request = UNNotificationRequest(
            identifier: alarm.id.uuidString,
            content: content,
            trigger: trigger
        )
        try? await UNUserNotificationCenter.current().add(request)
    }

    func cancel(_ alarm: Alarm) {
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: [alarm.id.uuidString])
    }

    nonisolated func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
        [.banner, .sound]
    }
}
