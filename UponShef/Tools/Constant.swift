//
//  Constant.swift
//  HCRxSwift
//
//  Created by cgtn on 2018/6/28.
//  Copyright © 2018年 cgtn. All rights reserved.
//

import Foundation
import UIKit
let apiKey = "b06520d3f7ef51f2abcf66363145290a"
let baseURL = "http://apis.juhe.cn/cook/"

let kScreenWidth = UIScreen.main.bounds.width
let kScreenHeight = UIScreen.main.bounds.height

let kThemeColor = UIColor(red: 230.0 / 255.0, green: 88.0 / 255.0, blue: 83.0 / 255.0, alpha: 1.0)

let kThemeLightGrayColor = UIColor(red: 240.0 / 255.0, green: 240.0 / 255.0, blue: 240.0 / 255.0, alpha: 1.0)


let kSafeAreaInsetTop = UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0
let kSafeAreaInsetBottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
let kNavgiationTabBarH = CGFloat(44.0)

let kStatusHeight = kSafeAreaInsetTop > 0 ? kSafeAreaInsetTop : 20
let kNavgiationHeight = kSafeAreaInsetTop + kStatusHeight + kNavgiationTabBarH
let kTabBarHeight = kSafeAreaInsetBottom + kNavgiationTabBarH

