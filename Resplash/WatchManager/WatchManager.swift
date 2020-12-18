//
//  WatchManager.swift
//  Resplash
//
//  Created by Eric Ziegler on 12/17/20.
//

import Foundation
import WatchConnectivity

class WatchManager: NSObject, WCSessionDelegate {

    // MARK: - Properties

    var session = WCSession.default
    var isSupported: Bool {
        return WCSession.isSupported()
    }

    // MARK: - Init

    static let shared = WatchManager()

    override init() {
        super.init()

        if isSupported == true {
            session.delegate = self
            session.activate()
        }
    }

    // MARK: - WCSessionDelegate

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("Watch session activation complete.")
    }

    func sessionDidBecomeInactive(_ session: WCSession) {
        print("Watch session did become inactive.")
    }

    func sessionDidDeactivate(_ session: WCSession) {
        session.activate()
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        DispatchQueue.main.async {
            guard let key = message["key"] as? String else {
                return
            }
            var data: [String : Any] = [String : Any]()
            // check key
            switch key {
            case "requestAmount":
                data["key"] = "requestAmount"
                if let log = LogManager.shared.logForDate(Date()) {
                    data["amount"] = NSNumber(integerLiteral: log.totalAmount)
                    data["goal"] = NSNumber(integerLiteral: DailyGoalAmount)
                }
                replyHandler(data)                
            case "addDailyAmount":
                data["key"] = "addDailyAmount"
                if let amount = message["amount"] as? NSNumber {
                    LogManager.shared.addAmount(amount.intValue, forDate: Date())
                }
                replyHandler(data)
            default:
                break
            }
        }
    }

}
