//
//  RecipeCategoryViewController.swift
//  UponShef
//
//  Created by cgtn on 2018/7/17.
//  Copyright © 2018年 houcong. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Then

enum CategoryListType: Int {
    case hot
    case normal
    case material
    case healthy
    
    static func categoryType(index: Int) -> String {
        switch index {
        case 0:
            return "fenlei"
        case 1:
            return "caipu"
        case 2:
            return "shicai"
        default:
            return "jiankang"
        }
    }
}

class RecipeCategoryViewController: UIViewController {

    let disposeBag = DisposeBag()
    let scroll = UIScrollView(frame: CGRect(x: 0, y: Tools.navigationHeight(), width: Constant.kScreenWidth, height: Constant.kScreenHeight - Tools.navigationHeight() - Tools.tabBarHeight()))
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // tapGesture

        
        view.backgroundColor = UIColor.white
        navigationItem.title = ""
        let segment = UISegmentedControl(items: ["热门","常见","食材","健康"]).then { segmentContol in
            segmentContol.center = CGPoint(x: Constant.kScreenWidth * 0.5, y: Constant.kNavgiationTabBarH * 0.5)
            segmentContol.selectedSegmentIndex = 0
        }
        navigationController?.navigationBar.addSubview(segment)
//        automaticallyAdjustsScrollViewInsets = false
        scroll.contentInsetAdjustmentBehavior = .never
        scroll.isPagingEnabled = true
        scroll.bounces = false
        scroll.showsVerticalScrollIndicator = false
        scroll.showsHorizontalScrollIndicator = false
        view.addSubview(scroll)
        scroll.contentSize = CGSize(width: Constant.kScreenWidth * 4.0, height: Constant.kScreenHeight - Tools.navigationHeight() - Tools.tabBarHeight())
        
        segment.rx.selectedSegmentIndex.asObservable()
            .subscribe(onNext: {[weak self] (segmentIndex) in
                    self?.scroll.setContentOffset(CGPoint(x: Constant.kScreenWidth * CGFloat(segmentIndex), y: 0), animated: false)
            })
            .disposed(by: disposeBag)

        scroll.rx.didEndDecelerating.asObservable().subscribe(onNext: {[weak self] _ in
            segment.selectedSegmentIndex = Int((self?.scroll.contentOffset.x)! / Constant.kScreenWidth)
        })
        .disposed(by: disposeBag)
        
       
        setupChildViewController()
    }
    
    func setupChildViewController() {
        let vcs = [HotCategoryViewController(),NormalViewController(),FoodMaterialViewController(),HealthyViewController()]
        
        for vc in vcs {
            vc.segmentIndex = Observable<Int>.of(vcs.index(of: vc) ?? 0)
            vc.view.frame = CGRect(x:Constant.kScreenWidth * CGFloat(vcs.index(of: vc) ?? 0) , y: 0, width: Constant.kScreenWidth, height: Constant.kScreenHeight - Tools.navigationHeight() - Tools.tabBarHeight())
            scroll.addSubview(vc.view)
            addChildViewController(vc)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.subviews.last?.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.subviews.last?.isHidden = true
    }
}
