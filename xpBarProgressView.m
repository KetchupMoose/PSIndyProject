//
//  xpBarProgressView.m
//  funnyBusiness
//
//  Created by Macbook on 2013-11-07.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import "xpBarProgressView.h"

#define fillOffsetX 2
#define fillOffsetTopY 2
#define fillOffsetBottomY 2

@implementation xpBarProgressView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        NSArray *subViews = self.subviews;
        for(UIView *view in subViews)
        {
            [view removeFromSuperview];
        }
        
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)drawRect2:(CGRect)rect {
    // lets prepare UIImage first, with stretching to fit our requirements
    
    self.backgroundColor = [UIColor clearColor];
    
    
    UIImage *fill = [[UIImage imageNamed:@"level-bar-fill.png"]
                     resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 4)];
   
   
    NSInteger maxWidth = rect.size.width;
    NSInteger curWidth = floor([self progress] * maxWidth);
    
    CGRect fillRect = CGRectMake(rect.origin.x,
                                 rect.origin.y+1,
                                 curWidth,
                                 rect.size.height-2);
    // Draw the fill
    [fill drawInRect:fillRect];
}

- (void)drawRect:(CGRect)rect {
    
   // CGSize backgroundStretchPoints = {10, 10}, fillStretchPoints = {7, 7};
    
     self.backgroundColor = [UIColor clearColor];
    
    // Initialize the stretchable images.
  // UIImage *background = [[UIImage imageNamed:@"Level-bar.png"] stretchableImageWithLeftCapWidth:backgroundStretchPoints.width topCapHeight:backgroundStretchPoints.height];
    
    UIImage *fill = [[UIImage imageNamed:@"level-bar-fill.png"]
                     resizableImageWithCapInsets:UIEdgeInsetsMake(0, 1, 0, 1)];
    
    // Draw the background in the current rect
    //[background drawInRect:rect];
    
    // Compute the max width in pixels for the fill.  Max width being how
    // wide the fill should be at 100% progress.
    NSInteger maxWidth = rect.size.width - (2 * fillOffsetX);
    
    // Compute the width for the current progress value, 0.0 - 1.0 corresponding
    // to 0% and 100% respectively.
    NSInteger curWidth = floor([self progress] * maxWidth);
    
    // Create the rectangle for our fill image accounting for the position offsets,
    // 1 in the X direction and 1, 3 on the top and bottom for the Y.
    CGRect fillRect = CGRectMake(rect.origin.x + fillOffsetX,
                                 rect.origin.y + fillOffsetTopY,
                                 curWidth,
                                 rect.size.height - fillOffsetBottomY);
    
    // Draw the fill
    [fill drawInRect:fillRect];
}

@end
