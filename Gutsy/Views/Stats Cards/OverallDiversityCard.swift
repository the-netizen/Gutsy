import SwiftUI

struct OverallDiversityCard: View {
    let percentage: Double

    var body: some View {
        FlippableCard {
            // ring visual
            frontContent
        } back: {
            // description text
            backContent
        }
        .frame(height: 180)
    }

    // MARK: - Front

    private var frontContent: some View {
        VStack {
            Text("Overall Diversity")
                .font(.body)
                .bold()
                .padding(.top, 16)

            Spacer()

            // Ring graph
            OverallDiversityVisual(percentage: percentage)
                .frame(width: 100, height: 100)

            Spacer()
        }
        .padding(.horizontal, 16)
    }

    // MARK: - Back

    private var backContent: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Overall Diversity")
                .font(.body)
                .bold()
                .padding(.top, 16)

            Text("Your overall gut diversity! This tracks the variety in your gut microbiome, building up continuously from your very first meal to your last.")
                .font(.caption)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            Spacer()
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    HStack {
        OverallDiversityCard(percentage: 70)
        OverallDiversityCard(percentage: 20)
    }
    .padding()
    .background(Color(.systemGray6))
}
