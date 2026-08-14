import SwiftUI
import SwiftData

struct AlarmSetupView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query private var alarms: [Alarm]

    @State private var time = Calendar.current.date(bySettingHour: 7, minute: 30, second: 0, of: .now) ?? .now
    @State private var isEnabled = true
    @State private var wakeWindowMinutes = 20.0
    @State private var missionEnabled = true

    private var existingAlarm: Alarm? { alarms.first }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    DatePicker("Uyanma saati", selection: $time, displayedComponents: .hourAndMinute)
                        .datePickerStyle(.wheel)
                    Toggle("Alarm açık", isOn: $isEnabled)
                }
                .listRowBackground(Somna.card)

                Section("Uyandırma görevi — ücretsiz") {
                    Toggle("Kamera görevi zorunlu", isOn: $missionEnabled)
                    VStack(alignment: .leading) {
                        Text("Akıllı uyandırma penceresi: \(Int(wakeWindowMinutes)) dk")
                            .font(.system(size: 13))
                            .foregroundStyle(Somna.textDim)
                        Slider(value: $wakeWindowMinutes, in: 0...45, step: 5)
                            .tint(Somna.amber)
                    }
                }
                .listRowBackground(Somna.card)

                Section {
                    Text("Şu an sabit saatte çalan yerel bir bildirim planlanıyor. Hafif uykuda erken uyandıran sensör tabanlı akıllı alarm henüz eklenmedi.")
                        .font(.system(size: 12))
                        .foregroundStyle(Somna.textFaint)
                }
                .listRowBackground(Somna.card.opacity(0.5))
            }
            .scrollContentBackground(.hidden)
            .background(Somna.ink.ignoresSafeArea())
            .navigationTitle("Alarm")
            .toolbarBackground(Somna.ink, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Kaydet") { save() }
                        .foregroundStyle(Somna.amber)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Vazgeç") { dismiss() }
                }
            }
            .onAppear(perform: loadExisting)
        }
    }

    private func loadExisting() {
        guard let alarm = existingAlarm else { return }
        time = alarm.time
        isEnabled = alarm.isEnabled
        wakeWindowMinutes = Double(alarm.wakeWindowMinutes)
        missionEnabled = alarm.missionEnabled
    }

    private func save() {
        let alarm = existingAlarm ?? Alarm(time: time)
        alarm.time = time
        alarm.isEnabled = isEnabled
        alarm.wakeWindowMinutes = Int(wakeWindowMinutes)
        alarm.missionEnabled = missionEnabled

        if existingAlarm == nil {
            modelContext.insert(alarm)
        }

        Task {
            await NotificationScheduler.shared.schedule(alarm)
        }
        dismiss()
    }
}

#Preview {
    AlarmSetupView()
        .modelContainer(for: [Alarm.self], inMemory: true)
        .preferredColorScheme(.dark)
}
