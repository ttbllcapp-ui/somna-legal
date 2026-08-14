import Foundation

/// Scores a session 0–100 from duration-vs-goal and efficiency.
/// A placeholder blend until real sensor data (HRV, motion) can inform it —
/// see docs/design-concept.md "Next steps".
enum SleepScoreCalculator {
    static func score(for session: SleepSession, goalMinutes: Int) -> Int {
        let durationRatio = min(1, Double(session.asleepMinutes) / Double(goalMinutes))
        let durationScore = durationRatio * 60
        let efficiencyScore = session.efficiency * 40
        return Int((durationScore + efficiencyScore).rounded())
    }

    static func label(for score: Int) -> String {
        switch score {
        case 85...: return "Excellent"
        case 70..<85: return "Good"
        case 50..<70: return "Fair"
        default: return "Poor"
        }
    }
}
