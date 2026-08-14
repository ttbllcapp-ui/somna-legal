import Foundation
import SwiftData

enum BiologicalSex: String, Codable, CaseIterable {
    case female, male, unspecified

    var label: String {
        switch self {
        case .female: return "Kadın"
        case .male: return "Erkek"
        case .unspecified: return "Belirtmek istemiyorum"
        }
    }
}

@Model
final class UserProfile {
    var id: UUID
    var birthDate: Date
    var heightCM: Int
    var weightKG: Double
    var sexRaw: String
    var onboardingCompleted: Bool

    init(
        id: UUID = UUID(),
        birthDate: Date,
        heightCM: Int,
        weightKG: Double,
        sex: BiologicalSex = .unspecified,
        onboardingCompleted: Bool = false
    ) {
        self.id = id
        self.birthDate = birthDate
        self.heightCM = heightCM
        self.weightKG = weightKG
        self.sexRaw = sex.rawValue
        self.onboardingCompleted = onboardingCompleted
    }

    var sex: BiologicalSex {
        get { BiologicalSex(rawValue: sexRaw) ?? .unspecified }
        set { sexRaw = newValue.rawValue }
    }

    var ageYears: Int {
        Calendar.current.dateComponents([.year], from: birthDate, to: .now).year ?? 30
    }

    var bmi: Double {
        guard heightCM > 0 else { return 0 }
        let heightM = Double(heightCM) / 100
        return weightKG / (heightM * heightM)
    }
}
