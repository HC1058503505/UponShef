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


class HTTPManager {
    let disposeBag = DisposeBag()
    var responseObserver = Observable<[HotCategoryModel]>.empty()
    
    
    static func manager() -> HTTPManager {
        return HTTPManager()
    }
    
    func categoryList(type: String) -> Observable<[HotCategoryModel]>{

        guard let url = URL(string: "http://localhost:3000/category_list/" + type) else {
            return Observable<[HotCategoryModel]>.empty()
        }

        return RxAlamofire.requestJSON(.get, url)
            .flatMap({ (response, result) -> Observable<[HotCategoryModel]> in
                guard let resultJson = result as? [[String : Any]] else {
                    return Observable<[HotCategoryModel]>.empty()
                }
                
                guard let resultSubs = resultJson.first else {
                    return Observable<[HotCategoryModel]>.empty()
                }
                
                guard let subs = resultSubs["subs"] as? [[String : Any]] else {
                    return Observable<[HotCategoryModel]>.empty()
                }
                
                var categories = [HotCategoryModel]()
                for sub in subs {
                    categories.append(HotCategoryModel(hotCategory: sub))
                }
                return Observable<[HotCategoryModel]>.create({ (category) -> Disposable in
                    category.onNext(categories)
                    return Disposables.create()
                })
            })
    }
}


