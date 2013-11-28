//
//  TagModel.m
//  json
//
//  Created by Patrick Ziegler on 23/11/13.
//  Copyright (c) 2013 Patrick Ziegler. All rights reserved.
//

#import "TagModel.h"
#import "Tag.h"

@implementation TagModel
-(id)saveToCore{
    Tag *tag=[Tag findFirstByAttribute:@"oID" withValue:self.oID];
    if(!tag){
        tag=[Tag createEntity];
        tag.oID=self.oID;
    }
    return tag;
}
@end
