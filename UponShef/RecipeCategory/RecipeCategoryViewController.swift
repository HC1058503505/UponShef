//
//  RecipeCategoryViewController.swift
//  UponShef
//
//  Created by cgtn on 2018/7/17.
//  Copyright © 2018年 houcong. All rights reserved.
//

import UIKit

class RecipeCategoryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        navigationItem.title = ""
        let segment = UISegmentedControl(items: ["热门","常见","食材","健康"])
        segment.center = CGPoint(x: kScreenWidth * 0.5, y: kNavgiationTabBarH * 0.5)
        navigationController?.navigationBar.addSubview(segment)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
