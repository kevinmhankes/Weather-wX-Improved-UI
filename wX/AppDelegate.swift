// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Override point for customization after application launch.
        MyApplication.onCreate()
        self.window?.tintColor = wXColor.uiColorInt(0, 0, 0)
        let color = wXColor.uiColorInt(204, 204, 204)
        UINavigationBar.appearance().barTintColor = color
        UIToolbar.appearance().barTintColor = color
        UITabBar.appearance().barTintColor = color
        // window = UIWindow(frame: UIScreen.main.bounds)
        // window?.rootViewController = UINavigationController(rootViewController: CustomTabBarVC())
        // window?.makeKeyAndVisible()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks.
        // Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // If your application supports background execution, this method is called instead of applicationWillTerminate:
        // when the user quits.
        UtilityFileManagement.deleteAllFiles()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the
        // changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive.
        // If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate.
        // See also applicationDidEnterBackground:.
    }

    #if targetEnvironment(macCatalyst)
    override func buildMenu(with builder: UIMenuBuilder) {
        super.buildMenu(with: builder)
        builder.remove(menu: .services)
        builder.remove(menu: .format)
        builder.remove(menu: .edit)
        builder.remove(menu: .toolbar)
        builder.remove(menu: .file)
        /*let refreshCommand = UIKeyCommand(input: "R", modifierFlags: [.command], action: #selector(nil))
        refreshCommand.title = "Reload data"
        let reloadDataMenu = UIMenu(title: "Reload data", image: nil, identifier: UIMenu.Identifier("reloadData"), options: .displayInline, children: [refreshCommand])
        builder.insertChild(reloadDataMenu, atStartOfMenu: .file)*/
        /*let refreshCommand = UIKeyCommand(input: "R", modifierFlags: [.command], action: #selector(UtilityActions.radarClickedFromMenu))
       refreshCommand.title = "Go to radar"
       let reloadDataMenu = UIMenu(title: "Go to radar", image: nil, identifier: UIMenu.Identifier("gotoRadar"), options: .displayInline, children: [refreshCommand])
       builder.insertChild(reloadDataMenu, atStartOfMenu: .file)*/
    }
    #endif
}
