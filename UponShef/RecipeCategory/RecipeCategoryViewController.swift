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
    let scroll = UIScrollView(frame: CGRect(x: 0, y: kNavgiationHeight, width: kScreenWidth, height: kScreenHeight - kNavgiationHeight - kTabBarHeight))
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        navigationItem.title = ""
       let segment = UISegmentedControl(items: ["热门","常见","食材","健康"]).then { segmentContol in
            segmentContol.center = CGPoint(x: kScreenWidth * 0.5, y: kNavgiationTabBarH * 0.5)
            segmentContol.selectedSegmentIndex = 0
        }
        navigationController?.navigationBar.addSubview(segment)
        
        print(view.bounds)
        
        scroll.backgroundColor = UIColor.black
        scroll.isPagingEnabled = true
        scroll.bounces = false
        scroll.showsVerticalScrollIndicator = false
        scroll.showsHorizontalScrollIndicator = false
        view.addSubview(scroll)
        scroll.contentSize = CGSize(width: kScreenWidth * 4.0, height: kScreenHeight - kNavgiationHeight - kTabBarHeight)
        
        segment.rx.selectedSegmentIndex.asObservable()
            .subscribe(onNext: {[weak self] (segmentIndex) in
                    self?.scroll.setContentOffset(CGPoint(x: kScreenWidth * CGFloat(segmentIndex), y: 0), animated: true)
            })
            .disposed(by: disposeBag)

        scroll.rx.didEndDecelerating.asObservable().subscribe(onNext: {[weak self] _ in
            segment.selectedSegmentIndex = Int((self?.scroll.contentOffset.x)! / kScreenWidth)
        })
        .disposed(by: disposeBag)
        
       
        setupChildViewController()
    }
    
    func setupChildViewController() {
        let vcs = [HotCategoryViewController(),NormalViewController(),FoodMaterialViewController(),HealthyViewController()]
        
        for vc in vcs {
            vc.segmentIndex = Observable<Int>.of(vcs.index(of: vc) ?? 0)
            vc.view.frame = CGRect(x:kScreenWidth * CGFloat(vcs.index(of: vc) ?? 0) , y: 0, width: kScreenWidth, height: kScreenHeight - kNavgiationHeight - kTabBarHeight)
            scroll.addSubview(vc.view)
            addChildViewController(vc)
        }
    }
}
