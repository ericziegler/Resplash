//
//  SettingsSwitchCell.swift
//  Resplash
//
//  Created by Eric Ziegler on 12/16/20.
//

import UIKit

// MARK: - Constants

let SettingsSwitchCellId = "SettingsSwitchCellId"

// MARK: - Protocols

protocol SettingsSwitchCellDelegate {
    func valueChanged(value: Bool, forSettingsSwitchCell cell: SettingsSwitchCell)
}

class SettingsSwitchCell: UITableViewCell {

    // MARK: - Properties

    @IBOutlet var nameLabel: RegularLabel!
    @IBOutlet var settingsSwitch: UISwitch!

    var delegate: SettingsSwitchCellDelegate?

    // MARK: - Init

    override func awakeFromNib() {
        super.awakeFromNib()
        styleUI()
    }

    private func styleUI() {
        settingsSwitch.onTintColor = UIColor.main
    }

    // MARK: - Layout

    func layoutFor(name: String, isOn: Bool) {
        nameLabel.text = name
        settingsSwitch.isOn = isOn
    }

    // MARK: - Actions

    @IBAction func switchChanged(_ sender: AnyObject) {
        if let valueSwitch = sender as? UISwitch {
            delegate?.valueChanged(value: valueSwitch.isOn, forSettingsSwitchCell: self)
        }
    }

}
