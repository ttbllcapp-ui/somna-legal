import SwiftUI
import SwiftData

struct OnboardingView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var step = 0

    @State private var birthDate = Calendar.current.date(byAdding: .year, value: -30, to: .now) ?? .now
    @State private var heightCM = 170.0
    @State private var weightKG = 70.0
    @State private var sex: BiologicalSex = .unspecified

    private var age: Int {
        Calendar.current.dateComponents([.year], from: birthDate, to: .now).year ?? 30
    }

    var body: some View {
        VStack(spacing: 0) {
            ProgressView(value: Double(step + 1), total: 3)
                .tint(Somna.accent)
                .padding(.horizontal, 24)
                .padding(.top, 20)

            Group {
                switch step {
                case 0: welcomeStep
                case 1: profileStep
                default: resultStep
                }
            }
            .transition(.asymmetric(
                insertion: .opacity.combined(with: .move(edge: .trailing)),
                removal: .opacity.combined(with: .move(edge: .leading))
            ))
            .animation(.easeInOut(duration: 0.35), value: step)
            .frame(maxHeight: .infinity)
        }
        .background(Somna.backdrop)
    }

    private var welcomeStep: some View {
        VStack(alignment: .leading, spacing: 0) {
            Spacer()

            TagPill(text: "SCIENCE-BACKED", color: Somna.accent)
                .padding(.bottom, 16)

            Text("Never Guess\nYour Sleep\nGoal Again.")
                .font(Somna.Font.heavy(44))
                .foregroundStyle(Somna.textPrimary)
                .lineSpacing(2)

            Text("A few quick questions, then a sleep goal that's actually calculated for your age — not a generic 8 hours.")
                .font(.system(size: 16))
                .foregroundStyle(Somna.textDim)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 16)

            Spacer()
            nextButton("Get started")
        }
        .padding(24)
    }

    private var profileStep: some View {
        VStack(alignment: .leading, spacing: 22) {
            Text("A little about you.")
                .font(Somna.Font.heavy(30))
                .foregroundStyle(Somna.textPrimary)
                .padding(.top, 12)

            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("DATE OF BIRTH").font(Somna.Font.bold(11)).foregroundStyle(Somna.textFaint)
                    DatePicker("", selection: $birthDate, displayedComponents: .date)
                        .datePickerStyle(.compact)
                        .labelsHidden()
                }

                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("HEIGHT").font(Somna.Font.bold(11)).foregroundStyle(Somna.textFaint)
                        Spacer()
                        Text("\(Int(heightCM)) cm").font(Somna.Font.heavy(15)).foregroundStyle(Somna.textPrimary)
                    }
                    Slider(value: $heightCM, in: 100...220, step: 1).tint(Somna.accent)
                }

                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("WEIGHT").font(Somna.Font.bold(11)).foregroundStyle(Somna.textFaint)
                        Spacer()
                        Text("\(Int(weightKG)) kg").font(Somna.Font.heavy(15)).foregroundStyle(Somna.textPrimary)
                    }
                    Slider(value: $weightKG, in: 30...200, step: 1).tint(Somna.accent)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("SEX").font(Somna.Font.bold(11)).foregroundStyle(Somna.textFaint)
                    Picker("", selection: $sex) {
                        ForEach(BiologicalSex.allCases, id: \.self) { option in
                            Text(option.label).tag(option)
                        }
                    }
                    .pickerStyle(.segmented)
                }
            }
            .glassCard(padding: 20)

            Spacer()
            nextButton("Continue")
        }
        .padding(24)
    }

    private var resultStep: some View {
        let targetMinutes = SleepGoalCalculator.targetMinutes(forAge: age)
        let range = SleepGoalCalculator.recommendedRangeMinutes(forAge: age)

        return VStack(alignment: .leading, spacing: 16) {
            Spacer()

            VStack(alignment: .leading, spacing: 16) {
                TagPill(text: "YOUR GOAL", color: Somna.success)

                HStack(alignment: .lastTextBaseline, spacing: 4) {
                    Text(SleepGoalCalculator.formatted(targetMinutes))
                        .font(Somna.Font.heavy(52))
                        .foregroundStyle(Somna.textPrimary)
                }

                Text("The recommended range for a \(age)-year-old is \(range.lowerBound / 60)–\(range.upperBound / 60) hours, based on the National Sleep Foundation's 2015 expert panel report.")
                    .font(.system(size: 13))
                    .foregroundStyle(Somna.textDim)
                    .fixedSize(horizontal: false, vertical: true)

                if let bmiNote = SleepGoalCalculator.bmiNote(weightKG / pow(heightCM / 100, 2)) {
                    Text(bmiNote)
                        .font(.system(size: 12))
                        .foregroundStyle(Somna.textFaint)
                }
            }
            .glassCard(padding: 20)

            Text("This is general guidance, not medical advice, and isn't a diagnosis. See Settings > Health Disclosure for details, and check with a doctor about your personal sleep needs.")
                .font(.system(size: 11))
                .foregroundStyle(Somna.textFaint)
                .padding(.top, 4)

            Spacer()
            nextButton("Start using Somna") { finish() }
        }
        .padding(24)
    }

    private func nextButton(_ title: String, action: (() -> Void)? = nil) -> some View {
        Button {
            if let action { action() } else {
                withAnimation { step += 1 }
            }
        } label: {
            Text(title.uppercased())
                .font(Somna.Font.bold(15))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .foregroundStyle(.white)
                .background(Somna.accent)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .shadow(color: Somna.accent.opacity(0.35), radius: 16, x: 0, y: 8)
        }
        .buttonStyle(PressableButtonStyle())
    }

    private func finish() {
        let profile = UserProfile(
            birthDate: birthDate,
            heightCM: Int(heightCM),
            weightKG: weightKG,
            sex: sex,
            onboardingCompleted: true
        )
        modelContext.insert(profile)
    }
}

#Preview {
    OnboardingView()
        .modelContainer(for: [UserProfile.self], inMemory: true)
        .preferredColorScheme(.light)
}
