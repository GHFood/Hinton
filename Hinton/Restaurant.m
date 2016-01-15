//
//  Restaurant.m
//  Hinton
//
//  Created by Brandon Roberts on 5/18/15.
//  Copyright © 2015 Gina Hinton. All rights reserved.
//

#import "Restaurant.h"
#import "Hours.h"
#import "Address.h"
#import "MenuItemPhoto.h"

@implementation Restaurant

+ (Restaurant *) restaurantFromJSONDictionary: (NSDictionary *) jsonDictionary {
  
  Restaurant *newRestaurant = [[Restaurant alloc] init];
  
  newRestaurant.restaurantId = jsonDictionary[@"_id"];
  
  NSDictionary *restaurantInfo = jsonDictionary[@"restaurant"];
  newRestaurant.name = restaurantInfo[@"name"];
  newRestaurant.phone = restaurantInfo[@"phone"];
  newRestaurant.genres = restaurantInfo[@"genre"];
  newRestaurant.pricePoint = restaurantInfo[@"price"];
  newRestaurant.recipes = restaurantInfo[@"menu_item"];
  newRestaurant.blogURL = [NSURL URLWithString:restaurantInfo[@"blog_link"]];
  newRestaurant.mainURL = [NSURL URLWithString:restaurantInfo[@"r_site"]];
  newRestaurant.menuURL = [NSURL URLWithString:restaurantInfo[@"menu_link"]];
  
  NSDictionary *hoursInfo = restaurantInfo[@"hours"];
  NSString *monday = hoursInfo[@"mon"];
  NSString *tuesday = hoursInfo[@"tue"];
  NSString *wednesday = hoursInfo[@"wed"];
  NSString *thursday = hoursInfo[@"thu"];
  NSString *friday = hoursInfo[@"fri"];
  NSString *saturday = hoursInfo[@"sat"];
  NSString *sunday = hoursInfo[@"sun"];
  Hours *hours = [[Hours alloc] initWithMonday:monday Tuesday:tuesday Wednesday:wednesday Thursday:thursday Friday:friday Saturday:saturday Sunday:sunday];
  newRestaurant.hours = hours;
  
  NSDictionary *addressInfo = restaurantInfo[@"address"];
  NSString *addressNumber = addressInfo[@"number"];
  NSString *addressStreet = addressInfo[@"street"];
  NSString *addressCity = addressInfo[@"city"];
  NSString *addressState = addressInfo[@"state"];
  NSString *addressZip = addressInfo[@"zip"];
  Address *address = [[Address alloc] initWithStreetNumber:addressNumber streetName:addressStreet city:addressCity state:addressState zip:addressZip];
  newRestaurant.address = address;
  
  NSArray *menuPhotos = restaurantInfo[@"photos"];
  NSMutableArray *newPhotos = [NSMutableArray array];
  for (NSDictionary *photoInfo in menuPhotos) {
    NSString *photoID = photoInfo[@"id"];
    NSString *caption = photoInfo[@"caption"];
    NSData *photoData = photoInfo[@"data"];
    
    MenuItemPhoto *photo = [[MenuItemPhoto alloc] initWithID:photoID caption:caption data:photoData];
    [newPhotos addObject:photo];
  }
  newRestaurant.menuPhotoURLs = newPhotos;
  
  return newRestaurant;
  
}

@end
