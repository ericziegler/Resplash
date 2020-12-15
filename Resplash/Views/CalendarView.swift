//
//  CalendarView.swift
//  Resplash
//
//  Created by Eric Ziegler on 12/15/20.
//

import UIKit

// MARK: - Protocols

protocol CalendarViewDelegate {
    func dateSelected(_ date: Date, calendarView: CalendarView)
    func calendarViewDidCancel(_ calendarView: CalendarView)
}

class CalendarView: UIView {

    // MARK: - Properties

    @IBOutlet var tapView: UIView!
    @IBOutlet var container: UIView!

    private var calendar: UIDatePicker!
    private var tapRecognizer: UITapGestureRecognizer?
    private var selectedDate = Date()
    private var minimumDate = Date.distantPast
    private var maximumDate = Date.distantFuture
    private var tint = UIColor.systemBlue

    var delegate: CalendarViewDelegate?

    // MARK: - Init

    class func createCalendarFor(parentController: UIViewController, selectedDate: Date?, minDate: Date?, maxDate: Date?, tint: UIColor?) -> CalendarView {
        let calendarView: CalendarView = UIView.fromNib()
        calendarView.fillInParentView(parentView: parentController.view)
        if let date = selectedDate {
            calendarView.selectedDate = date
        }
        if let date = minDate {
            calendarView.minimumDate = date
        }
        if let date = maxDate {
            calendarView.maximumDate = date
        }
        if let color = tint {
            calendarView.tint = color
        }
        return calendarView
    }

    // MARK: - Show / Hide Animations

    func showCalendar() {
        self.alpha = 0
        calendar = UIDatePicker(frame: .zero)
        calendar.datePickerMode = .date
        calendar.preferredDatePickerStyle = .inline
        calendar.tintColor = tint
        calendar.minimumDate = minimumDate
        calendar.maximumDate = maximumDate
        calendar.date = selectedDate
        calendar.fillInParentView(parentView: container)
        calendar.tintColor = tint
        calendar.addTarget(self, action: #selector(dateSelected(_:)), for: .valueChanged)
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 1
        }) { (didFinish) in

        }
        setupGestureRecognizers()
    }

    func hideCalendar() {
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0
        }) { (didFinish) in
            self.calendar.removeFromSuperview()
            self.removeFromSuperview()
        }
    }

    // MARK: - Actions

    @IBAction func dateSelected(_ sender: AnyObject) {
        delegate?.dateSelected(calendar.date, calendarView: self)
    }

    // MARK: - Gesture Recognizers

    private func setupGestureRecognizers() {
        if tapRecognizer == nil {
            tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped(_:)))
            tapView.addGestureRecognizer(tapRecognizer!)
        }
    }

    @objc func backgroundTapped(_ recognizer: UITapGestureRecognizer) {
        delegate?.calendarViewDidCancel(self)
    }

}
