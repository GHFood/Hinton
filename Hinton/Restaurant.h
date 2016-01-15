//
//  Restaurant.h
//  Hinton
//
//  Created by Brandon Roberts on 5/18/15.
//  Copyright © 2015 Gina Hinton. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Address;
@class Hours;
@class MenuItemPhoto;

@interface Restaurant : NSObject

@property (strong, nonatomic) NSString * restaurantId;
@property (strong, nonatomic) NSString * name;
@property (strong, nonatomic) Address *  address;
@property (strong, nonatomic) NSString * phone;
@property (strong, nonatomic) Hours *    hours;
@property (strong, nonatomic) NSArray *  genres;
@property (strong, nonatomic) NSString * pricePoint;
@property (strong, nonatomic) NSArray *  recipes;
@property (strong, nonatomic) NSArray *  menuPhotoURLs;
@property (strong, nonatomic) NSURL *    blogURL;
@property (strong, nonatomic) NSURL *    mainURL;
@property (strong, nonatomic) NSURL *    menuURL;

+ (Restaurant *) restaurantFromJSONDictionary: (NSDictionary *) jsonDictionary;

@end
