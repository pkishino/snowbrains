//
//  ViewController.h
//  json
//
//  Created by Patrick Ziegler on 3/8/13.
//  Copyright (c) 2013 Patrick Ziegler. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCell.h"
@class PostCollection;

@interface PostTableViewController : UITableViewController<MyCellDelegate>
@property (strong,nonatomic)PostCollection *allPosts;
- (IBAction)pulledToRefresh:(id)sender;


@end
