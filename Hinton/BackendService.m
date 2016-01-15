//
//  BackendService.m
//  Hinton
//
//  Created by Brandon Roberts on 5/18/15.
//  Copyright © 2015 Gina Hinton. All rights reserved.
//

#import "BackendService.h"
#import "MapPointParser.h"
#import "Restaurant.h"
#import "GenreParser.h"
#import "AFNetworking.h"


// Magic
static NSString * urlAllRestaurants = @"http://52.88.209.205:2121/api/restaurant/all";
static NSString * urlRestaurantByID = @"http://52.88.209.205:2121/api/restaurant/";
static NSString * urlGenreList = @"http://52.88.209.205:2121/api/restaurant/genre/all";
static NSString * urlMapPointsForGenre = @"http://52.88.209.205:2121/api/restaurant/genre/";


@interface BackendService ()

@property (strong, nonatomic) AFHTTPRequestOperationManager * manager;

- (instancetype) init;

@end


@implementation BackendService

// Initialize the AFNetworking manager.
- (instancetype) init {
  
  self = [super init];
  if (self) {
    self.manager = [AFHTTPRequestOperationManager manager];
  }
  
  return self;
  
}

// Download a JSON document from the back-end server at the URL specified.
// Because Objective-C does not support generics at the method-parameter level, we cannot assert NSDictionary vs. NSArray here; we can only pass back an "id" object.
- (void) loadJSONFromURL: (NSURL *) url success: ( void (^)(id jsonObject) ) successHandler failure: ( void (^)(NSError * error) ) failureHandler {
  
  [self.manager GET: url.absoluteString parameters: nil
       success: ^ (AFHTTPRequestOperation * operation, id responseObject) {
         successHandler(responseObject);
       }
       failure: ^ (AFHTTPRequestOperation * operation, NSError * error) {
         NSLog(@"Error retrieving JSON: %@", error.localizedDescription);
         failureHandler(error);
       }];
  
}

// Fetch the list of all restaurant locations near a given location.
- (void) fetchRestaurantsNearLatitude: (double) latitude longitude: (double) longitude success: ( void (^)(NSArray<NSDictionary *> * jsonArray) ) successHandler failure: ( void (^)(NSError * error) ) failureHandler {
  
  NSURL * fetchAllRestaurantsURL = [NSURL URLWithString: urlAllRestaurants];
  
  [self loadJSONFromURL: fetchAllRestaurantsURL
                success: ^ (id jsonObject) {
                  if ( ![jsonObject isKindOfClass: [NSArray class]] )
                  {
                    NSLog(@"JSON is not in the expected format");
                    return;
                  }
                  
                  successHandler(jsonObject);
                }
                failure: failureHandler];
  
}

// Fetch detailed information on a specific restaurant.
- (void) fetchRestaurantForID: (NSString *) restaurantID success: ( void (^)(NSDictionary * jsonDictionary) ) successHandler failure: ( void (^)(NSError * error) ) failureHandler {
  
  NSURL * fetchRestaurantURL = [[NSURL URLWithString: urlRestaurantByID] URLByAppendingPathComponent: restaurantID];
  
  [self loadJSONFromURL: fetchRestaurantURL
                success: ^ (id jsonObject) {
                  if ( ![jsonObject isKindOfClass: [NSDictionary class]] )
                  {
                    NSLog(@"JSON is not in the expected format");
                    return;
                  }
                  
                  successHandler(jsonObject);
                }
                failure: failureHandler];
  
}

// Fetch the list of all restaurant genres.
- (void) fetchGenresList: ( void (^)(NSArray<NSDictionary *> * jsonArray) ) successHandler failure: ( void (^)(NSError * error) ) failureHandler {
  
  NSURL * genresURL = [NSURL URLWithString: urlGenreList];
  
  [self loadJSONFromURL: genresURL
                success: ^ (id jsonObject) {
                  if ( ![jsonObject isKindOfClass: [NSArray class]] )
                  {
                    NSLog(@"JSON is not in the expected format");
                    return;
                  }
                  
                  successHandler(jsonObject);
                }
                failure: failureHandler];
  
}

// Fetch the list of all restaurant locations in a given genre.
- (void) fetchMapPointsForGenre: (NSString *) genre success: ( void (^)(NSArray<NSDictionary *> * jsonArray) ) successHandler failure: ( void (^)(NSError * error) ) failureHandler {
  
  NSURL * mapPointforGenreURL = [[NSURL URLWithString: urlMapPointsForGenre] URLByAppendingPathComponent: genre];
  
  [self loadJSONFromURL: mapPointforGenreURL
                success: ^ (id jsonObject) {
                  if ( ![jsonObject isKindOfClass: [NSArray class]] )
                  {
                    NSLog(@"JSON is not in the expected format");
                    return;
                  }
                  
                  successHandler(jsonObject);
                }
                failure: failureHandler];
  
}

@end
