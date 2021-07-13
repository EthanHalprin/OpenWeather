//
//  ForecastViewCell.swift
//  OpenWeather
//
//  Created by Ethan on 13/07/2021.
//

import UIKit

class ForecastViewCell: UICollectionViewCell {

    @IBOutlet weak var canvasView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var labelView: UILabel!
    @IBOutlet weak var forecastView: UILabel!
    @IBOutlet weak var temperatureView: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = 3
        imageView.layer.masksToBounds = true
        labelView.layer.cornerRadius = 3
        labelView.layer.masksToBounds = true
        canvasView.layer.cornerRadius = 3
        canvasView.layer.masksToBounds = true
    }
}
