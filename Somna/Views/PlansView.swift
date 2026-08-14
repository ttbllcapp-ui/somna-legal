import SwiftUI

struct PlansView: View {
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 12) {
                Text("Planlar")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(Somna.textFaint)
                    .textCase(.uppercase)

                planCard(
                    name: "Somna",
                    price: "Ücretsiz",
                    tint: Somna.free,
                    features: [
                        "Skor, evreler, uyandırma görevi",
                        "Uyku koçu — sınırsız",
                        "Health + Watch senkron"
                    ]
                )

                planCard(
                    name: "Somna+",
                    price: "149,99₺/yıl",
                    tint: Somna.amber,
                    features: [
                        "50+ ses, sınırsız katman",
                        "1 yıllık geçmiş + dışa aktar",
                        "Kendi fotoğrafınla görev"
                    ]
                )

                Spacer()
            }
            .padding(20)
            .background(Somna.ink.ignoresSafeArea())
            .navigationTitle("Somna+")
            .toolbarBackground(Somna.ink, for: .navigationBar)
        }
    }

    private func planCard(name: String, price: String, tint: Color, features: [String]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .firstTextBaseline) {
                Text(name)
                    .font(Somna.Font.serif(15))
                    .foregroundStyle(Somna.textPrimary)
                Spacer()
                Text(price)
                    .font(Somna.Font.mono(11))
                    .foregroundStyle(Somna.textFaint)
            }
            ForEach(features, id: \.self) { feature in
                HStack(spacing: 6) {
                    Image(systemName: "checkmark")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(tint)
                    Text(feature)
                        .font(.system(size: 12))
                        .foregroundStyle(Somna.textDim)
                }
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(tint.opacity(0.07))
        .overlay(RoundedRectangle(cornerRadius: 15).strokeBorder(tint.opacity(0.3), lineWidth: 0.5))
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}

#Preview {
    PlansView().preferredColorScheme(.dark)
}
