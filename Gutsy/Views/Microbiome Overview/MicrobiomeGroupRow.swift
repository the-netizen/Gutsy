import SwiftUI

struct MicrobiomeGroupRow: View {
    let group: SuperSixGroups
    let count: Int
    let progress: Double
    let eatenPlants: [Plants]          // ← new
    let isExpanded: Bool
    let onToggle: () -> Void

    private var barColor: Color {
        switch progress {
        case 0..<0.34:    return .red
        case 0.34..<0.67: return .orange
        default:          return .green
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            Button(action: onToggle) {
                HStack(spacing: 15) {
                    Image(group.bacteriaImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 44)

                    Text(group.rawValue)
                        .font(.body)
                        .foregroundColor(.primary)

                    Spacer()

                    progressBar.frame(width: 90)

                    Image(systemName: "chevron.down")
                        .foregroundColor(.secondary)
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 12)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            if isExpanded {
                Divider().padding(.horizontal, 14)
                expandedContent
            }
        }
        .background(.componentInner)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(color: .black.opacity(0.1), radius: 4, y: 4)
    }

    private var expandedContent: some View {
        VStack(alignment: .leading, spacing: 10) {

            // Short group description
            Text(group.description)
                .font(.footnote)
                .foregroundColor(.secondary)

            Divider()

            // Eaten this week
            VStack(alignment: .leading, spacing: 6) {
                Text("Eaten this week")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)

                if eatenPlants.isEmpty {
                    Text("No \(group.rawValue.lowercased()) logged yet this week.")
                        .font(.caption)
                        .foregroundColor(Color(.systemGray3))
                } else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 6) {
                            ForEach(eatenPlants, id: \.name) { plant in
                                Text(plant.name.capitalized)
                                    .font(.caption2)
                                    .foregroundColor(.primary)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(group.color.opacity(0.2))
                                    .clipShape(Capsule())
                                    .overlay(
                                        Capsule().stroke(group.color.opacity(0.4), lineWidth: 0.5)
                                    )
                            }
                        }
                    }
                }
            }
        }
        .padding(12)
    }

    private var progressBar: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule().fill(Color(.systemGray5))
                Capsule()
                    .fill(barColor)
                    .frame(width: max(6, geo.size.width * progress))
            }
        }
        .frame(height: 8)
    }
}

#Preview("Collapsed") {
    MicrobiomeGroupRow(
        group: .fruits,
        count: 2,
        progress: 0.4,
        eatenPlants: [],
        isExpanded: false,
        onToggle: {}
    )
    .padding()
}

#Preview("Expanded — with plants") {
    MicrobiomeGroupRow(
        group: .fruits,
        count: 3,
        progress: 0.6,
        eatenPlants: [
            Plants(name: "Apple", group: "Fruits", benefit: ""),
            Plants(name: "Strawberry", group: "Fruits", benefit: ""),
            Plants(name: "Banana", group: "Fruits", benefit: "")
        ],
        isExpanded: true,
        onToggle: {}
    )
    .padding()
}

#Preview("Expanded — none eaten") {
    MicrobiomeGroupRow(
        group: .legumes,
        count: 0,
        progress: 0,
        eatenPlants: [],
        isExpanded: true,
        onToggle: {}
    )
    .padding()
}
