//
//  MenuItemPhoto.m
//  Hinton
//
//  Created by Brandon Roberts on 5/18/15.
//  Copyright © 2015 Gina Hinton. All rights reserved.
//

#import "MenuItemPhoto.h"

@implementation MenuItemPhoto

-(instancetype)initWithID:(NSString *)photoID caption:(NSString *)caption data:(NSData *)photoData {
  if (self = [super init]) {
    self.photoId = photoID;
    self.caption = caption;
    self.photoData = photoData;
  }
  return self;
}

@end
