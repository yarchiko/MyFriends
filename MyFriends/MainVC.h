//
//  MainVC.h
//  MyFriends
//
//  Created by Yaroslav Obodov on 8/25/11.
//  Copyright 2011 Mouzone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "FBConnect.h"

@interface MainVC : UIViewController <FBSessionDelegate, FBDialogDelegate, FBRequestDelegate, UITableViewDelegate, UITableViewDataSource>

{
    UIView                              * mainView;
    UITableView                         * _table;
    UIButton                            * closeButton;
    UIButton                            * connectButton;
    
    Facebook                            * _facebook;
    NSArray                             * _permissions;
    NSUserDefaults                      * defaults;

    NSMutableData                       * _responseText;
    NSMutableDictionary                 * _data;
    NSMutableArray                      * imgArray;
    NSMutableArray                      * arrayWithData;
    NSMutableArray                      * connectionArray;
}

@property(nonatomic, retain) Facebook   *facebook;

- (id) init;
- (void) loginAction;
- (void) moveToFriendsListTable;
- (void) viewFriendsButtonPressed;
- (void) startIconDownload:(NSString *)urlString forIndexPath:(NSIndexPath *)indexPath;

@end
