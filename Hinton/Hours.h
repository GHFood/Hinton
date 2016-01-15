//
//  Hours.h
//  Hinton
//
//  Created by Brandon Roberts on 5/18/15.
//  Copyright © 2015 Gina Hinton. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Hours : NSObject

@property (strong, nonatomic) NSString *mondayHours;
@property (strong, nonatomic) NSString *tuesdayHours;
@property (strong, nonatomic) NSString *wednesdayHours;
@property (strong, nonatomic) NSString *thursdayHours;
@property (strong, nonatomic) NSString *fridayHours;
@property (strong, nonatomic) NSString *saturdayHours;
@property (strong, nonatomic) NSString *sundayHours;

-(instancetype)initWithMonday:(NSString *)monday Tuesday:(NSString *)tuesday Wednesday:(NSString *)wednesday Thursday:(NSString *)thursday Friday:(NSString *)friday Saturday:(NSString *)saturday Sunday:(NSString *)sunday;

@end
