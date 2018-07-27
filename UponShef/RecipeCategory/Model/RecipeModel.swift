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

struct RecipeShicai {
    let shicai_name: String
    let shicai_fenliang: String
    let shic_xiangke: String
    let shicai_detail: String
    
    static func recipeShicai(shicai: [String : String]) -> RecipeShicai {
        
        let shicaiModel = RecipeShicai(shicai_name: Tools.toString(item: shicai["shicai_name"]),
                                  shicai_fenliang: Tools.toString(item: shicai["shicai_fenliang"]),
                                  shic_xiangke: Tools.toString(item: shicai["shic_xiangke"]),
                                  shicai_detail: Tools.toString(item: shicai["shicai_detail"]))
        return shicaiModel
    }
}

struct RecipeSteps {
    let step_img_src: String
    let step_describe: String
    let step_index: String
    let step_img_alt: String
    
    static func recipeSteps(steps: [String : String]) -> RecipeSteps {
        let recipeStepsModel = RecipeSteps(step_img_src: Tools.toString(item: steps["step_img_src"]),
                                           step_describe: Tools.toString(item: steps["step_describe"]),
                                           step_index: Tools.toString(item: steps["step_index"]),
                                           step_img_alt: Tools.toString(item: steps["step_img_alt"]))
        return recipeStepsModel
    }
}

struct RecipeDetailModel {
    let identifier: String
    let recipe_cover: String
    let shicais: [RecipeShicai]
    let video_src: String
    let recipe_id: String
    let setps: [RecipeSteps]
    let video_poster: String
    
    static func recipeDetail(content: [String : Any]) -> RecipeDetailModel {
        var shicais = [RecipeShicai]()
        var steps = [RecipeSteps]()
        
        let shicaiAll = content["shicais"] as! [[String : String]]
        let stepsAll = content["steps"] as! [[String : String]]
        for shicai in shicaiAll {
            shicais.append(RecipeShicai.recipeShicai(shicai: shicai))
        }
        
        for step in stepsAll {
            steps.append(RecipeSteps.recipeSteps(steps: step))
        }
        
        let recipeDetail = RecipeDetailModel(identifier: Tools.toString(item: content["_id"]),
                                             recipe_cover: Tools.toString(item: content["recipe_cover"]),
                                             shicais: shicais,
                                             video_src: Tools.toString(item: content["video_src"]),
                                             recipe_id: Tools.toString(item: content["recipe_id"]),
                                             setps: steps,
                                             video_poster: Tools.toString(item: content["video_poster"]))
        return recipeDetail
    }
}
