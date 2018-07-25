//
//  CategoryViewModel.swift
//  UponShef
//
//  Created by cgtn on 2018/7/19.
//  Copyright © 2018年 houcong. All rights reserved.
//

import Foundation
import RxSwift
import RxAlamofire
import RxCocoa

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}

class CategoryViewModel : ViewModelType{
    
    struct Input {
        let categoryType: Observable<Int>
    }
    
    struct Output {
        let categoryList: Observable<[HotCategoryModel]>
        
    }
    
    func transform(input: CategoryViewModel.Input) -> CategoryViewModel.Output {
        let output = input.categoryType.flatMap { (categoryType) -> Observable<[HotCategoryModel]> in
            let type = CategoryListType.categoryType(index: categoryType)
            
            let http = HTTPManager.manager()
            return http.categoryList(type: type)
        }
        return Output(categoryList: output)
    }

}