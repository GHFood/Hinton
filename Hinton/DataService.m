//
//  DataService.m
//  Hinton
//
//  Created by Stephen Lardieri on 12/4/2015.
//  Copyright © 2015 Gina Hinton. All rights reserved.
//

#import "DataService.h"
#import "MapPointParser.h"
#import "Restaurant.h"
#import "GenreParser.h"
#import "AFNetworking.h"

#import "BackendService.h"
#import "BundleService.h"



@interface DataService ()

@property (strong, nonatomic) id<DataService> service;

@end


@implementation DataService

// Pick the data service we are going to use based on whether we are in test mode or not.
- (instancetype) initWithTestMode: (bool) testMode {
  
  self = [super init];
  if (self) {
    if (testMode) {
      self.service = [[BundleService alloc] init];
    } else {
      self.service = [[BackendService alloc] init];
    }
  }
  
  return self;
  
}

// Fetch the list of all restaurant locations near a given location.
- (void) fetchRestaurantsNearLatitude: (double) latitude longitude: (double) longitude success: ( void (^)(NSArray<MapPoint *> * mapPoints) ) successHandler failure: ( void (^)(NSError * error) ) failureHandler {
  
  [self.service fetchRestaurantsNearLatitude: latitude longitude: longitude
                                     success: ^ (NSArray<NSDictionary *> * jsonArray) {
                                       
                                       // Convert the JSON response object into our data model objects.
                                       NSArray * mapPoints = [MapPointParser mapPointsFromJSONArray: jsonArray];
                                       successHandler(mapPoints);
                                     }
                                     failure: failureHandler];
  
}

// Fetch detailed information on a specific restaurant.
- (void) fetchRestaurantForID: (NSString *) restaurantID
                      success: ( void (^)(Restaurant * restaurant) ) successHandler failure: ( void (^)(NSError * error) ) failureHandler {
  
  [self.service fetchRestaurantForID: restaurantID
                             success: ^ (NSDictionary * jsonDictionary) {
                               
                               // Convert the JSON response object into our data model objects.
                               Restaurant * restaurant = [Restaurant restaurantFromJSONDictionary: jsonDictionary];
                               successHandler(restaurant);
                             }
                             failure: failureHandler];
  
}

// Fetch the list of all restaurant genres.
- (void) fetchGenresList: ( void (^)(NSArray<Genre *> * genresList) ) successHandler failure: ( void (^)(NSError * error) ) failureHandler {
  
  [self.service fetchGenresList: ^ (NSArray<NSDictionary *> * jsonArray) {
    
    // Convert the JSON response object into our data model objects.
    NSArray * genres = [GenreParser genresFromJSONArray: jsonArray];
    successHandler(genres);
  }
                        failure: failureHandler];
  
}

// Fetch the list of all restaurant locations in a given genre.
- (void) fetchMapPointsForGenre: (NSString *) genre
                        success: ( void (^)(NSArray<MapPoint *> * mapPoints) ) successHandler failure: ( void (^)(NSError * error) ) failureHandler {
  
  [self.service fetchMapPointsForGenre: genre
                               success: ^ (NSArray<NSDictionary *> * jsonArray) {
                                 
                                 // Convert the JSON response object into our data model objects.
                                 NSArray * mapPoints = [MapPointParser mapPointsFromJSONArray: jsonArray];
                                 successHandler(mapPoints);
                               }
                               failure: failureHandler];
  
}

@end
