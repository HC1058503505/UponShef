//
//  MyProvider.swift
//  UponShef
//
//  Created by cgtn on 2018/8/6.
//  Copyright © 2018年 houcong. All rights reserved.
//

import Foundation
import Moya
import RxSwift

struct MyProvider {
    fileprivate static let HttpProvider = MoyaProvider<MyService>()
    
    static func categoryList(type: String) -> Observable<MealsCategoryModel>{
       return HttpProvider.rx.request(MyService.categoryList(type: type)).asObservable().mapJSON(failsOnEmptyData: true)
            .flatMap({ (json) -> Observable<MealsCategoryModel> in
                let jsonDecoder = JSONDecoder()
                guard let jsonData = try? JSONSerialization.data(withJSONObject: json, options: []) else {
                    return Observable<MealsCategoryModel>.error(UponShefError.dataFormatWrong)
                }
                guard let model = try? jsonDecoder.decode(MealsCategoryModel.self, from: jsonData) else {
                    return Observable<MealsCategoryModel>.error(UponShefError.dataFormatWrong)
                }
                return Observable<MealsCategoryModel>.create({ (category) -> Disposable in
                    category.onNext(model)
                    return Disposables.create()
                })
            })
    }
    
    static func recipeList(type: String, page: Int) -> Observable<[RecipeOutlineModel]> {
       return HttpProvider.rx.request(MyService.recipeList(type: type, page: page)).asObservable().mapJSON(failsOnEmptyData: true)
        .flatMap({ (result) -> Observable<[RecipeOutlineModel]> in
            guard let recipes = result as? [[String : Any]] else {
                return Observable<[RecipeOutlineModel]>.error(UponShefError.dataFormatWrong)
            }
            
            var recipeList = [RecipeOutlineModel]()
            for recipe in recipes {
                let recipeModel = RecipeOutlineModel.recipeOutlineModel(recipe: recipe)
                recipeList.append(recipeModel)
            }
            return Observable<[RecipeOutlineModel]>.create({ (category) -> Disposable in
                category.onNext(recipeList)
                return Disposables.create()
            })
        })
    }
    
    static func recipeSteps(type: String, identifier: String) -> Observable<RecipeDetailModel> {
        return HttpProvider.rx.request(MyService.recipeSteps(type: type, identifier: identifier)).asObservable().mapJSON(failsOnEmptyData: true)
                .flatMap { (result) -> Observable<RecipeDetailModel> in
                    guard let steps = result as? [String : Any] else {
                        return Observable<RecipeDetailModel>.error(UponShefError.dataFormatWrong)
                    }
                
                    let recipeDetailM = RecipeDetailModel.recipeDetail(content: steps)
                
                    return Observable<RecipeDetailModel>.create({ (recipeDetail) -> Disposable in
                        recipeDetail.onNext(recipeDetailM)
                        return Disposables.create()
                    })
            }
    }
}
