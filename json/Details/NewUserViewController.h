//
//  NewUserViewController.h
//  json
//
//  Created by Patrick Ziegler on 9/12/13.
//  Copyright (c) 2013 Patrick Ziegler. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewUserViewController : UITableViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UIView *headerView;
@property (nonatomic, strong) JVFloatLabeledTextField *nameTextView;
@property (nonatomic, strong) JVFloatLabeledTextField *emailTextView;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *saveButton;

@end
