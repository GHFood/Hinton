//
//  ViewController.m
//  Hinton
//
//  Created by Brandon Roberts on 5/18/15.
//  Copyright © 2015 Gina Hinton. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#import "ViewController.h"
#import "AppDelegate.h"
#import "DataService.h"
#import "MapPoint.h"
#import "RestaurantDetailViewController.h"
#import "RestaurantMapTableViewCell.h"
#import "RestaurantImageTableViewCell.h"
#import "SearchTableViewController.h"


@interface ViewController () <MKMapViewDelegate, RestaurantDetailDelegate, UISearchBarDelegate, SearchTableDelegate>


@property (strong, nonatomic) IBOutlet UIView *header;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UIButton *userLocationButton;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (strong, nonatomic) RestaurantDetailViewController *restaurantDetail;
@property (strong, nonatomic) NSArray *allMapPoints;
@property (strong, nonatomic) NSArray *currentMapPoints;
@property (strong, nonatomic) SearchTableViewController *searchTableView;
@property (nonatomic) BOOL isShowingSearchTableView;
@property (strong, nonatomic) UISearchController *searchController;

@end


@implementation ViewController

// Magic
const CLLocationDegrees latitudeOfCodeFellows = 47.6235;
const CLLocationDegrees longitudeOfCodeFellows = -122.3363;
const CLLocationDistance initialMapViewDistance = 4000;

const NSTimeInterval mapDimDuration = 0.1;
const float mapDimAlpha = 0.3;
const NSTimeInterval dismissViewAnimationDuration = 0.3;


- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
  self.searchController.searchResultsUpdater = self.searchTableView;
  self.searchController.dimsBackgroundDuringPresentation = NO;
  self.searchController.searchBar.delegate = self;
  self.searchController.searchBar.scopeButtonTitles = @[@"Address", @"Genre", @"Price"];
  self.searchController.view.tintColor = [UIColor darkGrayColor];
  [self.mapView addSubview:self.searchController.searchBar];
  
  self.searchTableView = [[SearchTableViewController alloc] init];
  self.searchTableView.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.header.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height - self.searchController.searchBar.frame.size.height*2);
  [self.view addSubview:self.searchTableView.view];
  [self addChildViewController:self.searchTableView];
  [self.searchTableView didMoveToParentViewController:self];
  self.searchTableView.delegate = self;
  self.isShowingSearchTableView = NO;
  
  self.mapView.delegate = self;
  self.spinner.color = [UIColor darkGrayColor];

  // If this device supports location tracking, then show the user's location if we have it.
  // TODO: replace our custom userLocationButton with a standard Apple MKUserTrackingBarButtonItem to let the user control tracking.
  // (Because, you know, this phone does belong to the *user*, not us...)
  if ([CLLocationManager locationServicesEnabled]) {
    self.mapView.showsUserLocation = YES;
    [self.mapView setUserTrackingMode: MKUserTrackingModeFollow animated: YES];
  } else {
    // Set the original position of the map to South Lake Union.
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitudeOfCodeFellows, longitudeOfCodeFellows);
    [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(coordinate, initialMapViewDistance, initialMapViewDistance) animated:NO];
  }

  [self enterWaitMode];
  
  AppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
  [appDelegate.restaurantDataService fetchRestaurantsNearLatitude: latitudeOfCodeFellows longitude: longitudeOfCodeFellows success: ^ (NSArray<MapPoint *> * mapPoints) {
    self.allMapPoints = mapPoints;
    self.currentMapPoints = mapPoints;
    [self exitWaitMode];
  } failure: ^ (NSError *error) {
    NSLog(@"Error: %@", error.localizedDescription);
    [self exitWaitMode];
  }];

}


-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
  
  if ([annotation isKindOfClass:[MKUserLocation class]]) {
    return nil;
  }
  
  MKAnnotationView *annoView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"mapAnnotation"];
  
  if (!annoView) {
    annoView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"mapAnnotation"];
    annoView.image = [UIImage imageNamed:@"hinton_logo_map_pin_size"];
    annoView.canShowCallout = YES;
    annoView.draggable = NO;
    annoView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
  }
  
  return annoView;
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
  [self.searchController setActive:NO];
  
  [self presentDetailViewWithAnnotation:view.annotation];
}

- (void) mapView: (MKMapView *) mapView didUpdateUserLocation: (MKUserLocation *) userLocation {

  CLLocation * location = userLocation.location;
  NSLog(@"MapView reports lat: %3.4f, long: %3.4f, alt: %3.0f m, head: %3.0f°, speed: %3.0f km/h", location.coordinate.latitude, location.coordinate.longitude, location.altitude, location.course, (location.speed * 3600.0 / 1000.0));

}


#pragma mark - CloseBannerDelegate

-(void)userDidTapCloseButton {
  [self dismissDetailView];
}

#pragma mark - UISearchBarDelegate

-(void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
  
  //show tableview of genres
  if (selectedScope == 1) {
    [self presentSearchTable];
    //[searchBar resignFirstResponder];
  } else if (self.isShowingSearchTableView) {
    [self dismissSearchTable];
  }
  //show tableview of price tiers
  if (selectedScope == 2) {
    [self presentSearchTable];
  } else if (self.isShowingSearchTableView) {
    //[self dismissSearchTable];
  }
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
  
  if (self.isShowingSearchTableView == YES) {
    [self dismissSearchTable];
  }
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
  searchBar.selectedScopeButtonIndex = 0;
  if (self.isShowingSearchTableView) {
    [self dismissSearchTable];
  }
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
  if ([searchText isEqualToString:@""]) {
    if (self.currentMapPoints != self.allMapPoints) {
      self.currentMapPoints = self.allMapPoints;
    }
  }
}

#pragma mark - SearchTableDelegate

-(void)searchTableDidSelectGenre:(NSString *)genre {
  self.searchController.searchBar.selectedScopeButtonIndex = 0;
  [self.searchController setActive:NO];
  self.searchController.searchBar.text = genre;
  
  [self enterWaitMode];
  
  AppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
  [appDelegate.restaurantDataService fetchMapPointsForGenre: genre success: ^ (NSArray<MapPoint *> * mapPoints) {
    self.currentMapPoints = mapPoints;
    [self exitWaitMode];
  } failure: ^ (NSError * error) {
    [self exitWaitMode];
  }];
}


#pragma mark - Custom Property Getters/Setters

-(void)setCurrentMapPoints:(NSArray *)currentMapPoints {
  [self.mapView removeAnnotations:_currentMapPoints];
  _currentMapPoints = currentMapPoints;
  [self.mapView addAnnotations:currentMapPoints];
}


#pragma mark - My Methods

// If the user taps the location button, recenter the map on their location.
- (IBAction)userLocationButtonPressed:(id)sender {

  [self.mapView setUserTrackingMode: MKUserTrackingModeFollow animated: YES];
  
}

-(void)dismissSearchTable {
  [UIView animateWithDuration:dismissViewAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
    self.searchTableView.view.center = CGPointMake(self.searchTableView.view.center.x, self.searchTableView.view.center.y + self.searchTableView.view.frame.size.height);
  } completion:^(BOOL finished) {
    self.isShowingSearchTableView = NO;
  }];
}

-(void)presentSearchTable {
  [UIView animateWithDuration:dismissViewAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
    self.searchTableView.view.center = CGPointMake(self.view.frame.size.width/2, self.mapView.frame.origin.y + self.searchTableView.view.frame.size.height/2 + self.searchController.searchBar.frame.size.height);
  } completion:^(BOOL finished) {
    self.isShowingSearchTableView = YES;
  }];
}

-(void)dismissDetailView {
  [UIView animateWithDuration:dismissViewAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
    
    self.restaurantDetail.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.header.frame.size.height);
    
  } completion:^(BOOL finished) {
    [self.restaurantDetail.view removeFromSuperview];
    [self.restaurantDetail didMoveToParentViewController:nil];
    [self.restaurantDetail removeFromParentViewController];
    self.restaurantDetail = nil;
  }];
}

-(void)presentDetailViewWithAnnotation:(id<MKAnnotation>)annotation {

  self.restaurantDetail = [self.storyboard instantiateViewControllerWithIdentifier:@"RestaurantDetailVC"];
  self.restaurantDetail.delegate = self;
  [self.view addSubview:self.restaurantDetail.view];
  [self.restaurantDetail didMoveToParentViewController:self];
  [self addChildViewController:self.restaurantDetail];
  [self.view bringSubviewToFront:self.restaurantDetail.view];
  self.restaurantDetail.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.header.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height);
  self.restaurantDetail.annotation = annotation;
  
  [UIView animateWithDuration:dismissViewAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
    self.restaurantDetail.view.frame = CGRectMake(0, self.mapView.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height - self.header.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height);
    //    self.restaurantDetail.view.bounds = bounds;
  } completion:^(BOOL finished) {
    [self.restaurantDetail.view setNeedsDisplay];
  }];

}

-(void)enterWaitMode {

  NSLog(@"Entering wait mode.");

  [UIView animateWithDuration:mapDimDuration animations:^{
    [self.spinner startAnimating];
    self.mapView.alpha = mapDimAlpha;
    self.mapView.userInteractionEnabled = NO;
    self.userLocationButton.enabled = NO;
  } completion:^(BOOL finished) {
  }];
  
}

-(void)exitWaitMode {
  
  NSLog(@"Exiting wait mode.");

  [UIView animateWithDuration:mapDimDuration animations:^{
    [self.spinner stopAnimating];
    self.mapView.alpha = 1.0;
    self.mapView.userInteractionEnabled = YES;
    self.userLocationButton.enabled = YES;
  } completion:^(BOOL finished) {
  }];
  
}

@end
