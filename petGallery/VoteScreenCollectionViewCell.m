//
//  VoteScreenCollectionViewCell.m
//  funnyBusiness
//
//  Created by Macbook on 2013-10-18.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import "VoteScreenCollectionViewCell.h"

@implementation VoteScreenCollectionViewCell

@synthesize voteScreenCollectionViewCellDelegate;


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

- (IBAction)SelectVoteButton:(id)sender
{
    //call a delegate method which takes into consideration whats displayed and pass it the cell index of this button.
    NSLog(@"vote button clicked");
    
    
    
    UIButton *blah= sender;
    
      UIView *thishostview = self.superview;
    
    
    [self.voteScreenCollectionViewCellDelegate processButtonClick:sender atIndex:blah.tag withHostView:thishostview];
    
  
    
}

-(void) doaclick : (id) sender{
    UIButton *clicked = (UIButton *) sender;
    NSLog(@"%d",clicked.tag);//Here you know which button has pressed
    
    UIButton *blah= sender;
    
    UIView *thishostview = self.superview;
    
    
    [self.voteScreenCollectionViewCellDelegate processButtonClick:sender atIndex:blah.tag withHostView:thishostview];
    
}



@end
