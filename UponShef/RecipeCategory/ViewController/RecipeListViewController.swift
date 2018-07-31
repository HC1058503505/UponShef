//
//  RecipeListTableViewController.swift
//  UponShef
//
//  Created by cgtn on 2018/7/26.
//  Copyright © 2018年 houcong. All rights reserved.
//

import UIKit
import RxSwift
import RxAlamofire

class RecipeListViewController: UIViewController {

    var recipeIdentifier: String = ""
    let disposeBag = DisposeBag()
    var recipes = [RecipeOutlineModel]()
    let tableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        navigationController?.navigationBar.subviews.last?.isHidden = true
        
        let recipeListVM = RecipeListViewModel()
        let input = RecipeListViewModel.Input(recipeType: Observable<(String , Int)>.just((recipeIdentifier, 0)))
        let recipeListOutput = recipeListVM.transform(input: input).recipeList
        
        tableView.frame = view.bounds
        view.addSubview(tableView)
        tableView.rowHeight = 120.0
        tableView.register(RecipeTableViewCell.self, forCellReuseIdentifier: "RecipeTableViewCell")
        
        recipeListOutput.subscribe(onNext: {[weak self] (recipeModels) in
            self?.recipes = recipeModels
        })
        .disposed(by: disposeBag)
        
        recipeListOutput.bind(to: tableView.rx.items){[weak self] (tableV, row, element) in
            let cell = tableV.dequeueReusableCell(withIdentifier: "RecipeTableViewCell") as! RecipeTableViewCell
            cell.configureCell(content: element)
            if self?.traitCollection.forceTouchCapability == UIForceTouchCapability.available {
                if !cell.isForceTouchRegistered {
                    cell.isForceTouchRegistered = true
                    self?.registerForPreviewing(with: (self)!, sourceView: cell)
                }
            }
            return cell
        }
        .disposed(by: disposeBag)
        
        
        tableView.rx.modelSelected(RecipeOutlineModel.self)
            .subscribe(onNext: {[weak self] (element) in
  
                let recipeStepsVC = RecipeSetpsViewController()
//                recipeStepsVC.recipeType = Observable<(String, String)>.just((element.recipe_type, element.recipe_id))
//                recipeStepsVC.title = element.recipe_name
//                recipeStepsVC.isVideo = element.recipe_isvideo
                recipeStepsVC.recipeOutlineModel = element
                self?.navigationController?.pushViewController(recipeStepsVC, animated: true)
            })
            .disposed(by: disposeBag)
    
    }
    
    
    
}


extension RecipeListViewController : UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let cell = previewingContext.sourceView as? RecipeTableViewCell else {
            return nil
        }
        guard let indexPath = tableView.indexPath(for: cell) else {
            return nil
        }
        let element = recipes[indexPath.row]
        let recipeStepsVC = RecipeSetpsViewController()
        recipeStepsVC.recipeOutlineModel = element
        return recipeStepsVC
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }
    
    
}
