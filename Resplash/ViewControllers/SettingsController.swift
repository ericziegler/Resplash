//
//  SettingsController.swift
//  Resplash
//
//  Created by Eric Ziegler on 12/16/20.
//

import UIKit

// MARK: - Constants

fileprivate let SettingsControllerId = "SettingsControllerId"

class SettingsController: BaseViewController, UITableViewDataSource, UITableViewDelegate, SettingsSwitchCellDelegate, SettingsTimeCellDelegate {

    // MARK: - Properties

    @IBOutlet var header: UIView!
    @IBOutlet var settingsTable: UITableView!

    // MARK: - Init

    static func createController() -> SettingsController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: SettingsControllerId) as! SettingsController
        return controller
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        styleUI()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // TODO: EZ - Update Notifications
    }

    private func styleUI() {
        header.backgroundColor = UIColor.main
    }

    // MARK: - Actions

    @IBAction func closeTapped(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: - Helpers

    private func calculateTimeFrom(dateComponents: DateComponents) -> Date {
        var date = Date().dateAtBeginningOfDay
        date = date.addingHours(numberOfHours: dateComponents.hour!)!
        date = date.addingMinutes(numberOfMinutes: dateComponents.minute!)!
        return date
    }

    // MARK: - UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        // if notifications are turned off, do not display the second section
        if UserPreferences.shared.notificationsOn == true {
            return 2
        } else {
            return 1
        }
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
            // reminders on/off
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsSwitchCellId, for: indexPath) as! SettingsSwitchCell
            cell.layoutFor(name: "Allow Reminders", isOn: UserPreferences.shared.notificationsOn)
            cell.delegate = self
            return cell
        } else {
            if indexPath.row == 2 {
                // reminder description
                let cell = tableView.dequeueReusableCell(withIdentifier: SettingsDescriptionCellId, for: indexPath) as! SettingsDescriptionCell
                let startTime = calculateTimeFrom(dateComponents: UserPreferences.shared.startComponents)
                let endTime = calculateTimeFrom(dateComponents: UserPreferences.shared.endComponents)
                let formatter = DateFormatter()
                formatter.dateFormat = "h:mm a"
                cell.descriptionLabel.text = "You will be reminded every 2 hours with your first reminder at \(formatter.string(from: startTime)) and your last reminder on or before \(formatter.string(from: endTime)) every day."
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTimeCellId, for: indexPath) as! SettingsTimeCell
                if indexPath.row == 0 {
                    // start time
                    let startTime = calculateTimeFrom(dateComponents: UserPreferences.shared.startComponents)
                    cell.layoutFor(name: "Start Time", time: startTime)
                }
                else if indexPath.row == 1 {
                    // end time
                    let endTime = calculateTimeFrom(dateComponents: UserPreferences.shared.endComponents)
                    cell.layoutFor(name: "End Time", time: endTime)
                }
                cell.delegate = self
                return cell
            }
        }
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsHeaderCellId) as! SettingsHeaderCell
        if section == 0 {
            cell.headerLabel.text = "Reminders"
        }
        else if section == 1 {
            cell.headerLabel.text = "Remind Between"
        }
        return cell
    }

    // MARK: - SettingsSwitchCellDelegate

    func valueChanged(value: Bool, forSettingsSwitchCell cell: SettingsSwitchCell) {
        if value == true {
            // if true, check if notifications are enabled at the OS level
            // if they aren't display a message and do not change the setting
            NotificationManager.shared.checkPermissionsWith { (allowed) in
                if allowed == false {
                    DispatchQueue.main.async {
                        // notifications disabled at OS level. alert the user with the option to go to Settings
                        let alert = UIAlertController(title: "Notifications Disabled", message: "User notifications have been turned off for Resplash. To turn them on, go to iOS Settings.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (action) in
                            if let settingsURL = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(settingsURL) == true {
                                UIApplication.shared.open(settingsURL)
                            }
                        }
                        alert.addAction(settingsAction)
                        self.present(alert, animated: true, completion: nil)
                    }
                    // because notifications are disabled, make sure that is reflected in UserPreferences and reload the settings table
                    UserPreferences.shared.notificationsOn = false
                } else {
                    UserPreferences.shared.notificationsOn = true
                }
                UserPreferences.shared.save()
                DispatchQueue.main.async {
                    self.settingsTable.reloadData()
                }
            }
        } else {
            UserPreferences.shared.notificationsOn = false
            UserPreferences.shared.save()
            DispatchQueue.main.async {
                self.settingsTable.reloadData()
            }
        }
    }

    // MARK: - SettingsTimeCellDelegate

    func timeChanged(time: Date, forSettingsTimeCell cell: SettingsTimeCell) {
        // determine whether this is the start time or end time
        guard let indexPath = settingsTable.indexPath(for: cell) else {
            return
        }

        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: time)
        let minute = calendar.component(.minute, from: time)
        if indexPath.row == 0 {
            // start time
            UserPreferences.shared.startComponents = DateComponents(hour: hour, minute: minute)
        }
        else if indexPath.row == 1 {
            // end time
            UserPreferences.shared.endComponents = DateComponents(hour: hour, minute: minute)
        }
        UserPreferences.shared.save()
        DispatchQueue.main.async {
            self.settingsTable.reloadData()
        }
    }

}
