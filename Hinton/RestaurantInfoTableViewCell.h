//
//  RestaurantInfoTableViewCell.h
//  Hinton
//
//  Created by Brandon Roberts on 5/19/15.
//  Copyright © 2015 Gina Hinton. All rights reserved.
//

#import <UIKit/UIKit.h>


@class Restaurant;


@interface RestaurantInfoTableViewCell : UITableViewCell

@property (strong, nonatomic) Restaurant *restaurantToDisplay;

- (void)hoursButtonPressed;

@end
