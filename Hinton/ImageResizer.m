//
//  ImageResizer.m
//  Hinton
//
//  Created by Brandon Roberts on 5/20/15.
//  Copyright © 2015 Gina Hinton. All rights reserved.
//

#import "ImageResizer.h"

@implementation ImageResizer

-(UIImage *)resizedImageWithImage:(UIImage *)image size:(CGSize)size {
  
  UIGraphicsBeginImageContext(size);
  [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
  UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  return resizedImage;
}

@end
