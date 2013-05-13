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
        if([self.textLabel.text isEqualToString:@"Locations"]||[self.textLabel.text isEqualToString:@"Video"]||[self.textLabel.text isEqualToString:@"More"]){
            self.accessoryView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"menuDiscloseNormal"]];
            showArrowDown=NO;
        }else
            self.accessoryView=nil;
    }
    return self;
}

- (void)updateCellDisplay {
    if (self.selected || self.highlighted) {
        self.accessoryView=nil;
        self.menuItem.textColor = [UIColor redColor];
        self.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sideBarCellBackgroundSelected"]];
    
    }
    else {
        self.accessoryView=nil;
        self.menuItem.textColor = [UIColor whiteColor];
        self.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sideBarCellBackground"]];
    }
    if(([self.textLabel.text isEqualToString:@"Locations"]||[self.textLabel.text isEqualToString:@"Video"]||[self.textLabel.text isEqualToString:@"More"])&&showArrowDown)
        self.accessoryView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"menuDiscloseSelected"]];
    else if(([self.textLabel.text isEqualToString:@"Locations"]||[self.textLabel.text isEqualToString:@"Video"]||[self.textLabel.text isEqualToString:@"More"])&&!showArrowDown)
        self.accessoryView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"menuDiscloseNormal"]];

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
