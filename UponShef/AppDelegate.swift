//
//  AppDelegate.swift
//  UponShef
//
//  Created by cgtn on 2018/7/17.
//  Copyright © 2018年 houcong. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        createShortcutItems()
        // rebase_test
        // 程序启动，点开Touch
        if let launchOptionsKey = launchOptions , let shortcutItem = launchOptionsKey[UIApplicationLaunchOptionsKey.shortcutItem] as? UIApplicationShortcutItem{
            touchShortcutItemAction(shortcutItem)
        }
        
        
        let tabbarVC = UponShefTabBarViewController()
        window = UIWindow(frame: UIScreen.main.bounds)
        
        window?.rootViewController = tabbarVC
        window?.makeKeyAndVisible()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


    // 程序进入后台未被杀死，点开Touch会调用该代理方法
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        touchShortcutItemAction(shortcutItem)
    }
    
    func createShortcutItems() {
        let searchItem = UIApplicationShortcutItem(type: "com.recipes.search", localizedTitle: "搜索", localizedSubtitle: nil, icon: UIApplicationShortcutIcon(type: UIApplicationShortcutIconType.search), userInfo: nil)
        let publishItem = UIApplicationShortcutItem(type: "com.recipes.publish", localizedTitle: "发布", localizedSubtitle: nil, icon: UIApplicationShortcutIcon(type: UIApplicationShortcutIconType.add), userInfo: nil)
        
        UIApplication.shared.shortcutItems = [searchItem, publishItem]
    }
    
    func touchShortcutItemAction(_ shortcutItem: UIApplicationShortcutItem) {
        switch shortcutItem.type {
        case "com.recipes.search":
            UIAlertView(title: "3D Touch", message: "Touched search", delegate: nil, cancelButtonTitle: "Ok").show()
        case "com.recipes.publish":
            UIAlertView(title: "3D Touch", message: "Touched publish", delegate: nil, cancelButtonTitle: "OK").show()
        default:
            print("")
        }
    }
}

