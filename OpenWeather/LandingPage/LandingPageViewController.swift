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
        if currentReachabilityStatus == .notReachable {
            // Network Unavailable
            self.alertPopup(title: "Internet Issue",
                            message: "No Internet Connection. Supply cellular or Wi-Fi connection or watch offline last forecasts",
                            extraButtonTitle: "Go Offline",
                            extraButtonHandler: { _ in
                                DispatchQueue.main.async {
                                    self.pushMainViewController()
                                }
                            })
        } else {
            // Network Available
            guard let key = textField.text, key.count == 32 else {
                self.alertPopup(title: "API Key Issue", message: "Please enter a valid 32-char key")
                return
            }
            UserDefaults.standard.set(key, forKey: "OW_API_Key")
            pushMainViewController()
        }
    }
}

extension LandingPageViewController {
    func pushMainViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainScreenViewController = storyboard.instantiateViewController(withIdentifier: "MainScreenViewController") as! MainScreenViewController
        self.navigationController?.pushViewController(mainScreenViewController, animated: true)
    }
}

extension UIViewController {
    func alertPopup(title: String,
                    message: String,
                    extraButtonTitle: String? = nil,
                    extraButtonHandler: ((UIAlertAction) -> Void)? = nil ) {
        
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: nil))
        if let title = extraButtonTitle, let handler = extraButtonHandler {
            alert.addAction(UIAlertAction(title: title, style: .cancel, handler: handler))
        }

        self.present(alert, animated: true)
    }
}
