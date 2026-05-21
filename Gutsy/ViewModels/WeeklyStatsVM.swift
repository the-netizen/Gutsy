import Foundation
internal import Combine

@MainActor
class WeeklyStatsVM: ObservableObject {

    // All meal logs for the current week
    @Published var weeklyLogs: [MealLog] = []

    // Unique plant names logged this week — the 12 in "12/30"
    var uniquePlantsThisWeek: Set<String> {
        let allPlants = weeklyLogs.flatMap { $0.confirmedPlants }
        return Set(allPlants.map { $0.name.lowercased() })
    }

    // The number shown on the card
    var plantCount: Int {
        uniquePlantsThisWeek.count
    }


    // How many unique plants per group this week across all meals
    var countPerGroup: [String: Int] {
        var result: [String: Int] = [:]
        let allPlants = weeklyLogs.flatMap { $0.confirmedPlants }

        // Count unique plant names per group
        for group in SuperSixGroups.allCases {
            let plantsInGroup = allPlants
                .filter { $0.group == group.rawValue }
                .map { $0.name.lowercased() }
            result[group.rawValue] = Set(plantsInGroup).count
        }
        return result
    }

    // How many of the 6 groups have at least 1 plant logged
    var groupsCovered: Int {
        countPerGroup.values.filter { $0 > 0 }.count
    }

    // The 70% number shown on the ring
    var diversityPercentage: Double {
        let quantityScore = min(Double(plantCount), 30.0) / 30.0
        let balanceScore = Double(groupsCovered) / Double(SuperSixGroups.allCases.count)
        return ((quantityScore + balanceScore) / 2.0) * 100
    }

    // --make it like UI
    var diversityLabel: String {
        switch diversityPercentage {
        case 0..<25:  return "Just Starting"
        case 25..<50: return "Getting There"
        case 50..<75: return "Good"
        case 75..<90: return "Great"
        default:      return "Excellent"
        }
    }

    // Filters logs to current week only (Monday → Sunday)
    private var currentWeekLogs: [MealLog] {
        let calendar = Calendar.current
        let now = Date()

        guard let weekStart = calendar.dateInterval(of: .weekOfYear, for: now)?.start else {
            return []
        }

        return weeklyLogs.filter { $0.date >= weekStart && $0.date <= now }
    }

    // Count for a specific group — used by the bar charts and group cards
    func count(for group: SuperSixGroups) -> Int {
        countPerGroup[group.rawValue] ?? 0
    }
}
