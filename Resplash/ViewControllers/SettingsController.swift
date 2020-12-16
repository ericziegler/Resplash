//
//  SettingsController.swift
//  Resplash
//
//  Created by Eric Ziegler on 12/16/20.
//

import UIKit

// MARK: - Constants

fileprivate let SettingsControllerId = "SettingsControllerId"

class SettingsController: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Properties

    @IBOutlet var header: UIView!
    @IBOutlet var settingsTable: UITableView!

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        styleUI()
    }

    private func styleUI() {
        header.backgroundColor = UIColor.main
    }

    // MARK: - UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else {
            return 3
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsSwitchCellId, for: indexPath) as! SettingsSwitchCell
            return cell
        } else {
            if indexPath.row == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: SettingsDescriptionCellId, for: indexPath) as! SettingsDescriptionCell
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTimeCellId, for: indexPath) as! SettingsTimeCell
                return cell
            }
        }
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }

}
