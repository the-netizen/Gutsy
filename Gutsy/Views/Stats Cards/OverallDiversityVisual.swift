import SwiftUI

struct OverallDiversityVisual: View {
    let percentage: Double

    var body: some View {
        ZStack {
            // Grey background ring
            Circle()
                .stroke(Color(.systemGray5), lineWidth: 12)

            // Colored progress ring
            Circle()
                .trim(from: 0, to: min(percentage / 100, 1.0))
                .stroke(
                    ringColor,
                    style: StrokeStyle(lineWidth: 12, lineCap: .round)
                )
                .rotationEffect(.degrees(-90)) // start from top
                .animation(.easeInOut(duration: 0.8), value: percentage)

            // Center text
            VStack(spacing: 2) {
                Text("\(Int(percentage.rounded()))%")
                    .font(.title2)
                    .bold()
                Text(diversityLabel)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(10) // Space between text and ring
        }
    }

    private var ringColor: Color {
        switch percentage {
        case 0..<5:   return Color(.systemGray)
        case 5..<15:  return Color("diversityPoor")
        case 15..<50: return Color("diversityCareful")
        case 50..<75: return Color("diversityAverage")
        default:      return Color("diversityGood")
        }
    }
    private var diversityLabel: String {
        switch percentage {
        case 0..<5:   return "Just starting"
        case 5..<15:  return "Very Poor"
        case 15..<50: return "Careful"
        case 50..<75: return "Average"
        default:      return "Good"
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        OverallDiversityVisual(percentage: 75)
            .frame(width: 100, height: 100)
        OverallDiversityVisual(percentage: 50)
            .frame(width: 100, height: 100)
        OverallDiversityVisual(percentage: 15)
            .frame(width: 100, height: 100)
        OverallDiversityVisual(percentage: 5)
            .frame(width: 100, height: 100)
        OverallDiversityVisual(percentage: 2)
            .frame(width: 100, height: 100)
    }
    .padding()
}
