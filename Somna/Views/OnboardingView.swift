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
            Text("Sana özel bir uyku hedefi belirlemek için birkaç şey soralım — yaşına göre bilimsel olarak önerilen süreyi hesaplayacağız.")
                .font(.system(size: 15))
                .foregroundStyle(Somna.textDim)
                .fixedSize(horizontal: false, vertical: true)
            Spacer()
            nextButton("Başla")
        }
        .padding(24)
    }

    private var profileStep: some View {
        VStack(alignment: .leading, spacing: 22) {
            Text("Biraz seni tanıyalım")
                .font(Somna.Font.serif(24))
                .foregroundStyle(Somna.textPrimary)

            VStack(alignment: .leading, spacing: 8) {
                Text("Doğum tarihi").font(.system(size: 13)).foregroundStyle(Somna.textFaint)
                DatePicker("", selection: $birthDate, displayedComponents: .date)
                    .datePickerStyle(.compact)
                    .labelsHidden()
                    .colorScheme(.dark)
            }

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Boy").font(.system(size: 13)).foregroundStyle(Somna.textFaint)
                    Spacer()
                    Text("\(Int(heightCM)) cm").font(Somna.Font.mono(13)).foregroundStyle(Somna.textPrimary)
                }
                Slider(value: $heightCM, in: 100...220, step: 1).tint(Somna.amber)
            }

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Kilo").font(.system(size: 13)).foregroundStyle(Somna.textFaint)
                    Spacer()
                    Text("\(Int(weightKG)) kg").font(Somna.Font.mono(13)).foregroundStyle(Somna.textPrimary)
                }
                Slider(value: $weightKG, in: 30...200, step: 1).tint(Somna.amber)
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("Cinsiyet").font(.system(size: 13)).foregroundStyle(Somna.textFaint)
                Picker("", selection: $sex) {
                    ForEach(BiologicalSex.allCases, id: \.self) { option in
                        Text(option.label).tag(option)
                    }
                }
                .pickerStyle(.segmented)
            }

            Spacer()
            nextButton("Devam")
        }
        .padding(24)
    }

    private var resultStep: some View {
        let targetMinutes = SleepGoalCalculator.targetMinutes(forAge: age)
        let range = SleepGoalCalculator.recommendedRangeMinutes(forAge: age)

        return VStack(alignment: .leading, spacing: 16) {
            Spacer()
            Text("Sana özel hedef")
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(Somna.textFaint)
                .textCase(.uppercase)
            Text(SleepGoalCalculator.formatted(targetMinutes))
                .font(Somna.Font.serif(48))
                .foregroundStyle(Somna.amber)
            Text("\(age) yaşındaki bir yetişkin için önerilen aralık \(range.lowerBound / 60)–\(range.upperBound / 60) saat. National Sleep Foundation'ın 2015 uzman panel önerisine dayanıyor.")
                .font(.system(size: 13))
                .foregroundStyle(Somna.textDim)
                .fixedSize(horizontal: false, vertical: true)

            if let bmiNote = SleepGoalCalculator.bmiNote(weightKG / pow(heightCM / 100, 2)) {
                Text(bmiNote)
                    .font(.system(size: 12))
                    .foregroundStyle(Somna.textFaint)
                    .padding(.top, 4)
            }

            Text("Bu bir tıbbi tavsiye değildir. Detaylar için Ayarlar > Sağlık Bilgisi Açıklaması.")
                .font(.system(size: 11))
                .foregroundStyle(Somna.textFaint)
                .padding(.top, 8)

            Spacer()
            nextButton("Somna'yı kullanmaya başla") { finish() }
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
        }
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
