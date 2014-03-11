//
//  BadgeCollectionViewCell.m
//  funnyBusiness
//
//  Created by Macbook on 2013-11-11.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import "BadgeCollectionViewCell.h"

@implementation BadgeCollectionViewCell
@synthesize cellPhoto;
@synthesize cellLabel;
//@synthesize cellPhotoImage;
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

//-(void) setCellPhotoImage:(UIImage *)img {
    
   // if(cellPhotoImage != img) {
   //     cellPhotoImage = img;
   // }
   // self.cellPhoto.image = img;
//}

-(void) dealloc
{
    cellPhoto = nil;
    cellLabel=nil;
    
}

@end
