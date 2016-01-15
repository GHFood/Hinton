//
//  Address.m
//  Hinton
//
//  Created by Brandon Roberts on 5/18/15.
//  Copyright © 2015 Gina Hinton. All rights reserved.
//

#import "Address.h"


@implementation Address

-(instancetype)initWithStreetNumber:(NSString *)streetNumber streetName:(NSString *)streetName city:(NSString *)city state:(NSString *)state zip:(NSString *)zip {
  if (self = [super init]) {
    self.streetNumber = streetNumber;
    self.streetName = streetName;
    self.city = city;
    self.state = state;
    self.zip = zip;
  }
  return self;
}

@end
