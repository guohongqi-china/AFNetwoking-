//
//  AppDelegate.m
//  AFNetworking 二次封装
//
//  Created by guohq on 2018/8/2.
//  Copyright © 2018年 guohq. All rights reserved.
//

#import "AppDelegate.h"
#import "RealReachability.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {


    [GLobalRealReachability startNotifier];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(networkChanged:)
                                                name:kRealReachabilityChangedNotification
                                              object:nil];


    return YES;
}


- (void)networkChanged:(NSNotification *)notification {
    RealReachability *reachability = (RealReachability *)notification.object;
    ReachabilityStatus status = [reachability currentReachabilityStatus];
    NSLog(@"currentStatus:%@",@(status));
    switch (status) {
        case RealStatusUnknown:
            NSLog(@"不知道状态");
            break;
        case RealStatusNotReachable:
            NSLog(@"无网络");
            break;
        case RealStatusViaWiFi:
            NSLog(@"wifi");
            break;
        case RealStatusViaWWAN:
            NSLog(@"以万物");

            break;
        default:
            break;
    }
    


}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
