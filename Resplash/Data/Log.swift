//
//  Log.swift
//  Resplash
//
//  Created by Eric Ziegler on 12/14/20.
//

import Foundation

// MARK: - Constants

let DailyGoalAmount: Int = 64
fileprivate let LogDateCacheKey = "LogDateCacheKey"
fileprivate let LogBeveragesCacheKey = "LogBeveragesCacheKey"

class Log: NSObject, NSCoding {

    // MARK: - Properties

    var date: Date?
    var beverages = [Beverage]()
    var totalAmount: Int {
        var result = 0
        for curBeverage in beverages {
            if let amount = curBeverage.amount {
                result += amount
            }
        }
        return result
    }
    var percentComplete: Double {
        return Double(totalAmount) / Double(DailyGoalAmount)
    }

    // MARK: - Init + Coding

    override init() {
        super.init()
    }

    required init?(coder: NSCoder) {
        if let cachedDate = coder.decodeObject(forKey: LogDateCacheKey) as? NSNumber {
            date = Date(timeIntervalSince1970: cachedDate.doubleValue)
        }
        if let beveragesData = coder.decodeObject(forKey: LogBeveragesCacheKey) as? Data {
            do {
                if let cachedBeverages = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(beveragesData) as? [Beverage] {
                    beverages = cachedBeverages
                }
            } catch {
                print("Could not load cached logs.")
            }
        }
    }

    func encode(with coder: NSCoder) {
        if let date = self.date {
            coder.encode(NSNumber(value: date.timeIntervalSince1970), forKey: LogDateCacheKey)
        }
        do {
            let beveragesData = try NSKeyedArchiver.archivedData(withRootObject: beverages, requiringSecureCoding: false)
            coder.encode(beveragesData  , forKey: LogBeveragesCacheKey)
        } catch {
            print("Could not save logs to cache.")
        }
    }

}
