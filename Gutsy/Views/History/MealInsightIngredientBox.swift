import SwiftUI

struct MealInsightIngredientBox: View {
    let plant: Plants

    private var headerColor: Color {
        plant.groupEnum?.color ?? Color(.systemGray4)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // header
            Text(plant.name)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(headerColor)

            // Benefit
            Text(plant.benefit)
                .font(.system(size: 12))
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .fixedSize(horizontal: false, vertical: true) //grows down
                .padding(12)
            Spacer(minLength: 0) 
        }
        .frame(width: 130)
        .frame(minHeight: 150) //can scale
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(.systemGray5), lineWidth: 1))
    }
}

#Preview {
    HStack(spacing: 12) {
        MealInsightIngredientBox(plant: Plants(name: "Strawberry", group: "Fruits",
            benefit: "Rich in vitamin C and antioxidants that support immunity and health."))
        MealInsightIngredientBox(plant: Plants(name: "Coffee", group: "Herbs & Spices",
            benefit: "Contains caffeine and antioxidants that boost energy and focus."))
    }
    .padding()
    .background(Color(.systemGray6))
}
