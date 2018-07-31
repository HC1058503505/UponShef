//
//  RecipeShiCaiTableViewCell.swift
//  UponShef
//
//  Created by cgtn on 2018/7/27.
//  Copyright © 2018年 houcong. All rights reserved.
//

import UIKit
import SnapKit

class RecipeShiCaiTableViewCell: UITableViewCell {

    let shicaiNameL = UILabel()
    let shicaiFengliangL = UILabel()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    fileprivate func setup() {
        selectionStyle = .none
        contentView.addSubview(shicaiNameL)
        contentView.addSubview(shicaiFengliangL)
        
        shicaiNameL.snp.makeConstraints { (make) in
            make.left.equalTo(contentView.snp.left).offset(10)
            make.top.equalTo(contentView.snp.top).offset(10)
            make.bottom.equalTo(contentView.snp.bottom).offset(-10)
            make.right.equalTo(shicaiFengliangL.snp.left)
        }
        
        shicaiFengliangL.snp.makeConstraints { (make) in
            make.right.equalTo(contentView.snp.right).offset(-10)
            make.top.equalTo(contentView.snp.top).offset(10)
            make.bottom.equalTo(contentView.snp.bottom).offset(-10)
            make.left.equalTo(shicaiNameL.snp.right)
        }
    }
 
    func configureCell(shicai: RecipeShicai) {
        shicaiNameL.text = shicai.shicai_name.components(separatedBy: " ").first
        shicaiFengliangL.text = shicai.shicai_fenliang
    }
}
