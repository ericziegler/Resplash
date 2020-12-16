//
//  UserPreferences.swift
//  Resplash
//
//  Created by Eric Ziegler on 12/15/20.
//

import Foundation

// MARK: - Constants

fileprivate let NotificationsOnCacheKey = "NotificationsOnCacheKey"
fileprivate let NotificationsStartTimeCacheKey = "NotificationsStartTimeCacheKey"
fileprivate let NotificationsEndTimeCacheKey = "NotificationsEndTimeCacheKey"

class UserPreferences {

    // MARK: - Properties

    var notificationsOn = false
    var startComponents = DateComponents(hour: 8, minute: 0)
    var endComponents = DateComponents(hour: 22, minute: 0)

    // MARK: - Init

    static let shared = UserPreferences()

    init() {
        load()
    }

    // MARK: - Load / Save

    func load() {
        let defaults = UserDefaults.standard
        if let notificationsOnValue = defaults.object(forKey: NotificationsOnCacheKey) as? NSNumber {
            notificationsOn = notificationsOnValue.boolValue
        }
        if let startData = defaults.object(forKey: NotificationsStartTimeCacheKey) as? Data, let endData = defaults.object(forKey: NotificationsEndTimeCacheKey) as? Data {
            do {
                if let cachedStartComponents = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(startData) as? DateComponents {
                    startComponents = cachedStartComponents
                }
                if let cachedEndComponents = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(endData) as? DateComponents {
                    endComponents = cachedEndComponents
                }
            } catch {
                print("Could not load start/end notification time.")
            }
        }
    }

    func save() {
        let defaults = UserDefaults.standard
        defaults.set(NSNumber(booleanLiteral: notificationsOn), forKey: NotificationsOnCacheKey)
        do {
            let startData = try NSKeyedArchiver.archivedData(withRootObject: startComponents, requiringSecureCoding: false)
            defaults.set(startData, forKey: NotificationsStartTimeCacheKey)
            let endData = try NSKeyedArchiver.archivedData(withRootObject: endComponents, requiringSecureCoding: false)
            defaults.set(endData, forKey: NotificationsEndTimeCacheKey)
        } catch {
            print("Could not save start/end notification time.")
        }
        defaults.synchronize()
    }

}
