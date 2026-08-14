import Foundation
import SwiftData

@Model
final class Alarm {
    var id: UUID
    /// Only the hour/minute components of this date are used.
    var time: Date
    var isEnabled: Bool
    var wakeWindowMinutes: Int
    var missionEnabled: Bool
    var bedtimeReminderEnabled: Bool

    init(
        id: UUID = UUID(),
        time: Date,
        isEnabled: Bool = true,
        wakeWindowMinutes: Int = 20,
        missionEnabled: Bool = true,
        bedtimeReminderEnabled: Bool = true
    ) {
        self.id = id
        self.time = time
        self.isEnabled = isEnabled
        self.wakeWindowMinutes = wakeWindowMinutes
        self.missionEnabled = missionEnabled
        self.bedtimeReminderEnabled = bedtimeReminderEnabled
    }

    /// Stable identifier for the paired bedtime-reminder notification.
    var bedtimeNotificationID: String { "\(id.uuidString)-bedtime" }
}
