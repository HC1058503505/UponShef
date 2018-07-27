//
//  UponShefNavigationController.swift
//  HCRxSwift
//
//  Created by cgtn on 2018/7/5.
//  Copyright © 2018年 cgtn. All rights reserved.
//

import UIKit

class UponShefNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationBar.tintColor = kThemeColor
        
        navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : kThemeColor]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
