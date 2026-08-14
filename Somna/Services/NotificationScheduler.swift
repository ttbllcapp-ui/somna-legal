import Foundation
import UserNotifications

private enum NotificationCategory {
    static let alarm = "com.somna.alarm"
    static let bedtime = "com.somna.bedtime"
}

/// Assumed minutes it typically takes to fall asleep once in bed —
/// used to place the bedtime reminder ahead of the actual sleep window.
private let assumedSleepLatencyMinutes = 15

@MainActor
final class NotificationScheduler: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationScheduler()

    private override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().setNotificationCategories([
            UNNotificationCategory(identifier: NotificationCategory.alarm, actions: [], intentIdentifiers: []),
            UNNotificationCategory(identifier: NotificationCategory.bedtime, actions: [], intentIdentifiers: [])
        ])
    }

    @discardableResult
    func requestAuthorization() async -> Bool {
        let granted = try? await UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge])
        return granted ?? false
    }

    /// Schedules the repeating daily wake alarm and, if enabled, a bedtime
    /// reminder placed `goalMinutes` (+ sleep-latency buffer) before it.
    /// Both are plain local notifications, not the sensor-driven "smart
    /// wake" described in the design concept — see docs/design-concept.md.
    func schedule(_ alarm: Alarm, goalMinutes: Int) async {
        cancel(alarm)
        guard alarm.isEnabled else { return }

        let granted = await requestAuthorization()
        guard granted else { return }

        await scheduleAlarmNotification(alarm)
        if alarm.bedtimeReminderEnabled {
            await scheduleBedtimeNotification(alarm, goalMinutes: goalMinutes)
        }
    }

    private func scheduleAlarmNotification(_ alarm: Alarm) async {
        let content = UNMutableNotificationContent()
        content.title = "Somna"
        content.body = alarm.missionEnabled
            ? "Uyanma vakti. Alarmı susturmak için görevi tamamla."
            : "Uyanma vakti."
        content.sound = .default
        content.categoryIdentifier = NotificationCategory.alarm

        var components = Calendar.current.dateComponents([.hour, .minute], from: alarm.time)
        components.second = 0
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)

        let request = UNNotificationRequest(identifier: alarm.id.uuidString, content: content, trigger: trigger)
        try? await UNUserNotificationCenter.current().add(request)
    }

    private func scheduleBedtimeNotification(_ alarm: Alarm, goalMinutes: Int) async {
        let calendar = Calendar.current
        let totalOffset = goalMinutes + assumedSleepLatencyMinutes
        guard let bedtime = calendar.date(byAdding: .minute, value: -totalOffset, to: alarm.time) else { return }

        let content = UNMutableNotificationContent()
        content.title = "Somna"
        content.body = "Yatma vakti yaklaştı — hedefin \(SleepGoalCalculator.formatted(goalMinutes))."
        content.sound = .default
        content.categoryIdentifier = NotificationCategory.bedtime

        var components = calendar.dateComponents([.hour, .minute], from: bedtime)
        components.second = 0
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)

        let request = UNNotificationRequest(identifier: alarm.bedtimeNotificationID, content: content, trigger: trigger)
        try? await UNUserNotificationCenter.current().add(request)
    }

    func cancel(_ alarm: Alarm) {
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: [alarm.id.uuidString, alarm.bedtimeNotificationID])
    }

    nonisolated func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
        [.banner, .sound]
    }
}
