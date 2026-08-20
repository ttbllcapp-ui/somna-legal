import SwiftUI

struct WakeMissionView: View {
    @Environment(\.dismiss) private var dismiss
    let object = "Kitchen light"
    let secondsLeft = 11

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Wake mission")
                    .font(Somna.Font.heavy(20))
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
                Somna.textPrimary
                RadialGradient(
                    colors: [Somna.amber.opacity(0.35), .clear],
                    center: .init(x: 0.5, y: 0.3),
                    startRadius: 0,
                    endRadius: 220
                )

                VStack(spacing: 12) {
                    TagPill(text: "OBJECT HUNT", color: Somna.amber)
                    Image(systemName: "viewfinder")
                        .font(.system(size: 30))
                        .foregroundStyle(.white)
                        .padding(.top, 4)
                    Text(object)
                        .font(Somna.Font.heavy(20))
                        .foregroundStyle(.white)
                    Text("Point your phone at the object — the alarm only stops once it matches")
                        .font(.system(size: 12))
                        .foregroundStyle(.white.opacity(0.65))
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: 220)
                    Text(String(format: "00:%02d", secondsLeft))
                        .font(Somna.Font.heavy(34))
                        .foregroundStyle(Somna.amber)
                        .padding(.top, 4)
                    ProgressView(value: 0.38)
                        .tint(Somna.amber)
                        .frame(width: 160)
                }
                .padding(24)
            }
            .frame(maxWidth: .infinity, minHeight: 340)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .shadow(color: .black.opacity(0.18), radius: 20, x: 0, y: 10)

            Text("This is a preview — camera-based object matching (Vision framework) isn't built yet. See docs/design-concept.md.")
                .font(.system(size: 11))
                .foregroundStyle(Somna.textFaint)

            Spacer()
        }
        .padding(20)
        .background(Somna.backdrop)
    }
}

#Preview {
    WakeMissionView().preferredColorScheme(.light)
}
