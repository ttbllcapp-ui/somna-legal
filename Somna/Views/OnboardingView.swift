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
                .tint(Somna.amber)
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
        .background(Somna.ink.ignoresSafeArea())
    }

    private var welcomeStep: some View {
        VStack(alignment: .leading, spacing: 14) {
            Spacer()
            Text("Somna")
                .font(Somna.Font.serif(40))
                .foregroundStyle(Somna.textPrimary)
            Text("Let's ask a few things so we can set a sleep goal that's actually yours — based on the science of what your age needs.")
                .font(.system(size: 15))
                .foregroundStyle(Somna.textDim)
                .fixedSize(horizontal: false, vertical: true)
            Spacer()
            nextButton("Get started")
        }
        .padding(24)
    }

    private var profileStep: some View {
        VStack(alignment: .leading, spacing: 22) {
            Text("A little about you")
                .font(Somna.Font.serif(24))
                .foregroundStyle(Somna.textPrimary)

            VStack(alignment: .leading, spacing: 8) {
                Text("Date of birth").font(.system(size: 13)).foregroundStyle(Somna.textFaint)
                DatePicker("", selection: $birthDate, displayedComponents: .date)
                    .datePickerStyle(.compact)
                    .labelsHidden()
                    .colorScheme(.dark)
            }

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Height").font(.system(size: 13)).foregroundStyle(Somna.textFaint)
                    Spacer()
                    Text("\(Int(heightCM)) cm").font(Somna.Font.mono(13)).foregroundStyle(Somna.textPrimary)
                }
                Slider(value: $heightCM, in: 100...220, step: 1).tint(Somna.amber)
            }

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Weight").font(.system(size: 13)).foregroundStyle(Somna.textFaint)
                    Spacer()
                    Text("\(Int(weightKG)) kg").font(Somna.Font.mono(13)).foregroundStyle(Somna.textPrimary)
                }
                Slider(value: $weightKG, in: 30...200, step: 1).tint(Somna.amber)
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("Sex").font(.system(size: 13)).foregroundStyle(Somna.textFaint)
                Picker("", selection: $sex) {
                    ForEach(BiologicalSex.allCases, id: \.self) { option in
                        Text(option.label).tag(option)
                    }
                }
                .pickerStyle(.segmented)
            }

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
            Text("Your personal goal")
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(Somna.textFaint)
                .textCase(.uppercase)

            HStack(spacing: 16) {
                ZStack {
                    Circle().stroke(Somna.hair, lineWidth: 6)
                    Circle()
                        .trim(from: 0, to: 0.8)
                        .stroke(Somna.scoreGradient, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                        .rotationEffect(.degrees(-126))
                }
                .frame(width: 64, height: 64)

                Text(SleepGoalCalculator.formatted(targetMinutes))
                    .font(Somna.Font.serif(44))
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
                    .padding(.top, 4)
            }

            Text("This is general guidance, not medical advice, and isn't a diagnosis. See Settings > Health Disclosure for details, and check with a doctor about your personal sleep needs.")
                .font(.system(size: 11))
                .foregroundStyle(Somna.textFaint)
                .padding(.top, 8)

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
            Text(title)
                .font(.system(size: 15, weight: .medium))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .foregroundStyle(Somna.ink)
                .background(Somna.amber)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                .amberGlow()
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
        .preferredColorScheme(.dark)
}
