import SwiftUI
import SwiftData

struct SettingsView: View {
    @Query private var profiles: [UserProfile]
    @State private var showProfileEdit = false

    private var profile: UserProfile? { profiles.first }

    var body: some View {
        NavigationStack {
            Form {
                if let profile {
                    Section("Profile") {
                        LabeledContent("Age", value: "\(profile.ageYears)")
                        LabeledContent("Height", value: "\(profile.heightCM) cm")
                        LabeledContent("Weight", value: "\(Int(profile.weightKG)) kg")
                        LabeledContent("Sex", value: profile.sex.label)
                        LabeledContent("Your sleep goal", value: SleepGoalCalculator.formatted(SleepGoalCalculator.targetMinutes(forAge: profile.ageYears)))
                        Button("Edit profile") { showProfileEdit = true }
                            .foregroundStyle(Somna.amber)
                    }
                    .listRowBackground(Somna.card)
                }

                Section("App") {
                    LabeledContent("In-app purchases", value: "None")
                    LabeledContent("Version", value: "1.0.0")
                }
                .listRowBackground(Somna.card)

                Section("Rules & policies") {
                    NavigationLink("Privacy Policy") {
                        PolicyDetailView(title: "Privacy Policy", text: PolicyText.privacy)
                    }
                    NavigationLink("Terms of Use") {
                        PolicyDetailView(title: "Terms of Use", text: PolicyText.terms)
                    }
                    NavigationLink("Health Disclosure") {
                        PolicyDetailView(title: "Health Disclosure", text: PolicyText.healthDisclaimer)
                    }
                }
                .listRowBackground(Somna.card)
            }
            .scrollContentBackground(.hidden)
            .background(Somna.backdrop)
            .navigationTitle("Settings")
            .toolbarColorScheme(.light, for: .navigationBar)
            .sheet(isPresented: $showProfileEdit) {
                if let profile {
                    ProfileEditView(profile: profile)
                }
            }
        }
    }
}

private struct ProfileEditView: View {
    @Bindable var profile: UserProfile
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                DatePicker("Date of birth", selection: $profile.birthDate, displayedComponents: .date)
                Stepper("Height: \(profile.heightCM) cm", value: $profile.heightCM, in: 100...220)
                Stepper("Weight: \(Int(profile.weightKG)) kg", value: $profile.weightKG, in: 30...200)
                Picker("Sex", selection: $profile.sex) {
                    ForEach(BiologicalSex.allCases, id: \.self) { Text($0.label).tag($0) }
                }
            }
            .navigationTitle("Edit profile")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

private struct PolicyDetailView: View {
    let title: String
    let text: String

    var body: some View {
        ScrollView {
            Text(text)
                .font(.system(size: 14))
                .foregroundStyle(Somna.textDim)
                .lineSpacing(5)
                .padding(20)
        }
        .background(Somna.backdrop)
        .navigationTitle(title)
        .toolbarColorScheme(.light, for: .navigationBar)
    }
}

private enum PolicyText {
    static let privacy = """
    Somna stores your sleep data (sleep/wake times, estimated stage breakdown) on your device. This data isn't sent to any server or shared with third parties.

    If Apple Health integration is on, the data you permit is read only to compute your sleep score — Somna doesn't upload Health data to its own servers.

    The camera is used to match an object for the wake mission; no image is recorded or stored. The microphone is used for snore/sound detection; recordings stay on your device.

    The age, height, weight, and sex you enter in your profile are used only to calculate your personal sleep goal, and never leave your device.
    """

    static let terms = """
    By using Somna, you agree that the scores, suggestions, and reminders it provides are for informational purposes only and are not a substitute for professional medical diagnosis or treatment.

    Somna has no subscription and no in-app purchases — every feature is available from the first launch.

    You may use the app as you like, other than misuse such as reverse engineering or redistribution.
    """

    static let healthDisclaimer = """
    Somna's sleep-goal suggestions are based on the age-based duration ranges in the National Sleep Foundation's 2015 expert panel report (Hirshkowitz et al., Sleep Health). This is general scientific guidance — not personal medical advice, and not a diagnosis.

    If you suspect sleep apnea, chronic insomnia, or another sleep disorder, talk to a healthcare professional. Somna cannot diagnose these conditions or prescribe treatment for them.

    Sleep stage estimates (deep/light/REM) are currently calculated with a statistical estimate from total measured duration — we don't claim clinical-grade accuracy. Sleep score and coach replies are generated on-device from that same data.
    """
}

#Preview {
    SettingsView()
        .modelContainer(for: [UserProfile.self], inMemory: true)
        .preferredColorScheme(.light)
}
