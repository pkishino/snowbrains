//
//  AttachmentModel.m
//  json
//
//  Created by Patrick Ziegler on 23/11/13.
//  Copyright (c) 2013 Patrick Ziegler. All rights reserved.
//

#import "AttachmentModel.h"
#import "Attachment.h"
#import "Image.h"

@implementation AttachmentModel
-(id)saveToCore{
    Attachment *attachment=[Attachment findFirstByAttribute:@"oID" withValue:self.oID];
    if(!attachment){
        attachment=[Attachment createEntity];
        attachment.oID=self.oID;
    }
    if(self.images&&!attachment.images){
        if(!self.images.oID){
            self.images.oID=self.oID;
        }
        attachment.images=[self.images saveToCore];
    }
    return attachment;
}

@end
