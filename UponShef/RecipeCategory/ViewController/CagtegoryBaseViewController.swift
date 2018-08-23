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
    fileprivate let disposeBag = DisposeBag()

    var segmentIndex:Observable<Int> = Observable<Int>.empty()
    var cellsArr = [Bool]()
    fileprivate var categoryModels: MealsCategoryModel?
    fileprivate var tempSelectedIndexPath = IndexPath(row: 0, section: 0)
    fileprivate let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: Constant.kListWidth, height: Constant.kScreenHeight - Tools.navigationHeight() - Tools.tabBarHeight()), style: .plain)
    
    
    fileprivate var detailCollection = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout())
    
    var hasHeader: Bool {
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        let input = CategoryViewModel.Input(categoryType: segmentIndex)
        let categoryVM = CategoryViewModel()
        let categoryListObservable = categoryVM.transform(input: input).categoryList
        
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.register(CategoryListTableViewCell.self, forCellReuseIdentifier: "Cell")
        
        tableView.rowHeight = 44.0
        tableView.separatorStyle = .none

        categoryListObservable.subscribe(onNext: {[weak self] (categoryModel) in
            self?.categoryModels = categoryModel
            self?.cellsArr.append(contentsOf: [Bool](repeatElement(false, count: (categoryModel.subs?.count ?? 0))))
            if (self?.cellsArr.count ?? 0) > 0 {
                self?.cellsArr[0] = true
            }
            self?.tableView.reloadData()
            self?.detailCollection.reloadData()
        })
        .disposed(by: disposeBag)
    
        
        let flowLayout = UICollectionViewFlowLayout().then { (flow) in
            flow.itemSize = CGSize(width: 80, height: 30)
            flow.minimumInteritemSpacing = 10
            flow.minimumLineSpacing = 10
            flow.scrollDirection = .vertical
            if hasHeader {
                flow.headerReferenceSize = CGSize(width: Constant.kScreenWidth - Constant.kListWidth, height: 34.0)
            }
        }
        
        detailCollection = UICollectionView(frame: CGRect(x: Constant.kListWidth, y: 0, width: Constant.kScreenWidth - Constant.kListWidth, height: Constant.kScreenHeight - Tools.navigationHeight() - Tools.tabBarHeight()), collectionViewLayout: flowLayout)
        detailCollection.backgroundColor = UIColor.white
        detailCollection.dataSource = self
        detailCollection.delegate = self
        
        view.addSubview(detailCollection)
        detailCollection.register(CategoryDetailCollectionViewCell.self, forCellWithReuseIdentifier: "Detail")
        if  hasHeader {
            detailCollection.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "DetailHeader")
        }
        
        
    }

}

extension CagtegoryBaseViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryModels?.subs?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! CategoryListTableViewCell
        cell.configureCell(content: categoryModels?.subs?[indexPath.row], selected:cellsArr[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        cellsArr[indexPath.row] = true
        cellsArr[tempSelectedIndexPath.row] = indexPath.row == tempSelectedIndexPath.row
        tableView.reloadRows(at: [indexPath, tempSelectedIndexPath], with: UITableViewRowAnimation.none)
        tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.middle, animated: true)
        tempSelectedIndexPath = indexPath
        detailCollection.reloadData()
    }
}

extension CagtegoryBaseViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if categoryModels?.subs?.count == 0 {
            return 0
        }
        
        guard let category = categoryModels?.subs?[tempSelectedIndexPath.row] else {
            return 0
        }
        
        if category.categorySubs == nil {
            return category.meterialSubs?.count ?? 0
        }
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if categoryModels?.subs?.count == 0 {
            return 0
        }
        
        guard let category = categoryModels?.subs?[tempSelectedIndexPath.row] else {
            return 0
        }
        if category.categorySubs == nil {
            return category.meterialSubs![section].count
        }
        return category.categorySubs?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Detail", for: indexPath) as! CategoryDetailCollectionViewCell
        guard let category = categoryModels?.subs![tempSelectedIndexPath.row] else {
            return cell
        }
        
        if category.categorySubs == nil {
            guard let meterial = category.meterialSubs?[indexPath.section][indexPath.row] else {
                return cell
            }
            
            cell.configureCell(content: meterial.categorySubTitle)
            return cell
        }
        
        let detail = category.categorySubs![indexPath.row]
        cell.configureCell(content: detail.categorySubTitle)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let recipeListVC = RecipeListViewController()
        guard let category = categoryModels?.subs![tempSelectedIndexPath.row] else {
            return
        }
        if category.categorySubs == nil {
            
            guard let meterial = category.meterialSubs?[indexPath.section][indexPath.row] else {
                return
            }
           
            recipeListVC.title = meterial.categorySubTitle
            let http = meterial.categorySubHref.components(separatedBy: "/")
            recipeListVC.recipeIdentifier = http[http.count - 2]
        } else {
            recipeListVC.title = category.categorySubs![indexPath.row].categorySubTitle
            let http = category.categorySubs![indexPath.row].categorySubHref.components(separatedBy: "/")
            recipeListVC.recipeIdentifier = http[http.count - 2]
        }
        
        recipeListVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(recipeListVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "DetailHeader", for: indexPath)
        
        header.backgroundColor = Constant.kThemeColor

        if header.subviews.count == 0 {
            let titelL = UILabel(frame: header.bounds)
            titelL.textColor = UIColor.white
            titelL.textAlignment = .center
            
            header.addSubview(titelL)
        }
        
        guard let category = categoryModels?.subs![tempSelectedIndexPath.row] else {
            return header
        }
        
        if category.categorySubs == nil {
            guard let meterial = category.meterialSubs?[indexPath.section][indexPath.row] else {
                return header
            }
            
            (header.subviews.first as! UILabel).text = meterial.categorySubTitle
        }
        
        return header

    }
   
    
}
