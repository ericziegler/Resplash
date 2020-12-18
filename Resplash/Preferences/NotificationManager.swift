//
//  UserNotifications.swift
//  Resplash
//
//  Created by Eric Ziegler on 12/15/20.
//

import Foundation
import UserNotifications

// MARK: - Constants

fileprivate let NotificationReminderCategory = "reminder"

// MARK: - TypeAliases

typealias NotificationsCompletionBlock = (_ permissionGranted: Bool) -> ()

class NotificationManager {

    // MARK: - Properties

    private let center = UNUserNotificationCenter.current()

    // MARK: - Init

    static let shared = NotificationManager()

    init() {

    }

    // MARK: - Permissions

    func checkPermissionsWith(completion: NotificationsCompletionBlock?) {
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            completion?(granted)
        }
    }

    // MARK: - Setup Notifications

    func setupNotificationsBetween(startComponents: DateComponents, endComponents: DateComponents, hourInterval: Int, repeats: Bool = true) {
        // starting with the start hour, add a notification every interval until you reach the end hour
        // the notification will repeat daily

        var components = DateComponents()
        components.hour = startComponents.hour
        components.minute = startComponents.minute

        // add one hour to endComponents to make sure the final end time is included
        while components.hour! < endComponents.hour! + 1 {
            // create and add the notification
            let content = UNMutableNotificationContent()
            content.title = "Time to Resplash!"
            content.body = "Be sure to drink at least 8 oz. of water this hour."
            content.categoryIdentifier = NotificationReminderCategory
            content.sound = UNNotificationSound.default
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: repeats)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)

            // add the hour interval to the date and go back through the loop
            components.hour = components.hour! + hourInterval
        }
    }

    // MARK: - Remove Notifications

    func unscheduleAllNotifications() {
        center.removeAllPendingNotificationRequests()
    }

    func clearDeliveredNotifications() {
        center.removeAllDeliveredNotifications()
    }

}
