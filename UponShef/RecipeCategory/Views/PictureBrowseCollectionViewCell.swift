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
    
    var translationAction: (()->())?
    
    fileprivate let scroll = UIScrollView().then { (scrollView) in
        scrollView.backgroundColor = UIColor.black
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.maximumZoomScale = 5.0
        scrollView.minimumZoomScale = 1.0
        scrollView.setZoomScale(1.0, animated: false)
    }
    
    fileprivate let imageV = UIImageView().then { (imageView) in
        imageView.isUserInteractionEnabled = true
        imageView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 250)
        imageView.center = CGPoint(x: kScreenWidth * 0.5, y: kScreenHeight * 0.5)
    }
    
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
        
        scroll.snp.makeConstraints { (make) in
            make.left.equalTo(contentView.snp.left)
            make.right.equalTo(contentView.snp.right)
            make.top.equalTo(contentView.snp.top)
            make.bottom.equalTo(contentView.snp.bottom)
        }

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(PictureBrowseCollectionViewCell.panGestureAction(gesture:)))
        
        imageV.addGestureRecognizer(panGesture)
        
        
        
        // 缩放时避免使用自动布局
//        imageV.snp.makeConstraints { (make) in
//            make.center.equalTo(scroll.snp.center)
//            make.width.equalTo(kScreenWidth)
//        }
        
    }
    
    func configureCell(content: RecipeSteps) {
        imageV.kf.setImage(with: URL(string: content.step_img_src), placeholder: placeholderImg)
    }
    
    func initlizeScale() {
        scroll.setZoomScale(1.0, animated: false)
    }
    
    @objc func panGestureAction(gesture: UIPanGestureRecognizer) {
        
        if gesture.state == .changed {
            let point = gesture.location(in: scroll)
            let scale = 1 - fabs(point.y - scroll.center.y) / (kScreenHeight)
            imageV.transform = CGAffineTransform.init(scaleX: scale, y: scale)
            
            let translationP = gesture.translation(in: scroll)
            imageV.center = CGPoint(x: (gesture.view?.center.x ?? 0) + translationP.x, y: (gesture.view?.center.y ?? 0) + translationP.y)


            gesture.setTranslation(CGPoint.zero, in: scroll)
            
        } else if gesture.state == .ended {
            guard let gestureEnd = translationAction else {
                return
            }
            gestureEnd()
        }
        
        
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
