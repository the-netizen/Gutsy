import SwiftUI
import SwiftData

struct HistoryPage: View {
    @Query(sort: \MealLog.date, order: .reverse) private var allMealLogs: [MealLog]
    @Query(sort: \Tag.name) private var allTags: [Tag]
    @State private var filter = TagFilterState()
    @State private var showFilterPanel = false
    @State private var selectedMeal: MealLog? = nil

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 5), count: 3)

    //filter by tags
    private var filteredMeals: [MealLog] {
        filter.apply(to: allMealLogs)
    }

    // Group meals by day label
    private var grouped: [(label: String, meals: [MealLog])] {
        let groups = Dictionary(grouping: filteredMeals) { $0.dayLabel }
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
        .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            showFilterPanel.toggle()
                        } label: {
                            Image(systemName: "line.3.horizontal.decrease")
                        }
                        .tint(filter.isFiltering ? .accentColor : .primary)
                        //i want to change bg color of button if filter is on
                    }
                }
                .overlay(alignment: .topTrailing) {
                    if showFilterPanel {
                        TagFilterPanel(allTags: allTags, filter: filter)
                            .padding(.top, 8).padding(.trailing, 12)
                            .transition(.opacity.combined(with: .move(edge: .top)))
                    }
                }
                .animation(.easeInOut(duration: 0.15), value: showFilterPanel)
                .sheet(item: $selectedMeal) { meal in
                    MealInsights(meal: meal)
                        .presentationDetents([.fraction(0.8), .large])
                        .presentationDragIndicator(.visible)
                }
    }
}
#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: MealLog.self, Tag.self, configurations: config)

    // Sample tags
    let healthy   = Tag(name: "Healthy Meal", colorName: "color_fruits")
    let highFruit = Tag(name: "High fruits", colorName: "color_vegetables")
    let highFiber = Tag(name: "High Fiber", colorName: "color_herbs")
    [healthy, highFruit, highFiber].forEach { container.mainContext.insert($0) }

    let p1 = Plants(name: "Apple", group: SuperSixGroups.fruits.rawValue, benefit: "Rich in fiber")
    let p2 = Plants(name: "Spinach", group: SuperSixGroups.vegetables.rawValue, benefit: "High in iron")

    let now = Date()
    let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: now)!

    let meals: [MealLog] = [
        MealLog(date: now, confirmedPlants: [p1, p2], tags: [healthy]),
        MealLog(date: now.addingTimeInterval(-3600), confirmedPlants: [p1], tags: [highFruit]),
        MealLog(date: yesterday, confirmedPlants: [p2], tags: [highFiber]),
        MealLog(date: yesterday.addingTimeInterval(-7200), confirmedPlants: [p1, p2], tags: [])
    ]
    meals.forEach { container.mainContext.insert($0) }

    return NavigationStack { HistoryPage() }
        .modelContainer(container)
}
