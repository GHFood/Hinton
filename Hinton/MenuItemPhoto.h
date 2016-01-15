//
//  MenuItemPhoto.h
//  Hinton
//
//  Created by Brandon Roberts on 5/18/15.
//  Copyright © 2015 Gina Hinton. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MenuItemPhoto : NSObject

@property (strong, nonatomic) NSString * photoId;
@property (strong, nonatomic) NSData * photoData;
@property (strong, nonatomic) NSString * caption;

-(instancetype)initWithID:(NSString *)photoID caption:(NSString *)caption data:(NSData *)photoData;

@end
