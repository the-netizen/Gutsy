import SwiftUI

struct HistorySection: View {
    let meals: [MealLog]
    let onMoreTapped: () -> Void
    let onMealTapped: (MealLog) -> Void

    private let contentHeight: CGFloat = 160 //to keep it stable

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            header
            content
                .frame(height: contentHeight)
        }
        .padding(16)
        .background(
            // Rounded background without clipping inner shadows
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(.systemBackground))
        )
    }

    private var header: some View {
        HStack {
            Text("History")
                .font(.system(size: 17, weight: .semibold))
            Spacer()
            Button(action: onMoreTapped) {
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
                        onMealTapped(meal)
                    }
                }
            }
//            .padding(.vertical, 3) // below cards
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
    let mocks = (0..<4).map { i in
        MealLog(
            date: Calendar.current.date(
                byAdding: .hour, value: -i * 3, to: Date()
            ) ?? Date(),
            imagePath: nil,
            confirmedPlants: [],
            tag: i == 0 ? "Healthy Meal" : nil
        )
    }
    HistorySection(
        meals: mocks,
        onMoreTapped: {},
        onMealTapped: { _ in }
    )
    .padding()
    .background(Color(.systemGray6))
}

#Preview("Empty") {
    HistorySection(
        meals: [],
        onMoreTapped: {},
        onMealTapped: { _ in }
    )
    .padding()
    .background(Color(.systemGray6))
}
