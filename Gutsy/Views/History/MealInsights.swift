import SwiftUI
import SwiftData

struct MealInsights: View {
    @Bindable var meal: MealLog
    @Environment(\.modelContext) private var modelContext

    @State private var isEditingTag = false
    @State private var draftTag = ""
    @State private var draftColor = Tag.palette.first ?? "color_fruits"

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text(meal.formattedDate).font(.title3).bold()

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
        // One tag per meal: show it if present
        if let tag = meal.tags.first, !isEditingTag {
            TagPill(tag: tag) {
                meal.tags.removeAll()          // remove → back to "Add Tag"
            }
        } else if isEditingTag {
            VStack(alignment: .leading, spacing: 8) {
                EditableTagPill(text: $draftTag) { commitTag() }
                colorPicker
            }
        } else {
            Button {
                draftTag = ""
                isEditingTag = true
            } label: {
                Label("Add Tag", systemImage: "tag")
                    .font(.system(.caption, weight: .medium))
                    .padding(.horizontal, 10).padding(.vertical, 6)
                    .background(Color(.systemBackground))
                    .clipShape(Capsule())
                    .overlay(Capsule().stroke(Color(.systemGray4), lineWidth: 0.5))
            }
            .buttonStyle(.plain)
        }
    }

    // Six asset-color swatches
    private var colorPicker: some View {
        HStack(spacing: 8) {
            ForEach(Tag.palette, id: \.self) { name in
                Circle()
                    .fill(Color(name))
                    .frame(width: 22, height: 22)
                    .overlay(
                        Circle().stroke(Color.primary,
                                        lineWidth: draftColor == name ? 2 : 0)
                    )
                    .onTapGesture { draftColor = name }
            }
        }
    }

    private func commitTag() {
        let name = draftTag.trimmingCharacters(in: .whitespaces)
        guard !name.isEmpty else { isEditingTag = false; return }
        let tag = TagStorage.findOrCreate(name: name, colorName: draftColor, in: modelContext)
        meal.tags = [tag]                       // one tag per meal
        isEditingTag = false
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
    let container = try! ModelContainer(for: MealLog.self, Tag.self, configurations: config)

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
