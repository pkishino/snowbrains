//
//  PostCommentViewController.h
//  json
//
//  Created by Patrick Ziegler on 9/12/13.
//  Copyright (c) 2013 Patrick Ziegler. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostCommentViewController : UITableViewController<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>

@property (nonatomic, strong) IBOutlet UIView *headerView;
@property (nonatomic, strong) IBOutlet UITextView *commentTextView;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *postButton;
@property (nonatomic, strong) NSNumber* post_id;


@end
