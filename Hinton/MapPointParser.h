//
//  MapPointParser.h
//  Hinton
//
//  Created by Brandon Roberts on 5/18/15.
//  Copyright © 2015 Gina Hinton. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MapPointParser : NSObject

+ (NSArray *) mapPointsFromJSONArray: (NSArray *) jsonArray;

@end
