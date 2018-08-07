//
//  MyServiceExtension.swift
//  UponShef
//
//  Created by cgtn on 2018/8/6.
//  Copyright © 2018年 houcong. All rights reserved.
//

import Foundation
import Moya

extension MyService : TargetType {
    var baseURL: URL {
        return  URL(string: Constant.baseURL)!
    }

    var path: String {
        switch self {
        case .categoryList(let type):
            return "/category_list/\(type)"
            
        case .recipeList(let type, let page):
            return "/caipulist/\(type)/page/\(page)"
            
        case .recipeSteps(let type, let identifier):
            return "/caipulist/\(type)/identifier/\(identifier)"
            
        }
    }

    var method: Moya.Method {
        return .get
    }

    var sampleData: Data {
        switch self {
        case .categoryList(let type):
            return "\"category\" : \(type)".utf8Encoded
            
        case .recipeList(let type, let page):
            return "\"category\" : \(type), \"page\": \(page)".utf8Encoded
            
        case .recipeSteps(let type, let identifier):
            return "\"category\" : \(type), \"identifier\" : \(identifier)".utf8Encoded
        }
    }

    var task: Task {
        return .requestPlain
    }

    var headers: [String : String]? {
        return ["Content-type" : "application/json"]
    }
    
    
}


private extension String {
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}
