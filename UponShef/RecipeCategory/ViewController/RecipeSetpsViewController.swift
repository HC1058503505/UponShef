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
    var recipeStepModel: RecipeDetailModel?
    var recipeOutlineModel: RecipeOutlineModel?
    
    fileprivate let disposeBag = DisposeBag()
    fileprivate var isPresented = false

    fileprivate let recipeCoverImgView = UIImageView(frame: CGRect(x: 0, y: -250.0, width: Constant.kScreenWidth, height: 250))
    fileprivate let recipePlayer = RecipeStepsPlayerView(frame: CGRect(x: 0, y: -200.0, width: Constant.kScreenWidth, height: 200))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = recipeOutlineModel?.recipe_name
        let kNavgiationHeight = Tools.navigationHeight()
        // (recipeOutlineModel?.recipe_isvideo)! ? 200.0 : 250.0
        let recipeCoverH: CGFloat = 250.0
        view.backgroundColor = UIColor.white
        
        let tableView = UITableView(frame: view.bounds, style: UITableViewStyle.grouped)
        view.addSubview(tableView)
        tableView.contentInset = UIEdgeInsetsMake(recipeCoverH, 0, 0, 0)
        tableView.register(RecipeShiCaiTableViewCell.self, forCellReuseIdentifier: "RecipeShiCai")
        tableView.register(RecipeStepTableViewCell.self, forCellReuseIdentifier: "RecipeStep")
        
//        if (recipeOutlineModel?.recipe_isvideo)! {
//            tableView.addSubview(recipePlayer)
//        } else {
//
//        }
        // 添加菜谱封面图
        recipeCoverImgView.contentMode = .scaleToFill
        tableView.addSubview(recipeCoverImgView)
        
        tableView.rx.contentOffset
            .subscribe(onNext: {[weak self] (offset) in
                let pointy = offset.y
                let underImageY = recipeCoverH + kNavgiationHeight
                let scale = (-underImageY - pointy) / recipeCoverH
                if pointy <= -underImageY {
                    self?.recipeCoverImgView.frame = CGRect(x: -(Constant.kScreenWidth * scale) / 2.0, y: pointy + kNavgiationHeight, width: Constant.kScreenWidth * (1.0 + scale), height: recipeCoverH * (1 + scale))
                }
            })
            .disposed(by: disposeBag)
 
        let recipeDetailVM = RecipeDetailViewModel()
        let input = RecipeDetailViewModel.Input(recipeType: Observable<(String, String)>.just(((recipeOutlineModel?.recipe_type)!, (recipeOutlineModel?.recipe_id)!)))
        let recipeDetail = recipeDetailVM.transform(input: input).recipeDetail
        
        let items = recipeDetail.flatMap {[weak self] (recipeDetailM) -> Observable<[SectionModel<String, Any>]> in
            self?.recipeStepModel = recipeDetailM
            var imageSource = [Resource]()
            for step in recipeDetailM.steps {
                let imgS = step.step_img_src
                let url = URL(string: imgS)
                imageSource.append(url!)
            }
            
            ImagePrefetcher.init(resources: imageSource, options: nil, progressBlock: nil, completionHandler: { (_, _, _) in
                tableView.reloadSections([1], with: UITableViewRowAnimation.none)
            }).start()
            
//            if recipeDetailM.recipe_cover.count == 0 {
//                
//                // video
//                self?.recipePlayer.sourcePlayer(url: URL(string: recipeDetailM.video_src)!)
//                self?.recipePlayer.play()
//            } else {
//            }
            let imageURL = recipeDetailM.recipe_cover.count == 0 ? recipeDetailM.video_poster : recipeDetailM.recipe_cover
            self?.recipeCoverImgView.kf.setImage(with: URL(string: imageURL), placeholder: Constant.placeholderImg)
           return Observable.just([
                SectionModel(model: "shicai", items: recipeDetailM.shicais),
                SectionModel(model: "steps", items: recipeDetailM.steps)
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
        
        
        tableView.rx.itemSelected
            .subscribe(onNext: {[weak self] (indexPath) in
                if indexPath.section == 0 {
                    return
                }
                
                let pictureBrowseVC = RecipePictureBrowseViewController()
                pictureBrowseVC.pictrueSteps = self?.recipeStepModel?.steps ?? [RecipeSteps]()
                pictureBrowseVC.currentStepIndex = indexPath.row
                let snapView = UIScreen.main.snapshotView(afterScreenUpdates: true)
                pictureBrowseVC.snapView = snapView
                self?.present(pictureBrowseVC, animated: true, completion: nil)
            })
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
