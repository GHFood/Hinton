//
//  Restaurant.h
//  Hinton
//
//  Created by Brandon Roberts on 5/18/15.
//  Copyright (c) 2015 BR World. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Address;
@class Hours;
@class MenuItemPhoto;

@interface Restaurant : NSObject

@property (strong, nonatomic) NSString *restaurantId;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) Address *address;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) Hours *hours;
@property (strong, nonatomic) NSString *genre;
@property (strong, nonatomic) NSString *pricePoint;
@property (strong, nonatomic) NSArray *recipes;
@property (strong, nonatomic) NSArray *photos;
@property (strong, nonatomic) NSURL *blogURL;
@property (strong, nonatomic) NSURL *mainURL;
@property (strong, nonatomic) NSURL *menuURL;

@end
