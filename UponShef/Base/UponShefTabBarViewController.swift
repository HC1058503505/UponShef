//
//  UponShefTabBarViewController.swift
//  HCRxSwift
//
//  Created by cgtn on 2018/7/3.
//  Copyright © 2018年 cgtn. All rights reserved.
//

import UIKit

class UponShefTabBarViewController: UITabBarController {
    fileprivate let imageNames = ["uponshef", "category", "more"]
    override func viewDidLoad() {
        
        addChildVC(title: "食神纪", imgName: imageNames[0], vc: UponShefViewController())
        addChildVC(title: "分类", imgName: imageNames[1], vc: RecipeCategoryViewController())
        addChildVC(title: "更多", imgName: imageNames[2], vc: MoreViewController())
        
        appearance()
    }
    
    func appearance() {
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor : Constant.kThemeColor], for: UIControlState.selected)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor : UIColor.black], for: UIControlState.normal)
    }
    
    func addChildVC(title: String, imgName: String, vc: UIViewController) {
        let navVC = UponShefNavigationController.init(rootViewController: vc)
        vc.tabBarItem.image = UIImage(named: "\(imgName)_normal")?.withRenderingMode(.alwaysOriginal)
        vc.tabBarItem.selectedImage = UIImage(named: "\(imgName)_selected")?.withRenderingMode(.alwaysOriginal)
        vc.title = title
        addChildViewController(navVC)
    }

}
