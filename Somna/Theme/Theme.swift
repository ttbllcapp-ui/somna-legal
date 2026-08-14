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
    static let amberDeep = Color(hex: 0xd97a3f)
    static let deep = Color(hex: 0x6577f2)
    static let stageLight = Color(hex: 0x39b8ac)
    static let stageRem = Color(hex: 0x8fe8da)
    static let stageAwake = Color(hex: 0xe2905a)
    static let free = Color(hex: 0x4fd3b8)

    static let scoreGradient = AngularGradient(
        colors: [amberDeep, amber, stageRem, deep, amberDeep],
        center: .center,
        startAngle: .degrees(-90),
        endAngle: .degrees(270)
    )

    enum SleepStage: CaseIterable {
        case deep, light, rem, awake

        var label: String {
            switch self {
            case .deep: return "Deep"
            case .light: return "Light"
            case .rem: return "REM"
            case .awake: return "Awake"
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
            .background(Somna.card.opacity(0.7))
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .strokeBorder(Somna.hair, lineWidth: 0.5)
            )
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .shadow(color: .black.opacity(0.25), radius: 12, x: 0, y: 6)
    }
}

extension View {
    func glassCard(padding: CGFloat = 12) -> some View {
        modifier(GlassCard(padding: padding))
    }

    /// A soft, tinted glow rather than a flat black drop shadow — reads as
    /// "premium" against a near-black ground without looking muddy.
    func amberGlow(radius: CGFloat = 20, opacity: Double = 0.25) -> some View {
        shadow(color: Somna.amber.opacity(opacity), radius: radius, x: 0, y: 4)
    }

    /// Minimum 44×44pt hit target per Apple HIG, for icon-only controls
    /// that would otherwise be too small to reliably tap.
    func minTapTarget() -> some View {
        frame(minWidth: 44, minHeight: 44)
            .contentShape(Rectangle())
    }
}

/// Subtle scale-down on press instead of the default opacity dim —
/// feels more tactile/premium on dark surfaces.
struct PressableButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1)
            .opacity(configuration.isPressed ? 0.85 : 1)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}
