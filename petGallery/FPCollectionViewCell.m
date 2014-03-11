//
//  FPCollectionViewCell.m
//  funnyBusiness
//
//  Created by Macbook on 2013-11-10.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import "FPCollectionViewCell.h"

@implementation FPCollectionViewCell
@synthesize cellImage;
@synthesize cellText;
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


-(void) dealloc
{
    cellImage = nil;
    cellText = nil;
    
}

@end
