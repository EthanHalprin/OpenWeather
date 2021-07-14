//
//  ForecastViewCell.swift
//  OpenWeather
//
//  Created by Ethan on 13/07/2021.
//

import UIKit


protocol ViewTappedDelegate: AnyObject {
    func viewTapped(_ indexPath : IndexPath?)
}

class ForecastViewCell: UICollectionViewCell, UIGestureRecognizerDelegate {
  
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var temp: UILabel!
    
    weak var delegate : ViewTappedDelegate?
    var indexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderWidth = 1.5
        self.temp.font = UIFont.boldSystemFont(ofSize: 12.0)
        self.layer.borderColor = UIColor.black.cgColor
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
        tapGesture.delegate = self
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap(recognizer:UITapGestureRecognizer) {
        delegate?.viewTapped(self.indexPath)
    }

}
