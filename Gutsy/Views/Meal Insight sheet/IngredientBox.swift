import SwiftUI

struct IngredientBox: View {
    let plant: Plants
    var onDelete: (() -> Void)? = nil       // ← new

    private var headerColor: Color {
        plant.groupEnum?.color ?? Color(.systemGray4)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 4) {
                Text(plant.name)
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(.primary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                Spacer()
                if let onDelete {
                    Button(action: onDelete) {
                        Image(systemName: "xmark")
                            .foregroundColor(.primary.opacity(0.6))
                            .font(.body)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(headerColor)

            Text(plant.benefit)
                .font(.caption)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .fixedSize(horizontal: false, vertical: true)
                .padding(12)

            Spacer(minLength: 0)
        }
        .frame(width: 150)
        .frame(minHeight: 150)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(.systemGray5), lineWidth: 1))
        .dynamicTypeSize(...DynamicTypeSize.accessibility2)
    }
}
#Preview {
    HStack(spacing: 12) {
        IngredientBox(plant: Plants(name: "Strawberry", group: "Fruits",
            benefit: "Rich in vitamin C and antioxidants that support immunity and health."))
        IngredientBox(plant: Plants(name: "Coffee", group: "Herbs & Spices",
            benefit: "Contains caffeine and antioxidants that boost energy and focus."))
    }
    .padding()
    .background(Color(.systemGray6))
}
