//
//  ImageDataModel.m
//  json
//
//  Created by Patrick Ziegler on 23/11/13.
//  Copyright (c) 2013 Patrick Ziegler. All rights reserved.
//

#import "ImageDataModel.h"
#import "ImageData.h"

@implementation ImageDataModel
-(id)saveToCore{
    ImageData *imageData=[ImageData findFirstByAttribute:@"url" withValue:self.url];
    if(!imageData){
        imageData=[ImageData createEntity];
        imageData.url=self.url;
    }
    return imageData;
}

@end
