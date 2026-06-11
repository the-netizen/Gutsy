import Foundation

@Observable
final class TagFilterState {
    var selectedNames: Set<String> = []

    func toggle(_ tag: Tag) {
        if selectedNames.contains(tag.name) {
            selectedNames.remove(tag.name)
        } else {
            selectedNames.insert(tag.name)
        }
    }

    func isSelected(_ tag: Tag) -> Bool { selectedNames.contains(tag.name) }

    var isFiltering: Bool { !selectedNames.isEmpty }

    func clear() { selectedNames.removeAll() }

    // Meal passes if it has ANY selected tag (multi-select OR)
    func apply(to meals: [MealLog]) -> [MealLog] {
        guard isFiltering else { return meals }
        return meals.filter { meal in
            meal.tags.contains { selectedNames.contains($0.name) }
        }
    }
}
