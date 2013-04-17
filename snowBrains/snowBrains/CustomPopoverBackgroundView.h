//
//  CustomPopoverBackgroundView.h
//  snowBrains
//
//  Created by Patrick on 13/04/16.
//  Copyright (c) 2013年 Patrick. All rights reserved.
//

#import <UIKit/UIPopoverBackgroundView.h>
#import <QuartzCore/QuartzCore.h>

@interface CustomPopoverBackgroundView : UIPopoverBackgroundView{
    CGFloat _arrowOffset;
    UIPopoverArrowDirection _arrowDirection;
}
@property (nonatomic, strong) UIImageView *borderImageView;
@property (nonatomic, strong) UIImageView *arrowView;


@end
