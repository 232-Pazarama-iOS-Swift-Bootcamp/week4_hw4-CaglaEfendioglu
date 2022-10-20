//
//  TabBarVC.swift
//  odev4
//
//  Created by Cagla Efendioglu on 12.10.2022.
//

import UIKit

class TabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBar.backgroundColor = .lightGray
        navigationItem.hidesBackButton = true
        
        let VC1 = UINavigationController(rootViewController: HomeVC(viewModel: HomeViewModel(service: IService())))
        let VC2 = UINavigationController(rootViewController: SearchVC(viewModel: SearchViewModel(service: IService())))
        let VC3 = UINavigationController(rootViewController: UserVC())
    
        self.setViewControllers([VC1, VC2, VC3], animated: true)
        guard let item = self.tabBar.items else { return }
        
        item[0].image = UIImage(systemName: "house")
        item[1].image = UIImage(systemName: "magnifyingglass")
        item[2].image = UIImage(systemName: "person")
        
    }
}
