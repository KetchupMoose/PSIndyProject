//
//  UIImage+Scaling.m
//  Pick Something
//
//  Created by Macbook on 2014-01-08.
//  Copyright (c) 2014 bricorp. All rights reserved.
//

#import "UIImage+Scaling.h"

@implementation UIImage (Scaling)

- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize {
    
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        if ([[UIScreen mainScreen] scale] == 2.0) {
            targetSize.height *= 2.0f;
            targetSize.width *= 2.0f;
        }
    }
    
    NSUInteger width = targetSize.width;
    NSUInteger height = targetSize.height;
    UIImage *newImage = [self resizedImageWithMinimumSize: CGSizeMake (width, height)];
    return [newImage croppedImageWithRect: CGRectMake ((newImage.size.width - width) / 2, (newImage.size.height - height) / 2, width, height)];
}

-(CGImageRef)CGImageWithCorrectOrientation
{
    if (self.imageOrientation == UIImageOrientationDown) {
        //retaining because caller expects to own the reference
        CGImageRetain([self CGImage]);
        return [self CGImage];
    }
    
    UIGraphicsBeginImageContext(self.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (self.imageOrientation == UIImageOrientationRight) {
        CGContextRotateCTM (context, 90 * M_PI/180);
    } else if (self.imageOrientation == UIImageOrientationLeft) {
        CGContextRotateCTM (context, -90 * M_PI/180);
    } else if (self.imageOrientation == UIImageOrientationUp) {
        CGContextRotateCTM (context, 180 * M_PI/180);
    }
    
    [self drawAtPoint:CGPointMake(0, 0)];
    
    CGImageRef cgImage = CGBitmapContextCreateImage(context);
    UIGraphicsEndImageContext();
    
    return cgImage;
}

-(UIImage*)resizedImageWithMinimumSize:(CGSize)size
{
    CGImageRef imgRef = [self CGImageWithCorrectOrientation];
    CGFloat original_width  = CGImageGetWidth(imgRef);
    CGFloat original_height = CGImageGetHeight(imgRef);
    CGFloat width_ratio = size.width / original_width;
    CGFloat height_ratio = size.height / original_height;
    CGFloat scale_ratio = width_ratio > height_ratio ? width_ratio : height_ratio;
    CGImageRelease(imgRef);
    return [self drawImageInBounds: CGRectMake(0, 0, round(original_width * scale_ratio), round(original_height * scale_ratio))];
}

-(UIImage*)drawImageInBounds:(CGRect)bounds
{
    UIGraphicsBeginImageContext(bounds.size);
    [self drawInRect: bounds];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resizedImage;
}

-(UIImage*)croppedImageWithRect:(CGRect)rect
{
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect drawRect = CGRectMake(-rect.origin.x, -rect.origin.y, self.size.width, self.size.height);
    CGContextClipToRect(context, CGRectMake(0, 0, rect.size.width, rect.size.height));
    [self drawInRect:drawRect];
    UIImage* subImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return subImage;
}

-(UIImage *) resizableImageWithCapInsets2: (UIEdgeInsets) inset
{
    if ([self respondsToSelector:@selector(resizableImageWithCapInsets:resizingMode:)])
    {
        return [self resizableImageWithCapInsets:inset resizingMode:UIImageResizingModeStretch];
    }
    else
    {
        float left = (self.size.width-2)/2;//The middle points rarely vary anyway
        float top = (self.size.height-2)/2;
        return [self stretchableImageWithLeftCapWidth:left topCapHeight:top];
    }
}

@end
