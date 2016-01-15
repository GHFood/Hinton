//
//  ImageFetcher.h
//  Hinton
//
//  Created by Brandon Roberts on 5/20/15.
//  Copyright © 2015 Gina Hinton. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageFetcher : NSObject

-(void)fetchImageAtURL:(NSURL *)url size:(CGSize)size completionHandler:(void(^)(UIImage *fetchedImage, NSError *error))completion;

@end
