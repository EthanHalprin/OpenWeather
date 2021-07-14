//
//  MainScreenViewController.swift
//  OpenWeather
//
//  Created by Ethan on 12/07/2021.
//

import UIKit

enum LoadingType {
    case database
    case network
}

class MainScreenViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var viewModel = MainScreenViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if currentReachabilityStatus == .notReachable {
            //CR - save
        }
    }
}

extension MainScreenViewController {
    fileprivate func setup() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.bullet"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(layoutToggleTapped))
        
        collectionView.collectionViewLayout = viewModel.gridFlowLayout

        if currentReachabilityStatus == .notReachable {
            // Network Unavailable
            load(via: .database)
        } else {
            // Network Available
            load(via: .network)
        }
    }

    fileprivate func load(via: LoadingType) {

        switch via {
        case .database:
            //CR - setup
            break
        
        case .network:
            self.viewModel.loadForecasts { [unowned self] result in
                switch result {
                case .success( _):
                    print("Extracted \(self.viewModel.forecasts.count) forecasts from network load")
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                case .failure(let error):
                    print("ERROR: On loadForecasts - \(error.localizedDescription)")
                }
            }
        }
    }
}

extension MainScreenViewController {
    @objc func layoutToggleTapped() {
        viewModel.isGridLayout = viewModel.isGridLayout ? false : true
        navigationItem.rightBarButtonItem!.image = viewModel.isGridLayout ? UIImage(systemName: "list.bullet") : UIImage(systemName: "square.grid.2x2")
        
        UIView.animate(withDuration: 0.2) { [unowned self] () -> Void in
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
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ForecastViewCell.self), for: indexPath) as! ForecastViewCell
        
        let index = indexPath.row % viewModel.forecasts.count

        //----ImageView HARDCODED----------------------------------------
        let imageName = viewModel.pics[index]
        cell.imageView.image = UIImage(named: imageName)
        cell.imageView.contentMode = .scaleAspectFit
        //---------------------------------------------------------------
        
        if let title = viewModel.forecasts[index].cityName {
            print(">>>>>>> title = \(title) >>>>>>>>>>>>>>>\n")
            cell.cityLabel.text = title
        }
        let temp = viewModel.forecasts[index].temperature
        print(">>>>>>> temp = \(temp) >>>>>>>>>>>>>>>\n")
        cell.temperatureLabel.text = String("\(temp)º")
    
        //cell.canvasView.decorate()
      
        return cell
    }
}
extension UIView {
    func decorate(){
        self.layer.cornerRadius = 2.0
        self.layer.borderColor  =  UIColor.lightGray.cgColor
        self.layer.borderWidth = 2.0
        self.layer.shadowOpacity = 1.0
        self.layer.shadowColor =  UIColor.clear.cgColor
        self.layer.shadowRadius = 2.0
        self.layer.shadowOffset = CGSize(width:3, height: 3)
        self.layer.masksToBounds = true
    }
}
