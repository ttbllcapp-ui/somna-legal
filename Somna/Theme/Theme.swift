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
    // Atmospheric night gradient — deep indigo through violet — with
    // glass cards floating on top, instead of a flat navy ground.
    // See docs/design-concept.md.
    static let ink = Color(hex: 0x0a0a1f)
    static let ink2 = Color(hex: 0x131033)
    static let violet = Color(hex: 0x2c1f5e)
    static let midnight = Color(hex: 0x191248)

    static let card = Color(hex: 0x1c1840)
    static let card2 = Color(hex: 0x241d52)
    static let hair = Color.white.opacity(0.14)

    static let textPrimary = Color(hex: 0xfbf9ff)
    static let textDim = Color(hex: 0xc2bce0)
    static let textFaint = Color(hex: 0x8b84b5)

    static let amber = Color(hex: 0xffb35e)
    static let amberDeep = Color(hex: 0xf5794a)
    static let deep = Color(hex: 0x7c7dfa)
    static let stageLight = Color(hex: 0x4fd1c5)
    static let stageRem = Color(hex: 0xa9a2ff)
    static let stageAwake = Color(hex: 0xf5794a)
    static let free = Color(hex: 0x4fd3b8)

    static let scoreGradient = AngularGradient(
        colors: [amberDeep, amber, stageRem, deep, amberDeep],
        center: .center,
        startAngle: .degrees(-90),
        endAngle: .degrees(270)
    )

    /// The full-bleed atmospheric background every screen sits on.
    static var backdrop: some View {
        ZStack {
            LinearGradient(
                colors: [midnight, ink2, ink],
                startPoint: .top,
                endPoint: .bottom
            )
            GeometryReader { proxy in
                Circle()
                    .fill(deep.opacity(0.35))
                    .frame(width: proxy.size.width * 0.9)
                    .blur(radius: 90)
                    .offset(x: -proxy.size.width * 0.3, y: -proxy.size.height * 0.28)
                Circle()
                    .fill(amberDeep.opacity(0.16))
                    .frame(width: proxy.size.width * 0.7)
                    .blur(radius: 100)
                    .offset(x: proxy.size.width * 0.35, y: proxy.size.height * 0.15)
                Circle()
                    .fill(stageRem.opacity(0.14))
                    .frame(width: proxy.size.width * 0.6)
                    .blur(radius: 90)
                    .offset(x: proxy.size.width * 0.1, y: proxy.size.height * 0.65)
            }
        }
        .ignoresSafeArea()
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
        static func serif(_ size: CGFloat, weight: SwiftUI.Font.Weight = .medium) -> SwiftUI.Font {
            .system(size: size, weight: weight, design: .serif)
        }
        static func mono(_ size: CGFloat, weight: SwiftUI.Font.Weight = .regular) -> SwiftUI.Font {
            .system(size: size, weight: weight, design: .monospaced)
        }
    }
}

/// Real glassmorphism: a blurred translucent material over the
/// atmospheric backdrop, not a flat solid fill.
struct GlassCard: ViewModifier {
    var padding: CGFloat = 16
    var radius: CGFloat = 22
    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(.ultraThinMaterial.opacity(0.55))
            .background(Somna.card.opacity(0.35))
            .overlay(
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .strokeBorder(
                        LinearGradient(
                            colors: [.white.opacity(0.35), .white.opacity(0.05)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
            .shadow(color: .black.opacity(0.35), radius: 20, x: 0, y: 10)
    }
}

extension View {
    func glassCard(padding: CGFloat = 16, radius: CGFloat = 22) -> some View {
        modifier(GlassCard(padding: padding, radius: radius))
    }

    /// A soft, tinted glow rather than a flat black drop shadow — reads as
    /// "premium" against a colorful ground without looking muddy.
    func amberGlow(radius: CGFloat = 24, opacity: Double = 0.35) -> some View {
        shadow(color: Somna.amber.opacity(opacity), radius: radius, x: 0, y: 6)
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
