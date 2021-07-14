//
//  CityForecastViewController.swift
//  OpenWeather
//
//  Created by Ethan on 12/07/2021.
//

import Foundation
import UIKit


class CityForecastViewController: UIViewController {

    var forecast = ForecastPersist()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UITextView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var feelingLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var seaLevelLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var windDirectionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let city = forecast.cityName {
            imageView.image = UIImage(named: city)
        }

        nameLabel.text = forecast.cityName
        descriptionLabel.text = forecast.weatherDescription
        tempLabel.text = String("\(forecast.temperature)") + "º"
        feelingLabel.text = String("\(forecast.feelsLike)") + "º"
        humidityLabel.text = String("\(forecast.humidity)")
        pressureLabel.text = String("\(forecast.pressure)")
        seaLevelLabel.text = String("\(forecast.seaLevel)")
        windSpeedLabel.text = String("\(forecast.windSpeed)")
        windDirectionLabel.text = String("\(forecast.windDirection)") + "º"
    }
}
