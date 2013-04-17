//
//  CustomPopoverBackgroundView.m
//  snowBrains
//
//  Created by Patrick on 13/04/16.
//  Copyright (c) 2013年 Patrick. All rights reserved.
//

#import "CustomPopoverBackgroundView.h"
#define CONTENT_INSET 0.0
#define CAP_INSET 0.0
#define ARROW_BASE 0.0
#define ARROW_HEIGHT 0.01

@implementation CustomPopoverBackgroundView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.borderImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"popover-bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(CAP_INSET,CAP_INSET,CAP_INSET,CAP_INSET)]];
        self.arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrowPop.png"]];
        [self addSubview:self.borderImageView];
        
        //[self addSubview:self.arrowView];
    }
    return self;
}
- (CGFloat) arrowOffset {
    return _arrowOffset;
}

- (void) setArrowOffset:(CGFloat)arrowOffset {
    _arrowOffset = arrowOffset;
}

- (UIPopoverArrowDirection)arrowDirection {
    return _arrowDirection;
}

- (void)setArrowDirection:(UIPopoverArrowDirection)arrowDirection {
    _arrowDirection = arrowDirection;
}


+(UIEdgeInsets)contentViewInsets{
    return UIEdgeInsetsMake(CONTENT_INSET, CONTENT_INSET, CONTENT_INSET, CONTENT_INSET);
}

+(CGFloat)arrowHeight{
    return ARROW_HEIGHT;
}

+(CGFloat)arrowBase{
    return ARROW_BASE;
}
-  (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat _height = self.frame.size.height;
    CGFloat _width = self.frame.size.width;
    CGFloat _left = 0.0;
    CGFloat _top = 0.0;
    CGFloat _coordinate = 0.0;
    CGAffineTransform _rotation = CGAffineTransformIdentity;
    
    
    switch (self.arrowDirection) {
        case UIPopoverArrowDirectionUp:
            _top += ARROW_HEIGHT;
            _height -= ARROW_HEIGHT;
            _coordinate = ((self.frame.size.width / 2) + self.arrowOffset) - (ARROW_BASE/2);
            self.arrowView.frame = CGRectMake(_coordinate, 0, ARROW_BASE, ARROW_HEIGHT);
            break;
            
            
        case UIPopoverArrowDirectionDown:
            _height -= ARROW_HEIGHT;
            _coordinate = ((self.frame.size.width / 2) + self.arrowOffset) - (ARROW_BASE/2);
            self.arrowView.frame = CGRectMake(_coordinate, _height, ARROW_BASE, ARROW_HEIGHT);
            _rotation = CGAffineTransformMakeRotation( M_PI );
            break;
            
        case UIPopoverArrowDirectionLeft:
            _left += ARROW_BASE;
            _width -= ARROW_BASE;
            _coordinate = ((self.frame.size.height / 2) + self.arrowOffset) - (ARROW_HEIGHT/2);
            self.arrowView.frame = CGRectMake(0, _coordinate, ARROW_BASE, ARROW_HEIGHT);
            _rotation = CGAffineTransformMakeRotation( -M_PI_2 );
            break;
            
        case UIPopoverArrowDirectionRight:
            _width -= ARROW_BASE;
            _coordinate = ((self.frame.size.height / 2) + self.arrowOffset)- (ARROW_HEIGHT/2);
            self.arrowView.frame = CGRectMake(_width, _coordinate, ARROW_BASE, ARROW_HEIGHT);
            _rotation = CGAffineTransformMakeRotation( M_PI_2 );
        case UIPopoverArrowDirectionAny:
            _top += ARROW_HEIGHT;
            _height -= ARROW_HEIGHT;
            _coordinate = ((self.frame.size.width / 2) + self.arrowOffset) - (ARROW_BASE/2);
            self.arrowView.frame = CGRectMake(_coordinate, 0, ARROW_BASE, ARROW_HEIGHT);
            break;
        case UIPopoverArrowDirectionUnknown:
            _top += ARROW_HEIGHT;
            _height -= ARROW_HEIGHT;
            _coordinate = ((self.frame.size.width / 2) + self.arrowOffset) - (ARROW_BASE/2);
            self.arrowView.frame = CGRectMake(_coordinate, 0, ARROW_BASE, ARROW_HEIGHT);
            break;
        default:
            _top += ARROW_HEIGHT;
            _height -= ARROW_HEIGHT;
            _coordinate = ((self.frame.size.width / 2) + self.arrowOffset) - (ARROW_BASE/2);
            self.arrowView.frame = CGRectMake(_coordinate, 0, ARROW_BASE, ARROW_HEIGHT);
            break;
            
    }
    
    self.borderImageView.frame =  CGRectMake(_left, 0, _width, _height);
    
    
    [self.arrowView setTransform:_rotation];
    
}

@end
