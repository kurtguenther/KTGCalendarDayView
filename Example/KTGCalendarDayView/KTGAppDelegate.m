//
//  KTGAppDelegate.m
//  KTGCalendarDayView
//
//  Created by CocoaPods on 07/15/2014.
//  Copyright (c) 2014 Kurt Guenther. All rights reserved.
//

#import "KTGAppDelegate.h"
#import "KTGViewController.h"
#import <KTGCalendarDayView/KTGSchedulerViewController.h>

@interface KTGAppDelegate ()

//@property (nonatomic, strong) KTGViewController* rootViewController;
@property (nonatomic, strong) KTGSchedulerViewController* rootViewController;

@end

@implementation KTGAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    self.rootViewController = [[KTGViewController alloc] init];
    self.rootViewController = [[KTGSchedulerViewController alloc] init];
    UINavigationController* navigationController = [[UINavigationController alloc] initWithRootViewController:self.rootViewController];
    navigationController.navigationBar.translucent = NO;
    
    self.window.rootViewController = navigationController;
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
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    //Convenient to refresh here, since we often swap back and forth between this and Calendar.app
    //[self.rootViewController fetchLocalEvents];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

@end
