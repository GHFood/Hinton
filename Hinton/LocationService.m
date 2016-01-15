//
//  LocationService.m
//  Hinton
//
//  Created by Stephen Lardieri on 12/7/2015.
//  Copyright © 2015 Gina Hinton. All rights reserved.
//


#import <CoreLocation/CoreLocation.h>
#import "LocationService.h"


@interface LocationService () <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager * locationManager;

@end


@implementation LocationService

- (instancetype) init {

  self = [super init];
  if (self) {

    // Create our location manager and register ourselves as its delegate.
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;

    // Ask the user for consent to track the phone's location while the app is in use.
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
      [self.locationManager requestWhenInUseAuthorization];
    }

  }

  return self;
  
}


#pragma mark - CLLocationManagerDelegate

- (void) locationManager: (CLLocationManager *) manager didChangeAuthorizationStatus: (CLAuthorizationStatus) status {

  NSLog(@"Location manager authorization status changed to %d", [CLLocationManager authorizationStatus]);

  switch (status) {

    case kCLAuthorizationStatusAuthorizedWhenInUse:
    case kCLAuthorizationStatusAuthorizedAlways:

      NSLog(@"Location manager received user consent for tracking.");

      // Since we ask our map view to track our location when the app starts, one might ask why this code is needed.
      // The answer is that location services may be turned off when the app starts;
      // if they get turned on after we are running, the map won't realize it until someone else (the user or our code)
      // requests an update to our most-recent location.
      // Note that we can only submit an explicit request like this in iOS 9 and later; since we still support iOS 8,
      // we must first test for the selector.
      if ([CLLocationManager locationServicesEnabled] && [manager respondsToSelector: @selector(requestLocation)]) {
        NSLog(@"Requesting rough location (nearest 3km).");
        manager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
        [manager requestLocation];
      }

      break;

    default:

      break;

  }

}


// Receive the phone's updated location.
- (void) locationManager:(CLLocationManager *) manager didUpdateLocations: (NSArray *) locations {

  CLLocation *location = locations.lastObject;
  NSLog(@"LocationManager reports lat: %3.4f, long: %3.4f, alt: %3.0f m, head: %3.0f°, speed: %3.0f km/h", location.coordinate.latitude, location.coordinate.longitude, location.altitude, location.course, (location.speed * 3600.0 / 1000.0));

}


// Handle errors with obtaining location.
- (void) locationManager: (CLLocationManager *) manager didFailWithError: (NSError *) error {

  // See if we have been denied permission to track location.
  if ([error.domain isEqualToString:kCLErrorDomain] && error.code == kCLErrorDenied) {
    NSLog(@"Location manager reported failure: kCLErrorDenied");
  }

}

@end
