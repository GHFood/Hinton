//
//  BundleService.h
//  Hinton
//
//  Created by Stephen Lardieri on 12/4/2015.
//  Copyright © 2015 Gina Hinton. All rights reserved.
//

#import "DataService.h"

@interface BundleService : NSObject <DataService>

- (void) fetchRestaurantsNearLatitude: (double) latitude longitude: (double) longitude success: ( void (^)(NSArray<NSDictionary *> * jsonArray) ) successHandler failure: ( void (^)(NSError * error) ) failureHandler;
- (void) fetchRestaurantForID: (NSString *) restaurantID success: ( void (^)(NSDictionary * jsonDictionary) ) successHandler failure: ( void (^)(NSError * error) ) failureHandler;
- (void) fetchGenresList: ( void (^)(NSArray<NSDictionary *> * jsonArray) ) successHandler failure: ( void (^)(NSError * error) ) failureHandler;
- (void) fetchMapPointsForGenre: (NSString *) genre success: ( void (^)(NSArray<NSDictionary *> * jsonArray) ) successHandler failure: ( void (^)(NSError * error) ) failureHandler;

@end
