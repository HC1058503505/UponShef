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

class RecipePictureBrowseViewController: UIViewController {
    fileprivate let disposeBag = DisposeBag()
    
    var pictrueSteps = [RecipeSteps]()
    var currentStepIndex = 0
    
    var isAppear = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        // Do any additional setup after loading the view.
        
        let flowLayout = UICollectionViewFlowLayout().then { (flowL) in
            flowL.itemSize = CGSize(width: kScreenWidth, height: kScreenHeight)
            flowL.minimumLineSpacing = 0
            flowL.minimumInteritemSpacing = 0
            flowL.scrollDirection = .horizontal
        }
        
        let collectionV = UICollectionView(frame: view.bounds, collectionViewLayout: flowLayout).then { (collection) in
            collection.isPagingEnabled = true
            collection.contentInsetAdjustmentBehavior = .never
            collection.backgroundColor = UIColor.black
        }
        view.addSubview(collectionV)
        
        
        let backBtn = UIButton(type: .custom).then { (btn) in
            btn.setImage(UIImage(named: "back_btn"), for: .normal)
            
        }
        view.addSubview(backBtn)
        
        backBtn.snp.makeConstraints { (make) in
            make.left.equalTo(view.snp.left).offset(15)
            make.top.equalTo(view.snp.top).offset(Tools.safeAreaInsetTop())
            make.width.height.equalTo(40)
        }
        
        backBtn.rx.controlEvent(UIControlEvents.touchUpInside)
            .subscribe(onNext: {[weak self] _ in
                self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        
        collectionV.register(PictureBrowseCollectionViewCell.self, forCellWithReuseIdentifier: "RecipePictureBrowse")
        Observable<[RecipeSteps]>.just(pictrueSteps).bind(to: collectionV.rx.items) {
            collection, indexPath, element in
            let cell = collection.dequeueReusableCell(withReuseIdentifier: "RecipePictureBrowse", for: IndexPath(item: indexPath, section: 0)) as! PictureBrowseCollectionViewCell
            cell.configureCell(content: element)
            cell.translationAction = {
                self.dismiss(animated: true, completion: nil)
            }
            return cell
        }
        .disposed(by: disposeBag)
        
    
        collectionV.rx.willDisplayCell
            .subscribe(onNext: { (cell, indexPath) in
                (cell as! PictureBrowseCollectionViewCell).initlizeScale()
                
                if self.isAppear == false {
                    collectionV.scrollToItem(at: IndexPath(item: self.currentStepIndex, section: 0), at: UICollectionViewScrollPosition.centeredHorizontally, animated: false)
                }
            })
            .disposed(by: disposeBag)
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isAppear = true
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
