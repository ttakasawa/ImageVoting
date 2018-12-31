//
//  AppDelegate.swift
//  ImageVoting
//
//  Created by Tomoki Takasawa on 12/15/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit
import CoreData
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        UINavigationBar.appearance().barTintColor = UIColor(red: 29.0/255.0, green: 48.0/255.0, blue: 118.0/255.0, alpha: 1)
        UINavigationBar.appearance().tintColor = UIColor(red:14.0/255.0, green:211.0/255.0, blue:140.0/255.0, alpha:255.0/255.0)
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        
        FirebaseApp.configure()
        self.setDiskPersistence()
        
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        window?.makeKeyAndVisible()
        
        self.startApp()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
        if let user = Global.network.user {
            Global.network.updateUser(user: user) { (error) in
                
            }
        }
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
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "ImageVoting")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func setDiskPersistence(){
        
        Database.database().isPersistenceEnabled = true
        let postRef = Database.database().reference(withPath: "Post")
        let postCreatorRef = Database.database().reference(withPath: "Post-CreatorTable")
        let userVotablePostsRef = Database.database().reference(withPath: "User-VotablePublicPostTable/{userId}")
        
        postRef.keepSynced(true)
        postCreatorRef.keepSynced(true)
        userVotablePostsRef.keepSynced(true)
        
    }

}


extension AppDelegate {
    
    func isOnBoardTest() -> Bool{
        return false
    }
    
    func startApp(){
        if self.isOnBoardTest(){
            toOnBoard()
        }else{
            loginIfPossible()
        }
    }
    
    func toOnBoard(){
        let loginScreen: LoginViewController = LoginViewController(network: Global.network)
        let navController = UINavigationController(rootViewController: loginScreen)
        
        window?.rootViewController = navController
    }
    
    func toHome(){
        let homeScreen: HomeViewController = HomeViewController(builder: HomeViewControllerBuilder.vote, network: Global.network)
        let navController = UINavigationController(rootViewController: homeScreen)
        
        window?.rootViewController = navController
    }
    
    func loginIfPossible(){
        if Global.network.firUserId != nil {
            
            self.toHome()
            
        }else{
            
            self.toOnBoard()
        }
    }
}
