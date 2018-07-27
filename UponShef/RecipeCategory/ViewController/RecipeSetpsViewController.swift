//
//  RecipeSetpsViewController.swift
//  UponShef
//
//  Created by cgtn on 2018/7/27.
//  Copyright © 2018年 houcong. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Kingfisher
class RecipeSetpsViewController: UIViewController {
    let disposeBag = DisposeBag()
    var recipeType = Observable<(String, String)>.empty()
    let kNavgiationHeight = Tools.safeAreaInsetTop() + kNavgiationTabBarH + kStatusHeight
    var recipeStepModel: RecipeDetailModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        let tableView = UITableView(frame: view.bounds, style: UITableViewStyle.grouped)
        view.addSubview(tableView)
        tableView.contentInset = UIEdgeInsetsMake(250, 0, 0, 0)
        tableView.register(RecipeShiCaiTableViewCell.self, forCellReuseIdentifier: "RecipeShiCai")
        tableView.register(RecipeStepTableViewCell.self, forCellReuseIdentifier: "RecipeStep")
        // 添加菜谱封面图
        
        let recipeCoverImgView = UIImageView(frame: CGRect(x: 0, y: -kNavgiationHeight, width: kScreenWidth, height: 250.0))
        recipeCoverImgView.contentMode = .scaleToFill
        tableView.addSubview(recipeCoverImgView)
        
        tableView.rx.contentOffset.subscribe(onNext: { (offset) in
    
            let pointy = offset.y
            let underImageY = 250 + self.kNavgiationHeight
            let scale = (-underImageY - pointy) / 250.0
            if pointy <= -underImageY {
                recipeCoverImgView.frame = CGRect(x: -(kScreenWidth * scale) / 2.0, y: pointy + self.kNavgiationHeight, width: kScreenWidth * (1.0 + scale), height: 250 * (1 + scale))
            }
        })
        .disposed(by: disposeBag)
 
        let recipeDetailVM = RecipeDetailViewModel()
        let input = RecipeDetailViewModel.Input(recipeType: recipeType)
        let recipeDetail = recipeDetailVM.transform(input: input).recipeDetail
        
        let items = recipeDetail.flatMap {[weak self] (recipeDetailM) -> Observable<[SectionModel<String, Any>]> in
            self?.recipeStepModel = recipeDetailM
            var imageSource = [Resource]()
            for step in recipeDetailM.setps {
                let imgS = step.step_img_src
                let url = URL(string: imgS)
                imageSource.append(url!)
            }
            
            ImagePrefetcher.init(resources: imageSource, options: nil, progressBlock: nil, completionHandler: { (_, _, _) in
                tableView.reloadSections([1], with: UITableViewRowAnimation.none)
            }).start()
            
           let cover = recipeDetailM.recipe_cover.count == 0 ? recipeDetailM.video_poster : recipeDetailM.recipe_cover
           recipeCoverImgView.kf.setImage(with: URL(string: cover), placeholder: placeholderImg)
           return Observable.just([
                SectionModel(model: "shicai", items: recipeDetailM.shicais),
                SectionModel(model: "steps", items: recipeDetailM.setps)
            ])
        }
     
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Any>>(configureCell: {
            dataS, tableV, indexPath, element in

            if indexPath.section == 1 {
                let step = element as! RecipeSteps
                let cellStep = tableV.dequeueReusableCell(withIdentifier: "RecipeStep") as! RecipeStepTableViewCell
                cellStep.configureCell(setps: step)
                return cellStep
            } else {
                let shicai = element as! RecipeShicai
                let cellShicai = tableV.dequeueReusableCell(withIdentifier: "RecipeShiCai") as! RecipeShiCaiTableViewCell
                cellShicai.configureCell(shicai: shicai)
                return cellShicai
            }
        })
        
        dataSource.titleForHeaderInSection = { ds, index in
            if index == 0 {
                return "食材"
            }
            return "步骤"
        }
        
        items.bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        
        
    }

    // MARK: - UIPreviewActionItem
    override var previewActionItems: [UIPreviewActionItem] {
        
        let collectionAction = UIPreviewAction(title: "收藏", style: UIPreviewActionStyle.default) { (previewAction, viewController) in
            UIAlertView(title: "收藏", message: self.title, delegate: nil, cancelButtonTitle: "Ok").show()
        }
        
        let praiseAction = UIPreviewAction(title: "赞", style: UIPreviewActionStyle.default) { (previewAction, viewController) in
            UIAlertView(title: "收藏", message: self.title, delegate: nil, cancelButtonTitle: "Ok").show()
        }
        
        return [praiseAction, collectionAction]
    }

}
