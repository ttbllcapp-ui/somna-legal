import Foundation
import SwiftData

@Model
final class SleepSession {
    var id: UUID
    var startDate: Date
    var endDate: Date
    var deepMinutes: Int
    var lightMinutes: Int
    var remMinutes: Int
    var awakeMinutes: Int

    init(
        id: UUID = UUID(),
        startDate: Date,
        endDate: Date,
        deepMinutes: Int,
        lightMinutes: Int,
        remMinutes: Int,
        awakeMinutes: Int
    ) {
        self.id = id
        self.startDate = startDate
        self.endDate = endDate
        self.deepMinutes = deepMinutes
        self.lightMinutes = lightMinutes
        self.remMinutes = remMinutes
        self.awakeMinutes = awakeMinutes
    }

    var totalMinutes: Int { deepMinutes + lightMinutes + remMinutes + awakeMinutes }

    var asleepMinutes: Int { deepMinutes + lightMinutes + remMinutes }

    var efficiency: Double {
        guard totalMinutes > 0 else { return 0 }
        return Double(asleepMinutes) / Double(totalMinutes)
    }

    var stageMinutes: [(stage: Somna.SleepStage, minutes: Int)] {
        [
            (.deep, deepMinutes),
            (.light, lightMinutes),
            (.rem, remMinutes),
            (.awake, awakeMinutes)
        ]
    }

    /// Placeholder heuristic until real motion/audio sensing lands (see docs/design-concept.md).
    /// Splits a measured total duration into stage estimates using population-average ratios.
    static func estimatingStages(startDate: Date, endDate: Date) -> SleepSession {
        let totalMinutes = max(1, Int(endDate.timeIntervalSince(startDate) / 60))
        let deep = Int(Double(totalMinutes) * 0.22)
        let rem = Int(Double(totalMinutes) * 0.24)
        let awake = Int(Double(totalMinutes) * 0.07)
        let light = totalMinutes - deep - rem - awake
        return SleepSession(
            startDate: startDate,
            endDate: endDate,
            deepMinutes: deep,
            lightMinutes: max(0, light),
            remMinutes: rem,
            awakeMinutes: awake
        )
    }
}
