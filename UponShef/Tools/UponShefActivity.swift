//
//  UponShefActivity.swift
//  UponShef
//
//  Created by cgtn on 2018/8/2.
//  Copyright © 2018年 houcong. All rights reserved.
//

import UIKit
import Foundation

class UponShefActivity: UIActivity {
    fileprivate var activity_Title: String?
    fileprivate var activity_image: UIImage?
    fileprivate var activity_url: URL?
    fileprivate var activity_type: UIActivityType?
    
    init(title: String?, image: UIImage?, url: URL?, type: UIActivityType?) {
        super.init()
        activity_Title = title
        activity_image = image
        activity_url = url
        activity_type = type
    }
    
    override var activityTitle: String? {
        return activity_Title
    }
    
    override var activityImage: UIImage? {
        return activity_image
    }
    
    override var activityType: UIActivityType? {
        return activity_type
    }

    
    override class var activityCategory: UIActivityCategory {
        return UIActivityCategory.share
    }
    
    override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        return true
    }
    
    override func prepare(withActivityItems activityItems: [Any]) {
        
    }
    
    override func activityDidFinish(_ completed: Bool) {
        
    }
    
    
}
