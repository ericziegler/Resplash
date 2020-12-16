//
//  SettingsTimeCell.swift
//  Resplash
//
//  Created by Eric Ziegler on 12/16/20.
//

import UIKit

// MARK: - Constants

let SettingsTimeCellId = "SettingsTimeCellId"

// MARK: - Protocols

protocol SettingsTimeCellDelegate {
    func timeChanged(time: Date, forSettingsTimeCell cell: SettingsTimeCell)
}

class SettingsTimeCell: UITableViewCell {

    // MARK: - Properties

    @IBOutlet var nameLabel: RegularLabel!
    @IBOutlet var timePicker: UIDatePicker!

    var delegate: SettingsTimeCellDelegate?

    // MARK: - Init

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    // MARK: - Layout

    func layoutFor(name: String, time: Date) {
        nameLabel.text = name
        timePicker.date = time
    }

    // MARK: - Actions

    @IBAction func timeChanged(_ sender: AnyObject) {
        if let datePicker = sender as? UIDatePicker {
            delegate?.timeChanged(time: datePicker.date, forSettingsTimeCell: self)
        }
    }

}
