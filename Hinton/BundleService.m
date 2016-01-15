//
//  BundleService.m
//  Hinton
//
//  Created by Stephen Lardieri on 12/4/2015.
//  Copyright © 2015 Gina Hinton. All rights reserved.
//

#import "BundleService.h"
#import "MapPointParser.h"
#import "Restaurant.h"
#import "GenreParser.h"
#import "AFNetworking.h"


// Magic
static NSString * resourceDirectory = @"SampleData/";
static NSString * resourceAllRestaurants = @"restaurants";
static NSString * resourceGenreList = @"genres";


@implementation BundleService

// Load a generic JSON resource from the main bundle.
// Because Objective-C does not support generics at the method-parameter level, we cannot assert NSDictionary vs. NSArray here; we can only pass back an "id" object.
- (void) loadJSONFromResource: (NSString *) resourceName success: ( void (^)(id jsonObject) ) successHandler failure: ( void (^)(NSError * error) ) failureHandler {
  
  NSError * error;
  NSString * resourcePath = [resourceDirectory stringByAppendingString: resourceName];
  NSURL * url = [[NSBundle mainBundle] URLForResource: resourcePath withExtension: @"json"];
  if (!url) {
    NSLog(@"Error generating URL for JSON resource '%@'", resourceName);
    return;
  }
  
  NSData * jsonData = [NSData dataWithContentsOfURL: url];
  if (!jsonData) {
    NSLog(@"Error loading JSON resource '%@'", url.absoluteString);
    return;
  }
  
  id jsonObject = [NSJSONSerialization JSONObjectWithData: jsonData options: 0 error: &error];
  if (!error) {
    successHandler(jsonObject);
  } else {
    NSLog(@"Error parsing JSON: %@", error.localizedDescription);
    failureHandler(error);
  }
  
}

// Fetch the list of all restaurant locations near a given location.
// Note: the test-bundle service ignores the location. This is not likely to change in the future, as geo-scoping functionality is a back-end function, not a client function.
- (void) fetchRestaurantsNearLatitude: (double) latitude longitude: (double) longitude success: ( void (^)(NSArray<NSDictionary *> * jsonArray) ) successHandler failure: ( void (^)(NSError * error) ) failureHandler {

  [self loadJSONFromResource: resourceAllRestaurants
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

  [self loadJSONFromResource: restaurantID
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

  [self loadJSONFromResource: resourceGenreList
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

  [self loadJSONFromResource: genre
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
