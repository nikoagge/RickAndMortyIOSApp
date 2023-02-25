//
//  RickAndMortyTabBarController.swift
//  RickAndMortyiOSApp
//
//  Created by Nikos Aggelidis on 18/2/23.
//

import UIKit

final class RickAndMortyTabBarController:
    UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
}

private extension RickAndMortyTabBarController {
    func setupUI() {
        view.backgroundColor = .systemBackground
        setupTabs()
    }
    
    func setupTabs() {
        let rickAndMortyCharactersViewController = RickAndMortyCharactersViewController()
        rickAndMortyCharactersViewController.title = "Characters"
        let rickAndMortyCharacterNavigationController = UINavigationController(rootViewController: rickAndMortyCharactersViewController)
        rickAndMortyCharacterNavigationController.tabBarItem = UITabBarItem(
            title: "Characters",
            image: UIImage(systemName: "person"),
            tag: 1
        )
        
        let rickAndMortyEpisodeViewController = RickAndMortyEpisodeViewController()
        rickAndMortyEpisodeViewController.title = "Episodes"
        let rickAndMortyEpisodeNavigationController = UINavigationController(rootViewController: rickAndMortyEpisodeViewController)
        rickAndMortyEpisodeNavigationController.tabBarItem = UITabBarItem(
            title: "Episodes",
            image: UIImage(systemName: "tv"),
            tag: 2
        )
        
        let rickAndMortyLocationViewController = RickAndMortyLocationViewController()
        rickAndMortyLocationViewController.title = "Locations"
        let rickAndMortyLocationNavigationController = UINavigationController(rootViewController: rickAndMortyLocationViewController)
        rickAndMortyLocationNavigationController.tabBarItem = UITabBarItem(
            title: "Locations",
            image: UIImage(systemName: "globe"),
            tag: 3
        )
        
        let rickAndMortySettingsViewController = RickAndMortySettingsViewController()
        rickAndMortySettingsViewController.title = "Settings"
        let rickAndMortySettingsNavigationController = UINavigationController(rootViewController: rickAndMortySettingsViewController)
        rickAndMortySettingsNavigationController.tabBarItem = UITabBarItem(
            title: "Settings",
            image: UIImage(systemName: "gear"),
            tag: 4
        )
        
        for navigationController in [rickAndMortyCharacterNavigationController, rickAndMortyEpisodeNavigationController, rickAndMortyLocationNavigationController, rickAndMortySettingsNavigationController] {
            navigationController.navigationBar.prefersLargeTitles = true
        }
        
        setViewControllers(
            [
                rickAndMortyCharacterNavigationController,
                rickAndMortyEpisodeNavigationController,
                rickAndMortyLocationNavigationController,
                rickAndMortySettingsNavigationController
            ],
            animated: true
        )
    }
}
