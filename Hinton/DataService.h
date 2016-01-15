//
//  DataService.h
//  Hinton
//
//  Created by Stephen Lardieri on 12/4/2015.
//  Copyright © 2015 Gina Hinton. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Restaurant;
@class MapPoint;
@class Genre;


// Classes that conform to the DataService **protocol** have one purpose:
//     Obtain some JSON from somewhere.
// Interpreting that JSON to create our data model objects is the purpose of the DataService **class** which is NOT the same as the DataService protocol (and doesn't even conform to it).
// In this way, we separate these two distinct responsibilities.
@protocol DataService <NSObject>

- (void) fetchRestaurantsNearLatitude: (double) latitude longitude: (double) longitude success: ( void (^)(NSArray<NSDictionary *> * jsonArray) ) successHandler failure: ( void (^)(NSError * error) ) failureHandler;
- (void) fetchRestaurantForID: (NSString *) restaurantID success: ( void (^)(NSDictionary * jsonDictionary) ) successHandler failure: ( void (^)(NSError * error) ) failureHandler;
- (void) fetchGenresList: ( void (^)(NSArray<NSDictionary *> * jsonArray) ) successHandler failure: ( void (^)(NSError * error) ) failureHandler;
- (void) fetchMapPointsForGenre: (NSString *) genre success: ( void (^)(NSArray<NSDictionary *> * jsonArray) ) successHandler failure: ( void (^)(NSError * error) ) failureHandler;

@end

@interface DataService : NSObject

- (instancetype) initWithTestMode: (bool) testMode;
- (void) fetchRestaurantsNearLatitude: (double) latitude longitude: (double) longitude success: ( void (^)(NSArray<MapPoint *> * mapPoints) ) successHandler failure: ( void (^)(NSError * error) ) failureHandler;
- (void) fetchRestaurantForID: (NSString *) restaurantID success: ( void (^)(Restaurant * restaurant) ) successHandler failure: ( void (^)(NSError * error) ) failureHandler;
- (void) fetchGenresList: ( void (^)(NSArray<Genre *> * genresList) ) successHandler failure: ( void (^)(NSError * error) ) failureHandler;
- (void) fetchMapPointsForGenre: (NSString *) genre success: ( void (^)(NSArray<MapPoint *> * mapPoints) ) successHandler failure: ( void (^)(NSError * error) ) failureHandler;

@end
