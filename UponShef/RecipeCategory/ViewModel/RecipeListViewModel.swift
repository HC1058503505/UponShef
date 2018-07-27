//
//  RecipeListViewModel.swift
//  UponShef
//
//  Created by cgtn on 2018/7/27.
//  Copyright © 2018年 houcong. All rights reserved.
//

import Foundation
import RxSwift

struct RecipeListViewModel: ViewModelType {
    
    struct Input {
        let recipeType: Observable<(String , Int)>
    }
    
    struct Output {
        let recipeList: Observable<[RecipeOutlineModel]>
        
    }
    
    func transform(input: RecipeListViewModel.Input) -> RecipeListViewModel.Output {
        let output = input.recipeType.flatMap { (recipeType, page) -> Observable<[RecipeOutlineModel]> in
            return HTTPManager.recipeList(type: recipeType, page: page)
        }
        
        return Output(recipeList: output)
    }
}
