//
//  RestaurantMapTableViewCell.m
//  Hinton
//
//  Created by Brandon Roberts on 5/19/15.
//  Copyright © 2015 Gina Hinton. All rights reserved.
//

#import "RestaurantMapTableViewCell.h"
#import "MapPoint.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface RestaurantMapTableViewCell () <MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation RestaurantMapTableViewCell

- (void)awakeFromNib {
    // Initialization code
  
 
  
  self.selectionStyle = UITableViewCellSelectionStyleNone;
  self.mapView.delegate = self;
}

-(void)setMapPoint:(MapPoint *)mapPoint {
  
  [self.mapView removeAnnotations:self.mapView.annotations];
  self.mapView.showsUserLocation = YES;
  [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(mapPoint.coordinate, 1000, 1000)];
  [self.mapView addAnnotation:mapPoint];
  self.mapView.scrollEnabled = NO;
  
  MKPlacemark *destinationPlacemark = [[MKPlacemark alloc] initWithCoordinate:mapPoint.coordinate addressDictionary:@{}];
  
  MKMapItem *userLocMapItem = [MKMapItem mapItemForCurrentLocation];
//  MKMapItem *userLocMapItem = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:manager.location.coordinate addressDictionary:nil]];
  MKMapItem *destinationLocMapItem = [[MKMapItem alloc] initWithPlacemark:destinationPlacemark];
//  MKMapItem *destinationLocMapItem = [MKMapItem mapItemForCurrentLocation];
  
  MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
  request.source = userLocMapItem;
  request.destination = destinationLocMapItem;
  request.transportType = MKDirectionsTransportTypeAutomobile;
  
  MKDirections *direction = [[MKDirections alloc] initWithRequest:request];
  
  if (!direction.calculating) {
    [direction calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
      
      if (!error) {
//        NSLog(@"MKDirResp: %@", response);
        MKRoute *route = response.routes.firstObject;
        MKPolyline *routePolyline = route.polyline;
        [self.mapView addOverlay:routePolyline];
      } else {
        NSLog(@"Error: %@", error);
      }
      
    }];
  }
}

-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
  MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
//  renderer.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
//  renderer.lineWidth = 10;
//  
  return renderer;
}

@end
