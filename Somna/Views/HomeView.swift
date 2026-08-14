import SwiftUI

struct HomeView: View {
    let score = 88
    let sleepDuration = "7s 52d"
    let efficiency = "%94"

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    header
                    integrationRow
                    scoreRing
                    statRow
                }
                .padding(20)
            }
            .background(Somna.ink.ignoresSafeArea())
            .navigationBarHidden(true)
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text("Somna")
                    .font(Somna.Font.serif(15))
                    .foregroundStyle(Somna.textDim)
                Spacer()
                FreeTag()
            }
            Text("İyi geceler, Tayfun")
                .font(.system(size: 12))
                .foregroundStyle(Somna.textFaint)
        }
    }

    private var integrationRow: some View {
        HStack(spacing: 8) {
            IntegrationPill(label: "Health senkron")
            IntegrationPill(label: "Watch bağlı")
            Spacer()
        }
    }

    private var scoreRing: some View {
        HStack(spacing: 18) {
            ZStack {
                Circle()
                    .stroke(Somna.hair, lineWidth: 8)
                Circle()
                    .trim(from: 0, to: CGFloat(score) / 100)
                    .stroke(Somna.amber, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                Text("\(score)")
                    .font(Somna.Font.serif(22))
                    .foregroundStyle(Somna.textPrimary)
            }
            .frame(width: 92, height: 92)

            VStack(alignment: .leading, spacing: 2) {
                Text("Çok iyi")
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(Somna.textPrimary)
                Text("Son 7 gece · Watch verisiyle")
                    .font(.system(size: 12))
                    .foregroundStyle(Somna.textFaint)
            }
        }
    }

    private var statRow: some View {
        HStack(spacing: 10) {
            StatCard(label: "Uyku süresi", value: sleepDuration, delta: "▲ 6 dk", up: true)
            StatCard(label: "Verimlilik", value: efficiency, delta: "▼ %1", up: false)
        }
    }
}

private struct FreeTag: View {
    var body: some View {
        Text("ÜCRETSİZ")
            .font(.system(size: 10, weight: .medium))
            .foregroundStyle(Somna.free)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(Somna.free.opacity(0.12))
            .overlay(Capsule().strokeBorder(Somna.free.opacity(0.3), lineWidth: 0.5))
            .clipShape(Capsule())
    }
}

private struct IntegrationPill: View {
    let label: String
    var body: some View {
        HStack(spacing: 4) {
            Circle().fill(Somna.free).frame(width: 5, height: 5)
            Text(label)
                .font(.system(size: 10))
                .foregroundStyle(Somna.textFaint)
        }
        .padding(.horizontal, 9)
        .padding(.vertical, 4)
        .overlay(Capsule().strokeBorder(Somna.hair, lineWidth: 0.5))
    }
}

private struct StatCard: View {
    let label: String
    let value: String
    let delta: String
    let up: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label.uppercased())
                .font(.system(size: 9.5, weight: .medium))
                .foregroundStyle(Somna.textFaint)
            Text(value)
                .font(Somna.Font.mono(16))
                .foregroundStyle(Somna.textPrimary)
            Text(delta)
                .font(Somna.Font.mono(9.5))
                .foregroundStyle(up ? Somna.stageLight : Somna.stageAwake)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassCard(padding: 12)
    }
}

#Preview {
    HomeView().preferredColorScheme(.dark)
}
