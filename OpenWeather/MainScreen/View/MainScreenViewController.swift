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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        viewModel.loadForecast(for: .telAviv) { forecast in
//            print("===== FORCAST TA ====================================")
//            dump(forecast)
//            print("===== FORCAST TA ====================================")
//        }
    }
}

extension MainScreenViewController {
    
    fileprivate func setup() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.bullet"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(layoutToggleTapped))
        
        collectionView.collectionViewLayout = viewModel.gridFlowLayout
    }
    
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
        return viewModel.pics.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ForecastViewCell.self), for: indexPath) as! ForecastViewCell
        
        let index = indexPath.row % viewModel.pics.count
        let imageName = viewModel.pics[index]
        cell.imageView.image = UIImage(named: imageName)
        cell.imageView.contentMode = .scaleAspectFit
        cell.labelView.text = String(describing: viewModel.temps[index])
        cell.canvasView.setup(view: cell.canvasView)
      
        return cell
        
    }
}
extension UIView {
    
    func setup(view : UIView){
        
        view.layer.cornerRadius = 2.0
        view.layer.borderColor  =  UIColor.lightGray.cgColor
        view.layer.borderWidth = 2.0
        view.layer.shadowOpacity = 1.0
        view.layer.shadowColor =  UIColor.clear.cgColor
        view.layer.shadowRadius = 2.0
        view.layer.shadowOffset = CGSize(width:3, height: 3)
        view.layer.masksToBounds = true
        
    }
}
