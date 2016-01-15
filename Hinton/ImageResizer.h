//
//  ImageResizer.h
//  Hinton
//
//  Created by Brandon Roberts on 5/20/15.
//  Copyright © 2015 Gina Hinton. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageResizer : NSObject

-(UIImage *)resizedImageWithImage:(UIImage *)image size:(CGSize)size;

@end
