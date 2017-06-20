//
//  DrawerViewController.swift
//  NavigationDrawer
//
//  Created by Everton Luiz Pascke on 18/10/16.
//  Copyright © 2016 Everton Luiz Pascke. All rights reserved.
//

import UIKit
import SideMenu

class DrawerViewController: MenuStoryboardViewController {
    
    var isLeftMenu = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isLeftMenu {
            
            let menuViewController = self.storyboard?.instantiateViewController(withIdentifier: "Scene.Menu") as! MenuViewController
            
            let menuLeftNavigationController = UISideMenuNavigationController(rootViewController: menuViewController)
            menuLeftNavigationController.leftSide = true
            menuLeftNavigationController.navigationBar.isHidden = true
            
            SideMenuManager.menuPresentMode = .viewSlideInOut
            SideMenuManager.menuFadeStatusBar = false
            SideMenuManager.menuLeftNavigationController = menuLeftNavigationController
            
            SideMenuManager.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
            //SideMenuManager.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
            
            let drawerIcon = UIImage(named: "DrawerIcon")
            let menuButton = UIBarButtonItem(image: drawerIcon, style: .plain, target: self, action: #selector(onSlideMenuButtonTapped))
            navigationItem.setLeftBarButtonItems([menuButton], animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func onSlideMenuButtonTapped() {
        self.present(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
    }
}
