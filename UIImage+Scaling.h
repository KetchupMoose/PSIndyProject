//
//  UIImage+Scaling.h
//  Pick Something
//
//  Created by Macbook on 2014-01-08.
//  Copyright (c) 2014 bricorp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Scaling)

-(UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize;
-(UIImage*) croppedImageWithRect: (CGRect) rect;

@end
