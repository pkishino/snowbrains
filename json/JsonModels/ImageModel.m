//
//  ImageModel.m
//  json
//
//  Created by Patrick Ziegler on 23/11/13.
//  Copyright (c) 2013 Patrick Ziegler. All rights reserved.
//

#import "ImageModel.h"
#import "Image.h"
#import "ImageData.h"

@implementation ImageModel
-(id)saveToCore{
    Image *image=[Image findFirstByAttribute:@"oID" withValue:self.oID];
    if(!image){
        image=[Image createEntity];
        image.oID=self.oID;
    }
    if(!image.full){
        image.full=[self.full saveToCore];
        [image.full importValuesForKeysWithObject:self.full];
    }
    if(!image.large){
        image.large=[self.large saveToCore];
        [image.large importValuesForKeysWithObject:self.large];
    }
    if(!image.medium){
        image.medium=[self.medium saveToCore];
        [image.medium importValuesForKeysWithObject:self.medium];
    }
    if(!image.thumbnail){
        image.thumbnail=[self.thumbnail saveToCore];
        [image.thumbnail importValuesForKeysWithObject:self.thumbnail];
    }
    return image;
}

@end
