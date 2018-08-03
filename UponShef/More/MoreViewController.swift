//
//  MoreViewController.swift
//  UponShef
//
//  Created by cgtn on 2018/7/17.
//  Copyright © 2018年 houcong. All rights reserved.
//

import UIKit
import Eureka
class MoreViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
        
        form +++ Section()
            <<< AccountRow(){ row in
                row.title = "SunnyHCong"
            }
        
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
