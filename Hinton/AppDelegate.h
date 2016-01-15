//
//  AppDelegate.h
//  Hinton
//
//  Created by Stephen Lardieri on 12/3/2015.
//  Copyright © 2015 Gina Hinton. All rights reserved.
//

#import <UIKit/UIKit.h>


@class DataService;


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) DataService * restaurantDataService;

@end

