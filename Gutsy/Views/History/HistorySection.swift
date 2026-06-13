import SwiftUI
import SwiftData

struct HistorySection: View {
    let meals: [MealLog]
    @State private var selectedMeal: MealLog? = nil

    private let contentHeight: CGFloat = 160 //to keep it stable

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            header
            content
                .frame(height: contentHeight)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(.systemBackground))
            
        )
        .sheet(item: $selectedMeal) { meal in
            MealInsights(meal: meal)
                .presentationDetents([.fraction(0.8), .large])
                .presentationDragIndicator(.visible)
        }
    }

    private var header: some View {
        HStack {
            Text("History")
                .font(.body)
                .bold()
            Spacer()
            NavigationLink(destination: HistoryPage()) {
                Text("More >")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }
        }
    }

    @ViewBuilder
    private var content: some View {
        if !meals.isEmpty {
            mealScroll
        } else {
            emptyState
        }
    }

    // Most recent meal is leftmost
    private var mealScroll: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(meals.prefix(10)) { meal in
                    MealCard(meal: meal, style: .compact) {
                        selectedMeal = meal
                    }
                }
            }
            .padding(.vertical, 6) // below cards
        }//scroll
    }

    private var emptyState: some View {
        Text("No meals logged yet — tap + to add your first meal")
            .font(.system(size: 13))
            .foregroundColor(.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}
#Preview("With meals") {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: MealLog.self, Tag.self, configurations: config)

    let healthy = Tag(name: "Healthy Meal", colorName: "color_fruits")
    let mocks = (0..<4).map { i in
        MealLog(
            date: Calendar.current.date(byAdding: .hour, value: -i * 3, to: Date()) ?? Date(),
            confirmedPlants: [],
            tags: i == 0 ? [healthy] : []
        )
    }
    mocks.forEach { container.mainContext.insert($0) }

    return HistorySection(meals: mocks)
        .padding()
        .background(Color(.systemGray6))
        .modelContainer(container)
}

#Preview("Empty") {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: MealLog.self, Tag.self, configurations: config)

    return HistorySection(meals: [])
        .padding()
        .background(Color(.systemGray6))
        .modelContainer(container)
}
