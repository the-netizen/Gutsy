import Foundation

struct GroupBar: Identifiable {
    let group: SuperSixGroups
    let count: Int
    let share: Double          // 0.0...1.0 — this group's portion of the meal
    var id: SuperSixGroups { group }
}

enum MealGraphData {
    static func bars(for meal: MealLog) -> [GroupBar] {
        let counts = SuperSixGroups.allCases.map { group in
            (group, meal.countPerGroup[group.rawValue] ?? 0)
        }
        let total = counts.reduce(0) { $0 + $1.1 }

        return counts.map { group, count in
            GroupBar(
                group: group,
                count: count,
                share: total > 0 ? Double(count) / Double(total) : 0
            )
        }
    }
}
