import SwiftUI

struct PlantsPerWeekCard: View {
    let plantCount: Int

    var body: some View {
        FlippableCard {
            frontContent
        } back: {
            backContent
        }
        .frame(height: 180)
    }

    // MARK: - Front

    private var frontContent: some View {
        VStack(spacing: 4) {
            Text("Plants per Week")
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.primary)
                .padding(.top, 16)
            Spacer()
            
            ZStack {
                PlantsPerWeekVisual(progress: Double(plantCount) / 30.0)
                    .frame(width: 100, height: 100)

                Text("\(plantCount)/30")
                    .font(.system(size: 20, weight: .bold))
            }

            Spacer()
        }
        .padding(.horizontal, 12)
    }

    // MARK: - Back

    private var backContent: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Plants per Week")
                .font(.system(size: 15, weight: .semibold))
                .padding(.top, 16)

            Text("Your weekly goal! Every new plant-based food you add this week helps feed and diversify the good bacteria in your gut.")
                .font(.system(size: 13))
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            Spacer()
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    HStack {
        PlantsPerWeekCard(plantCount: 15)
    }
    .padding()
    .background(Color(.systemGray6))
}
