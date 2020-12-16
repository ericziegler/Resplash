//
//  UserPreferences.swift
//  Resplash
//
//  Created by Eric Ziegler on 12/15/20.
//

import Foundation

// MARK: - Constants

fileprivate let PreferenceNotificationsOnCacheKey = "PreferenceNotificationsCacheKey"
fileprivate let PreferenceStartTimeCacheKey = "PreferenceStartTimeCacheKey"
fileprivate let PreferenceEndTimeCacheKey = "PreferenceEndTimeCacheKey"

class UserPreferences {

    // MARK: - Properties

    var notificationsOn = false
    var startTime = 8
    var endTime = 22

    // MARK: - Init

    init() {
        load()
    }

    // MARK: - Load / Save

    func load() {
        let defaults = UserDefaults.standard
        if let notificationsOnValue = defaults.object(forKey: PreferenceNotificationsOnCacheKey) as? NSNumber {
            notificationsOn = notificationsOnValue.boolValue
        }
        if let startTimeValue = defaults.object(forKey: PreferenceStartTimeCacheKey) as? NSNumber {
            startTime = startTimeValue.intValue
        }
        if let endTimeValue = defaults.object(forKey: PreferenceEndTimeCacheKey) as? NSNumber {
            endTime = endTimeValue.intValue
        }
    }

    func save() {
        let defaults = UserDefaults.standard
        defaults.set(NSNumber(booleanLiteral: notificationsOn), forKey: PreferenceNotificationsOnCacheKey)
        defaults.set(NSNumber(integerLiteral: startTime), forKey: PreferenceStartTimeCacheKey)
        defaults.set(NSNumber(integerLiteral: endTime), forKey: PreferenceEndTimeCacheKey)
        defaults.synchronize()
    }

}
