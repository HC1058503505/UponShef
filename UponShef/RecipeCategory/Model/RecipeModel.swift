//
//  RecipeOutlineModel.swift
//  UponShef
//
//  Created by cgtn on 2018/7/27.
//  Copyright © 2018年 houcong. All rights reserved.
//

import Foundation

struct RecipeOutlineModel {
    let identifier: String
    let recipe_type: String
    let recipe_collection: String
    let recipe_id: String
    let recipe_href: String
    let recipe_browse: String
    let recipe_img_h: String
    let recipe_imgalt: String
    let recipe_isvideo: Bool
    let recipe_name: String
    let recipe_img_w: String
    let recipe_imgsrc: String
    
    static func recipeOutlineModel(recipe: [String : Any]) -> RecipeOutlineModel {
        
        let recipeModel = RecipeOutlineModel(identifier: Tools.toString(item: recipe["_id"]),
                                             recipe_type: Tools.toString(item: recipe["recipe_type"]),
                                             recipe_collection: Tools.toString(item: recipe["recipe_collection"]),
                                             recipe_id: Tools.toString(item: recipe["recipe_id"]),
                                             recipe_href: Tools.toString(item: recipe["recipe_href"]),
                                             recipe_browse: Tools.toString(item: recipe["recipe_browse"]),
                                             recipe_img_h: Tools.toString(item: recipe["recipe_img_h"]),
                                             recipe_imgalt: Tools.toString(item: recipe["recipe_imgalt"]),
                                             recipe_isvideo: Tools.toBool(item: recipe["recipe_isvideo"]),
                                             recipe_name: Tools.toString(item: recipe["recipe_name"]),
                                             recipe_img_w: Tools.toString(item: recipe["recipe_img_w"]),
                                             recipe_imgsrc: Tools.toString(item: recipe["recipe_imgsrc"]))
        
        return recipeModel
    }
    
}

struct RecipeShicai: Codable {
    let shicai_name: String
    let shicai_fenliang: String
    let shic_xiangke: String
    let shicai_detail: String
}

struct RecipeSteps: Codable{
    let step_img_src: String
    let step_describe: String
    let step_index: String
    let step_img_alt: String
 
}

struct RecipeDetailModel: Codable {
    let identifier: String
    let recipe_cover: String
    let shicais: [RecipeShicai]
    let video_src: String
    let recipe_id: String
    let steps: [RecipeSteps]
    let video_poster: String
    
    init() {
        identifier = ""
        recipe_cover = ""
        shicais = [RecipeShicai]()
        video_src = ""
        recipe_id = ""
        steps = [RecipeSteps]()
        video_poster = ""
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(identifier, forKey: .identifier)
        try container.encode(recipe_cover, forKey: .recipe_cover)
        try container.encode(shicais, forKey: .shicais)
        try container.encode(video_src, forKey: .video_src)
        try container.encode(recipe_id, forKey: .recipe_id)
        try container.encode(steps, forKey: .steps)
        try container.encode(video_poster, forKey: .video_poster)
        
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        identifier = try container.decode(String.self, forKey: .identifier)
        recipe_cover = try container.decode(String.self, forKey: .recipe_cover)
        shicais = try container.decode([RecipeShicai].self, forKey: .shicais)
        video_src = try container.decode(String.self, forKey: .video_src)
        recipe_id = try container.decode(String.self, forKey: .recipe_id)
        steps = try container.decode([RecipeSteps].self, forKey: .steps)
        video_poster = try container.decode(String.self, forKey: .video_poster)
        
    }
    
    enum CodingKeys: String, CodingKey{
        case identifier = "_id"
        case recipe_cover = "recipe_cover"
        case shicais = "shicais"
        case video_src = "video_src"
        case recipe_id = "recipe_id"
        case steps = "steps"
        case video_poster = "video_poster"
    }
    
//    static func recipeDetail(content: [String : Any]) -> RecipeDetailModel {
//        var shicais = [RecipeShicai]()
//        var steps = [RecipeSteps]()
//
//        let shicaiAll = content["shicais"] as! [[String : String]]
//        let stepsAll = content["steps"] as! [[String : String]]
//        for shicai in shicaiAll {
//            shicais.append(RecipeShicai.recipeShicai(shicai: shicai))
//        }
//
//        for step in stepsAll {
//            steps.append(RecipeSteps.recipeSteps(steps: step))
//        }
//
//        let recipeDetail = RecipeDetailModel(identifier: Tools.toString(item: content["_id"]),
//                                             recipe_cover: Tools.toString(item: content["recipe_cover"]),
//                                             shicais: shicais,
//                                             video_src: Tools.toString(item: content["video_src"]),
//                                             recipe_id: Tools.toString(item: content["recipe_id"]),
//                                             setps: steps,
//                                             video_poster: Tools.toString(item: content["video_poster"]))
//        return recipeDetail
//    }
}
