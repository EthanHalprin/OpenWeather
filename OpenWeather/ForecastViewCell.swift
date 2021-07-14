//
//  ForecastViewCell.swift
//  OpenWeather
//
//  Created by Ethan on 13/07/2021.
//

import UIKit

class ForecastViewCell: UICollectionViewCell {
  
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
