//
//  MainController.swift
//  Resplash
//
//  Created by Eric Ziegler on 12/14/20.
//

import UIKit

class MainController: BaseViewController {

    // MARK: - Properties

    @IBOutlet var dateLabel: LightLabel!
    @IBOutlet var dropBackground: UIView!
    @IBOutlet var dropFill: UIView!
    @IBOutlet var dropImageView: UIImageView!
    @IBOutlet var fillConstraint: NSLayoutConstraint!
    @IBOutlet var percentageLabel: RegularLabel!
    @IBOutlet var amountLabel: LightLabel!
    @IBOutlet var addButton: ActionButton!
    @IBOutlet var addMenu: UIView!
    @IBOutlet var addMenuConstraint: NSLayoutConstraint!
    @IBOutlet var amount8Button: RegularButton!
    @IBOutlet var amount10Button: RegularButton!
    @IBOutlet var amount12Button: RegularButton!
    @IBOutlet var amount16Button: RegularButton!
    @IBOutlet var amount20Button: RegularButton!

    private var showingAddMenu = false

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        styleUI()
    }

    private func styleUI() {
        self.view.backgroundColor = UIColor.main
        
        dropImageView.image = dropImageView.image?.maskedWithColor(UIColor.main)
        dropBackground.backgroundColor = UIColor.accent
        fillConstraint.constant = dropBackground.bounds.height

        addButton.adjustsImageWhenHighlighted = false

        addMenu.backgroundColor = UIColor.overlay
        addMenu.layer.shadowColor = UIColor.black.cgColor
        addMenu.layer.shadowRadius = 2
        addMenu.layer.shadowOpacity = 0.2
        addMenuConstraint.constant = -(addMenu.bounds.height + addMenu.layer.shadowRadius)

        updateAddMenuAlpha(0)

        amount12Button.layer.borderWidth = 2
        amount12Button.layer.borderColor = UIColor.white.cgColor
        amount12Button.layer.cornerRadius = amount12Button.bounds.height / 2

        amount8Button.layer.borderWidth = amount12Button.layer.borderWidth
        amount8Button.layer.borderColor = amount12Button.layer.borderColor
        amount8Button.layer.cornerRadius = amount12Button.layer.cornerRadius

        amount10Button.layer.borderWidth = amount12Button.layer.borderWidth
        amount10Button.layer.borderColor = amount12Button.layer.borderColor
        amount10Button.layer.cornerRadius = amount12Button.layer.cornerRadius

        amount16Button.layer.borderWidth = amount12Button.layer.borderWidth
        amount16Button.layer.borderColor = amount12Button.layer.borderColor
        amount16Button.layer.cornerRadius = amount12Button.layer.cornerRadius

        amount20Button.layer.borderWidth = amount12Button.layer.borderWidth
        amount20Button.layer.borderColor = amount12Button.layer.borderColor
        amount20Button.layer.cornerRadius = amount12Button.layer.cornerRadius
    }

    // MARK: - Actions

    @IBAction func dateTapped(_ sender: AnyObject) {
        print("DATE")
    }

    @IBAction func addTapped(_ sender: AnyObject) {
        if showingAddMenu == true {
            hideAddMenu()
        } else {
            showAddMenu()
        }
    }

    @IBAction func amountTapped(_ sender: AnyObject) {
        guard let amountButton = sender as? UIButton else {
            return
        }

        print(amountButton.tag)
        hideAddMenu()
    }

    // MARK: - Helpers

    private func hideAddMenu() {
        addButton.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.1) {
            self.updateAddMenuAlpha(0)
        } completion: { (finished) in
            self.addMenuConstraint.constant = -(self.addMenu.bounds.height + self.addMenu.layer.shadowRadius)
            UIView.animate(withDuration: 0.2) {
                self.addButton.transform = CGAffineTransform.identity
                self.view.layoutIfNeeded()
            } completion: { (finished) in
                self.addButton.isUserInteractionEnabled = true
                self.showingAddMenu = false
            }
        }
    }

    private func showAddMenu() {
        addButton.isUserInteractionEnabled = false
        addMenuConstraint.constant = 0
        UIView.animate(withDuration: 0.2) {
            var transform = CGAffineTransform.identity
            transform = transform.translatedBy(x: 0, y: 20)
            transform = transform.rotated(by: CGFloat.pi / 4)
            transform = transform.scaledBy(x: 0.4, y: 0.4)
            self.addButton.transform = transform
            self.view.layoutIfNeeded()
        } completion: { (finished) in
            UIView.animate(withDuration: 0.1) {
                self.updateAddMenuAlpha(1)
            } completion: { (finished) in
                self.addButton.isUserInteractionEnabled = true
                self.showingAddMenu = true
            }
        }
    }

    private func updateAddMenuAlpha(_ alpha: CGFloat) {
        for curView in self.addMenu.subviews {
            curView.alpha = alpha
        }
    }

}

