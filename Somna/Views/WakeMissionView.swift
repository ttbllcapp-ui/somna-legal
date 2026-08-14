import SwiftUI

struct WakeMissionView: View {
    let object = "Mutfak lambası"
    let secondsLeft = 11

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text("Uyandırma görevi")
                    .font(Somna.Font.serif(20))
                    .foregroundStyle(Somna.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)

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
                        Text("Telefonunu nesneye doğrult, alarm ancak eşleşince susar")
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

                Spacer()
            }
            .padding(20)
            .background(Somna.ink.ignoresSafeArea())
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    WakeMissionView().preferredColorScheme(.dark)
}
