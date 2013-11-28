//
//  SpeedTestViewController.h
//  json
//
//  Created by Patrick Ziegler on 24/11/13.
//  Copyright (c) 2013 Patrick Ziegler. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFURLSessionManager.h>


@interface SpeedTestViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *result0;
@property (strong, nonatomic) IBOutlet UITextField *result1;
@property (strong, nonatomic) IBOutlet UITextField *result2;
@property (strong, nonatomic) IBOutlet UITextField *result3;
@property (strong, nonatomic) IBOutlet UITextField *result4;
@property (strong, nonatomic) IBOutlet UITextField *result5;

@property (strong, nonatomic) IBOutlet UITextField *avg0;
@property (strong, nonatomic) IBOutlet UITextField *avg1;
@property (strong, nonatomic) IBOutlet UITextField *avg2;
@property (strong, nonatomic) IBOutlet UITextField *avg3;
@property (strong, nonatomic) IBOutlet UITextField *avg4;
@property (strong, nonatomic) IBOutlet UITextField *avg5;

@property (strong, nonatomic) IBOutlet UITextField *label0;
@property (strong, nonatomic) IBOutlet UITextField *label1;
@property (strong, nonatomic) IBOutlet UITextField *label2;
@property (strong, nonatomic) IBOutlet UITextField *label3;
@property (strong, nonatomic) IBOutlet UITextField *label4;
@property (strong, nonatomic) IBOutlet UITextField *label5;

@property (strong, nonatomic) IBOutlet UILabel *loopLabel;

@end
