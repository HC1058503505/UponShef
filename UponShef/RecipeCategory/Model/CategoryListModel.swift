//
//  CategoryListModel.swift
//  UponShef
//
//  Created by cgtn on 2018/7/19.
//  Copyright © 2018年 houcong. All rights reserved.
//

import Foundation

struct CategoryInfo: Codable {
    let categorySubHref: String
    let categorySubTitle: String
    
    enum CodingKeys: String, CodingKey {
        case categorySubHref = "category_sub_href"
        case categorySubTitle = "category_sub_title"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(categorySubHref, forKey: .categorySubHref)
        try container.encode(categorySubTitle, forKey: .categorySubTitle)
        
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        categorySubHref = try container.decode(String.self, forKey: .categorySubHref)
        
        categorySubTitle = try container.decode(String.self, forKey: .categorySubTitle)
        
    }
}

// 结构体实例无法改变结构体属性的值
// 因为结构体是值类型
struct MealsSubModel: Codable {
    let categoryUrl: String
    let categoryTitle: String
    let categorySubs: [CategoryInfo]?
    let meterialSubs: [[CategoryInfo]]?
    
    enum CodingKeys: String, CodingKey {
        case categoryUrl = "category_url"
        case categoryTitle = "category_title"
        case categorySubs = "category_subs"
        case meterialSubs = "category_meterial"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(categoryUrl, forKey: .categoryUrl)
        try container.encode(categoryTitle, forKey: .categoryTitle)
        try container.encode(categorySubs, forKey: .categorySubs)
        try container.encode(meterialSubs, forKey: .meterialSubs)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        categoryUrl = try container.decode(String.self, forKey: .categoryUrl)
        
        categoryTitle = try container.decode(String.self, forKey: .categoryTitle)
        do {
            categorySubs = try container.decode([CategoryInfo]?.self, forKey: .categorySubs)
            meterialSubs = nil
        } catch  {
            meterialSubs = try container.decode([[CategoryInfo]]?.self, forKey: .meterialSubs)
            categorySubs = nil
        }
        
    }
}

struct MealsCategoryModel: Codable {
    let identifier: String
    let recipeType: String
    let subs: [MealsSubModel]?
    
    enum CodingKeys: String, CodingKey {
        case identifier = "_id"
        case recipeType = "recipe_type"
        case subs = "subs"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(identifier, forKey: .identifier)
        try container.encode(recipeType, forKey: .recipeType)
        try container.encode(subs, forKey: .subs)
        
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        identifier = try container.decode(String.self, forKey: .identifier)
        recipeType = try container.decode(String.self, forKey: .recipeType)
        subs = try container.decode([MealsSubModel]?.self, forKey: .subs)
    }
}

//class CategoryInfo {
//    fileprivate var categoryInfo = [String : String]()
//    init(info: [String : String]) {
//       categoryInfo = info
//    }
//
//    var categorySubHref: String {
//        return categoryInfo["category_sub_href"] ?? ""
//    }
//
//    var categorySubTitle: String {
//        return categoryInfo["category_sub_title"] ?? ""
//    }
//}

//class HotCategoryModel {
//    internal var category = [String : Any]()
//    var isSelected:Bool = false
//
//    init(hotCategory: [String : Any]) {
//        category = hotCategory
//    }
//
//    var categorySubs: [CategoryInfo] {
//        var temp = [CategoryInfo]()
//
//        guard let infos = category["category_subs"] as? [[String : String]] else {
//            return temp
//        }
//        for item in infos {
//            let categoryInfo = CategoryInfo.init(info: item)
//            temp.append(categoryInfo)
//        }
//        return temp
//    }
//
//    var categoryTitle: String {
//        return (category["category_title"] as? String) ?? ""
//    }
//
//    var categoryUrl: String {
//        return (category["category_url"] as? String) ?? ""
//    }
//
//    var meterialSubs: [[String : [CategoryInfo]]] {
//        guard let infos = category["category_subs"] as? [String : [[String : String]]] else {
//            return [[String : [CategoryInfo]]]()
//        }
//        var foodMeterial = [[String : [CategoryInfo]]]()
//        for item in infos {
//            var tempMeterial = [String : [CategoryInfo]]()
//            var temp = [CategoryInfo]()
//            for info in item.value {
//                let categoryInfo = CategoryInfo.init(info: info)
//                temp.append(categoryInfo)
//            }
//            tempMeterial = [item.key : temp]
//            foodMeterial.append(tempMeterial)
//        }
//        return foodMeterial
//    }
//}
