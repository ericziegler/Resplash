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

    // MARK: - Helpers

    func logForDate(_ date: Date) -> Log? {
        for curLog in logs {
            if let curDate = curLog.date, curDate.dateAtBeginningOfDay.timeIntervalSince1970 == date.dateAtBeginningOfDay.timeIntervalSince1970 {
                return curLog
            }
        }
        return nil
    }

    func addAmount(_ amount: Int, forDate date: Date) {
        var log: Log

        if let foundLog = logForDate(date) {
            log = foundLog
        } else {
            log = Log()
            log.date = date.dateAtBeginningOfDay
            logs.append(log)
        }

        let beverage = Beverage()
        beverage.type = .water
        beverage.amount = amount
        beverage.timestamp = date
        log.beverages.append(beverage)

        save()
    }

}
