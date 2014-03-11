//
//  MainUITabBar.m
//  Pick Something
//
//  Created by Macbook on 2014-01-07.
//  Copyright (c) 2014 bricorp. All rights reserved.
//

#import "MainUITabBar.h"

@implementation MainUITabBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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

- (void)viewDidLayoutSubviews
{
    
    NSLog(@"LAYING OUT SUBVIEWS!!!!!");
    
    int counti = 0;
   for (UIControl *btn in self.subviews)
     
   {
       
       CGRect fra = btn.frame;
       fra.origin.x = 153.6*counti;
       fra.size.width = 153.6;
       counti=counti+1;
       btn.frame = fra;
       
   }
   
}

@end
