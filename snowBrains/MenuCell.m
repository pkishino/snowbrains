//
//  MenuCell.m
//  snowBrains
//
//  Created by Patrick on 13/04/25.
//  Copyright (c) 2013年 Patrick. All rights reserved.
//

#import "MenuCell.h"

@implementation MenuCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.menuItem=self.textLabel;
    }
    return self;
}

- (void)updateCellDisplay {
    if (self.selected || self.highlighted) {
        self.menuItem.textColor = [UIColor redColor];
    }
    else {
        self.menuItem.textColor = [UIColor whiteColor];
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    [self updateCellDisplay];
}

- (void) setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [self updateCellDisplay];
}


@end
