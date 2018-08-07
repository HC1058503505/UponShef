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
import Moya


struct CategoryViewModel : ViewModelType{
    
    struct Input {
        let categoryType: Observable<Int>
    }
    
    struct Output {
        let categoryList: Observable<MealsCategoryModel>
        
    }
    
    func transform(input: CategoryViewModel.Input) -> CategoryViewModel.Output {
        let output = input.categoryType.flatMap { (categoryType) -> Observable<MealsCategoryModel> in
            let type = CategoryListType.categoryType(index: categoryType)
            
            return MyProvider.categoryList(type: type)
            
            
            
//            return HTTPManager.categoryList(type: type)
        }
        return Output(categoryList: output)
    }

}
