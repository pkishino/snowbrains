//
//  SideMenuViewController.h
//  MFSideMenuDemo
//
//  Created by Michael Frederick on 3/19/12.

#import <UIKit/UIKit.h>
#import "MFSideMenu.h"
#import <MessageUI/MessageUI.h>

@interface LeftMenuViewController : UITableViewController<UISearchBarDelegate,MFMailComposeViewControllerDelegate>

@property (nonatomic, assign) MFSideMenu *sideMenu;
@property (nonatomic,weak) id delegate;
@property (nonatomic,retain) UITableView *tableView;

@end

@protocol LeftMenuViewControllerDelegate <NSObject>

-(void)menuTap:(NSString *)menuItem;
-(void)search:(NSString *)searchItem;
-(void)bookmarkLoad:(NSURL *)bookmark;

@end
