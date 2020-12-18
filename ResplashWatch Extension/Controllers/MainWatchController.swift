//
//  MainWatchController.swift
//  ResplashWatch Extension
//
//  Created by Eric Ziegler on 12/18/20.
//

import WatchKit
import Foundation
import WatchConnectivity

class MainWatchController: WKInterfaceController, WCSessionDelegate, AddCellDelegate {

    // MARK: - Properties

    @IBOutlet var mainTable: WKInterfaceTable!

    let session = WCSession.default
    var isSupported: Bool {
        return WCSession.isSupported()
    }
    var isReachable: Bool {
        return session.isReachable
    }

    private var curAmount: Int?
    private var curGoal: Int?

    // MARK: - WKInterfaceController

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
    }

    override func willActivate() {
        super.willActivate()
        setupSession()
        setupUI()
    }

    override func didDeactivate() {
        super.didDeactivate()
    }

    private func setupUI() {
        mainTable.insertRows(at: IndexSet(integer: 0), withRowType: InfoCellId)
        updateInfoCell()
        mainTable.insertRows(at: IndexSet(integersIn: 1..<6), withRowType: AddCellId)
        var addCell = mainTable.rowController(at: 1) as! AddCell
        addCell.layoutFor(amount: 8)
        addCell.delegate = self
        addCell = mainTable.rowController(at: 2) as! AddCell
        addCell.layoutFor(amount: 10)
        addCell.delegate = self
        addCell = mainTable.rowController(at: 3) as! AddCell
        addCell.layoutFor(amount: 12)
        addCell.delegate = self
        addCell = mainTable.rowController(at: 4) as! AddCell
        addCell.layoutFor(amount: 16)
        addCell.delegate = self
        addCell = mainTable.rowController(at: 5) as! AddCell
        addCell.layoutFor(amount: 20)
        addCell.delegate = self
    }

    private func setupSession() {
        if isSupported == true {
            if isReachable == true {
                askForDailyAmount()
            } else {
                session.delegate = self
                session.activate()
            }
        }
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
                    if let amount = message["amount"] as? NSNumber, let goal = message["goal"] as? NSNumber {
                        self.curAmount = amount.intValue
                        self.curGoal = goal.intValue
                        self.updateInfoCell()
                    }
                default:
                    break
                }
            } errorHandler: { (error) in
                print("Error occurred requesting daily amount.")
            }
        }
    }

    private func addToDailyAmount(_ amount: Int) {
        DispatchQueue.main.async {
            // immediately update
            if self.curAmount != nil {
                self.curAmount! += amount
            } else {
                self.curAmount = amount
            }
            self.updateInfoCell()

            // tell phone to update
            var data: [String : Any] = [String : Any]()
            data["key"] = "addDailyAmount"
            data["amount"] = NSNumber(integerLiteral: amount)
            self.session.sendMessage(data) { (message) in
                // successful update. make sure watch matches phone
                self.askForDailyAmount()
            } errorHandler: { (error) in
                print("Error occurred adding to daily amount.")
            }
        }
    }

    private func updateInfoCell() {
        if let infoCell = mainTable.rowController(at: 0) as? InfoCell {
            infoCell.layoutFor(amount: curAmount, goal: curGoal)
        }
    }

    // MARK: - WCSessionDelegate

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        DispatchQueue.main.async {
            self.askForDailyAmount()
        }
    }

    // MARK: - AddCellDelegate

    func addAmountTapped(amount: Int, cell: AddCell) {
        DispatchQueue.main.async {
            self.addToDailyAmount(amount)
        }
    }

}
