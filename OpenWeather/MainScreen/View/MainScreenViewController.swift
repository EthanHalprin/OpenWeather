//
//  MainScreenViewController.swift
//  OpenWeather
//
//  Created by Ethan on 12/07/2021.
//

import UIKit
import CoreData

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
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      
      //1
      guard let appDelegate =
        UIApplication.shared.delegate as? AppDelegate else {
          return
      }
      
      let managedContext =
        appDelegate.persistentContainer.viewContext
      
      //2
      let fetchRequest =
        NSFetchRequest<NSManagedObject>(entityName: "ForecastPersist")
      
      //3
      do {
        self.viewModel.forecasts = try managedContext.fetch(fetchRequest)
      } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
      }
 
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
           // load(via: .database)
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
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ForecastViewCell.self), for: indexPath) as! ForecastViewCell
        
        let index = indexPath.row % viewModel.forecasts.count

        //----ImageView HARDCODED----------------------------------------
        let imageName = viewModel.pics[index]
        cell.imageView.image = UIImage(named: imageName)
        cell.imageView.contentMode = .scaleAspectFit
        //---------------------------------------------------------------
        
        if let title = viewModel.forecasts[index].value(forKeyPath: "cityName") as? String {
            cell.city.text = title
        }
        if let temp = viewModel.forecasts[index].value(forKeyPath: "temperature") as? Double {
            cell.temp.text = String("\(temp)º")
        }
        return cell
    }
}

