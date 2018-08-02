//
//  HTTPManager.swift
//  UponShef
//
//  Created by cgtn on 2018/7/19.
//  Copyright © 2018年 houcong. All rights reserved.
//

import Foundation
import RxAlamofire
import RxSwift


enum UponShefError: Error {
    case urlNotExist
    case dataFormatWrong
    case failedConnectServer
}

class HTTPManager {
    let disposeBag = DisposeBag()
    var responseObserver = Observable<[HotCategoryModel]>.empty()

    
    static func categoryList(type: String) -> Observable<[HotCategoryModel]>{

        guard let url = URL(string: baseURL + "category_list/" + type) else {
            return Observable<[HotCategoryModel]>.error(UponShefError.urlNotExist)
        }

        return RxAlamofire.requestJSON(.get, url)
            .flatMap({ (response, result) -> Observable<[HotCategoryModel]> in
                guard response.statusCode == 200 else {
                    return Observable<[HotCategoryModel]>.error(UponShefError.failedConnectServer)
                }
                
                guard let resultJson = result as? [[String : Any]] else {
                    return Observable<[HotCategoryModel]>.error(UponShefError.dataFormatWrong)
                }
                
                guard let resultSubs = resultJson.first else {
                    return Observable<[HotCategoryModel]>.error(UponShefError.dataFormatWrong)
                }
                
                guard let subs = resultSubs["subs"] as? [[String : Any]] else {
                    return Observable<[HotCategoryModel]>.error(UponShefError.dataFormatWrong)
                }
                
                var categories = [HotCategoryModel]()
                var tempIndex = 0
                for sub in subs {
                    let category = HotCategoryModel(hotCategory: sub)
                    if tempIndex == 0 {
                        category.isSelected = true
                    }
                    categories.append(category)
                    tempIndex = tempIndex + 1
                }
                return Observable<[HotCategoryModel]>.create({ (category) -> Disposable in
                    category.onNext(categories)
                    return Disposables.create()
                })
            })

    }
    
    static func recipeList(type: String, page: Int) -> Observable<[RecipeOutlineModel]> {
        guard let url = URL(string: baseURL + "caipulist/\(type)/page/\(page)") else {
            return Observable<[RecipeOutlineModel]>.error(UponShefError.urlNotExist)
        }
        
        return RxAlamofire.requestJSON(.get, url)
            .flatMap({ (response, result) -> Observable<[RecipeOutlineModel]> in
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
        
    
//        return Observable<[RecipeOutlineModel]>.create({ (recipeSubscribe) -> Disposable in
//            guard let url = URL(string: "http://localhost:3000/caipulist/\(type)/page/\(page)") else {
//                return Disposables.create()
//            }
//
//            _ = RxAlamofire.requestJSON(.get, url).subscribe(onNext: { (response, result) in
//                guard let recipes = result as? [[String : Any]] else {
//                    return
//                }
//
//                var recipeList = [RecipeOutlineModel]()
//                for recipe in recipes {
//                    let recipeModel = RecipeOutlineModel.recipeOutlineModel(recipe: recipe)
//                    recipeList.append(recipeModel)
//                }
//
//                recipeSubscribe.onNext(recipeList)
//            })
//
//            return Disposables.create()
//
//        })
    }
    
    
    static func recipeSteps(type: String, identifier: String) -> Observable<RecipeDetailModel> {
        guard let url = URL(string: baseURL + "caipulist/\(type)/identifier/\(identifier)") else {
            return Observable<RecipeDetailModel>.error(UponShefError.urlNotExist)
        }
        
        return RxAlamofire.requestJSON(.get, url).flatMap { (response, result) -> Observable<RecipeDetailModel> in
            
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


