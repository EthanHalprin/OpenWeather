//
//  MainScreenViewController.swift
//  OpenWeather
//
//  Created by Ethan on 12/07/2021.
//

import UIKit

class MainScreenViewController: UIViewController {

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
        let image = viewModel.isGridLayout ? UIImage(systemName: "list.bullet") : UIImage(systemName: "square.grid.2x2")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image,
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(layoutToggleTapped))
    }
    
    @objc func layoutToggleTapped() {
        viewModel.isGridLayout = viewModel.isGridLayout ? false : true
        navigationItem.rightBarButtonItem!.image = viewModel.isGridLayout ? UIImage(systemName: "list.bullet") : UIImage(systemName: "square.grid.2x2")
    }
}

