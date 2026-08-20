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

/// Light, bold, high-contrast system — modeled on PushClock (5,700+
/// ratings in ~5 months, the fastest-growing app in this category we
/// found). Swapped the previous dark "atmospheric" direction entirely:
/// that kept getting rejected as too soft. See docs/design-concept.md.
enum Somna {
    static let bg = Color(hex: 0xF1F0F6)
    static let card = Color.white
    static let card2 = Color(hex: 0xF7F6FB)
    static let hair = Color.black.opacity(0.07)

    static let textPrimary = Color(hex: 0x15141C)
    static let textDim = Color(hex: 0x66646F)
    static let textFaint = Color(hex: 0x9997A2)

    // Somna's own brand accent — bold indigo, not a copy of PushClock's
    // green, but the same "one loud color on a light ground" logic.
    static let accent = Color(hex: 0x5B4FEE)
    static let accentDeep = Color(hex: 0x4038B8)
    static let success = Color(hex: 0x1FAA59)
    static let coral = Color(hex: 0xFF6152)
    static let mint = Color(hex: 0x2FCCB8)
    static let gold = Color(hex: 0xFFB020)
    static let lavender = Color(hex: 0x9C8CFF)

    static let deep = accent
    static let stageLight = mint
    static let stageRem = lavender
    static let stageAwake = coral
    static let free = success
    static let amber = gold
    static let amberDeep = Color(hex: 0xE0921A)

    /// Flat light ground — no gradient mesh, no glow. PushClock's whole
    /// point is plain, legible, high-contrast utility.
    static var backdrop: some View {
        bg.ignoresSafeArea()
    }

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
        /// Heavy rounded weight for hero numbers and headlines — the
        /// PushClock signature: big, black, unmissable.
        static func heavy(_ size: CGFloat) -> SwiftUI.Font {
            .system(size: size, weight: .heavy, design: .rounded)
        }
        static func bold(_ size: CGFloat) -> SwiftUI.Font {
            .system(size: size, weight: .bold, design: .rounded)
        }
        static func serif(_ size: CGFloat, weight: SwiftUI.Font.Weight = .semibold) -> SwiftUI.Font {
            .system(size: size, weight: weight, design: .rounded)
        }
        static func mono(_ size: CGFloat, weight: SwiftUI.Font.Weight = .semibold) -> SwiftUI.Font {
            .system(size: size, weight: weight, design: .rounded)
        }
    }
}

/// Flat white card with a soft, close, low-opacity shadow — not glass,
/// not glow. This is the PushClock card language.
struct GlassCard: ViewModifier {
    var padding: CGFloat = 16
    var radius: CGFloat = 20
    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(Somna.card)
            .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
            .shadow(color: .black.opacity(0.06), radius: 14, x: 0, y: 6)
    }
}

extension View {
    func glassCard(padding: CGFloat = 16, radius: CGFloat = 20) -> some View {
        modifier(GlassCard(padding: padding, radius: radius))
    }

    /// Kept as a name for call-site compatibility; now a plain soft
    /// shadow in the accent color rather than a colored glow — the
    /// light system doesn't want neon bloom.
    func amberGlow(radius: CGFloat = 14, opacity: Double = 0.22) -> some View {
        shadow(color: Somna.accent.opacity(opacity), radius: radius, x: 0, y: 6)
    }

    /// Minimum 44×44pt hit target per Apple HIG, for icon-only controls
    /// that would otherwise be too small to reliably tap.
    func minTapTarget() -> some View {
        frame(minWidth: 44, minHeight: 44)
            .contentShape(Rectangle())
    }
}

/// Subtle scale-down on press — tactile without being showy.
struct PressableButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1)
            .opacity(configuration.isPressed ? 0.85 : 1)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}

/// A small colorful pill badge — PushClock's category-tag language
/// (Push-ups / Touch Grass / Exercise chips).
struct TagPill: View {
    let text: String
    var color: Color = Somna.accent
    var body: some View {
        Text(text)
            .font(Somna.Font.bold(11))
            .foregroundStyle(color == .white ? Somna.textPrimary : .white)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(color)
            .clipShape(Capsule())
    }
}
