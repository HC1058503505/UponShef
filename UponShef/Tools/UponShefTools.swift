//
//  UponShefTools.swift
//  UponShef
//
//  Created by cgtn on 2018/7/27.
//  Copyright © 2018年 houcong. All rights reserved.
//

import Foundation
import UIKit
struct Tools  {
    static func toString(item: Any?) -> String {
        guard let source = item as? String else { return "" }
        return source
    }
    
    static func toBool(item: Any?) -> Bool {
        guard let source = item as? Bool else { return false }
        return source
    }
    
    static func toFormat(item: String?) -> String {
        guard let num = Int(item ?? "") else { return "" }
        
        if num > 9999 {
            return String(format: "%.1f万", arguments: [(Double(num) / 10000.0)])
        }
        
        return item ?? ""
    }
    
    static func safeAreaInsetTop() -> CGFloat {
        let  safeTop = UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0
        
        return safeTop == 0 ? 20 : safeTop
    }
    
    static func safeAreaInsetBottom() -> CGFloat {
        return UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
    }
    
    static func navigationHeight() -> CGFloat {
        return Tools.safeAreaInsetTop() + Constant.kNavgiationTabBarH
    }
    
    static func tabBarHeight() -> CGFloat {
        return Tools.safeAreaInsetBottom() + Constant.kNavgiationTabBarH
    }
}
