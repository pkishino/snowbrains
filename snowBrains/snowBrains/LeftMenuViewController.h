//
//  SideMenuViewController.h
//  MFSideMenuDemo
//
//  Created by Michael Frederick on 3/19/12.

#import <UIKit/UIKit.h>
#import "MFSideMenu.h"

@interface LeftMenuViewController : UITableViewController<UISearchBarDelegate>

@property (nonatomic, assign) MFSideMenu *sideMenu;
@property (nonatomic,weak) id delegate;

@end

@protocol LeftMenuViewControllerDelegate <NSObject>

-(void)homeTap;

@end
