import Foundation
import UserNotifications
import UIKit

class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationManager()
    private let reminderID = "dailyMealReminder"

    private override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }

    func requestPermission() async -> Bool {
        (try? await UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge])) ?? false
    }

    // Lets banners show even while the app is open in the foreground —
    // mainly so the DEBUG test button is actually visible when tapped.
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound])
    }

    func refreshDailyReminder(
        mealLogs: [MealLog],
        plantsPerWeekCount: Int,
        currentStreak: Int,
        laggingGroup: SuperSixGroups?
    ) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [reminderID])

        let calendar = Calendar.current
        guard !mealLogs.contains(where: { calendar.isDateInToday($0.date) }) else {
            print("✅ NotificationManager: already logged today — no reminder scheduled")
            return
        }

        center.getNotificationSettings { settings in
            // 0 = not determined, 1 = denied, 2 = authorized, 3 = provisional, 4 = ephemeral
            print("📋 NotificationManager: authorization status raw value — \(settings.authorizationStatus.rawValue)")
        }

        let daysSinceLastLog = Self.daysSinceLastLog(mealLogs, calendar: calendar)

        let decision = NotificationContent(
            daysSinceLastLog: daysSinceLastLog,
            currentStreak: currentStreak,
            plantsPerWeekCount: plantsPerWeekCount,
            laggingGroup: laggingGroup
        )
        let content = makeContent(from: decision)

        var when = DateComponents(); when.hour = 19; when.minute = 30
        let trigger = UNCalendarNotificationTrigger(dateMatching: when, repeats: false)
        center.add(UNNotificationRequest(identifier: reminderID, content: content, trigger: trigger)) { error in
            if let error {
                print("❌ NotificationManager: failed to schedule — \(error.localizedDescription)")
            } else {
                print("🔔 NotificationManager: scheduled for 19:30 — \"\(content.title)\"")
            }
        }
    }

    // Calendar-day distance
    // so a log at 11:58pm followed by a check 4 minutes later still reads as a day boundary crossed.
    private static func daysSinceLastLog(_ mealLogs: [MealLog], calendar: Calendar) -> Int {
        mealLogs.first.map {
            calendar.dateComponents(
                [.day],
                from: calendar.startOfDay(for: $0.date),
                to: calendar.startOfDay(for: .now)
            ).day ?? .max
        } ?? .max
    }

    // put notif content in real system notification.
    private func makeContent(from decision: NotificationContent) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.sound = .default
        content.title = decision.title
        content.body = decision.body
        attach(decision.imageGroup, to: content)
        return content
    }

    private func attach(_ group: SuperSixGroups?, to content: UNMutableNotificationContent) {
        guard let group,
              let image = UIImage(named: group.bacteriaImage),
              let data = image.pngData() else { return }
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString + ".png")
        guard (try? data.write(to: url)) != nil,
              let attachment = try? UNNotificationAttachment(identifier: group.bacteriaImage, url: url) else { return }
        content.attachments = [attachment]
    }

    #if DEBUG
//    /// Fires the currently-computed reminder content in 5 seconds, bypassing the
//    /// "already logged today" check and the 19:30 schedule — testing only.
//    /// Compiled out of release builds, so it can never ship.
//    func debugFireNow(
//        mealLogs: [MealLog],
//        plantsPerWeekCount: Int,
//        currentStreak: Int,
//        laggingGroup: SuperSixGroups?
//    ) {
//        let calendar = Calendar.current
//        let daysSinceLastLog = Self.daysSinceLastLog(mealLogs, calendar: calendar)
//        let decision = NotificationContent(
//            daysSinceLastLog: daysSinceLastLog,
//            currentStreak: currentStreak,
//            plantsPerWeekCount: plantsPerWeekCount,
//            laggingGroup: laggingGroup
//        )
//        let content = makeContent(from: decision)
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
//        UNUserNotificationCenter.current().add(
//            UNNotificationRequest(identifier: "debugReminder", content: content, trigger: trigger)
//        )
//        print("🧪 NotificationManager: debug reminder firing in 5s — \"\(content.title)\"")
//    }
    #endif
}
