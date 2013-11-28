//
//  CategoryModel.m
//  json
//
//  Created by Patrick Ziegler on 23/11/13.
//  Copyright (c) 2013 Patrick Ziegler. All rights reserved.
//

#import "CategoryModel.h"
#import "Category.h"

@implementation CategoryModel
-(id)saveToCore{
    Category *category=[Category findFirstByAttribute:@"oID" withValue:self.oID];
    if(!category){
        category=[Category createEntity];
        category.oID=self.oID;
    }
    return category;
}

@end
