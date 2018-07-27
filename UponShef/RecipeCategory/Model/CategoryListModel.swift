//
//  CategoryListModel.swift
//  UponShef
//
//  Created by cgtn on 2018/7/19.
//  Copyright © 2018年 houcong. All rights reserved.
//

import Foundation



class CategoryInfo {
    fileprivate var categoryInfo = [String : String]()
    init(info: [String : String]) {
       categoryInfo = info
    }
    
    var categorySubHref: String {
        return categoryInfo["category_sub_href"] ?? ""
    }
    
    var categorySubTitle: String {
        return categoryInfo["category_sub_title"] ?? ""
    }
}

class HotCategoryModel {
    internal var category = [String : Any]()
    var isSelected:Bool = false
    
    init(hotCategory: [String : Any]) {
        category = hotCategory
    }
    
    var categorySubs: [CategoryInfo] {
        var temp = [CategoryInfo]()
        
        guard let infos = category["category_subs"] as? [[String : String]] else {
            return temp
        }
        for item in infos {
            let categoryInfo = CategoryInfo.init(info: item)
            temp.append(categoryInfo)
        }
        return temp
    }
    
    var categoryTitle: String {
        return (category["category_title"] as? String) ?? ""
    }
    
    var categoryUrl: String {
        return (category["category_url"] as? String) ?? ""
    }

    var meterialSubs: [[String : [CategoryInfo]]] {
        guard let infos = category["category_subs"] as? [String : [[String : String]]] else {
            return [[String : [CategoryInfo]]]()
        }
        var foodMeterial = [[String : [CategoryInfo]]]()
        for item in infos {
            var tempMeterial = [String : [CategoryInfo]]()
            var temp = [CategoryInfo]()
            for info in item.value {
                let categoryInfo = CategoryInfo.init(info: info)
                temp.append(categoryInfo)
            }
            tempMeterial = [item.key : temp]
            foodMeterial.append(tempMeterial)
        }
        return foodMeterial
    }
}
