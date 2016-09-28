//
//  AppDelegate.m
//  sidebar-menu-ios
//
//  Created by Clint Cabanero on 9/3/14.
//  Copyright (c) 2014 Big Leaf Mobile LLC. All rights reserved.
//

#import "AppDelegate.h"
#import "SettingsViewController.h"
#import "CategoriesViewController.h"
#import "LoginViewController.h"
#import "MeViewController.h"
#import "WebViewController.h"
#import "CookieManager.h"
//----------------------------------------------
//STEP 1: IMPORT THE SIDEBARMENU VIEWCONTROLLER
//----------------------------------------------
#import "SidebarMenuViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    SidebarMenuViewController *sidebarMenuVC = [[SidebarMenuViewController alloc] initWithNibName:@"SidebarMenuViewController" bundle:nil];

    SettingsViewController *settingsVC = [[UIStoryboard storyboardWithName:@"Settings" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"Settings"];
    MeViewController *meVC =[[UIStoryboard storyboardWithName:@"Me" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"Me"];
    
    LoginViewController *loginVC = [[LoginViewController alloc] initWithNibName:@"LoginView" bundle:nil];
    WebViewController *webVC = [[WebViewController alloc] initWithString:@"login.html"];
    
    CategoriesViewController *masterViewController = [[CategoriesViewController
 alloc] initWithNibName:@"CategoriesViewController" bundle:nil];
    
    sidebarMenuVC.menuItemViewControllers = [[NSArray alloc] initWithObjects:masterViewController, settingsVC, meVC, loginVC,webVC, nil];

    sidebarMenuVC.menuItemNames = [[NSArray alloc] initWithObjects:@"Categorize", @"Settings", @"Me", @"Login", @"WebLogin", nil];
    sidebarMenuVC.sideBarButtonImageName = @"topic_icon";
    
    
    [self.window setRootViewController:sidebarMenuVC];
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    BOOL success = [[CookieManager sharedInstance] archiveCookies];
    if(success){
        NSLog(@"saved cookies");
    }else{
        NSLog(@"not saved cookies");
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
