//
//  PictureBrowseCollectionViewCell.swift
//  UponShef
//
//  Created by cgtn on 2018/7/30.
//  Copyright © 2018年 houcong. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher
import RxCocoa
import RxSwift
import Then

class PictureBrowseCollectionViewCell: UICollectionViewCell {
    
    fileprivate let scroll = UIScrollView().then { (scrollView) in
        scrollView.backgroundColor = UIColor.black
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.maximumZoomScale = 2.5
        scrollView.minimumZoomScale = 1.0
        scrollView.backgroundColor = UIColor.clear
        scrollView.setZoomScale(1.0, animated: false)
    }
    
    fileprivate let imageV = UIImageView().then { (imageView) in
        imageView.isUserInteractionEnabled = true
        imageView.frame = CGRect(x: 0, y: 0, width: Constant.kScreenWidth, height: 250)
        imageView.center = CGPoint(x: Constant.kScreenWidth * 0.5, y: Constant.kScreenHeight * 0.5)
    }
    
//    fileprivate let describeLabel = UILabel().then { (describe) in
//        describe.backgroundColor = UIColor.clear
//        describe.textColor = UIColor.white
//        describe.font = UIFont.systemFont(ofSize: 15.0)
//        describe.numberOfLines = 0
//    }
//
//    fileprivate let containerView = UIView().then { (container) in
//        container.backgroundColor = UIColor.black.withAlphaComponent(0.5)
//    }
    
    fileprivate let disposeBag = DisposeBag()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setup() {
        
        scroll.delegate = self
        contentView.addSubview(scroll)
        scroll.addSubview(imageV)
//        contentView.addSubview(containerView)
//        containerView.addSubview(describeLabel)
        
        scroll.snp.makeConstraints { (make) in
            make.left.equalTo(contentView.snp.left)
            make.right.equalTo(contentView.snp.right)
            make.top.equalTo(contentView.snp.top)
            make.bottom.equalTo(contentView.snp.bottom)
        }
        
//        containerView.snp.makeConstraints { (make) in
//            make.left.equalTo(contentView.snp.left)
//            make.right.equalTo(contentView.snp.right)
//            make.bottom.equalTo(contentView.snp.bottom)
//            make.top.equalTo(contentView.snp.centerY).offset(150)
//        }
//
//        describeLabel.snp.makeConstraints { (make) in
//            make.left.equalTo(containerView.snp.left).offset(10)
//            make.right.equalTo(containerView.snp.right).offset(-10)
//            make.top.equalTo(containerView.snp.top).offset(10)
//        }
        // 缩放时避免使用自动布局
//        imageV.snp.makeConstraints { (make) in
//            make.center.equalTo(scroll.snp.center)
//            make.width.equalTo(kScreenWidth)
//        }
        
    }
    
    func configureCell(content: RecipeSteps) {
        imageV.kf.setImage(with: URL(string: content.step_img_src), placeholder: Constant.placeholderImg)
//        describeLabel.text = "\(content.step_index). \(content.step_describe)"
    }
    
    func initlizeScale() {
        scroll.setZoomScale(1.0, animated: false)
    }
    
}


extension PictureBrowseCollectionViewCell : UIScrollViewDelegate{
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageV
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        var center = scrollView.center
        //目前contentsize的width是否大于原scrollview的contentsize，如果大于，设置imageview中心x点为contentsize的一半，以固定imageview在该contentsize中心。如果不大于说明图像的宽还没有超出屏幕范围，可继续让中心x点为屏幕中点，此种情况确保图像在屏幕中心。
        center.x = scrollView.contentSize.width > scrollView.frame.width ?
            scrollView.contentSize.width/2 : center.x
        //同上，此处修改y值
        center.y = scrollView.contentSize.height > scrollView.frame.height ?
            scrollView.contentSize.height/2  : center.y
        imageV.center = center

    }

}
