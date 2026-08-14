import SwiftUI

struct CoachView: View {
    struct Message: Identifiable {
        let id = UUID()
        let text: String
        let fromCoach: Bool
    }

    @State private var draft = ""
    @State private var messages: [Message] = [
        Message(text: "Merhaba Tayfun. Health ve Watch verini okudum — gece hakkında ne merak ediyorsun?", fromCoach: true),
        Message(text: "Bu hafta nasıldım?", fromCoach: false),
        Message(text: "İstikrarlı bir hafta, HRV'in de yükseliyor — 8 saatlik hedefini ortalamada tuttun.", fromCoach: true)
    ]

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HStack {
                    Text("Uyku koçu")
                        .font(Somna.Font.serif(15))
                        .foregroundStyle(Somna.textDim)
                    Spacer()
                    Text("ÜCRETSİZ")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundStyle(Somna.free)
                        .padding(.horizontal, 8).padding(.vertical, 3)
                        .background(Somna.free.opacity(0.12))
                        .clipShape(Capsule())
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .padding(.bottom, 8)

                ScrollView {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(messages) { message in
                            bubble(message)
                        }
                        HStack {
                            Text("Uyku skoru")
                                .font(.system(size: 10))
                                .foregroundStyle(Somna.textFaint)
                            Spacer()
                            Text("88 ▲2")
                                .font(Somna.Font.mono(15))
                                .foregroundStyle(Somna.amber)
                        }
                        .padding(10)
                        .background(Somna.card2)
                        .overlay(RoundedRectangle(cornerRadius: 13).strokeBorder(Somna.hair, lineWidth: 0.5))
                        .clipShape(RoundedRectangle(cornerRadius: 13))
                        .frame(maxWidth: 260, alignment: .leading)
                    }
                    .padding(.horizontal, 20)
                }

                HStack {
                    TextField("Somna'ya sor…", text: $draft)
                        .font(.system(size: 13))
                        .foregroundStyle(Somna.textPrimary)
                    Image(systemName: "arrow.up.circle.fill")
                        .foregroundStyle(Somna.amber)
                }
                .padding(12)
                .background(Somna.card)
                .overlay(Capsule().strokeBorder(Somna.hair, lineWidth: 0.5))
                .clipShape(Capsule())
                .padding(20)
            }
            .background(Somna.ink.ignoresSafeArea())
            .navigationBarHidden(true)
        }
    }

    @ViewBuilder
    private func bubble(_ message: Message) -> some View {
        HStack {
            if !message.fromCoach { Spacer(minLength: 40) }
            Text(message.text)
                .font(.system(size: 13))
                .foregroundStyle(message.fromCoach ? Somna.textDim : Color(hex: 0xf6d3ab))
                .padding(11)
                .background(message.fromCoach ? Somna.card.opacity(0.65) : Somna.amber.opacity(0.14))
                .overlay(
                    RoundedRectangle(cornerRadius: 15).strokeBorder(
                        message.fromCoach ? Somna.hair : .clear, lineWidth: 0.5
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 15))
            if message.fromCoach { Spacer(minLength: 40) }
        }
    }
}

#Preview {
    CoachView().preferredColorScheme(.dark)
}
