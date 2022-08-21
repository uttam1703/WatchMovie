//
//  ViewController.swift
//  WatchMovie
//
//  Created by uttam on 11/08/22.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        let vc1=UINavigationController(rootViewController: HomeViewController())
        let vc2=UINavigationController(rootViewController: SearchViewController())
        let vc3=UINavigationController(rootViewController: UpcomingViewController())
        let vc4=UINavigationController(rootViewController: DownloadViewController())
        
        vc1.tabBarItem.image=UIImage(systemName: "house")
        vc2.tabBarItem.image=UIImage(systemName: "magnifyingglass")
        vc3.tabBarItem.image=UIImage(systemName: "play.circle")
        vc4.tabBarItem.image=UIImage(systemName: "arrow.down.to.line")
        
        vc1.tabBarItem.title="Home"
        vc2.tabBarItem.title="Search"
        vc3.tabBarItem.title="Upcoming Movie"
        vc4.tabBarItem.title="Download"
        tabBar.tintColor = .label
        
        setViewControllers([vc1,vc2,vc3,vc4], animated: true)

        
        // Do any additional setup after loading the view.
    }


}

