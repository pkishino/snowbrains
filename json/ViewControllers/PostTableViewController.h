//
//  ViewController.h
//  json
//
//  Created by Patrick Ziegler on 3/8/13.
//  Copyright (c) 2013 Patrick Ziegler. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCell.h"

@interface PostTableViewController : UITableViewController<MyCellDelegate>

- (IBAction)pulledToRefresh:(id)sender;


@end
