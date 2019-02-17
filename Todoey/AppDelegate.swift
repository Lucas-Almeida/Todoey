//
//  AppDelegate.swift
//  Todoey
//
//  Created by Lucas Almeida on 26/01/19.
//  Copyright © 2019 Lucas Almeida. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
//        let data = Data()
//        data.name = "Lucas"
//        data.age = 27
//
//        do {
//            let realm = try Realm()
//            try realm.write {
//                realm.add(data)
//            }
//        } catch {
//            print("Error initializing Realm")
//        }
//
//        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        do {
            let _ = try Realm()
        } catch {
            print("Error initializing Realm")
        }
        
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        CoreDataManager.sharedManager.saveContext()
    }
}

