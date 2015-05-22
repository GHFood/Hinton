//
//  ViewController.m
//  Hinton
//
//  Created by Brandon Roberts on 5/18/15.
//  Copyright (c) 2015 BR World. All rights reserved.
//

#import "ViewController.h"
#import "BackendService.h"
#import "MapPoint.h"
#import "RestaurantDetailViewController.h"
#import "RestaurantMapTableViewCell.h"
#import "RestaurantImageTableViewCell.h"
#import "SearchTableViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController () <CLLocationManagerDelegate, MKMapViewDelegate, RestaurantDetailDelegate, UISearchBarDelegate, SearchTableDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) IBOutlet UIView *header;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UIProgressView *progressBar;
@property (strong, nonatomic) RestaurantDetailViewController *restaurantDetail;
@property (strong, nonatomic) NSArray *allMapPoints;
@property (strong, nonatomic) NSArray *currentMapPoints;
@property (strong, nonatomic) SearchTableViewController *searchTableView;
@property (nonatomic) BOOL isShowingSearchTableView;
@property (strong, nonatomic) UISearchController *searchController;

@end

@implementation ViewController

CLLocationDistance initialMapViewDistance = 5000;
NSTimeInterval dismissViewAnimationDuration = 0.3;

- (void)viewDidLoad {
  [super viewDidLoad];

  self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
  self.searchController.searchResultsUpdater = self.searchTableView;
  self.searchController.dimsBackgroundDuringPresentation = NO;
  self.searchController.searchBar.delegate = self;
  self.searchController.searchBar.scopeButtonTitles = @[@"Address", @"Genre"];
  [self.mapView addSubview:self.searchController.searchBar];
  
  self.searchTableView = [[SearchTableViewController alloc] init];
  self.searchTableView.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.header.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height - self.searchController.searchBar.frame.size.height*2);
  [self.view addSubview:self.searchTableView.view];
  [self addChildViewController:self.searchTableView];
  [self.searchTableView didMoveToParentViewController:self];
  self.searchTableView.delegate = self;
  self.isShowingSearchTableView = NO;
  
  self.mapView.delegate = self;
  [self.progressBar setProgress:0.0 animated:NO];
  
  self.locationManager = [[CLLocationManager alloc] init];
  self.locationManager.delegate = self;
  
  if ([CLLocationManager locationServicesEnabled]) {
    [self.locationManager requestWhenInUseAuthorization];
  } else {
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(47.622152, -122.312965);
    [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(coordinate, initialMapViewDistance, initialMapViewDistance) animated:NO];
  }
  
  
  [BackendService fetchMapPointsForArea:CGRectZero completionHandler:^(NSArray *mapPoints, NSError *error) {
    if (!error) {
      self.allMapPoints = mapPoints;
      self.currentMapPoints = mapPoints;
    } else {
      NSLog(@"Error: %@", error.localizedDescription);
    }
    
  }];
}

//-(void)viewWillAppear:(BOOL)animated {
//  [super viewWillAppear:animated];
//  [self.searchController.searchBar sizeToFit];
//}

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

#pragma mark - CloseBannerDelegate

-(void)userDidTapCloseButton {
  [self dismissDetailView];
}

#pragma mark - CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
  self.mapView.showsUserLocation = YES;
  
  if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
    [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(manager.location.coordinate, initialMapViewDistance, initialMapViewDistance) animated:YES];
  } else {
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(47.622152, -122.312965);
    [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(coordinate, initialMapViewDistance, initialMapViewDistance) animated:NO];
  }
}

#pragma mark - UISearchBarDelegate

-(void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
  
  if (selectedScope == 1) {
    [self presentSearchTable];
  } else if (self.isShowingSearchTableView) {
    [self dismissSearchTable];
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
  
  [BackendService fetchMapPointsForGenre:genre completionHandler:^(NSArray *mapPoints, NSError *error) {
    self.currentMapPoints = mapPoints;
  }];
}


#pragma mark - Custom Property Getters/Setters

-(RestaurantDetailViewController *)restaurantDetail {
  if (_restaurantDetail) {
    return _restaurantDetail;
  }
  _restaurantDetail = [self.storyboard instantiateViewControllerWithIdentifier:@"RestaurantDetailVC"];
  _restaurantDetail.delegate = self;
  return _restaurantDetail;
}

-(void)setCurrentMapPoints:(NSArray *)currentMapPoints {
  [self.mapView removeAnnotations:_currentMapPoints];
  _currentMapPoints = currentMapPoints;
  [self.mapView addAnnotations:currentMapPoints];
}


#pragma mark - My Methods

- (IBAction)userLocationButtonPressed:(id)sender {
    [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(self.locationManager.location.coordinate, initialMapViewDistance, initialMapViewDistance) animated:YES];
}

-(void)dismissSearchTable {
  [UIView animateWithDuration:dismissViewAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
    self.searchTableView.view.center = CGPointMake(self.searchTableView.view.center.x, 800);
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
  }];
}

-(void)presentDetailViewWithAnnotation:(id<MKAnnotation>)annotation {
  
  [self.view addSubview:self.restaurantDetail.view];
  [self.restaurantDetail didMoveToParentViewController:self];
  [self addChildViewController:self.restaurantDetail];
  [self.view bringSubviewToFront:self.restaurantDetail.view];
  self.restaurantDetail.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.header.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height);
  self.restaurantDetail.annotation = annotation;
  
  [UIView animateWithDuration:dismissViewAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
    self.restaurantDetail.view.frame = CGRectMake(0, self.mapView.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height - self.header.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height);
  } completion:^(BOOL finished) {
    
  }];
}



@end
