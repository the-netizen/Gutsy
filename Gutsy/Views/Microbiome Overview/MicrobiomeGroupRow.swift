import SwiftUI

struct MicrobiomeGroupRow: View {
    let group: SuperSixGroups
    let count: Int
    let progress: Double          // 0.0...1.0
    let isExpanded: Bool
    let onToggle: () -> Void

    // red → orange → green by how full the bar is
    private var barColor: Color {
        switch progress {
        case 0..<0.34:  return .red
        case 0.34..<0.67: return .orange
        default:        return .green
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            // Tappable header row
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

                    progressBar
                        .frame(width: 100)

                    Image(systemName: "chevron.down")
                        .foregroundColor(.secondary)
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 12)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            // Expanded detail
            if isExpanded {
                Divider().padding(.horizontal, 14)
                Text(group.description)
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 12)
            }
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
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
        count: 3,
        progress: 0.3,
        isExpanded: false,
        onToggle: {}
    )
    .padding()
//    .previewLayout(.sizeThatFits)
}

#Preview("Expanded") {
    MicrobiomeGroupRow(
        group: .herbsAndSpices,
        count: 5,
        progress: 1.0,
        isExpanded: true,
        onToggle: {}
    )
//    .padding()
//    .previewLayout(.sizeThatFits)
}
