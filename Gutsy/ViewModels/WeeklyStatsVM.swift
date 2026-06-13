import Foundation
internal import Combine

@MainActor
class WeeklyStatsVM: ObservableObject {
    
    @Published var allMealLogs: [MealLog] = [] //full meal history

    private var weeklyLogs: [MealLog] { //weekly meal history
        let calendar = Calendar.current

        // Get the start of the current week (Monday 00:00)
        guard let weekStart = calendar.dateInterval(
            of: .weekOfYear, for: Date()
        )?.start else { return [] }

        return allMealLogs.filter {
            $0.date >= weekStart && $0.date <= Date() //filters to only current week
        }
    }

    // MARK: - Plants Per Week (the 12/30 card)

    // Collects every plant from every meal this week and deduplicates by name
    var uniquePlantsThisWeek: Set<String> {
        let allPlants = weeklyLogs.flatMap { $0.confirmedPlants }
        return Set(allPlants.map { $0.name.lowercased() })
    }

    // The number displayed on the Plants per Week card e.g. "12"
    var plantsPerWeekCount: Int {
        uniquePlantsThisWeek.count
    }

    // MARK: - Overall Diversity (the ring card)

    // Counts unique plants per Super Six group this week
    var countPerGroup: [String: Int] {
        var result: [String: Int] = [:]
        let allPlants = weeklyLogs.flatMap { $0.confirmedPlants }

        for group in SuperSixGroups.allCases {
            // Filter plants belonging to this group then deduplicate
            let uniqueInGroup = Set(
                allPlants
                    .filter { $0.group == group.rawValue }
                    .map { $0.name.lowercased() }
            )
            result[group.rawValue] = uniqueInGroup.count
        }
        return result
    }

    // How many of the 6 groups the user has eaten from this week
    var plantGroupsEaten: Int {
        countPerGroup.values.filter { $0 > 0 }.count
    }
    
    func plantsEaten(for group: SuperSixGroups) -> [Plants] {
        var seen = Set<String>()
        return weeklyLogs
            .flatMap { $0.confirmedPlants }
            .filter { $0.group == group.rawValue }
            .filter { seen.insert($0.name.lowercased()).inserted }  // dedupe
    }
    // The percentage shown on the Overall Diversity ring e.g. 70.0
    // Combines two scores:
    // - Quantity score: how close to 30 plants (out of 30)
    // - Balance score: how many of the 6 groups are covered (out of 6)
    // Both weighted equally at 50% each
    var diversityPercentage: Double {
        let quantityScore = min(Double(plantsPerWeekCount), 30.0) / 30.0
        let balanceScore = Double(plantGroupsEaten) / Double(SuperSixGroups.allCases.count)
        return ((quantityScore + balanceScore) / 2.0) * 100
    }

    var diversityLabel: String {
        switch diversityPercentage {
        case 0..<25:  return "Just Starting"
        case 25..<50: return "Getting There"
        case 50..<75: return "Good"
        case 75..<90: return "Great"
        default:      return "Excellent"
        }
    }

    // Returns the unique plant count for one specific group
    // Used by individual group stat bars in Microbiome Overview
    func count(for group: SuperSixGroups) -> Int {
        countPerGroup[group.rawValue] ?? 0
    }
    
    // Target unique plants per group for a "full" bar. Tune as you like.
    let perGroupTarget = 5

    // 0.0...1.0 fill for a group's bar
    func progress(for group: SuperSixGroups) -> Double {
        min(Double(count(for: group)) / Double(perGroupTarget), 1.0)
    }
}
