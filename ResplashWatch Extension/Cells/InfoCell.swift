//
//  InfoCell.swift
//  ResplashWatch Extension
//
//  Created by Eric Ziegler on 12/18/20.
//

import WatchKit
import Foundation

// MARK: - Constants

let InfoCellId = "InfoCellId"

class InfoCell: NSObject {

    // MARK: - Properties

    @IBOutlet var dateLabel: WKInterfaceLabel!
    @IBOutlet var percentageLabel: WKInterfaceLabel!
    @IBOutlet var amountLabel: WKInterfaceLabel!

    // MARK: - Layout

    func layoutFor(amount: Int?, goal: Int?) {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE M/d/yy"
        dateLabel.setText(formatter.string(from: Date()))

        if let amount = amount, let goal = goal {
            var percentage = Double(amount) / Double(goal)
            if percentage > 1 {
                percentage = 1
            }
            percentageLabel.setText(NSString(format: "%.0f%%", (percentage * 100)) as String)

            if amount <= goal {
                amountLabel.setText("\(amount)oz of \(goal)oz")
            } else {
                amountLabel.setText("\(amount)oz")
            }
        } else {
            percentageLabel.setText("--%")
            amountLabel.setText("-- of --")
        }
    }

}
