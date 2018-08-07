//
//  RecipeDetailViewModel.swift
//  UponShef
//
//  Created by cgtn on 2018/7/27.
//  Copyright © 2018年 houcong. All rights reserved.
//

import Foundation
import RxSwift

struct RecipeDetailViewModel : ViewModelType {
    
    struct Input {
        var recipeType: Observable<(String, String)>
    }
    
    struct Output {
        var recipeDetail: Observable<RecipeDetailModel>
    }
    
    func transform(input: RecipeDetailViewModel.Input) -> RecipeDetailViewModel.Output {
        let output = input.recipeType.flatMap { (type, identifier) -> Observable<RecipeDetailModel> in
            return MyProvider.recipeSteps(type: type, identifier: identifier)
        }
        
        return Output(recipeDetail: output)
    }
    
}
