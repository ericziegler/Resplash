//
//  LogManager.swift
//  Resplash
//
//  Created by Eric Ziegler on 12/14/20.
//

import Foundation

// MARK: - Constant

fileprivate let LogManagerLogsCacheKey = "LogManagerLogsCacheKey"

class LogManager {

    // MARK: - Properties

    var logs = [Log]()

    // MARK: - Init

    init() {
        load()
    }

    // MARK: - Load / Save

    func load() {
        do {
            if let logsData = UserDefaults.standard.object(forKey: LogManagerLogsCacheKey) as? Data {
                if let cachedLogs = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(logsData) as? [Log] {
                    logs = cachedLogs
                }
            }
        } catch {
            print("Could not load LogManager.")
        }
    }

    func save() {
        let defaults = UserDefaults.standard
        do {
            let logsData = try NSKeyedArchiver.archivedData(withRootObject: logs, requiringSecureCoding: false)
            defaults.set(logsData, forKey: LogManagerLogsCacheKey)
        } catch {
            print("Could not save LogManager.")
        }
        defaults.synchronize()
    }

}
