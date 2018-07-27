//
//  RecipeTableViewCell.swift
//  UponShef
//
//  Created by cgtn on 2018/7/27.
//  Copyright © 2018年 houcong. All rights reserved.
//

import UIKit
import SnapKit
import Then
import Kingfisher
class RecipeTableViewCell: UITableViewCell {
    var isForceTouchRegistered = false
    fileprivate let recipeImgView = UIImageView()
    fileprivate let recipeName = UILabel().then { (nameL) in
        nameL.font = UIFont.boldSystemFont(ofSize: 15.0)
    }
    fileprivate let recipeBrowse = UILabel().then { (browseL) in
        browseL.font = UIFont.systemFont(ofSize: 15.0)
    }
    fileprivate let recipeCollection = UILabel().then { (collectionL) in
        collectionL.font = UIFont.systemFont(ofSize: 15.0)
    }
    fileprivate let recipeVideo = UIImageView().then { (imgV) in
        imgV.image = UIImage(named: "play_btn")
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setup() {
        contentView.addSubview(recipeImgView)
        contentView.addSubview(recipeName)
        contentView.addSubview(recipeBrowse)
        contentView.addSubview(recipeCollection)
        recipeImgView.addSubview(recipeVideo)
        
        recipeImgView.snp.makeConstraints { (make) in
            make.left.equalTo(contentView.snp.left).offset(10)
            make.top.equalTo(contentView.snp.top).offset(10)
            make.bottom.equalTo(contentView.snp.bottom).offset(-10)
            make.width.equalTo(160.0)
        }
        
        recipeVideo.snp.makeConstraints { (make) in
            make.centerX.equalTo(recipeImgView.snp.centerX)
            make.centerY.equalTo(recipeImgView.snp.centerY)
            make.width.height.equalTo(40)
        }
        
        recipeName.snp.makeConstraints { (make) in
            make.left.equalTo(recipeImgView.snp.right).offset(10)
            make.top.equalTo(recipeImgView.snp.top)
            make.height.equalTo(35)
            make.right.equalTo(contentView.snp.right).offset(-10)
        }
        
        recipeBrowse.snp.makeConstraints { (make) in
            make.left.equalTo(recipeName.snp.left)
            make.bottom.equalTo(recipeImgView.snp.bottom)
            make.height.equalTo(30)
        }
        
        recipeCollection.snp.makeConstraints { (make) in
            make.bottom.equalTo(recipeBrowse.snp.bottom)
            make.height.equalTo(recipeBrowse.snp.height)
            make.right.equalTo(contentView.snp.right).offset(-10)
            make.left.equalTo(recipeBrowse.snp.right).offset(-10)
        }
    }
    
    func configureCell(content: RecipeOutlineModel) {
        recipeImgView.kf.setImage(with: URL(string: content.recipe_imgsrc), placeholder: UIImage(named: "placeholder"))
        recipeBrowse.text = Tools.toFormat(item: content.recipe_browse) + "浏览"
        recipeCollection.text = Tools.toFormat(item: content.recipe_collection) + "收藏"
        recipeName.text = content.recipe_name
        recipeVideo.isHidden = !content.recipe_isvideo
    }

    
}
