//
//  RestaurantParser.m
//  Hinton
//
//  Created by Brandon Roberts on 5/18/15.
//  Copyright (c) 2015 BR World. All rights reserved.
//

#import "RestaurantParser.h"
#import "Restaurant.h"
#import "Hours.h"
#import "Address.h"
#import "MenuItemPhoto.h"

@implementation RestaurantParser

+(Restaurant *)restaurantFromJSONData:(NSData *)jsonData {
  NSError *jsonError;
  NSDictionary *restaurantInfo = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&jsonError];
  if (jsonError) {
    NSLog(@"JSON Error: %@", jsonError.localizedDescription);
    return nil;
  }
  
  Restaurant *newRestaurant = [[Restaurant alloc] init];
  
  newRestaurant.restaurantId = restaurantInfo[@"r_id"];
  newRestaurant.name = restaurantInfo[@"name"];
  newRestaurant.phone = restaurantInfo[@"phone"];
  newRestaurant.genre = restaurantInfo[@"genre"];
  newRestaurant.pricePoint = [NSNumber numberWithInt:(int)restaurantInfo[@"price"]];
  newRestaurant.recipe = restaurantInfo[@"recipe"];
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
  newRestaurant.photos = newPhotos;
  
  return newRestaurant;
  
}

@end
