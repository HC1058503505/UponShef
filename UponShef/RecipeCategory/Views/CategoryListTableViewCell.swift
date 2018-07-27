//
//  CategoryListTableViewCell.swift
//  UponShef
//
//  Created by cgtn on 2018/7/25.
//  Copyright © 2018年 houcong. All rights reserved.
//

import UIKit
import SnapKit
class CategoryListTableViewCell: UITableViewCell {
    let titleL = UILabel().then { (label) in
        label.font = UIFont.systemFont(ofSize: 15.0)
        label.textAlignment = .center
    }
    
    let indicatorV = UIView().then { (view) in
        view.backgroundColor = kThemeLightGrayColor
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setup() {
        contentView.addSubview(titleL)
        contentView.addSubview(indicatorV)
        
        titleL.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView.snp.centerX)
            make.centerY.equalTo(contentView.snp.centerY)
            make.top.equalTo(contentView.snp.top)
            make.bottom.equalTo(contentView.snp.bottom)
        }
        
        indicatorV.snp.makeConstraints { (make) in
            make.centerX.equalTo(titleL.snp.centerX)
            make.top.equalTo(titleL.snp.bottom).offset(-2.0)
            make.width.equalTo(titleL.snp.width)
            make.height.equalTo(2.0)
        }
        
    }
    
    
    func configureCell(content: HotCategoryModel) {
        titleL.text = content.categoryTitle
        itemSelected = content.isSelected
    }
    
 
   fileprivate var itemSelected: Bool = false {
        willSet {
            if  newValue {
                titleL.textColor = kThemeColor
                indicatorV.backgroundColor = kThemeColor
                contentView.backgroundColor = kThemeLightGrayColor
            } else {
                titleL.textColor = UIColor.black
                indicatorV.backgroundColor = kThemeLightGrayColor
                contentView.backgroundColor = UIColor.white
            }
        }
    }
    
}
