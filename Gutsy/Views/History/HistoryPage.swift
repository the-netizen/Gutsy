import SwiftUI
import SwiftData

struct HistoryPage: View {
    @Query(sort: \MealLog.date, order: .reverse) private var allMealLogs: [MealLog]
    @State private var selectedMeal: MealLog? = nil

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 3)

    // Group meals by day label ("Today", "Yesterday", weekday…), preserving recency order
    private var grouped: [(label: String, meals: [MealLog])] {
        let groups = Dictionary(grouping: allMealLogs) { $0.dayLabel }
        // Order sections by each section's newest meal
        return groups
            .map { (label: $0.key, meals: $0.value) }
            .sorted { ($0.meals.first?.date ?? .distantPast) > ($1.meals.first?.date ?? .distantPast) }
    }

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 20) {
                ForEach(grouped, id: \.label) { section in
                    VStack(alignment: .leading, spacing: 10) {
                        Text(section.label)
                            .font(.title3).bold()
                        LazyVGrid(columns: columns, spacing: 12) {
                            ForEach(section.meals) { meal in
                                MealCard(meal: meal, style: .gallery) {
                                    selectedMeal = meal
                                }
                            }
                        }
                    }
                }
            }
            .padding(16)
        }
        .navigationTitle("History")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $selectedMeal) { meal in
            MealInsights(meal: meal)
                .presentationDetents([.fraction(0.8)]) // 80% size
                .presentationDragIndicator(.visible)
                .presentationBackgroundInteraction(.enabled)
        }
    }
}

#Preview {
    // In-memory SwiftData container so @Query works in previews
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: MealLog.self, configurations: config)

    // Sample plants
    let p1 = Plants(name: "Apple", group: SuperSixGroups.fruits.rawValue, benefit: "Rich in fiber")
    let p2 = Plants(name: "Spinach", group: SuperSixGroups.vegetables.rawValue, benefit: "High in iron")
    let p3 = Plants(name: "Lentils", group: SuperSixGroups.legumes.rawValue, benefit: "Great protein")
    let p4 = Plants(name: "Oats", group: SuperSixGroups.wholegrains.rawValue, benefit: "Beta-glucan fiber")
    let p5 = Plants(name: "Almond", group: SuperSixGroups.nutsAndSeeds.rawValue, benefit: "Healthy fats")
    let p6 = Plants(name: "Cinnamon", group: SuperSixGroups.herbsAndSpices.rawValue, benefit: "Warming spice")

    // Helper to make dates: today, yesterday, and 3 days ago
    let calendar = Calendar.current
    let now = Date()
    let yesterday = calendar.date(byAdding: .day, value: -1, to: now)!
    let earlier = calendar.date(byAdding: .day, value: -3, to: now)!

    // Create some sample meals across days
    let meals: [MealLog] = [
        MealLog(date: now, confirmedPlants: [p1, p2], tag: "Lunch", mealInsight: "Nice mix of fruit and veg."),
        MealLog(date: now.addingTimeInterval(-3600), confirmedPlants: [p4, p6], tag: "Breakfast", mealInsight: "Wholegrains and spices boost fiber."),
        MealLog(date: yesterday, confirmedPlants: [p3, p5], tag: "Dinner", mealInsight: "Protein and healthy fats."),
        MealLog(date: earlier, confirmedPlants: [p2, p3, p6], tag: nil, mealInsight: "Greens and legumes are great for diversity.")
    ]

    meals.forEach { container.mainContext.insert($0) }

    return NavigationStack {
        HistoryPage()
    }
    .modelContainer(container)
}

