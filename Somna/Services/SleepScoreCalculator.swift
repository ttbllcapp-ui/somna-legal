import Foundation

/// Scores a session 0–100 from duration-vs-goal and efficiency.
/// A placeholder blend until real sensor data (HRV, motion) can inform it —
/// see docs/design-concept.md "Sonraki adımlar".
enum SleepScoreCalculator {
    static let goalMinutes = 8 * 60

    static func score(for session: SleepSession) -> Int {
        let durationRatio = min(1, Double(session.asleepMinutes) / Double(goalMinutes))
        let durationScore = durationRatio * 60
        let efficiencyScore = session.efficiency * 40
        return Int((durationScore + efficiencyScore).rounded())
    }

    static func label(for score: Int) -> String {
        switch score {
        case 85...: return "Çok iyi"
        case 70..<85: return "İyi"
        case 50..<70: return "Orta"
        default: return "Zayıf"
        }
    }
}
