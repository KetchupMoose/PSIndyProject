//
//  VoteScreenCollectionView.m
//  funnyBusiness
//
//  Created by Macbook on 2013-10-21.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import "VoteScreenCollectionView.h"
#import "PSCollectionView.h"
#import "VoteScreenCollectionViewCell.h"
#import "UIView+Animation.h"

@interface VoteScreenCollectionView ()

@end

@implementation VoteScreenCollectionView

NSArray *arryData;
NSInteger selectionIndex;
@synthesize querytouse;
@synthesize vschallengeVotes;
@synthesize challengeIndexNSNumber;
@synthesize vschallengeMode;
@synthesize vscontentObjectsArray;
@synthesize vscollectionViewDelegate;



//NSMutableArray *vschallengevotes;


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void) addFrames:(UIView *) addview
{
    [self addSubview:addview];
    }

-(void) queryforData
{
    PFQuery *contentQuery = querytouse;
    
    [contentQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded. The first 100 objects are available in objects
            //set the array
            
            [self.vscontentObjectsArray removeAllObjects];
            
            PFObject *bl;
            
            //try to do the proper method for adding the objects to the array.
            
            for (bl in objects)
                
            {
                [self.vscontentObjectsArray addObject:(bl)];
                
            }
            //self.contentObjectsArray = objects;
            
            
            //need method to call to reload table
            //[self reloadData:(self)];
            
            
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    NSLog(@"thismanysubviews %i" , self.subviews.count);
    
    NSLog(@"didre-query");
}


- (void)FrontPageSelectionViewControllerBackToFrontPage:
(FrontPageSelectionViewController *)controller
{
	//[self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark delegate methods for ContentVoteCells
- (void)processButtonClick:(UIButton *)btnclicked atIndex:(NSInteger)index withHostView:(UIView *) cview;
{
  
    PlayerData *sharedData = [PlayerData sharedData];
    float hearts = [sharedData.usercurrenthearts floatValue];
    
    if(hearts<=0)
    {
          [self.vscollectionViewDelegate showoutofhearts];
        return;
        
    }
    
      
    // NSLog(@"blabhalbalhbh this is the content array count: %i", self.vscontentObjectsArray.count);
    
    //do a vote function with this button
    //store the data on the server
    //refresh the views to show what got picked.
    
    //step 0: check what mode.  If it's vote mode, proceed to step 1.  If it's guess mode, show the user how they did and proceed to next object.  If it's tenth object, get some MO'.
    
    
    //step 1: update the pools object with the user's votes.  Total votes +1 and specific vote + 1 (later user vote strength)
    //NSArray *frogarray = [[NSArray alloc] initWithArray:[self.vscollectionViewDelegate getChallengeVotes:self]];
    
   // NSLog(@"hereis thecount :%i", self.vschallengeVotes.count ) ;
    
    NSInteger chgmode = [self.vschallengeMode integerValue];
    
    if (chgmode==1)
    {
        
        //do a guess and report if right or wrong
        NSInteger properchoice = 0;
        NSInteger valueholder=0;
        NSInteger iterator = 1;
        for (NSNumber *cellvote in vschallengeVotes)
        {
            
            NSInteger thisint = [cellvote intValue];
            if (thisint >valueholder)
            {
                valueholder=thisint;
                properchoice= iterator;
                
            }
            iterator = iterator +1;
            
        }
    
        
        //NSLog(@"TheProperChoiceWas: %i", properchoice);
        
        //delegate method to bring up the summary screen
        if([vschallengeVotes[index-1] integerValue]==valueholder)
            
        {
            //win mode
            NSInteger win = 1;
            [self.vscollectionViewDelegate showSummaryScreen:self withWinMode:win withChoice:index];
        }
        else
        {
            //lose mode
            
            
            NSInteger lose=0;
            [self.vscollectionViewDelegate showSummaryScreen:self withWinMode:lose withChoice:index];
        }
        
        //reset to challenge mode 0
        chgmode=0;
        self.vschallengeMode = [NSNumber numberWithInt:(chgmode)];
        
        //display something to show if the player was right or wrong, play a celebration or failure.
        
        
        
        //trigger next challengeindex..add a check to see if less than 10, else re-query for MO'
        //challengeindexvar = challengeindexvar+1;
       
        
        //[self.vscollectionViewDelegate getNextChallenge:wf];
        
        
        
        //reload data
        
          [self.vscollectionViewDelegate displayVoteFave:self];
        
    }
    
    else
    {
        
        NSLog(@"saving vote to db");
        [self.vscollectionViewDelegate VoteScreenNewVote:self voteIndex:index];
        //create a delegate function to do this data stuff from the ContentVotingViewController
        //sent: button index
        
        //later I would like to add a mode to save their guess history also and track their performance...figure this out tomorrow.
        
        
        //step 3: trigger the 2nd mode to guess.
        chgmode=1;
        self.vschallengeMode = [NSNumber numberWithInt:(chgmode)];
      
        
        //step 4: change the label to show the mode has changed or trigger a better display
        //change this to a delegate method if the parent UI ViewController (ContentVotingViewController) needs to do something..
        //self.modelabel.text = @"guess now!";
        
        [self.vscollectionViewDelegate displayGuessNow:self];
        
        //change the button text to show Most Popular
        NSLog(@"showing most popular instead %i", self.subviews.count);
        //UIScrollView *fred = [self.subviews objectAtIndex:2];
        
        for (VoteScreenCollectionViewCell * cell in self.subviews)
           
        {
            
            NSString *className = [[cell class] description];
            
            if ([className isEqualToString:@"VoteScreenCollectionViewCell"])
            {
                
                UIButton *btn = cell.thevotebtn;
                
                CGRect blah = cell.thevotebtn.frame;
                
                [cell PopButtonForBounce:cell.thevotebtn];
               
                if(btn.tag ==index)
                    
                {
                
                UIImageView *voteheartview = [[UIImageView alloc] initWithFrame:(CGRectMake(cell.frame.size.width-32,0,32,32))];
                
                [voteheartview setImage:[UIImage imageNamed:@"heartvote.png"]];
                
                voteheartview.contentMode = UIViewContentModeScaleAspectFit;
                
                    [cell addHeartThenSpin:voteheartview withCellView:cell];
                    
                //[cell BounceAddTheView:voteheartview];
                
                }
                
                
                //animate the <3 choice over the cell, partially transparent
                //[cell.thevotebtn setTitle:@"Guess Most Popular" forState:UIControlStateNormal];
                
                //cell.thevotebtn.titleLabel.font = [UIFont systemFontOfSize:11.0f];
                
                //cell.thevotebtn.frame= CGRectMake(blah.origin.x, blah.origin.y,121,34);
                
            }
            
            
        }
        
    }
    
}

//not using this at the moment, but in the future this is how you can add subviews and get the data.
- (void)addthelabels
{
    //get positions for labels according to cell positions
    
    UILabel *cell1count = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 250, 15)];
    UILabel *cell2count= [[UILabel alloc] initWithFrame:CGRectMake(20, 200, 250, 15)];
    UILabel *cell3count= [[UILabel alloc] initWithFrame:CGRectMake(50, 100, 250, 15)];
    UILabel *cell4count= [[UILabel alloc] initWithFrame:CGRectMake(20, 200, 250, 45)];
    
    
    cell1count.text = [NSString stringWithFormat:@"%@", [self.vschallengeVotes objectAtIndex:0]];
    cell2count.text = [NSString stringWithFormat:@"%@", [self.vschallengeVotes objectAtIndex:1]];
    cell3count.text = [NSString stringWithFormat:@"%@", [self.vschallengeVotes objectAtIndex:2]];
    cell4count.text = [NSString stringWithFormat:@"%@", [self.vschallengeVotes objectAtIndex:3]];
    
    cell1count.textColor = [UIColor redColor];
    cell2count.textColor = [UIColor redColor];
    cell3count.textColor = [UIColor redColor];
    cell4count.textColor = [UIColor redColor];
    
    [self addSubview:cell1count];
    [self addSubview:cell2count];
    [self addSubview:cell3count];
    [self addSubview:cell4count];
    
    NSLog(@"inserting subview");
    [self bringSubviewToFront:cell1count];
    [self bringSubviewToFront:cell2count];
    [self bringSubviewToFront:cell3count];
    [self bringSubviewToFront:cell4count];
}



@end
