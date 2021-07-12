//
//  LandingPageViewController.swift
//  OpenWeather
//
//  Created by Ethan on 12/07/2021.
//

import Foundation
import UIKit


class LandingPageViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!

    @IBAction func submitDidPress(_ sender: UIButton) {

        guard let text = textField.text, text.count == 32 else {
            self.alertPopup(title: "Bad Key", message: "Please enter a valid 32-char key")
            return
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainScreenViewController = storyboard.instantiateViewController(withIdentifier: "MainScreenViewController") as! MainScreenViewController
        mainScreenViewController.apiKey = text
        self.navigationController?.pushViewController(mainScreenViewController, animated: true)
    }
}

extension UIViewController {
    func alertPopup(title: String, message: String, cancelButton: Bool = false) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: nil))
        if cancelButton {
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        }

        self.present(alert, animated: true)
    }
}
