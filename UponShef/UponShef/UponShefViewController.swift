//
//  UponShefViewController.swift
//  UponShef
//
//  Created by cgtn on 2018/7/17.
//  Copyright © 2018年 houcong. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
class UponShefViewController: UIViewController {

    fileprivate let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
        // 创建label
        let label = UILabel().then { (textL) in
            textL.textColor = UIColor.white
            textL.backgroundColor = UIColor.orange
            textL.textAlignment = .center
            view.addSubview(textL)
            
            textL.snp.makeConstraints({ (make) in
                make.width.equalTo(200)
                make.height.equalTo(40)
                make.center.equalToSuperview()
            })
        }
        
//        Observable<String>.of("Hello RxSwift").bind(to: label.rx.text).dispose()
        
//        Observable<Int>.interval(1.0, scheduler: MainScheduler.instance)
//            .map {
//                return "\($0)"
//            }
//            .bind(to: label.rx.text)
//            .disposed(by: disposeBag)
        
//        Observable<Int>.interval(1.0, scheduler: MainScheduler.instance)
//            .map{
//                print($0)
//                return CGFloat($0)
//            }
//            .bind(to: label.rx.fontSize)
//            .disposed(by: disposeBag)
        
//        Observable<Int>.from([1,3,4,5,6,7,3,3,2,2,1,1,4])
//            .distinctUntilChanged()
//            .map {
//                print($0)
//               return "\($0)"
//            }
//            .asDriver(onErrorJustReturn: "")
//            .drive(label.rx.text)
//            .disposed(by: disposeBag)
        
        Observable<Int>.of(1,2,3,4,5,6).takeLast(3)
            .map {
                print($0)
                return "\($0)"
            }
            .bind(to: label.rx.text)
            .disposed(by: disposeBag)
        
    }
}

extension Reactive where Base: UILabel {
    var fontSize : Binder<CGFloat> {
        return Binder(self.base, binding: { (label, font) in
            label.font = UIFont.systemFont(ofSize: font)
        })
    }
    
}
