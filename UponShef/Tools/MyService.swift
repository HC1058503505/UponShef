//
//  MyService.swift
//  UponShef
//
//  Created by cgtn on 2018/8/6.
//  Copyright © 2018年 houcong. All rights reserved.
//

import Foundation



enum MyService {
    case categoryList(type: String)
    case recipeList(type: String, page: Int)
    case recipeSteps(type: String, identifier: String)
}
