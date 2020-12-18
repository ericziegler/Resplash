//
//  InterfaceController.swift
//  ResplashWatch Extension
//
//  Created by Eric Ziegler on 12/16/20.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController, WCSessionDelegate {

    // MARK: - Properties

//    @IBOutlet var dateLabel: WKInterfaceLabel!
//    @IBOutlet var percentageLabel: WKInterfaceLabel!
//    @IBOutlet var amountLabel: WKInterfaceLabel!

    let session = WCSession.default
    var isSupported: Bool {
        return WCSession.isSupported()
    }
    var isReachable: Bool {
        return session.isReachable
    }

    // MARK: - WKInterfaceController

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        // TODO: EZ - Remove
//        setupSession()
    }
    
    override func willActivate() {
        super.willActivate()
        setupSession()
        setupUI()
        // TODO: EZ - Put back
//        percentageLabel.setText("--%")
//        amountLabel.setText("-- of --")
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }

    private func setupUI() {
        // TODO: EZ - Put back
//        let formatter = DateFormatter()
//        formatter.dateFormat = "EEE M/d/yy"
//        dateLabel.setText(formatter.string(from: Date()))
//        percentageLabel.setText("--%")
    }

    private func setupSession() {
        if isSupported == true {
            session.delegate = self
            session.activate()
        }
    }

    // MARK: - Actions

    @IBAction func amount8Tapped() {
        addToDailyAmount(8)
    }

    @IBAction func amount10Tapped() {
        addToDailyAmount(10)
    }

    @IBAction func amount12Tapped() {
        addToDailyAmount(12)
    }

    @IBAction func amount16Tapped() {
        addToDailyAmount(16)
    }

    @IBAction func amount20Tapped() {
        addToDailyAmount(20)
    }

    // MARK: - Helpers

    private func askForDailyAmount() {
        DispatchQueue.main.async {
            var data: [String : Any] = [String : Any]()
            data["key"] = "requestAmount"
            self.session.sendMessage(data) { (message) in
                guard let key = message["key"] as? String else {
                    return
                }

                switch key {
                case "requestAmount":
                    print("Put this code back.")
                    // TODO: EZ - Put back
//                    if let percentage = message["percentage"] as? String {
//                        self.percentageLabel.setText(percentage)
//                    } else {
//                        self.percentageLabel.setText("--%")
//                    }
//                    if let amount = message["amount"] as? String {
//                        self.amountLabel.setText(amount)
//                    } else {
//                        self.amountLabel.setText("-- of --")
//                    }
                default:
                    break
                }
            } errorHandler: { (error) in
                print("Error occurred requesting daily amount.")
            }

            // TODO: EZ - Remove
//            self.session.sendMessage(data, replyHandler: nil, errorHandler: nil)
        }
    }

    private func addToDailyAmount(_ amount: Int) {
        DispatchQueue.main.async {
            // TODO: EZ - Put back
//            self.percentageLabel.setText("--")
//            self.amountLabel.setText("Updating...")

            var data: [String : Any] = [String : Any]()
            data["key"] = "addDailyAmount"
            data["amount"] = NSNumber(integerLiteral: amount)
            self.session.sendMessage(data) { (message) in
                self.askForDailyAmount()
            } errorHandler: { (error) in
                print("Error occurred adding to daily amount.")
            }

            // TODO: EZ - Remove
//            self.session.sendMessage(data, replyHandler: nil, errorHandler: nil)
        }
    }

    // MARK: - WCSessionDelegate

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        DispatchQueue.main.async {
            self.askForDailyAmount()
        }
    }

    // TODO: EZ - Remove
//    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
//
//    }

}
