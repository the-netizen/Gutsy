import SwiftUI

struct MealInsightsAI: View {
    let insight: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack{
                Image(systemName: "sparkles")
                    .foregroundColor(.pink)
                Text("Meal Insight")
                    .font(.body).bold()
                    .foregroundColor(.pink)
            }
            Text(insight ?? "No insight available for this meal yet.")
                .font(.subheadline)
                .foregroundColor(.primary.opacity(0.8))
                .fixedSize(horizontal: false, vertical: true) //grows down
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color.pink.opacity(0.12))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .dynamicTypeSize(...DynamicTypeSize.accessibility2) // clip extreme scaling
    }
}

#Preview {
    MealInsightsAI(insight: "This meal is rich in natural fruits and fiber, supporting digestion, gut diversity, and overall wellness.")
        .padding()
}
