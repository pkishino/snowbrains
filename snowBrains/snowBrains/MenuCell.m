//
//  MenuCell.m
//  snowBrains
//
//  Created by Patrick on 13/04/25.
//  Copyright (c) 2013年 Patrick. All rights reserved.
//

#import "MenuCell.h"

@implementation MenuCell{
    BOOL showArrowDown;
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.menuItem=self.textLabel;
        self.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sideBarCellBackground"]];
        self.menuItem.textColor = [UIColor whiteColor];
        if(([self.textLabel.text isEqualToString:NSLocalizedString(@"Locations", @"Locations name")]||[self.textLabel.text isEqualToString:NSLocalizedString(@"More", @"More name")]||[self.textLabel.text isEqualToString:NSLocalizedString(@"Video", @"Video name")])){
            self.accessoryView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"menuDiscloseNormal"]];
            showArrowDown=NO;
        }else
            self.accessoryView=nil;
    }
    return self;
}

- (void)updateCellDisplay {
    if(([self.textLabel.text isEqualToString:NSLocalizedString(@"Locations", @"Locations name")]||[self.textLabel.text isEqualToString:NSLocalizedString(@"More", @"More name")]||[self.textLabel.text isEqualToString:NSLocalizedString(@"Video", @"Video name")])&&showArrowDown)
        self.accessoryView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"menuDiscloseSelected"]];
    else if(([self.textLabel.text isEqualToString:NSLocalizedString(@"Locations", @"Locations name")]||[self.textLabel.text isEqualToString:NSLocalizedString(@"More", @"More name")]||[self.textLabel.text isEqualToString:NSLocalizedString(@"Video", @"Video name")])&&!showArrowDown)
        self.accessoryView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"menuDiscloseNormal"]];
    else if (self.selected || self.highlighted) {
        self.accessoryView=nil;
        self.menuItem.textColor = [UIColor redColor];
        self.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sideBarCellBackgroundSelected"]];
    }
    else {
        self.accessoryView=nil;
        self.menuItem.textColor = [UIColor whiteColor];
        self.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sideBarCellBackground"]];
    }
    

}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    [self updateCellDisplay];
}

- (void) setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if(!showArrowDown&&selected)
        showArrowDown=YES;
    else if(showArrowDown&&selected)
        showArrowDown=NO;
    [self updateCellDisplay];
}


@end
