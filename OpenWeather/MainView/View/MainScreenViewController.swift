//
//  MainScreenViewController.swift
//  OpenWeather
//
//  Created by Ethan on 12/07/2021.
//

import UIKit

class MainScreenViewController: UIViewController {

    var apiKey: String! //"298b60e02f2991627d6b5a431f7c31f1"

    override func viewDidLoad() {
        super.viewDidLoad()
        URLLoader().loadForecast(for: City.telAviv)
    }
}

