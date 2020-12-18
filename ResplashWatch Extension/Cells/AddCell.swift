//
//  AddCell.swift
//  ResplashWatch Extension
//
//  Created by Eric Ziegler on 12/18/20.
//

import WatchKit
import Foundation

// MARK: - Constants

let AddCellId = "AddCellId"

// MARK: - Protocols

protocol AddCellDelegate {
    func addAmountTapped(amount: Int, cell: AddCell)
}

class AddCell: NSObject {

    // MARK: - Properties

    @IBOutlet var addButton: WKInterfaceButton!

    var delegate: AddCellDelegate?
    var amount = 0

    // MARK: - Layout

    func layoutFor(amount: Int) {
        self.amount = amount
        addButton.setTitle("Add \(amount) ounces")
    }

    // MARK: - Actions

    @IBAction func addTapped(_ sender: AnyObject) {
        delegate?.addAmountTapped(amount: amount, cell: self)
    }

}
