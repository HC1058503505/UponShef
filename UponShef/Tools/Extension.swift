//
//  Extension.swift
//  HCRxSwift
//
//  Created by cgtn on 2018/6/29.
//  Copyright © 2018年 cgtn. All rights reserved.
//

import Foundation
import UIKit


extension String {
    static func height(str: String, font: UIFont) -> CGFloat {
        return (str as NSString).boundingRect(with: CGSize(width: kScreenWidth - 20, height: CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font : font], context: nil).size.height
    }
}
