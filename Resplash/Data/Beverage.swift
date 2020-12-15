//
//  Beverage.swift
//  Resplash
//
//  Created by Eric Ziegler on 12/14/20.
//

import Foundation

// MARK: - Constants

fileprivate let BeverageTypeCacheKey = "BeverageTypeCacheKey"
fileprivate let BeverageNameCacheKey = "BeverageNameCacheKey"
fileprivate let BeverageTimestampCacheKey = "BeverageTimestampCacheKey"
fileprivate let BeverageAmountCacheKey = "BeverageAmountCacheKey"

// MARK: - Enums

enum BeverageType: Int {
    case water
    case carbonatedWater
    case tea
    case coffee
    case milk
    case juice
    case soda
    case sportsDrink
    case energyDrink
    case other

    var displayName: String {
        switch self {
        case .water:
            return "Water"
        case .carbonatedWater:
            return "Carbonated Water"
        case .tea:
            return "Tea"
        case .coffee:
            return "Coffee"
        case .milk:
            return "Milk"
        case .juice:
            return "Juice"
        case .soda:
            return "Soda"
        case .sportsDrink:
            return "Sports Drink"
        case .energyDrink:
            return "Energy Drink"
        case .other:
            return ""
        }
    }

    var imageName: String {
        switch self {
        case .water:
            return "beverage-water"
        case .carbonatedWater:
            return "beverage-carbonated-water"
        case .tea:
            return "beverage-tea"
        case .coffee:
            return "beverage-coffee"
        case .milk:
            return "beverage-milk"
        case .juice:
            return "beverage-juice"
        case .soda:
            return "beverage-soda"
        case .sportsDrink:
            return "beverage-sports-drink"
        case .energyDrink:
            return "beverage-energy-drink"
        case .other:
            return "beverage-other"
        }
    }

}

class Beverage: NSObject, NSCoding {

    // MARK: - Properties

    var type: BeverageType?
    var name: String?
    var timestamp: Date?
    var amount: Int?

    // MARK: - Init + NSCoding

    override init() {
        super.init()
    }

    required init?(coder: NSCoder) {
        if let typeValue = coder.decodeObject(forKey: BeverageTypeCacheKey) as? NSNumber, let cachedType = BeverageType(rawValue: typeValue.intValue) {
            type = cachedType
        }
        if let cachedName = coder.decodeObject(forKey: BeverageNameCacheKey) as? String {
            name = cachedName
        }
        if let cachedTimestamp = coder.decodeObject(forKey: BeverageTimestampCacheKey) as? NSNumber {
            timestamp = Date(timeIntervalSince1970: cachedTimestamp.doubleValue)
        }
        if let cachedAmount = coder.decodeObject(forKey: BeverageAmountCacheKey) as? NSNumber {
            amount = cachedAmount.intValue
        }
    }

    func encode(with coder: NSCoder) {
        if let type = self.type {
            coder.encode(NSNumber(value: type.rawValue), forKey: BeverageTypeCacheKey)
        }
        coder.encode(name, forKey: BeverageNameCacheKey)
        if let timestamp = self.timestamp {
            coder.encode(NSNumber(value: timestamp.timeIntervalSince1970), forKey: BeverageTimestampCacheKey)
        }
        if let amount = self.amount {
            coder.encode(NSNumber(value: amount), forKey: BeverageAmountCacheKey)
        }
    }

}
