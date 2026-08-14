import SwiftUI
import SwiftData

struct AlarmSetupView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query private var alarms: [Alarm]
    @Query private var profiles: [UserProfile]

    @State private var time = Calendar.current.date(bySettingHour: 7, minute: 30, second: 0, of: .now) ?? .now
    @State private var isEnabled = true
    @State private var wakeWindowMinutes = 20.0
    @State private var missionEnabled = true
    @State private var bedtimeReminderEnabled = true
    @State private var showMissionPreview = false

    private var existingAlarm: Alarm? { alarms.first }
    private var goalMinutes: Int {
        SleepGoalCalculator.targetMinutes(forAge: profiles.first?.ageYears ?? 30)
    }
    private var bedtimeText: String {
        let calendar = Calendar.current
        guard let bedtime = calendar.date(byAdding: .minute, value: -(goalMinutes + 15), to: time) else { return "" }
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: bedtime)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    DatePicker("Wake-up time", selection: $time, displayedComponents: .hourAndMinute)
                        .datePickerStyle(.wheel)
                    Toggle("Alarm on", isOn: $isEnabled)
                }
                .listRowBackground(Somna.card)

                Section("Wake mission") {
                    Toggle("Require camera mission", isOn: $missionEnabled)
                    VStack(alignment: .leading) {
                        Text("Smart wake window: \(Int(wakeWindowMinutes)) min")
                            .font(.system(size: 13))
                            .foregroundStyle(Somna.textDim)
                        Slider(value: $wakeWindowMinutes, in: 0...45, step: 5)
                            .tint(Somna.amber)
                    }
                    Button("Preview mission") { showMissionPreview = true }
                        .foregroundStyle(Somna.amber)
                }
                .listRowBackground(Somna.card)

                Section("Bedtime reminder") {
                    Toggle("Remind me", isOn: $bedtimeReminderEnabled)
                    if bedtimeReminderEnabled {
                        Text("Your goal is \(SleepGoalCalculator.formatted(goalMinutes)) — so we'll remind you around \(bedtimeText).")
                            .font(.system(size: 12))
                            .foregroundStyle(Somna.textFaint)
                    }
                }
                .listRowBackground(Somna.card)

                Section {
                    Text("This schedules a plain notification at a fixed time. The sensor-driven smart alarm that wakes you early during light sleep isn't built yet.")
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
                    Button("Save") { save() }
                        .foregroundStyle(Somna.amber)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
            .onAppear(perform: loadExisting)
            .sheet(isPresented: $showMissionPreview) {
                WakeMissionView()
            }
        }
    }

    private func loadExisting() {
        guard let alarm = existingAlarm else { return }
        time = alarm.time
        isEnabled = alarm.isEnabled
        wakeWindowMinutes = Double(alarm.wakeWindowMinutes)
        missionEnabled = alarm.missionEnabled
        bedtimeReminderEnabled = alarm.bedtimeReminderEnabled
    }

    private func save() {
        let alarm = existingAlarm ?? Alarm(time: time)
        alarm.time = time
        alarm.isEnabled = isEnabled
        alarm.wakeWindowMinutes = Int(wakeWindowMinutes)
        alarm.missionEnabled = missionEnabled
        alarm.bedtimeReminderEnabled = bedtimeReminderEnabled

        if existingAlarm == nil {
            modelContext.insert(alarm)
        }

        let goal = goalMinutes
        Task {
            await NotificationScheduler.shared.schedule(alarm, goalMinutes: goal)
        }
        dismiss()
    }
}

#Preview {
    AlarmSetupView()
        .modelContainer(for: [Alarm.self], inMemory: true)
        .preferredColorScheme(.dark)
}
