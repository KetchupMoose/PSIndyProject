//
//  UIImageView+Scaling.m
//  Pick Something
//
//  Created by Macbook on 2014-01-08.
//  Copyright (c) 2014 bricorp. All rights reserved.
//

#import "UIImageView+Scaling.h"
#import "UIImage+Scaling.h"
#import "SDImageCache.h"
#import "SDWebImageDownloader.h"

@implementation UIImageView (Scaling)

-(void)setImageWithURL:(NSURL*)url scaleToSize:(BOOL)scale
{
    if(url.absoluteString.length < 5) return;
    if(!scale){
        [self setImageWithURL:url scaleToSize:NO];
        
        //[self setImageWithURL:url];
        return;
    }
    __block UIImageView* selfimg = self;
   //@"%@_%ix%i"
    __block NSString* prevKey = [NSString stringWithFormat:@"%@_%ix%i",url.absoluteString,(int)self.frame.size.width, (int)self.frame.size.height];
    
    
    
    __block UIImage* prevImage = nil;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^ {
        
        prevImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:prevKey];
        if(prevImage){
            dispatch_async(dispatch_get_main_queue(), ^ {
                [self setImage:prevImage];
            });
        }else{
            
            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:url options:SDWebImageDownloaderProgressiveDownload progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                if(error){
                    [selfimg setImageWithURL:url scaleToSize:scale];
                }else{
                    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                    dispatch_async(queue, ^ {
                        prevImage = [image imageByScalingProportionallyToSize:self.frame.size];
                        if(finished)
                            [[SDImageCache sharedImageCache] storeImage:prevImage forKey:prevKey];
                        dispatch_async(dispatch_get_main_queue(), ^ {
                            [self setImage:prevImage];
                        });
                    });
                }
            }];
        }
    });
    
    return;
}

-(void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder scaleToSize:(BOOL)scale
{
    [self setImage:placeholder];
    [self setImageWithURL:url scaleToSize:scale];
}


@end
