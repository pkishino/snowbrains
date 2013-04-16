//
//  CustomPopoverBackgroundView.h
//  snowBrains
//
//  Created by Patrick on 13/04/16.
//  Copyright (c) 2013年 Patrick. All rights reserved.
//

#import <UIKit/UIPopoverBackgroundView.h>

@interface CustomPopoverBackgroundView : UIPopoverBackgroundView{
    UIImageView *_borderImageView;
    UIImageView *_arrowView;
    CGFloat _arrowOffset;
    UIPopoverArrowDirection _arrowDirection;
}

@end
