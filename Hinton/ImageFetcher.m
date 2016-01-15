//
//  ImageFetcher.m
//  Hinton
//
//  Created by Brandon Roberts on 5/20/15.
//  Copyright © 2015 Gina Hinton. All rights reserved.
//

#import "ImageFetcher.h"
#import "AFNetworking.h"
#import "ImageResizer.h"

@interface ImageFetcher ()

//@property (strong, nonatomic) NSOperationQueue *imageQueue;
@property (strong, nonatomic) ImageResizer *imageResizer;

@end

@implementation ImageFetcher

-(instancetype)init {
  if (self = [super init]) {
//    _imageQueue = [[NSOperationQueue alloc] init];
    _imageResizer = [[ImageResizer alloc] init];
  }
  return self;
}

-(void)fetchImageAtURL:(NSURL *)url size:(CGSize)size completionHandler:(void (^)(UIImage *, NSError *))completion {
  
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  [manager GET:url.absoluteString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    if ([responseObject isKindOfClass:[NSData class]]) {
      UIImage *returnedImage = [UIImage imageWithData:responseObject];
      UIImage *resizedImage = [self.imageResizer resizedImageWithImage:returnedImage size:size];
      
      completion(resizedImage, nil);
    }
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    completion(nil, error);
  }];
  
  
}

@end
