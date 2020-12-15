//
//  BaseViewController.swift
//

import UIKit

class BaseViewController: UIViewController {

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light        
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: - Helpers

    func showAlert(title: String?, message: String?) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

}

