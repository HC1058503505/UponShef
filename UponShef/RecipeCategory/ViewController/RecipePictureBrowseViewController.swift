//
//  RecipePictureBrowseViewController.swift
//  UponShef
//
//  Created by cgtn on 2018/7/30.
//  Copyright © 2018年 houcong. All rights reserved.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa
import RxAlamofire
import Social

class RecipePictureBrowseViewController: UIViewController {
    fileprivate let disposeBag = DisposeBag()
    
    fileprivate let describeLabel = UILabel().then { (describe) in
        describe.backgroundColor = UIColor.clear
        describe.textColor = UIColor.white
        describe.font = UIFont.systemFont(ofSize: 15.0)
        describe.numberOfLines = 0
    }
    
    fileprivate let containerView = UIView().then { (container) in
        container.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    
    fileprivate let collectionV: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout().then { (flowL) in
            flowL.itemSize = CGSize(width: kScreenWidth, height: kScreenHeight)
            flowL.minimumLineSpacing = 0
            flowL.minimumInteritemSpacing = 0
            flowL.scrollDirection = .horizontal
        }
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout).then { (collection) in
            collection.isPagingEnabled = true
            collection.contentInsetAdjustmentBehavior = .never
            collection.backgroundColor = UIColor.clear
        }
        
        return collectionView
    }()
    
    let shareBtn = UIButton(type: .custom).then { (shareButton) in
        shareButton.backgroundColor = UIColor.clear
        shareButton.setImage(UIImage(named: "more"), for: UIControlState.normal)
    }
    
    
    fileprivate let bgView = UIView()
    fileprivate var isAppear = false
    
    var snapView = UIView()
    var pictrueSteps = [RecipeSteps]()
    var currentStepIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        setupView()

        dataDelegate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isAppear = true
    }

}

extension RecipePictureBrowseViewController {
    func setupView() {

        
        
        view.addSubview(snapView)
        snapView.snp.makeConstraints { (make) in
            make.left.top.right.bottom.equalToSuperview()
        }
        
        bgView.backgroundColor = UIColor.black
        bgView.alpha = 1.0
        view.addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
        
        
        view.addSubview(collectionV)
        collectionV.snp.makeConstraints { (make) in
            make.left.equalTo(view.snp.left)
            make.top.equalTo(view.snp.top)
            make.right.equalTo(view.snp.right)
            make.bottom.equalTo(view.snp.bottom)
        }
        
        view.addSubview(containerView)
        containerView.addSubview(describeLabel)
        
        containerView.snp.makeConstraints { (make) in
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.bottom.equalTo(view.snp.bottom)
            make.top.equalTo(view.snp.centerY).offset(150)
        }
        
        describeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(containerView.snp.left).offset(10)
            make.right.equalTo(containerView.snp.right).offset(-10)
            make.top.equalTo(containerView.snp.top).offset(10)
        }
        
        view.addSubview(shareBtn)
        shareBtn.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top).offset(Tools.safeAreaInsetTop())
            make.right.equalTo(view.snp.right).offset(-10)
            make.width.equalTo(50)
            make.height.equalTo(40)
        }
        
        shareBtn.rx.controlEvent(UIControlEvents.touchUpInside)
            .subscribe(onNext: {
                let shareText = "食神纪"
                let shareImage = UIImage(named: "AppIcon")!
                let shareUrl = URL(string: "https://www.jianshu.com/u/15d37d620d5b")!
                let activityItemsArray = [shareText, shareImage, shareUrl] as [Any]
                let activity = UponShefActivity(title: shareText, image: shareImage, url: shareUrl, type: UIActivityType(rawValue: "UponShef"))
                
                let activityVC = UIActivityViewController(activityItems: activityItemsArray, applicationActivities: [activity])
                activityVC.excludedActivityTypes = [UIActivityType.postToWeibo,UIActivityType.postToTwitter,UIActivityType.postToFacebook]
                
                activityVC.isModalInPopover = true
                self.present(activityVC, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(RecipePictureBrowseViewController.tapToClose))
        collectionV.addGestureRecognizer(tapGesture)
        
        collectionV.register(PictureBrowseCollectionViewCell.self, forCellWithReuseIdentifier: "RecipePictureBrowse")
    }
    
    func dataDelegate() {
        Observable<[RecipeSteps]>.just(pictrueSteps).bind(to: collectionV.rx.items) {
            collection, indexPath, element in
            let cell = collection.dequeueReusableCell(withReuseIdentifier: "RecipePictureBrowse", for: IndexPath(item: indexPath, section: 0)) as! PictureBrowseCollectionViewCell
            cell.configureCell(content: element)
            return cell
            }
            .disposed(by: disposeBag)
        
        
        collectionV.rx.willDisplayCell
            .subscribe(onNext: { (cell, indexPath) in
                (cell as! PictureBrowseCollectionViewCell).initlizeScale()
                
                if self.isAppear == false {
                    let index = indexPath.row
                    let step = self.pictrueSteps[index]
                    self.describeLabel.text = "\(step.step_index)/\(self.pictrueSteps.count)、 \(step.step_describe)"
                    
                    self.collectionV.scrollToItem(at: IndexPath(item: self.currentStepIndex, section: 0), at: UICollectionViewScrollPosition.centeredHorizontally, animated: false)
                }
            })
            .disposed(by: disposeBag)
        
        
        collectionV.rx.didEndDecelerating
            .subscribe(onNext: {
                let row = Int(self.collectionV.contentOffset.x / kScreenWidth)
                let step = self.pictrueSteps[row]
                self.describeLabel.text = "\(step.step_index)/\(self.pictrueSteps.count)、 \(step.step_describe)"
            })
            .disposed(by: disposeBag)
    }
    
    @objc func tapToClose() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func panGestureAction(panGesture: UIPanGestureRecognizer) {
        if panGesture.state == .changed {
            let reduce = fabs((panGesture.view?.center.y ?? 0) - view.center.y) / (kScreenHeight * 0.5)
            let scale = 1 - reduce
            
            panGesture.view?.transform = CGAffineTransform.init(scaleX: scale, y: scale)
            
            let translationP = panGesture.translation(in: panGesture.view)
            panGesture.view?.center = CGPoint(x: (panGesture.view?.center.x ?? 0) + translationP.x, y: (panGesture.view?.center.y ?? 0) + translationP.y)
            
            panGesture.setTranslation(CGPoint.zero, in: panGesture.view)
            bgView.alpha = scale
            if scale < 0.3 {
                self.dismiss(animated: false, completion: nil)
            }
            
        } else if panGesture.state == .ended {
            self.dismiss(animated: false, completion: nil)
        }
    }

}
