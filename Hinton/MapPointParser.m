//
//  MapPointParser.m
//  Hinton
//
//  Created by Brandon Roberts on 5/18/15.
//  Copyright © 2015 Gina Hinton. All rights reserved.
//

#import "MapPointParser.h"
#import "MapPoint.h"

@implementation MapPointParser

+ (NSArray *) mapPointsFromJSONArray: (NSArray *) jsonArray {
  NSMutableArray *returnArray = [NSMutableArray array];
  
  for (NSDictionary *mapPointInfo in jsonArray) {
    NSString *restaurantID = mapPointInfo[@"_id"];
    
    NSDictionary *mapInfo = mapPointInfo[@"map"];
    NSString *caption = mapInfo[@"caption"];
    
    NSDictionary *locInfo = mapInfo[@"loc"];
    NSNumber *lat = locInfo[@"lat"];
    NSNumber *lon = locInfo[@"long"];
    
    MapPoint *newMapPoint = [[MapPoint alloc] initWithLatitude:lat longitude:lon title:caption restaurantID:restaurantID];
    
    [returnArray addObject:newMapPoint];
    
  }
  
  return returnArray;
}

@end
