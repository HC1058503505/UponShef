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
    
    fileprivate var categoryModels = [HotCategoryModel]()
    fileprivate var tempSelectedIndexPath = IndexPath(row: 0, section: 0)
    fileprivate let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 100, height: kScreenHeight - Tools.navigationHeight() - Tools.tabBarHeight()), style: .plain)
    
    
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
                flow.headerReferenceSize = CGSize(width: kScreenWidth - 100, height: 34.0)
            }
        }
        
        detailCollection = UICollectionView(frame: CGRect(x: 100, y: 0, width: kScreenWidth - 100, height: kScreenHeight - Tools.navigationHeight() - Tools.tabBarHeight()), collectionViewLayout: flowLayout)
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
        return self.categoryModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! CategoryListTableViewCell
        cell.configureCell(content: categoryModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedModel = categoryModels[indexPath.row]
        selectedModel.isSelected = true
        
        let lastSelectedModel = categoryModels[tempSelectedIndexPath.row]
        lastSelectedModel.isSelected = indexPath.row == tempSelectedIndexPath.row
        tableView.reloadRows(at: [indexPath, tempSelectedIndexPath], with: UITableViewRowAnimation.none)
        tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.middle, animated: true)
        tempSelectedIndexPath = indexPath
        detailCollection.reloadData()
    }
}

extension CagtegoryBaseViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if categoryModels.count == 0 {
            return 0
        }
        
        let category = categoryModels[tempSelectedIndexPath.row]
        if category.categorySubs.isEmpty {
            return category.meterialSubs.count
        }
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if categoryModels.count == 0 {
            return 0
        }
        
        let category = categoryModels[tempSelectedIndexPath.row]
        if category.categorySubs.isEmpty {
            return (category.meterialSubs[section].values.first?.count ?? 1) - 1
        }
        return category.categorySubs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Detail", for: indexPath) as! CategoryDetailCollectionViewCell
        let category = categoryModels[tempSelectedIndexPath.row]
        
        if category.categorySubs.isEmpty {
            
            guard let meterial = category.meterialSubs[indexPath.section].values.first else {
                return cell
            }
            cell.configureCell(content: meterial[indexPath.row + 1].categorySubTitle)
            return cell
        }
        
        let detail = category.categorySubs[indexPath.row]
        cell.configureCell(content: detail.categorySubTitle)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let category = categoryModels[tempSelectedIndexPath.row]
        let recipeListVC = RecipeListViewController()
        if category.categorySubs.isEmpty {
            
            guard let meterial = category.meterialSubs[indexPath.section].values.first else {
                return
            }
           
            recipeListVC.title = meterial[indexPath.row + 1].categorySubTitle
            let http = meterial[indexPath.row].categorySubHref.components(separatedBy: "/")
            recipeListVC.recipeIdentifier = http[http.count - 2]
        } else {
            recipeListVC.title = category.categorySubs[indexPath.row].categorySubTitle
            let http = category.categorySubs[indexPath.row].categorySubHref.components(separatedBy: "/")
            recipeListVC.recipeIdentifier = http[http.count - 2]
        }
        
        recipeListVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(recipeListVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "DetailHeader", for: indexPath)
        
        header.backgroundColor = kThemeColor
        
        let titelL = UILabel(frame: header.bounds)
        titelL.textColor = UIColor.white
        titelL.textAlignment = .center
        
        header.addSubview(titelL)
        let category = categoryModels[tempSelectedIndexPath.row]
        
        if category.categorySubs.isEmpty {
            guard let meterial = category.meterialSubs[indexPath.section].values.first else {
                return header
            }
            
            titelL.text = meterial.first?.categorySubTitle
        }
        
        return header

    }
   
    
}
