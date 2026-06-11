import SwiftUI
import SwiftData

struct MealInsights: View {
    @Bindable var meal: MealLog
    @State private var isEditingTag = false
    @State private var draftTag = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text(meal.formattedDate).font(.title3).bold()

                // Image + (insight over tag)
                HStack(alignment: .top, spacing: 12) {
                    mealImage
                    VStack(alignment: .leading, spacing: 10) {
                        MealInsightsAI(insight: meal.mealInsight)
                        tagControl
                    }
                }

                ingredientsSection
                MealInsightGraph(meal: meal)
            }
            .padding(20)
        }
    }

    private var mealImage: some View {
        Group {
            if let filename = meal.imagePath,
               let uiImage = ImageStorage.load(from: filename) {
                Image(uiImage: uiImage).resizable().scaledToFill()
            } else {
                Color(.systemGray5)
            }
        }
        .frame(width: 130, height: 130)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    @ViewBuilder
    private var tagControl: some View {
        if let tag = meal.tag, !tag.isEmpty, !isEditingTag {
            TagPill(text: tag) { meal.tag = nil }
        } else if isEditingTag {
            EditableTagPill(text: $draftTag) {
                let t = draftTag.trimmingCharacters(in: .whitespaces)
                meal.tag = t.isEmpty ? nil : t
                isEditingTag = false
            }
        } else {
            Button {
                draftTag = ""
                isEditingTag = true
            } label: {
                TagPill(text: "Add Tag")
            }
            .buttonStyle(.plain)
        }
    }

    private var ingredientsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Ingredients").font(.headline)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(meal.confirmedPlants, id: \.name) { plant in
                        MealInsightIngredientBox(plant: plant)
                    }
                }
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: MealLog.self, configurations: config)

    let mock = MealLog(confirmedPlants: [
        Plants(name: "Strawberry", group: "Fruits", benefit: "Rich in vitamin C and antioxidants that support immunity and health."),
        Plants(name: "Cauliflower", group: "Vegetables", benefit: "High in fibre and vitamins that help digestion and immunity."),
        Plants(name: "Coffee", group: "Herbs & Spices", benefit: "Contains caffeine and antioxidants that boost energy and focus."),
        Plants(name: "Rice", group: "Wholegrains", benefit: "Provides carbohydrates that give the body energy.")
    ])
    mock.mealInsight = "This meal is rich in natural fruits and fiber, supporting digestion, gut diversity, and overall wellness."
    container.mainContext.insert(mock)

    return MealInsights(meal: mock).modelContainer(container)
}
