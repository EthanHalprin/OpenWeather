//
//  MainScreenViewController.swift
//  OpenWeather
//
//  Created by Ethan on 12/07/2021.
//

import UIKit

class MainScreenViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel = MainScreenViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

extension MainScreenViewController {
    fileprivate func setup() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.bullet"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(layoutToggleTapped))
        
        collectionView.collectionViewLayout = viewModel.gridFlowLayout
        
        let loaderTarget: LoadingType = currentReachabilityStatus == .notReachable ? .database : .network
        
        self.viewModel.loadForecasts(via: loaderTarget) { [unowned self] result in
            switch result {
            case .success( _):
                print("Extracted \(self.viewModel.forecasts.count) forecasts")
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print("ERROR: On loadForecasts - \(error.localizedDescription)")
            }
        }
    }
}

extension MainScreenViewController {
    @objc func layoutToggleTapped() {
        viewModel.isGridLayout = viewModel.isGridLayout ? false : true
        navigationItem.rightBarButtonItem!.image = viewModel.isGridLayout ? UIImage(systemName: "list.bullet") : UIImage(systemName: "square.grid.2x2")
        
        UIView.animate(withDuration: 0.5) { [unowned self] () -> Void in
            self.collectionView.collectionViewLayout.invalidateLayout()
            let chosenLayout = self.viewModel.isGridLayout ? self.viewModel.gridFlowLayout : self.viewModel.listFlowLayout
            self.collectionView.setCollectionViewLayout(chosenLayout, animated: true)
        }
    }
}

extension MainScreenViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.forecasts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ForecastViewCell.self),
                                                      for: indexPath) as! ForecastViewCell
        
        guard viewModel.forecasts.count <= 4 else {
            fatalError("++++ Duplicates in DB ++++++++++++++++++++++++++++++")
        }
        
        let index = indexPath.row % viewModel.forecasts.count

        if let title = viewModel.forecasts[index].value(forKeyPath: "cityName") as? String {
            cell.city.text = title
            cell.imageView.image = UIImage(named: title)
            cell.imageView.contentMode = .scaleAspectFit
        }
        if let temp = viewModel.forecasts[index].value(forKeyPath: "temperature") as? Double {
            cell.temp.text = String("\(temp)º")
            let backgroundColor = self.adjustColor(temp)
            cell.backgroundColor = backgroundColor
        }
        return cell
    }
    
    fileprivate func adjustColor(_ temp: Double) -> UIColor {
        switch temp {
            case ..<0: return UIColor.systemBlue
            case 0..<19: return UIColor.systemTeal
            case 19..<26: return UIColor.systemYellow
            case 26..<35: return UIColor.systemOrange
            case 35..<60: return UIColor.systemRed
            default: return UIColor.white
        }
    }

}

