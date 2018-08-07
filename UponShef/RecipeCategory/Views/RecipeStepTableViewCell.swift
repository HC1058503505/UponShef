//
//  RecipeStepTableViewCell.swift
//  UponShef
//
//  Created by cgtn on 2018/7/27.
//  Copyright © 2018年 houcong. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher
class RecipeStepTableViewCell: UITableViewCell {
    
    let recipeImgView = UIImageView().then { (recipeImg) in
        recipeImg.contentMode = .scaleAspectFit
    }
    let recipeStepL = UILabel().then { (label) in
        label.numberOfLines = 0
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setup() {
        selectionStyle = .none
        contentView.addSubview(recipeImgView)
        contentView.addSubview(recipeStepL)
        
        recipeImgView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top).offset(10)
            make.centerX.equalTo(contentView.snp.centerX)
            make.width.equalTo(250.0)
            make.height.equalTo(200.0)
            make.bottom.equalTo(recipeStepL.snp.top).offset(-10)
        }
        
        recipeStepL.snp.makeConstraints { (make) in
            make.left.equalTo(contentView.snp.left).offset(10)
            make.bottom.equalTo(contentView.snp.bottom).offset(-10)
            make.right.equalTo(contentView.snp.right).offset(-10)
            make.top.equalTo(recipeImgView.snp.bottom).offset(10)
        }
    }
    
    func configureCell(setps: RecipeSteps) {
        recipeImgView.kf.setImage(with: URL(string: setps.step_img_src), placeholder: Constant.placeholderImg)
        recipeStepL.text = setps.step_describe
    }
}
