import SwiftUI

struct WakeMissionView: View {
    @Environment(\.dismiss) private var dismiss
    let object = "Kitchen light"
    let secondsLeft = 11

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Wake mission")
                    .font(Somna.Font.serif(20))
                    .foregroundStyle(Somna.textPrimary)
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(Somna.textFaint)
                        .font(.system(size: 15, weight: .medium))
                        .minTapTarget()
                }
                .buttonStyle(PressableButtonStyle())
            }

            ZStack {
                RadialGradient(
                    colors: [Somna.amber.opacity(0.4), Somna.amber.opacity(0.03)],
                    center: .init(x: 0.5, y: 0.3),
                    startRadius: 0,
                    endRadius: 220
                )

                VStack(spacing: 12) {
                    Image(systemName: "viewfinder")
                        .font(.system(size: 30))
                        .foregroundStyle(Somna.amber)
                    Text(object)
                        .font(Somna.Font.serif(17))
                        .foregroundStyle(Somna.textPrimary)
                    Text("Point your phone at the object — the alarm only stops once it matches")
                        .font(.system(size: 12))
                        .foregroundStyle(Somna.textDim)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: 220)
                    Text(String(format: "00:%02d", secondsLeft))
                        .font(Somna.Font.mono(30))
                        .foregroundStyle(Somna.amber)
                        .padding(.top, 4)
                    ProgressView(value: 0.38)
                        .tint(Somna.amber)
                        .frame(width: 160)
                }
                .padding(24)
            }
            .frame(maxWidth: .infinity, minHeight: 320)
            .background(Somna.card)
            .overlay(RoundedRectangle(cornerRadius: 20).strokeBorder(Somna.hair, lineWidth: 0.5))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .amberGlow(radius: 24, opacity: 0.12)

            Text("This is a preview — camera-based object matching (Vision framework) isn't built yet. See docs/design-concept.md.")
                .font(.system(size: 11))
                .foregroundStyle(Somna.textFaint)

            Spacer()
        }
        .padding(20)
        .background(Somna.ink.ignoresSafeArea())
    }
}

#Preview {
    WakeMissionView().preferredColorScheme(.dark)
}
