import Foundation

struct NotificationContent {
    let title: String
    let body: String
    let imageGroup: SuperSixGroups?   // mascot to attach, if any

    init(daysSinceLastLog: Int, currentStreak: Int, plantsPerWeekCount: Int, laggingGroup: SuperSixGroups?) {
        switch daysSinceLastLog {
        case 0...1 where currentStreak >= 2:
            title = "🔥 \(currentStreak)-day streak"
            body = "Log tonight's meal to keep it going!"
            imageGroup = laggingGroup
        case 0...1:
            let remaining = max(0, 30 - plantsPerWeekCount)
            title = "\(plantsPerWeekCount)/30 plants this week 🌱"
            body = remaining > 0
                ? "\(remaining) more to hit your weekly goal\(laggingGroup.map { " — try some \($0.rawValue)" } ?? "")."
                : "You hit your goal — log today's meal to keep the momentum."
            imageGroup = laggingGroup
        case 2...3:
            title = "Missed a couple days"
            body = "No pressure — snap your next meal whenever you're ready."
            imageGroup = nil
        case 4...13:
            title = "Still here 👋"
            body = "Pick up right where you left off."
            imageGroup = nil
        default:
            title = "Gutsy"
            body = "Wanna check in on your gut health today?"
            imageGroup = nil
        }
    }
}
