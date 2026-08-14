import SwiftUI
import SwiftData

struct CoachView: View {
    struct Message: Identifiable {
        let id = UUID()
        let text: String
        let fromCoach: Bool
    }

    @Query(sort: \SleepSession.startDate, order: .reverse) private var sessions: [SleepSession]
    @Query private var profiles: [UserProfile]
    @State private var draft = ""
    @State private var messages: [Message] = [
        Message(text: "Hi, I'm Somna. Ask me how last night went, or how your week's looking.", fromCoach: true)
    ]

    private var goalMinutes: Int {
        SleepGoalCalculator.targetMinutes(forAge: profiles.first?.ageYears ?? 30)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HStack {
                    Text("Sleep coach")
                        .font(Somna.Font.serif(15))
                        .foregroundStyle(Somna.textDim)
                    Spacer()
                    Text("FREE")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundStyle(Somna.free)
                        .padding(.horizontal, 8).padding(.vertical, 3)
                        .background(Somna.free.opacity(0.12))
                        .clipShape(Capsule())
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .padding(.bottom, 2)

                Text("Reads the sleep data already on this device — no account, nothing sent off-device.")
                    .font(.system(size: 11))
                    .foregroundStyle(Somna.textFaint)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 8)

                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(messages) { message in
                                bubble(message).id(message.id)
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    .onChange(of: messages.count) {
                        withAnimation {
                            proxy.scrollTo(messages.last?.id, anchor: .bottom)
                        }
                    }
                }

                suggestionRow

                HStack(spacing: 10) {
                    TextField("Ask Somna…", text: $draft)
                        .font(.system(size: 13))
                        .foregroundStyle(Somna.textPrimary)
                        .onSubmit(send)
                    Button(action: send) {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.system(size: 22))
                            .foregroundStyle(draft.trimmingCharacters(in: .whitespaces).isEmpty ? Somna.textFaint : Somna.amber)
                            .minTapTarget()
                    }
                    .buttonStyle(PressableButtonStyle())
                    .disabled(draft.trimmingCharacters(in: .whitespaces).isEmpty)
                }
                .padding(.leading, 12)
                .padding(.trailing, 4)
                .background(Somna.card)
                .overlay(Capsule().strokeBorder(Somna.hair, lineWidth: 0.5))
                .clipShape(Capsule())
                .padding(20)
            }
            .background(Somna.backdrop)
            .navigationBarHidden(true)
        }
    }

    private var suggestionRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(["How was last night?", "How's my week?", "What's my goal?"], id: \.self) { suggestion in
                    Button {
                        draft = suggestion
                        send()
                    } label: {
                        Text(suggestion)
                            .font(.system(size: 12))
                            .foregroundStyle(Somna.textDim)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 7)
                            .overlay(Capsule().strokeBorder(Somna.hair, lineWidth: 0.5))
                    }
                    .buttonStyle(PressableButtonStyle())
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 8)
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

    private func send() {
        let text = draft.trimmingCharacters(in: .whitespaces)
        guard !text.isEmpty else { return }
        messages.append(Message(text: text, fromCoach: false))
        draft = ""

        let reply = reply(to: text)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            withAnimation {
                messages.append(Message(text: reply, fromCoach: true))
            }
        }
    }

    /// A local, rule-based reply grounded in real on-device data — not a
    /// live AI model yet. See docs/design-concept.md "Next steps".
    private func reply(to text: String) -> String {
        let lower = text.lowercased()

        if lower.contains("week") {
            let calendar = Calendar.current
            let cutoff = calendar.date(byAdding: .day, value: -7, to: .now) ?? .now
            let recent = sessions.filter { $0.startDate >= cutoff }
            guard !recent.isEmpty else {
                return "No nights logged in the past week yet — tap \"Going to sleep\" on the Tonight tab to start."
            }
            let avgMinutes = recent.reduce(0) { $0 + $1.asleepMinutes } / recent.count
            return "Over the last \(recent.count) night\(recent.count == 1 ? "" : "s"), you averaged \(SleepGoalCalculator.formatted(avgMinutes)) — your goal is \(SleepGoalCalculator.formatted(goalMinutes))."
        }

        if lower.contains("goal") {
            return "Your personal goal is \(SleepGoalCalculator.formatted(goalMinutes)), based on your age and the National Sleep Foundation's guidelines. You can adjust your profile in Settings."
        }

        guard let last = sessions.first else {
            return "I don't have a night logged yet. Tap \"Going to sleep\" on the Tonight tab before you sleep, then again when you wake up."
        }
        let score = SleepScoreCalculator.score(for: last, goalMinutes: goalMinutes)
        let hours = last.asleepMinutes / 60
        let minutes = last.asleepMinutes % 60
        return "Last night you slept \(hours)h \(minutes)m with a score of \(score) — \(SleepScoreCalculator.label(for: score).lowercased())."
    }
}

#Preview {
    CoachView()
        .modelContainer(for: [SleepSession.self, UserProfile.self], inMemory: true)
        .preferredColorScheme(.dark)
}
