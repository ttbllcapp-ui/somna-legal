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
                    Section("Profil") {
                        LabeledContent("Yaş", value: "\(profile.ageYears)")
                        LabeledContent("Boy", value: "\(profile.heightCM) cm")
                        LabeledContent("Kilo", value: "\(Int(profile.weightKG)) kg")
                        LabeledContent("Cinsiyet", value: profile.sex.label)
                        LabeledContent("Uyku hedefin", value: SleepGoalCalculator.formatted(SleepGoalCalculator.targetMinutes(forAge: profile.ageYears)))
                        Button("Profili düzenle") { showProfileEdit = true }
                            .foregroundStyle(Somna.amber)
                    }
                    .listRowBackground(Somna.card)
                }

                Section("Uygulama") {
                    LabeledContent("Fiyatlandırma", value: "Tamamen ücretsiz")
                    LabeledContent("Sürüm", value: "1.0.0")
                }
                .listRowBackground(Somna.card)

                Section("Kurallar ve politikalar") {
                    NavigationLink("Gizlilik Politikası") {
                        PolicyDetailView(title: "Gizlilik Politikası", text: PolicyText.privacy)
                    }
                    NavigationLink("Kullanım Şartları") {
                        PolicyDetailView(title: "Kullanım Şartları", text: PolicyText.terms)
                    }
                    NavigationLink("Sağlık Bilgisi Açıklaması") {
                        PolicyDetailView(title: "Sağlık Bilgisi Açıklaması", text: PolicyText.healthDisclaimer)
                    }
                }
                .listRowBackground(Somna.card)
            }
            .scrollContentBackground(.hidden)
            .background(Somna.ink.ignoresSafeArea())
            .navigationTitle("Ayarlar")
            .toolbarBackground(Somna.ink, for: .navigationBar)
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
                DatePicker("Doğum tarihi", selection: $profile.birthDate, displayedComponents: .date)
                Stepper("Boy: \(profile.heightCM) cm", value: $profile.heightCM, in: 100...220)
                Stepper("Kilo: \(Int(profile.weightKG)) kg", value: $profile.weightKG, in: 30...200)
                Picker("Cinsiyet", selection: $profile.sex) {
                    ForEach(BiologicalSex.allCases, id: \.self) { Text($0.label).tag($0) }
                }
            }
            .navigationTitle("Profili düzenle")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Kapat") { dismiss() }
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
        .background(Somna.ink.ignoresSafeArea())
        .navigationTitle(title)
        .toolbarBackground(Somna.ink, for: .navigationBar)
    }
}

private enum PolicyText {
    static let privacy = """
    Somna, uyku verilerini (uyuma/uyanma saatleri, tahmini evre dağılımı) cihazında saklar. Bu veriler şu an için hiçbir sunucuya gönderilmiyor veya üçüncü taraflarla paylaşılmıyor.

    Apple Health entegrasyonu açıksa, izin verdiğin veriler yalnızca uyku skorunu hesaplamak için okunur; Somna, Health verilerini kendi sunucularına aktarmaz.

    Kamera, uyandırma görevinde nesne eşleştirmek için kullanılır; hiçbir görüntü kaydedilmez veya saklanmaz. Mikrofon, horlama/ses tespiti için kullanılır; kayıtlar cihazında kalır.

    Profilinde girdiğin yaş, boy, kilo ve cinsiyet bilgisi sadece sana özel uyku hedefini hesaplamak için kullanılır ve cihazından çıkmaz.
    """

    static let terms = """
    Somna'yı kullanarak, uygulamanın sağladığı skor, öneri ve hatırlatmaların bilgilendirme amaçlı olduğunu, tıbbi teşhis veya tedavi yerine geçmediğini kabul edersin.

    Uygulama şu an tamamen ücretsizdir; hiçbir özellik ücret duvarının arkasında değildir.

    Uygulamayı kötüye kullanım (ör. tersine mühendislik, yeniden dağıtım) dışında istediğin gibi kullanabilirsin.
    """

    static let healthDisclaimer = """
    Somna'daki uyku hedefi önerileri, National Sleep Foundation'ın 2015 uzman panel raporundaki yaş bazlı süre aralıklarına dayanır. Bu bilimsel bir genel kılavuzdur — kişisel tıbbi tavsiye değildir.

    Uyku apnesi, kronik uykusuzluk veya başka bir uyku bozukluğundan şüpheleniyorsan, bir sağlık uzmanına danış. Somna bu durumları teşhis edemez ve tedavi öneremez.

    Uyku evresi tahminleri (derin/hafif/REM), şu an ölçülen toplam süreden istatistiksel bir tahminle hesaplanıyor — klinik düzeyde doğruluk iddia etmiyoruz.
    """
}

#Preview {
    SettingsView()
        .modelContainer(for: [UserProfile.self], inMemory: true)
        .preferredColorScheme(.dark)
}
