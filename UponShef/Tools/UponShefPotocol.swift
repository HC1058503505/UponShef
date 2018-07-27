//
//  UponShefPotocol.swift
//  UponShef
//
//  Created by cgtn on 2018/7/27.
//  Copyright © 2018年 houcong. All rights reserved.
//

import Foundation


protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
