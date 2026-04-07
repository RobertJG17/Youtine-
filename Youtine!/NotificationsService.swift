//
//  NotificationsService.swift
//  Youtine!
//
//  Created by Bobby Guerra on 3/19/26.
//


//
//  NotificationsManager.swift
//  Youtine
//
//  Created by Bobby Guerra on 2/7/25.
//

import UserNotifications

struct NotificationsService {
    static let shared: NotificationsService = .init()
    
    private init() {}
    
    // ???: Function is static so it can be invoked after a user signs in without creating a NotificationService Instance
    static func promptNotificationsGrant() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("Notifications prompt finished!")
            } else if let error {
                print(error.localizedDescription)
            }
        }
    }
    
    func getDateFromString(timeString: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        formatter.locale = Locale(identifier: "en_US_POSIX") // Ensures correct AM/PM parsing
        let date = formatter.date(from: timeString)
        
        return date!
    }
        
    func getDateComponents(date: Date) -> DateComponents {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.hour, .minute], from: date)
        return dateComponents
    }
    
    func getWeeklyComponents(date: Date) -> DateComponents {
        Calendar.current.dateComponents([.weekday, .hour, .minute], from: date)
    }
    
    func getMonthlyComponents(date: Date) -> DateComponents {
        Calendar.current.dateComponents([.day, .hour, .minute], from: date)
    }
    
    func addNotification(routine: Routine) {
        let content = UNMutableNotificationContent()
        
        content.title = routine.title
        content.sound = UNNotificationSound.default
        content.subtitle = routine.start.formatted(date: .omitted, time: .shortened)
        content.body = routine.habits.first?.label ?? "No habit detected"
        
        var dateComponents = getDateComponents(date: routine.start)
    
        switch Cadence.init(rawValue: routine.cadence) {
            case .daily: dateComponents = getDateComponents(date: routine.start)
            case .monthly: dateComponents = getMonthlyComponents(date: routine.start)
            case .weekly: dateComponents = getWeeklyComponents(date: routine.start)
            case .once, .none: return
        }
    
        // Create a calendar-based trigger
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        // Provision notification request
        let request = UNNotificationRequest(identifier: routine.id.uuidString, content: content, trigger: trigger)

        // add our notification request
        UNUserNotificationCenter.current().add(request)
    }
    
    func updateNotification(routine: Routine) {
        // Remove the existing notification
        deleteNotification(id: routine.id.uuidString)

        // Re-add the notification with the new start time
        addNotification(routine: routine) // Adjust index if needed
    }
    
    func deleteNotification(id: String) {
        // Remove the existing notification
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
    }
}
