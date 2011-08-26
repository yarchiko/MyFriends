//
//  MyFriendsAppDelegate.h
//  MyFriends
//
//  Created by Yaroslav Obodov on 8/25/11.
//  Copyright 2011 Mouzone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainVC.h"

@interface MyFriendsAppDelegate : NSObject <UIApplicationDelegate>

{
    MainVC * mainVC;
}

@property (nonatomic, retain) UIWindow *window;

@end
