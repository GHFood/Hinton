//
//  Address.h
//  Hinton
//
//  Created by Brandon Roberts on 5/18/15.
//  Copyright © 2015 Gina Hinton. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Address : NSObject

@property (nonatomic, retain) NSString * streetNumber;
@property (nonatomic, retain) NSString * streetName;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSString * zip;

-(instancetype)initWithStreetNumber:(NSString *)streetNumber streetName:(NSString *)streetName city:(NSString *)city state:(NSString *)state zip:(NSString *)zip;

@end
