//
//  CategoryDetailCollectionViewCell.swift
//  UponShef
//
//  Created by cgtn on 2018/7/26.
//  Copyright © 2018年 houcong. All rights reserved.
//

import UIKit
import SnapKit
class CategoryDetailCollectionViewCell: UICollectionViewCell {
    
    var is3DTouch = false

    let titleL = UILabel().then { (label) in
        label.font = UIFont.systemFont(ofSize: 15.0)
        label.textAlignment = .center
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setup() {
        contentView.addSubview(titleL)
        titleL.snp.makeConstraints { (make) in
            make.left.equalTo(contentView.snp.left)
            make.right.equalTo(contentView.snp.right)
            make.top.equalTo(contentView.snp.top)
            make.bottom.equalTo(contentView.snp.bottom)
        }
    }
    
    func configureCell(content:String) {
        titleL.text = content
    }
}
