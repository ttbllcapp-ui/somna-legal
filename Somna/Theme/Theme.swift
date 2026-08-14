import SwiftUI

extension Color {
    init(hex: UInt32, opacity: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: opacity
        )
    }
}

enum Somna {
    // Night-blue ground, single warm dawn accent. See docs/design-concept.md.
    static let ink = Color(hex: 0x070f16)
    static let ink2 = Color(hex: 0x0c1820)
    static let card = Color(hex: 0x13222c)
    static let card2 = Color(hex: 0x182a35)
    static let hair = Color(hex: 0x26404f)

    static let textPrimary = Color(hex: 0xf4f8f9)
    static let textDim = Color(hex: 0xa6b8c2)
    static let textFaint = Color(hex: 0x71879e)

    static let amber = Color(hex: 0xf2a65a)
    static let deep = Color(hex: 0x6577f2)
    static let stageLight = Color(hex: 0x39b8ac)
    static let stageRem = Color(hex: 0x8fe8da)
    static let stageAwake = Color(hex: 0xe2905a)
    static let free = Color(hex: 0x4fd3b8)

    enum SleepStage: CaseIterable {
        case deep, light, rem, awake

        var label: String {
            switch self {
            case .deep: return "Derin"
            case .light: return "Hafif"
            case .rem: return "REM"
            case .awake: return "Uyanık"
            }
        }

        var color: Color {
            switch self {
            case .deep: return Somna.deep
            case .light: return Somna.stageLight
            case .rem: return Somna.stageRem
            case .awake: return Somna.stageAwake
            }
        }
    }

    enum Font {
        static func serif(_ size: CGFloat, weight: SwiftUI.Font.Weight = .medium) -> SwiftUI.Font {
            .system(size: size, weight: weight, design: .serif)
        }
        static func mono(_ size: CGFloat, weight: SwiftUI.Font.Weight = .regular) -> SwiftUI.Font {
            .system(size: size, weight: weight, design: .monospaced)
        }
    }
}

struct GlassCard: ViewModifier {
    var padding: CGFloat = 12
    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(Somna.card.opacity(0.65))
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .strokeBorder(Somna.hair, lineWidth: 0.5)
            )
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}

extension View {
    func glassCard(padding: CGFloat = 12) -> some View {
        modifier(GlassCard(padding: padding))
    }
}
