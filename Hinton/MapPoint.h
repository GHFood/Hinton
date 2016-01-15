//
//  MapPoint.h
//  Hinton
//
//  Created by Brandon Roberts on 5/18/15.
//  Copyright © 2015 Gina Hinton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapPoint : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (strong, nonatomic) NSString *restaurantId;

-(instancetype)initWithLatitude:(NSNumber *)latitude longitude:(NSNumber *)longitude title:(NSString *)title restaurantID:(NSString *)restaurantID;

@end
