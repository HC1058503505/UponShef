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
    var responseObserver = Observable<MealsCategoryModel>.empty()

    
    static func categoryList(type: String) -> Observable<MealsCategoryModel>{

        guard let url = URL(string: Constant.baseURL + "category_list/" + type) else {
            return Observable<MealsCategoryModel>.error(UponShefError.urlNotExist)
        }

        return RxAlamofire.requestJSON(.get, url)
            .flatMap({ (response, result) -> Observable<MealsCategoryModel> in
                guard response.statusCode == 200 else {
                    return Observable<MealsCategoryModel>.error(UponShefError.failedConnectServer)
                }
                let jsonDecoder = JSONDecoder()
                guard let jsonData = try? JSONSerialization.data(withJSONObject: result, options: []) else {
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
        guard let url = URL(string: Constant.baseURL + "caipulist/\(type)/page/\(page)") else {
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
        guard let url = URL(string: Constant.baseURL + "caipulist/\(type)/identifier/\(identifier)") else {
            return Observable<RecipeDetailModel>.error(UponShefError.urlNotExist)
        }
        
        return RxAlamofire.requestJSON(.get, url).flatMap { (response, result) -> Observable<RecipeDetailModel> in
            
            guard let steps = result as? [String : Any] else {
                return Observable<RecipeDetailModel>.error(UponShefError.dataFormatWrong)
            }
            
            let recipeDetailM = (try? JSONDecoder().decode(RecipeDetailModel.self, from: JSONSerialization.data(withJSONObject: steps, options: []))) ?? RecipeDetailModel()
    
            return Observable<RecipeDetailModel>.create({ (recipeDetail) -> Disposable in
                recipeDetail.onNext(recipeDetailM)
                return Disposables.create()
            })
        }
        
    }
}


