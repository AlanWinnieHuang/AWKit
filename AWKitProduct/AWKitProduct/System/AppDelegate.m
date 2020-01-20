//
//  AppDelegate.m
//  AWKitProduct
//
//  Created by winnie on 2019/12/6.
//  Copyright © 2019 winnie. All rights reserved.
//

#import "AppDelegate.h"
#import "FactoryViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window setRootViewController:[FactoryViewController new]];
    [self.window makeKeyAndVisible];
    
    
    return YES;
}





@end
