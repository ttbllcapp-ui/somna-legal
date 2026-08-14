import Foundation

/// Age-based sleep duration targets from the National Sleep Foundation's
/// 2015 panel recommendations (Hirshkowitz et al., Sleep Health journal).
/// Weight/height are collected for the profile and BMI-based context tips,
/// but NSF ties recommended *duration* to age, not body composition — we
/// don't invent a weight-adjusted hour formula that doesn't exist in the
/// literature.
enum SleepGoalCalculator {
    static func recommendedRangeMinutes(forAge age: Int) -> ClosedRange<Int> {
        switch age {
        case ..<1: return (14 * 60)...(17 * 60)
        case 1...2: return (11 * 60)...(14 * 60)
        case 3...5: return (10 * 60)...(13 * 60)
        case 6...13: return (9 * 60)...(11 * 60)
        case 14...17: return (8 * 60)...(10 * 60)
        case 18...64: return (7 * 60)...(9 * 60)
        default: return (7 * 60)...(8 * 60)
        }
    }

    static func targetMinutes(forAge age: Int) -> Int {
        let range = recommendedRangeMinutes(forAge: age)
        return (range.lowerBound + range.upperBound) / 2
    }

    static func formatted(_ minutes: Int) -> String {
        "\(minutes / 60)s \(minutes % 60)d"
    }

    /// A light, non-diagnostic context note. Not medical advice — see
    /// SettingsView's "Sağlık Bilgisi Açıklaması".
    static func bmiNote(_ bmi: Double) -> String? {
        guard bmi > 0 else { return nil }
        switch bmi {
        case ..<18.5: return "Düşük BMI bazen uyku düzenini etkileyebilir."
        case 30...: return "Yüksek BMI, uyku apnesi riskiyle ilişkilendirilir — horlama sık oluyorsa bir uzmana danışmanı öneririz."
        default: return nil
        }
    }
}
