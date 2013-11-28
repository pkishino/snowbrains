//
//  AuthorModel.m
//  json
//
//  Created by Patrick Ziegler on 23/11/13.
//  Copyright (c) 2013 Patrick Ziegler. All rights reserved.
//

#import "AuthorModel.h"
#import "Author.h"

@implementation AuthorModel
-(id)saveToCore{
     Author *author=[Author findFirstByAttribute:@"oID" withValue:self.oID];
    if(!author){
        author=[Author createEntity];
        author.oID=self.oID;
    }
    return author;
}
@end
