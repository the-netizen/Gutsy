import SwiftUI
import SwiftData

struct MealInsights: View {
    @Bindable var meal: MealLog

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text(meal.formattedDate).font(.title3).bold()

//                HStack(alignment: .top, spacing: 12) {
//                    mealImage
                    AI_Insights(insight: meal.mealInsight)
//                }
                MealTagEditor(meal: meal)
                IngredientsEditor(meal: meal)
                MealInsightGraph(meal: meal)
                MealDeleteButton(meal: meal)
            }
            .padding(20)
        }
        .background(Color(.systemBackground))
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
