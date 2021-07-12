//
//  MainScreenViewController.swift
//  OpenWeather
//
//  Created by Ethan on 12/07/2021.
//

import UIKit

class MainScreenViewController: UIViewController {

    var viewModel = MainScreenViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.loadForecast(for: .telAviv) { forecast in
            print("===== FORCAST TA ====================================")
            dump(forecast)
            print("===== FORCAST TA ====================================")
        }
    }
}

