//
//  MyFriendsAppDelegate.m
//  MyFriends
//
//  Created by Yaroslav Obodov on 8/25/11.
//  Copyright 2011 Mouzone. All rights reserved.
//

#import "MyFriendsAppDelegate.h"

@implementation MyFriendsAppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [_window makeKeyAndVisible];
    
    mainVC = [[MainVC alloc] init];
    mainVC.view.frame = [UIScreen mainScreen].bounds;
    [_window addSubview:mainVC.view];
    
    return YES;
}

- (void)dealloc
{
    [_window release];
    [mainVC release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url 
{
    return [mainVC.facebook handleOpenURL:url]; 
}

@end
