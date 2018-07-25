//
//  CagtegoryBaseViewController.swift
//  UponShef
//
//  Created by cgtn on 2018/7/25.
//  Copyright © 2018年 houcong. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
class CagtegoryBaseViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    var segmentIndex:Observable<Int> = Observable<Int>.empty()
    
    let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 100, height: kScreenHeight - kNavgiationHeight - kTabBarHeight), style: .plain)
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        let input = CategoryViewModel.Input(categoryType: segmentIndex)
        let categoryVM = CategoryViewModel()
        let categoryListObservable = categoryVM.transform(input: input).categoryList
        
//        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 100, height: kScreenHeight - kNavgiationHeight - kTabBarHeight), style: .plain)
        view.addSubview(tableView)
        tableView.register(CategoryListTableViewCell.self, forCellReuseIdentifier: "Cell")
        
        tableView.rowHeight = 44.0
        tableView.separatorStyle = .none
        
        categoryListObservable.bind(to: tableView.rx.items){[weak self](tableV, row, element) in
                let cell = self?.tableView.dequeueReusableCell(withIdentifier: "Cell") as! CategoryListTableViewCell
                cell.configureCell(content: element.categoryTitle)
                return cell
            }
            .disposed(by: disposeBag)
        
        
        tableView.rx.itemSelected
            .subscribe(onNext: {[weak self] (indexpath) in
                let cell = self?.tableView.cellForRow(at: indexpath) as! CategoryListTableViewCell
                cell.itemSelected = true
            })
            .disposed(by: disposeBag)
        
        
        tableView.rx.itemDeselected
            .subscribe(onNext: {[weak self] (indexpath) in
                let cell = self?.tableView.cellForRow(at: indexpath) as! CategoryListTableViewCell
                cell.itemSelected = false
            })
            .disposed(by: disposeBag)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
