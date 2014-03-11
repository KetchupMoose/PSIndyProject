//
//  VoteSummaryViewController.m
//  funnyBusiness
//
//  Created by Macbook on 2013-10-22.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import "VoteSummaryViewController.h"
#import <parse/parse.h>
#import "TopBarViewController.h"
#import "UITabBarController+TabBarControl.h"
#import "UIView+Animation.h"
#import "GoldCoinParticleEmitter.h"
#import "CelebrateParticleView.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "funData.h"
#import "AppDelegate.h"
#import "InternetOfflineViewController.h"

@interface VoteSummaryViewController ()

@end

@implementation VoteSummaryViewController

@synthesize vsSummaryDelegate;
@synthesize contentobjs;
@synthesize votecounts;
@synthesize WinorFailMode;
@synthesize vsummarychallengeIndexNSNumber;

@synthesize winsinarow;
@synthesize topbar;
@synthesize imagearea;
@synthesize reactionSound;
@synthesize tpvc;
NSArray *sorted;
@synthesize justappeared;
@synthesize nextBtn;
@synthesize chosenobj;
LossScreenViewController *lossvc;
UIButton *lossBtn;


// I need a system for tracking player score.
//1. player current score must be reset to 0 if the player loses
//2. player current score must be retrieved from the server at the start of each session.  This should take place on load of the first vote screen.
//3. Player score should be uploaded to the server each time it changes along with xp/gold uploads.


NSInteger playerScore;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
   lossBtn = [[UIButton alloc] init];
    //black button.
    
    lossBtn.alpha = 0;
    
    NSString *btnfileName = [[NSBundle mainBundle] pathForResource:@"score" ofType:@"png"];
    UIImage *btnimg =[UIImage imageWithContentsOfFile:btnfileName];
    
    [lossBtn setBackgroundImage:btnimg forState:UIControlStateNormal];
    
    //[lossBtn setTitle:@"Show Score" forState:UIControlStateNormal];
    //lossBtn.titleLabel.font = [UIFont fontWithName:@"CooperBlackStd" size:15];
    
    
    //[lossBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    
    CGRect  buttonFrame = lossBtn.frame;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        buttonFrame.size = CGSizeMake(120, 50);
    }
    else
    {
        buttonFrame.size = CGSizeMake(240, 100);
        lossBtn.titleLabel.font = [UIFont fontWithName:@"CooperBlackStd" size:30];
    }
    
    lossBtn.frame = buttonFrame;
    
    CGRect bounds = self.view.bounds;
    
    //set two different frames for iphone 4/iphone 5
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        
        //setting frame of show score button
        CGSize result = [[UIScreen mainScreen] bounds].size;
        
        if(result.height>=500)
        {
            NSLog(@"got called, iphone 5 frame");
            
            buttonFrame.origin = CGPointMake((bounds.size.width-buttonFrame.size.width)/2,bounds.size.height-155);
        }
        else
        {
            buttonFrame.origin = CGPointMake((bounds.size.width-buttonFrame.size.width)/2,bounds.size.height-70);
            
        }
    }
    else
    {
        buttonFrame.origin = CGPointMake((bounds.size.width-buttonFrame.size.width)/2,bounds.size.height-200);
    }
    
    
    lossBtn.frame = buttonFrame;
    
    
    [lossBtn addTarget:self action:@selector(ShowLossScreen:) forControlEvents:UIControlEventTouchUpInside];
    
    //considerfixinglossbtnhere
    [self.view addSubview:lossBtn];
    
    NSString *bgfileName = [[NSBundle mainBundle] pathForResource:@"blue-backgroundnosections" ofType:@"png"];
    UIImage *background =[UIImage imageWithContentsOfFile:bgfileName];
    
    UIImage *myb = [self imageWithImage:background scaledToSize:self.view.frame.size];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:myb]];
    
    self.imagearea.backgroundColor = [UIColor clearColor];
    
    
    self.topbar.backgroundColor = [UIColor clearColor];
        
    //does iPhone need this code?
    
     if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
     {
    CGRect myframe = self.view.frame;
    
    CGFloat tabheight = self.tabBarController.tabBar.frame.size.height;
    
    
   self.tabBarController.tabBar.frame = CGRectMake(0, myframe.size.height - tabheight, 320, 47);
     }
        //code to add top bar to container
 
    
   tpvc=[self.storyboard instantiateViewControllerWithIdentifier:@"topbar"];
    
    [self addChildViewController:tpvc];
    
    tpvc.topbardelegate = self;
    
    
    [self.topbar addSubview:tpvc.view];
    
    tpvc.view.frame = self.topbar.bounds;
    
    NSInteger indexvar = [vsummarychallengeIndexNSNumber intValue];
     PFObject *challengepoolsobj = [self.contentobjs objectAtIndex:indexvar];
    NSMutableArray *pfobjs = [[NSMutableArray alloc] init];
    CGRect img1pos;
    CGRect img2pos, img3pos, img4pos;
     if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
     {
    img1pos = CGRectMake(5,5, 152,152);
    img2pos = CGRectMake(160,5, 152,152);
    img3pos = CGRectMake(5,160, 152,152);
    img4pos = CGRectMake(160,160, 152,152);
}
    else
    {
        img1pos = CGRectMake(65,40, 324,324);
        img2pos = CGRectMake(389,40, 324,324);
        img3pos = CGRectMake(65,364, 324,324);
        img4pos = CGRectMake(389,364, 324,324);
    }


    int h;
    float totalvotecount = 0;
    for (int i=0; i<votecounts.count; i++)
    {
        NSNumber *thenum = votecounts[i];
        
        float thisvote = [thenum floatValue];
        totalvotecount = totalvotecount + thisvote;
        h=h+1;
        
    }
    totalvotecount = totalvotecount;
    
    
    // put objects in order, add objects for the images to load to add as subviews later
    for (int i =0; i<=3; i++)
    {
       
        NSString *cellIndexString = [NSString stringWithFormat:@"%i", i +1 ];
        NSString *keystring = @"funPhotoObj";
        
        NSString *concatenatedCellObjString = [keystring stringByAppendingString:cellIndexString];
        
        PFObject *cellDataObj = [challengepoolsobj objectForKey:concatenatedCellObjString];
        
        [pfobjs addObject:cellDataObj];
        
            }
   
    
    NSMutableArray *dataArray = [NSMutableArray array];
    for (int i=0; i<pfobjs.count; i++) {
        NSNumber *originalpos = [NSNumber numberWithInt:i];
        
        UIImageView *imgobj = [[UIImageView alloc] init];
        UIImageView *scoreview = [[UIImageView alloc] init];
        UILabel *votenumlabel = [[UILabel alloc] init];
        UILabel *votepctlabel = [[UILabel alloc] init];
        UIView *cellview = [[UIView alloc] init];
        
        votepctlabel.opaque = NO;
        votenumlabel.opaque=NO;
        
        votepctlabel.backgroundColor = [UIColor clearColor];
        votenumlabel.backgroundColor = [UIColor clearColor];
        
        scoreview.image = [UIImage imageNamed:@"Score-popup-top-of-pic.png"];
        //scoreview.opaque = NO;
        
        cellview.backgroundColor = [UIColor clearColor];
        
        
        
        if(i==0)
        {
       // NSNumber *imgheight =[pfobjs[i] objectForKey:@"imgHeight"];
        //NSNumber *imgwidth =[pfobjs[i] objectForKey:@"imgWidth"];
        
           //float imgh = [imgheight floatValue];
           // float imgw = [imgwidth floatValue];
           // CGSize sizei = CGSizeMake(imgw,imgh);
            
          // CGSize imgsize = [self scalesize:sizei maxWidth:maxw maxHeight:maxh];
            
            //CGRect imgframe;
            //imgframe.origin = img1point;
            //imgframe.size = imgsize;
            
            cellview.frame = img1pos;
            
            imgobj.frame = CGRectMake(0,0,cellview.frame.size.width, cellview.frame.size.height);
            
            NSString *imglink = [pfobjs[i] objectForKey:@"imgLink"];
            NSString *imgurl;
            if(imglink.length<2)
            {
                PFFile *mydata = [pfobjs[i] objectForKey:@"imageFile"];
                imgurl = mydata.url;
                
            }
            else
            {
                imgurl =imglink;
            }
            
            //sets gifs to a non gif default
            NSString *imgtype = [pfobjs[i] objectForKey:@"imgURType"];
            CGSize result = [[UIScreen mainScreen] bounds].size;
            if(result.height == 480)
            {
                // iPhone Classic
                if([imgtype isEqualToString:@"image/gif"])
                {
                    imgurl = @"http://i.imgur.com/cwAB9XA.jpg";
                }
                
            }
            
            UIImage *cellplaceholder = [UIImage imageWithContentsOfFile:@"imgloadingplaceholder.png"];
            [imgobj setImageWithURL:[NSURL URLWithString:imgurl] placeholderImage:cellplaceholder];
            
            imgobj.layer.cornerRadius=9.0;
            imgobj.layer.masksToBounds = YES;
            
           
            
            //code to add extra elements to cells
            
             if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
             {
                 scoreview.frame = CGRectMake(0, cellview.frame.size.height -60, 110, 40);
             }
            else
            {
                 scoreview.frame = CGRectMake(0, cellview.frame.size.height -120, 220, 80);
            }
           
            scoreview.layer.cornerRadius = 4.0;
            
            
           float thisvotenum = [votecounts[i] floatValue];
            
            NSString *votestring = [NSString stringWithFormat:@"%.f",thisvotenum];
            
            NSString *totalvotestring = [votestring stringByAppendingString:@" Votes"];
            
            float votepct = 100 * thisvotenum/totalvotecount;

            if (thisvotenum==0)
            {
                votepct = 0;
                
            }
            
            NSString *pctstring = [NSString stringWithFormat:@"%.02f",votepct];
            
            NSString *totalpctstring = [pctstring stringByAppendingString:@"%    Picked This"];
             if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
             {
                 totalpctstring = [pctstring stringByAppendingString:@"% Picked This"];
             }
            
            
            votenumlabel.text = totalvotestring;
            votepctlabel.text = totalpctstring;
            
            votenumlabel.frame = CGRectMake(4, 0,scoreview.bounds.size.width,scoreview.frame.size.height/2);
            
            
            votepctlabel.frame = CGRectMake(4, scoreview.frame.size.height/2,scoreview.frame.size.width,scoreview.frame.size.height/2);
            
             if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
             {
                 votenumlabel.font =  [UIFont fontWithName:@"CooperBlackStd" size:10];
                 votepctlabel.font =  [UIFont fontWithName:@"CooperBlackStd" size:10];
             }
            else
            {
                votenumlabel.font =  [UIFont fontWithName:@"CooperBlackStd" size:30];
                votepctlabel.font =  [UIFont fontWithName:@"CooperBlackStd" size:30];
                votepctlabel.frame = CGRectMake(4, 0,scoreview.frame.size.width,scoreview.frame.size.height);
                votepctlabel.numberOfLines =2;
                
                votenumlabel.alpha = 0;
                
                
            }
           
            
            [scoreview addSubview:votenumlabel];
            [scoreview addSubview:votepctlabel];
            
            [cellview addSubview:imgobj];
            [cellview addSubview:scoreview];
            
            
        }
        if(i==1)
        {
           
            cellview.frame = img2pos;
            
            imgobj.frame = CGRectMake(0,0,cellview.frame.size.width, cellview.frame.size.height);
            NSString *imglink = [pfobjs[i] objectForKey:@"imgLink"];
            NSString *imgurl;
            if(imglink.length<2)
            {
                PFFile *mydata = [pfobjs[i] objectForKey:@"imageFile"];
                imgurl = mydata.url;
                
            }
            else
            {
                imgurl =imglink;
            }
           
            //sets gifs to a non gif default
            NSString *imgtype = [pfobjs[i] objectForKey:@"imgURType"];
            CGSize result = [[UIScreen mainScreen] bounds].size;
            if(result.height == 480)
            {
                // iPhone Classic
                if([imgtype isEqualToString:@"image/gif"])
                {
                    imgurl = @"http://i.imgur.com/cwAB9XA.jpg";
                }
                
            }
            
            UIImage *cellplaceholder = [UIImage imageWithContentsOfFile:@"imgloadingplaceholder.png"];
            [imgobj setImageWithURL:[NSURL URLWithString:imgurl] placeholderImage:cellplaceholder];
            imgobj.layer.cornerRadius=9.0;
            imgobj.layer.masksToBounds = YES;
            
                        //code to add extra elements to cells
            
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            {
                 scoreview.frame = CGRectMake(0, cellview.frame.size.height -60, 110, 40);
            }
            else
            {
                 scoreview.frame = CGRectMake(0, cellview.frame.size.height -120, 220, 80);
            }
           
            scoreview.layer.cornerRadius = 4.0;
           
            
            float thisvotenum = [votecounts[i] floatValue];
            
            NSString *votestring = [NSString stringWithFormat:@"%.f",thisvotenum];
            
            NSString *totalvotestring = [votestring stringByAppendingString:@" Votes"];
            
            float votepct = 100 * thisvotenum/totalvotecount;
            
            if (thisvotenum==0)
            {
                votepct = 0;
                
            }
            
            NSString *pctstring = [NSString stringWithFormat:@"%.02f",votepct];
            
            NSString *totalpctstring = [pctstring stringByAppendingString:@"%      Picked This"];
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            {
                totalpctstring = [pctstring stringByAppendingString:@"% Picked This"];
            }
            votenumlabel.text = totalvotestring;
            votepctlabel.text = totalpctstring;
            
            
            
            votenumlabel.frame = CGRectMake(4, 0,scoreview.frame.size.width,scoreview.frame.size.height/2);
            
            
            votepctlabel.frame = CGRectMake(4, scoreview.frame.size.height/2,scoreview.frame.size.width,scoreview.frame.size.height/2);
            
             if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
             {
                 votenumlabel.font =  [UIFont fontWithName:@"CooperBlackStd" size:10];
                 votepctlabel.font =  [UIFont fontWithName:@"CooperBlackStd" size:10];
             }
            else
            {
                votenumlabel.font =  [UIFont fontWithName:@"CooperBlackStd" size:30];
                votepctlabel.font =  [UIFont fontWithName:@"CooperBlackStd" size:30];
                
                votepctlabel.frame = CGRectMake(4, 0,scoreview.frame.size.width,scoreview.frame.size.height);
                votepctlabel.numberOfLines =2;
                votenumlabel.alpha = 0;
                
            }
           
            
            [scoreview addSubview:votenumlabel];
            [scoreview addSubview:votepctlabel];
            
            [cellview addSubview:imgobj];
            [cellview addSubview:scoreview];
            
                    }
        if(i==2)
        {
           
            cellview.frame = img3pos;
            
            imgobj.frame = CGRectMake(0,0,cellview.frame.size.width, cellview.frame.size.height);
            NSString *imglink = [pfobjs[i] objectForKey:@"imgLink"];
            NSString *imgurl;
            if(imglink.length<2)
            {
                PFFile *mydata = [pfobjs[i] objectForKey:@"imageFile"];
                imgurl = mydata.url;
                
            }
            else
            {
                imgurl =imglink;
            }
            //sets gifs to a non gif default
            NSString *imgtype = [pfobjs[i] objectForKey:@"imgURType"];
            CGSize result = [[UIScreen mainScreen] bounds].size;
            if(result.height == 480)
            {
                // iPhone Classic
                if([imgtype isEqualToString:@"image/gif"])
                {
                    imgurl = @"http://i.imgur.com/cwAB9XA.jpg";
                }
                
            }
            
            UIImage *cellplaceholder = [UIImage imageWithContentsOfFile:@"imgloadingplaceholder.png"];
            [imgobj setImageWithURL:[NSURL URLWithString:imgurl] placeholderImage:cellplaceholder];
            imgobj.layer.cornerRadius=9.0;
            imgobj.layer.masksToBounds = YES;
            
            
            
            //code to add extra elements to cells
            
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            {
                scoreview.frame = CGRectMake(0, cellview.frame.size.height -60, 110, 40);
            }
            else
            {
                scoreview.frame = CGRectMake(0, cellview.frame.size.height -120, 220, 80);
            }
           
            scoreview.layer.cornerRadius = 4.0;
           
            
            float thisvotenum = [votecounts[i] floatValue];
            
            NSString *votestring = [NSString stringWithFormat:@"%.f",thisvotenum];
            
            NSString *totalvotestring = [votestring stringByAppendingString:@" Votes"];
            
            float votepct = 100* thisvotenum/totalvotecount;
            if (thisvotenum==0)
            {
                votepct = 0;
                
            }

            NSString *pctstring = [NSString stringWithFormat:@"%.02f",votepct];
            
            NSString *totalpctstring = [pctstring stringByAppendingString:@"%      Picked This"];
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            {
                totalpctstring = [pctstring stringByAppendingString:@"% Picked This"];
            }
            votenumlabel.text = totalvotestring;
            votepctlabel.text = totalpctstring;
            
            votenumlabel.frame = CGRectMake(4, 0,scoreview.frame.size.width,scoreview.frame.size.height/2);
            
            
            votepctlabel.frame = CGRectMake(4, scoreview.frame.size.height/2,scoreview.frame.size.width,scoreview.frame.size.height/2);
            
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            {
                votenumlabel.font =  [UIFont fontWithName:@"CooperBlackStd" size:10];
                votepctlabel.font =  [UIFont fontWithName:@"CooperBlackStd" size:10];
            }
            else
            {
                votenumlabel.font =  [UIFont fontWithName:@"CooperBlackStd" size:30];
                votepctlabel.font =  [UIFont fontWithName:@"CooperBlackStd" size:30];
                votepctlabel.frame = CGRectMake(4, 0,scoreview.frame.size.width,scoreview.frame.size.height);
                votepctlabel.numberOfLines =2;
                votenumlabel.alpha = 0;
            }
            
            [scoreview addSubview:votenumlabel];
            [scoreview addSubview:votepctlabel];
            
            [cellview addSubview:imgobj];
            [cellview addSubview:scoreview];
           
        }
        if(i==3)
        {
           
            cellview.frame = img4pos;
            
            imgobj.frame = CGRectMake(0,0,cellview.frame.size.width, cellview.frame.size.height);
            NSString *imglink = [pfobjs[i] objectForKey:@"imgLink"];
            NSString *imgurl;
            if(imglink.length<2)
            {
                PFFile *mydata = [pfobjs[i] objectForKey:@"imageFile"];
                imgurl = mydata.url;
                
            }
            else
            {
                imgurl =imglink;
            }
            
            //sets gifs to a non gif default
            NSString *imgtype = [pfobjs[i] objectForKey:@"imgURType"];
            CGSize result = [[UIScreen mainScreen] bounds].size;
            if(result.height == 480)
            {
                // iPhone Classic
                if([imgtype isEqualToString:@"image/gif"])
                {
                    imgurl = @"http://i.imgur.com/cwAB9XA.jpg";
                }
                
            }
            
            UIImage *cellplaceholder = [UIImage imageWithContentsOfFile:@"imgloadingplaceholder.png"];
            [imgobj setImageWithURL:[NSURL URLWithString:imgurl] placeholderImage:cellplaceholder];
            imgobj.layer.cornerRadius=9.0;
            imgobj.layer.masksToBounds = YES;
            
            
            
            //code to add extra elements to cells
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            {
                scoreview.frame = CGRectMake(0, cellview.frame.size.height -60, 110, 40);
            }
            else
            {
                scoreview.frame = CGRectMake(0, cellview.frame.size.height -120, 220, 80);
            }
            scoreview.layer.cornerRadius = 4.0;
            
            
            float thisvotenum = [votecounts[i] floatValue];
            
            NSString *votestring = [NSString stringWithFormat:@"%.f",thisvotenum];
            
            NSString *totalvotestring = [votestring stringByAppendingString:@" Votes"];
            
            float votepct = 100* thisvotenum/totalvotecount;
            if (thisvotenum==0)
            {
                votepct = 0;
                
            }

            NSString *pctstring = [NSString stringWithFormat:@"%.02f",votepct];
            
            NSString *totalpctstring = [pctstring stringByAppendingString:@"%      Picked This"];
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            {
                totalpctstring = [pctstring stringByAppendingString:@"% Picked This"];
            }
            votenumlabel.text = totalvotestring;
            votepctlabel.text = totalpctstring;
            
            votenumlabel.frame = CGRectMake(4, 0,scoreview.frame.size.width,scoreview.frame.size.height/2);
            
            
            votepctlabel.frame = CGRectMake(4, scoreview.frame.size.height/2,scoreview.frame.size.width,scoreview.frame.size.height/2);
            
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            {
                votenumlabel.font =  [UIFont fontWithName:@"CooperBlackStd" size:10];
                votepctlabel.font =  [UIFont fontWithName:@"CooperBlackStd" size:10];
            }
            else
            {
                votenumlabel.font =  [UIFont fontWithName:@"CooperBlackStd" size:30];
                votepctlabel.font =  [UIFont fontWithName:@"CooperBlackStd" size:30];
                votepctlabel.frame = CGRectMake(4, 0,scoreview.frame.size.width,scoreview.frame.size.height);
                votepctlabel.numberOfLines =2;
                votenumlabel.alpha = 0;
            }
            
            [scoreview addSubview:votenumlabel];
            [scoreview addSubview:votepctlabel];
            
            [cellview addSubview:imgobj];
            [cellview addSubview:scoreview];
           
        }
        
        NSInteger winorfailmd = [self.WinorFailMode intValue];
        NSInteger choice = [self.chosenobj intValue];
        choice = choice-1;
        
        if(winorfailmd==1)
        {
            //win.
            //show a checkmark
        }
        else
        {
            
            //loss.
            //show an x on top right.
            
            if (i==choice)
            {
            UILabel *redXLabel = [[UILabel alloc] init];
                redXLabel.backgroundColor = [UIColor clearColor];
                
            redXLabel.frame = CGRectMake(cellview.frame.size.width/2-25,cellview.frame.size.height/2-25,50, 50);
            redXLabel.text = @"X";
            
            redXLabel.textAlignment = NSTextAlignmentCenter;
            
            redXLabel.font = [UIFont fontWithName:@"CooperBlackStd" size:40];
            redXLabel.textColor = [UIColor redColor];
            redXLabel.shadowColor = [UIColor blackColor];
        
            [cellview addSubview:redXLabel];
            }
            
        }

        
        [dataArray addObject:@{
                               @"votecount" : self.votecounts[i],
                               @"object"    : pfobjs[i],
                               @"originalposition" : originalpos,
                               @"imageobj" :imgobj,
                               @"scoreview" :scoreview,
                               @"totalcell" :cellview
                               }];
    }
    sorted = [dataArray sortedArrayUsingDescriptors:@[
                                                               [NSSortDescriptor sortDescriptorWithKey:@"votecount"
                                                ascending:YES]]];
    
    
    

    //self.count1.text = [NSString stringWithFormat:@"%@", [self.votecounts objectAtIndex:0]];
    //self.count2.text = [NSString stringWithFormat:@"%@", [self.votecounts objectAtIndex:1]];
    //self.count3.text = [NSString stringWithFormat:@"%@", [self.votecounts objectAtIndex:2]];
    //self.count4.text = [NSString stringWithFormat:@"%@", [self.votecounts objectAtIndex:3]];
    
    NSInteger winorfailmd = [self.WinorFailMode intValue];
    NSInteger wins = [self.winsinarow intValue];
    if(winorfailmd ==1)
    {
       // self.winorlose.text = @"Win!";
        NSString *winstreakstring = [NSString stringWithFormat:@"%i",wins];
        
        NSString *endstring = @" Wins in a Row!";
        
        //self.winstreak.text = [winstreakstring stringByAppendingString: endstring];
        
        //give the user xp and gold.  Write a cloud side script for this.
        
        //show the button try again..
        }
    else
    {
        //self.winorlose.text = @"Loss";
        //self.winstreak.text = @"Try to start a new streak!";
        
        //take away a user's heart
        //image stays as next
        
        NSString *fileName = [[NSBundle mainBundle] pathForResource:@"try-again-button" ofType:@"png"];
        UIImage *bgimage = [UIImage imageWithContentsOfFile:fileName];
        
        [nextBtn setImage:bgimage forState:UIControlStateNormal];
        
        
        
        
}
    AppDelegate *myad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if(myad.internet==NO)
    {
        InternetOfflineViewController *iovc = [[InternetOfflineViewController alloc] init];
        
        [self addChildViewController:iovc];
        
        [self.view addSubview:iovc.view];
    }

}
- (UIImage *)imageManager:(SDWebImageManager *)imageManager transformDownloadedImage:(UIImage *)image withURL:(NSURL *)imageURL
{
    int maxw = 145;
    int maxh = 112;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        maxw = 145;
        maxh = 112;
    }
    else
    {
        maxw = 290;
        maxh = 224;
           }
   
    
    
    CGSize sizeobj = image.size;
    
    
    CGSize sizeforimgcontainer = [self scalesize:sizeobj maxWidth:maxw maxHeight:maxh];
    //reduce the image to its proper size.
    
    image=[self imageWithImage:image scaledToSize:sizeforimgcontainer];
    
    
    
    return image;
    
    
}

-(void) viewDidLayoutSubviews
{
    CGRect  buttonFrame = lossBtn.frame;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        buttonFrame.size = CGSizeMake(120, 50);
    }
    else
    {
        buttonFrame.size = CGSizeMake(240, 100);
        lossBtn.titleLabel.font = [UIFont fontWithName:@"CooperBlackStd" size:30];
    }
    
    lossBtn.frame = buttonFrame;
    
    CGRect bounds = self.view.bounds;
    
    //set two different frames for iphone 4/iphone 5
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        
        //setting frame of show score button
        CGSize result = [[UIScreen mainScreen] bounds].size;
        
        if(result.height>=500)
        {
            NSLog(@"got called, iphone 5 frame");
            
            buttonFrame.origin = CGPointMake((bounds.size.width-buttonFrame.size.width)/2,bounds.size.height-155);
        }
        else
        {
            buttonFrame.origin = CGPointMake((bounds.size.width-buttonFrame.size.width)/2,370);
            
        }
    }
    else
    {
        buttonFrame.origin = CGPointMake((bounds.size.width-buttonFrame.size.width)/2,bounds.size.height-200);
    }
    
    
    lossBtn.frame = buttonFrame;
}

-(UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(void) animatetextsizeincrease:(UILabel *) mylabel
{
     [self.imagearea addSubview:mylabel];
    [UIView beginAnimations:nil context:nil/*contextPoint*/];
    mylabel.transform = CGAffineTransformMakeScale(2, 2); //increase the size by 2
    //etc etc same procedure for the other labels.
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDelay:1];
    [UIView setAnimationDuration:2];
    [UIView setAnimationRepeatCount:4];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView commitAnimations];
    
    CGRect myrect = mylabel.frame;
    CGPoint mypoint = CGPointMake(myrect.origin.x + (myrect.size.width / 2), myrect.origin.y + (myrect.size.height / 2));
    
       //NSInteger winresult = [WinorFailMode integerValue];
    
   /* if(winresult ==1)
    {
    GoldCoinParticleEmitter *gp = [[GoldCoinParticleEmitter alloc] initWithFrame:self.view.frame particlePosition:mypoint];
    [self.view addSubview:gp];
    
    [gp decayOverTime:2.0];
    }
    */
    
}
-(void) animatescoretextsizeincrease:(UILabel *) mylabel
{
    [self.imagearea addSubview:mylabel];
    [UIView beginAnimations:nil context:nil/*contextPoint*/];
    mylabel.transform = CGAffineTransformMakeScale(2, 2); //increase the size by 2
    //etc etc same procedure for the other labels.
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDelay:0.5];
    [UIView setAnimationDuration:2];
    [UIView setAnimationRepeatCount:4];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView commitAnimations];
    
}

- (void)viewDidAppear:(BOOL)animated
{
  
    
    //code to show level up popup when needed.
    
    /*
    NSNumber *hearts = [NSNumber numberWithInt:1];
      NSNumber *gold = [NSNumber numberWithInt:1];
      NSNumber *diamonds = [NSNumber numberWithInt:1];
    
    [self showalevelup:hearts withGold:gold withGems:diamonds withHearts:hearts];
    */
    
    NSInteger just = [justappeared integerValue];
    
  if(just==1)
  {
      return;
  }
    
    NSInteger j=1;
    self.justappeared = [NSNumber numberWithInteger:j];
    
    //animate in the different imageviews and set their positions
    
    float delay;
    int voteholder;
    NSDictionary *winner = [sorted objectAtIndex:3];
    voteholder = [[winner objectForKey:@"votecount"] integerValue];
    for( int i =0; i<=3; i++)
    {
        NSDictionary *dictval = [sorted objectAtIndex:i];
        
        PFImageView *imgtoadd = [dictval objectForKey:@"imageobj"];
        
        UIView *cell = [dictval objectForKey:@"totalcell"];
        
        cell.backgroundColor = [UIColor clearColor];
        
        int thevotes = [[dictval objectForKey:@"votecount"] integerValue];
        
        
        
        //darken the image if it didn't win
        if(i<3 && thevotes < voteholder)
        {
            //if
            imgtoadd = [self darken2:imgtoadd];
            
           cell.layer.borderColor = [UIColor redColor].CGColor;
            cell.layer.borderWidth = 1.5f;
            cell.layer.cornerRadius = 9.0f;
            cell.layer.masksToBounds = YES;
            
        }
        else
        {
            cell.layer.borderColor = [UIColor greenColor].CGColor;
            cell.layer.borderWidth = 1.5f;
             cell.layer.cornerRadius = 9.0f;
            cell.layer.masksToBounds = YES;
            
        }
        //perform a selector with variable delay
        //[self.imagearea addSubview:cell];
        delay=0.1f;
        [self performSelector:@selector(addCellView:) withObject:cell afterDelay:delay];
    }
    
    delay=delay+1;

  
    NSInteger winresult = [WinorFailMode integerValue];
    
    
    //animate xp bar progress moving up and awards xp
    //always give gold before xp, the xp counter does the saving to user table.
    //change these values to be drawn from the challenge value on the DB
    
    NSInteger indexvar = [vsummarychallengeIndexNSNumber intValue];
    PFObject *thechgobj = [self.contentobjs objectAtIndex:indexvar];
    NSInteger chgval = [[thechgobj objectForKey:@"challengeScore"] integerValue];
    float chgvalfloat = [[thechgobj objectForKey:@"challengeScore"] floatValue];
    NSInteger chgrank = [[thechgobj objectForKey:@"rank"] integerValue];
    
    if(winresult ==1 || chgrank ==1)
    {
        
        //plays confetti
        if (chgval>10)
        {
            CelebrateParticleView *cpv = [[CelebrateParticleView alloc] initWithFrame:self.view.frame particlePosition:self.view.frame.origin];
            
            [self.view addSubview:cpv];
            
            NSTimeInterval decaytime= 3.0;
            
            [cpv decayOverTime:decaytime];
        }
        
        
        
        //play a voice sound
       // NSString *filestring = [self decideWinSound];
        
      //  NSString *shutterplayerPath = [[NSBundle mainBundle] pathForResource:filestring ofType:@"m4a"];
        
        
        //self.reactionSound =  [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSURL alloc] initFileURLWithPath: shutterplayerPath] error:NULL];
        
        //self.reactionSound.volume = 1.0;
        self.reactionSound.volume = 0;
        
        self.reactionSound.delegate = self;
        
       // [self.reactionSound prepareToPlay];
        
        
       // [reactionSound play];
        PlayerData *sharedData = [PlayerData sharedData];
        
       
        NSInteger prevscore =  [sharedData.playerscore integerValue];
        
        NSString *thescoretext = [NSString stringWithFormat:@"%i",prevscore+chgval];
        NSString *fullstring = [@"Score:" stringByAppendingString:thescoretext];
        
        
        //show labels for gold, xp, and score.
        UILabel *gold = [[UILabel alloc] init];
          UILabel *xp = [[UILabel alloc] init];
          UILabel *score = [[UILabel alloc] init];
        
        gold.text = @" Gold:";
        xp.text = @" XP:";
        score.text = @" Score:";
        
        
        UILabel *goldnum = [[UILabel alloc] init];
        UILabel *xpnum = [[UILabel alloc] init];
        UILabel *scorenum = [[UILabel alloc] init];
        
        
        NSString *chgvalstring = [NSString stringWithFormat:@"%i",chgval];
        
        goldnum.text = [@"+" stringByAppendingString:chgvalstring];
        
        //goldnum.textColor = [UIColor yellowColor];
        
        xpnum.text = [@"+" stringByAppendingString:chgvalstring];
       // xpnum.textColor = [UIColor yellowColor];
        
        NSString *ScoreString = [[sharedData.playerscore stringValue] stringByAppendingString:@" +("];
        NSString *scoreend = [chgvalstring stringByAppendingString:@")"];
        
        NSString *finalscorestring = [ScoreString stringByAppendingString:scoreend];
        
        scorenum.text = finalscorestring;
        
        //set fonts
        
       
        
        
        //set different dimensions for iphone 5 vs iPhone 4.
        
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
       
            gold.font = [UIFont fontWithName:@"CooperBlackStd" size:10];
            goldnum.font = [UIFont fontWithName:@"CooperBlackStd" size:10];
            xp.font = [UIFont fontWithName:@"CooperBlackStd" size:10];
            xpnum.font = [UIFont fontWithName:@"CooperBlackStd" size:10];
            score.font = [UIFont fontWithName:@"CooperBlackStd" size:10];
            scorenum.font = [UIFont fontWithName:@"CooperBlackStd" size:10];
            
            
            
            
            
            gold.frame = CGRectMake(10,367,50,20);
         xp.frame = CGRectMake(10,388,50,20);
         score.frame = CGRectMake(10,409,50,20);
        
        goldnum.frame = CGRectMake(50,367,110,20);
        xpnum.frame = CGRectMake(50,388,110,20);
       scorenum.frame = CGRectMake(50,409,110,20);
        }
        
        else
        {
            gold.frame = CGRectMake(10,780,100,30);
            xp.frame = CGRectMake(10,800,100,30);
            score.frame = CGRectMake(10,820,100,30);
            
            goldnum.frame = CGRectMake(90,780,220,30);
            xpnum.frame = CGRectMake(90,800,220,30);
            scorenum.frame = CGRectMake(90,820,220,30);
            
            gold.font = [UIFont fontWithName:@"CooperBlackStd" size:20];
            goldnum.font = [UIFont fontWithName:@"CooperBlackStd" size:20];
            xp.font = [UIFont fontWithName:@"CooperBlackStd" size:20];
            xpnum.font = [UIFont fontWithName:@"CooperBlackStd" size:20];
            score.font = [UIFont fontWithName:@"CooperBlackStd" size:20];
            scorenum.font = [UIFont fontWithName:@"CooperBlackStd" size:20];
        }
        //add labels with rhythm and animation, then the button
        //present the win or loss text with a quick pop-out
       
        
        if(chgval==10)
        {
            
            
            UILabel *feedbacktext = [[UILabel alloc] init];
            
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            {
               feedbacktext.font = [UIFont fontWithName:@"CooperBlackStd" size:15];
                 feedbacktext.frame = CGRectMake(110,145,100,30);
            }
            else
            {
                feedbacktext.font = [UIFont fontWithName:@"CooperBlackStd" size:30];
                feedbacktext.frame = CGRectMake(310,350,250,40);
            }
            
            feedbacktext.numberOfLines = 2;
            feedbacktext.textColor = [UIColor greenColor];
            
            feedbacktext.shadowColor = [UIColor blackColor];
            feedbacktext.backgroundColor = [UIColor clearColor];
            
           
            feedbacktext.textAlignment = NSTextAlignmentCenter;
            feedbacktext.text = @"Free Win";
            
            [self performSelector:@selector(animatetextsizeincrease:) withObject:feedbacktext afterDelay:1];
            

        }
        
        
        [self performSelector:@selector(slideInLabel:) withObject:gold afterDelay:0.5];
        [self performSelector:@selector(slideInLabel:) withObject:xp afterDelay:0.7];
        [self performSelector:@selector(slideInLabel:) withObject:score afterDelay:1];
        [self performSelector:@selector(slideInLabel:) withObject:goldnum afterDelay:0.5];
        [self performSelector:@selector(slideInLabel:) withObject:xpnum afterDelay:0.7];
        [self performSelector:@selector(slideInLabel:) withObject:scorenum afterDelay:1];
        
        self.nextBtn.alpha =1;
        self.nextBtn.userInteractionEnabled=TRUE;
        
        
        //give the data for the player winning & trigger a levelup
        float prog = [sharedData AddGoldXPScoreVote:chgval withXP:chgvalfloat withScore:chgval];
        
                
        if (prog>1)
        {
            //show the level up screen.
            
            [self showalevelup:sharedData.userLevel withGold:sharedData.levelupGoldReward withGems:sharedData.levelupGemReward withHearts:sharedData.levelupHeartReward];
            
        }
        
        
    }
    
    else
    {
        
        //play a voice sound
        //NSString *filestring = [self decideLossSound];
        
        //NSString *shutterplayerPath = [[NSBundle mainBundle] pathForResource:filestring ofType:@"m4a"];
        
        
       // self.reactionSound =  [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSURL alloc] initFileURLWithPath: shutterplayerPath] error:NULL];
        
        self.reactionSound.volume = 4.0;
        
        self.reactionSound.delegate = self;
        
        //[self.reactionSound prepareToPlay];
        
        
       // [reactionSound play];
        
        
        float result = [self.tpvc RemoveHeartTopBar:self];
        
        if(result==0)
        {
        /*
        NSString *myTitle = @"Out Of Hearts";
        NSString *myMessage = @"You are now out of hearts, buy some more!";
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: myTitle
                              message: myMessage
                              delegate: nil
                              cancelButtonTitle: @"OK"
                              otherButtonTitles: nil];
        [alert show];
        */
        }
        
       
        
        lossBtn.alpha = 1;
        
        //[self performSelector:@selector(ShowLossBtn:) withObject:lossBtn afterDelay:0.2];
        
        //[self performSelector:@selector(ShowLossScreen:) withObject:(self) afterDelay:2.0];
        
      //hide the next btn
        self.nextBtn.alpha = 0;
        }
      [super viewDidAppear:YES];
}

-(void) ShowStatsClick:(id) sender
{
    
}

-(void) ShowLossBtn:(UIButton *) btn
{
    [self.view addSubview:btn];
    
}

-(NSString *) decideWinText
{
    NSArray *winstrings = [NSArray arrayWithObjects:@"Great",@"Unstoppable",@"Candylicious",@"You the man", @"You the woman", @"You go girl", @"HOT stuff", @"GET SOME", @"nice pick", @"Our base are belong to YOU", @"Hammer time!", @"THIS GUY...man!", @"Keep it up!", @"BANANAS!" ,nil];
    
    return [winstrings objectAtIndex: arc4random() % [winstrings count]];
    
}

-(NSString *) decideLossText
{
    NSArray *lossstrings = [NSArray arrayWithObjects:@"DUDE?", @"Go Home", @"You Lose", @"Improve", @"Your chi is weak", @"Pick your nose instead", @"for reeeeeal?", @"cmon man!", @"step it up", @"stop twerking", @"You need a Rocky montage", nil];
    
     return [lossstrings objectAtIndex: arc4random() % [lossstrings count]];
    
}

-(NSString *) decideLossSound
{
    //NSArray *lossstrings = [NSArray arrayWithObjects:@"no",@"practice", @"sowellohwaitno",@"youchosepoorly", nil];
    
    //return [lossstrings objectAtIndex: arc4random() % [lossstrings count]];
    return @"fred";
}
-(NSString *) decideWinSound
{
   // NSArray *winstrings = [NSArray arrayWithObjects:@"goodjob",@"nice", @"youchosewisely",@"yourock", nil];
    
    //return [winstrings objectAtIndex: arc4random() % [winstrings count]];
    return @"fred";
}




-(void)addScoreView:(UIView *) myscoreview {
    //put whatever code you want to happen after the 30 seconds
    
     [self.imagearea AddFromTop:myscoreview duration:0.5 option:UIViewAnimationOptionCurveLinear];
    
    
  
    
}


-(PFImageView *) darken2:(PFImageView *) imageview
{
    CALayer *newLayer = [CALayer layer];
    CGRect frame = CGRectMake(0.0, 0.0, imageview.frame.size.width, imageview.frame.size.height);
    newLayer.frame = frame;
    newLayer.backgroundColor = [[UIColor blackColor] CGColor];
    newLayer.opacity = 0.7; //Adjust as needed
    [imageview.layer addSublayer: newLayer];
    
    return imageview;
    
}


-(UIImage *)darkenImage:(UIImage *)image toLevel:(CGFloat)level
{
    // Create a temporary view to act as a darkening layer
    CGRect frame = CGRectMake(0.0, 0.0, image.size.width, image.size.height);
    UIView *tempView = [[UIView alloc] initWithFrame:frame];
    tempView.backgroundColor = [UIColor blackColor];
    tempView.alpha = level;
    
    // Draw the image into a new graphics context
    UIGraphicsBeginImageContext(frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [image drawInRect:frame];
    
    // Flip the context vertically so we can draw the dark layer via a mask that
    // aligns with the image's alpha pixels (Quartz uses flipped coordinates)
    CGContextTranslateCTM(context, 0, frame.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextClipToMask(context, frame, image.CGImage);
    [tempView.layer renderInContext:context];
    
    // Produce a new image from this context
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    UIImage *toReturn = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    UIGraphicsEndImageContext();
    
    return toReturn;
}

-(CGSize)scalesize:(CGSize)imgsize maxWidth:(int) maxWidth maxHeight:(int) maxHeight
{
    
    CGFloat width = imgsize.width;
    
    CGFloat height = imgsize.height;
    
    if (width <= maxWidth && height <= maxHeight)
    {
        return imgsize;
    }
    
    
    CGSize newsize;
    
    
    if (width > maxWidth)
    {
        CGFloat ratio = width/height;
        
        if (ratio > 1)
        {
            newsize.width = maxWidth;
            newsize.height = newsize.width / ratio;
        }
        else
        {
            newsize.width = maxWidth;
            newsize.height = newsize.width/ratio;
        }
    }
    
    //make sure to enforce a maximum height on upload so you dont get fkin nonsense.
    
    CGSize size = newsize;
    
    
    return size;
    
}



-(void)addCellView:(UIView *) mycellview {
    //put whatever code you want to happen after the 30 seconds
    [self.imagearea addSubviewWithZoomInAnimation:mycellview duration:0.2 option:UIViewAnimationOptionCurveEaseIn];
    
    
    
}

-(void)addCellViewTranslation:(UIView *) mycellview {
    //put whatever code you want to happen after the 30 seconds
   
    [self.imagearea AddWithMoveTo:mycellview duration:0.1 option:UIViewAnimationOptionCurveEaseIn];
    
  

    
}

-(void)ShowLossScreen:(id) sender
{
    //remove the button with a bounce.
    UIButton *btn = sender;
    [btn removeWithSinkAnimation:1];
    
    
    
    //init the popup view controller and set its delegate
    UIStoryboard *sb;
    NSString *lstring;
    
     if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
     {
          sb= [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]];
         lstring = @"lossvc";
     }
    else
    {
         sb= [UIStoryboard storyboardWithName:@"MainStoryboard-iPad" bundle:[NSBundle mainBundle]];
         lstring = @"lossvcpad";
    }
   
   lossvc = [sb instantiateViewControllerWithIdentifier:lstring];
     //[self addChildViewController:mylossscreenvc];
    //[mylossscreenvc loadView];
    PlayerData *sharedData = [PlayerData sharedData];
    
    
    
    lossvc.lsdelegate = self;
    
   
    //@Brian note--this caused an error where shared data was nil.  need to inspect why.
    lossvc.LossScreenPlayerScore = sharedData.playerscore;
    
    lossvc.LossScreenPlayerTopScore = sharedData.playerTopScore;
    
    //add function call to delegate to display the loss screen
    
   // CGRect fra = self.view.frame;
    //CGRect fra2 = lossvc.view.frame;
    
    
    [self.view addSubview:lossvc.view];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        lossvc.view.frame = CGRectMake(25,70,250,363);
    }
    else
    {
       lossvc.view.frame = CGRectMake(134,100,500,726);
    }
    
    // [pvc.fullScreenBtn setImage:popularimg forState:UIControlStateNormal];
    
    CGRect endFrame = lossvc.view.frame; // destination for "slide in" animation
    CGRect startFrame = endFrame; // offscreen source
    
    // new view starts off bottom of screen
    startFrame.origin.y += self.view.frame.size.height;
    lossvc.view.frame = startFrame;
    
    // start the slide up animation
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.6];
    lossvc.view.frame = endFrame; // slide in
    [UIView commitAnimations];
   
    }



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)ToNextContentBtn:(id)sender
{
    
    NSLog(@"got clicked homey");
    
    //NSInteger winloss = [WinorFailMode integerValue];
    
    //not sure if needed
    /*
    if (winloss ==0)
    {
    PlayerData *sharedData = [PlayerData sharedData];
    
    sharedData.playerscore = [NSNumber numberWithInt:0];
    
    sharedData.lossCost = [NSNumber numberWithInt:1];
    
    PFUser *user = [PFUser currentUser];
    
    [user setObject:[NSNumber numberWithInt:0] forKey:@"currentScore"];
    
    [user setObject:[NSNumber numberWithInt:1] forKey:@"gemCheatCost"];
        
        [user saveInBackground];
        
    }
     */
    
    //[self.view removeFromSuperview];
    
    [self.vsSummaryDelegate dismissSummaryForNextContent:self];
    
    
}

//delegate method for top bar
-(void) showalevelup:(NSNumber *) lvl withGold:(NSNumber *) gold withGems:(NSNumber *) gems withHearts:(NSNumber *) hearts
{
    //reset the player data progress to 0.
    PlayerData *sharedData = [PlayerData sharedData];
    sharedData.progress = [NSNumber numberWithFloat:0];
    
    
    
    //init the popup view controller and set its delegate
    LevelUpViewController *lvc = [self.storyboard instantiateViewControllerWithIdentifier:@"lvlup"];
    lvc.lvlupdelegate = self;
    lvc.lvluplevel = lvl;
    lvc.lvlupgold = gold;
    lvc.lvlupgems = gems;
    lvc.lvlupheart=hearts;
    
    // [pvc.fullScreenBtn setImage:popularimg forState:UIControlStateNormal];
    
    
    [self addChildViewController:lvc];
    
    
    //add function call to delegate to display a level up
    
     if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
     {
             lvc.view.frame = CGRectMake(25,10,260,300);
     }
    else
    {
            lvc.view.frame = CGRectMake(124,140,520,600);
    }

    
    [self.view addSubview:lvc.view];
    
    
    CGRect endFrame = lvc.view.frame; // destination for "slide in" animation
    CGRect startFrame = endFrame; // offscreen source
    
    // new view starts off bottom of screen
    startFrame.origin.y += self.view.frame.size.height;
    lvc.view.frame = startFrame;
    
    // start the slide up animation
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.6];
    lvc.view.frame = endFrame; // slide in
    [UIView commitAnimations];
    
}

-(void) slideInLabel:(UILabel *) lblslide
{
   // lblslide.backgroundColor =  [UIColor colorWithRed:42.0/255.0 green:247.0/255.0 blue:244.0/255.0 alpha:1];
    //42, 247, 244
    lblslide.backgroundColor = [UIColor whiteColor];
    
    
    lblslide.layer.cornerRadius = 6.0f;
    lblslide.layer.masksToBounds = YES;
    
    
    
    [self.view SlideFromLeft:lblslide duration:0.6 option:UIViewAnimationOptionCurveEaseIn];
    
    
}

//delegate method for level up view delegate
-(void)dismisslevelup:(LevelUpViewController *)controller
{
    //dismiss
    
    [controller.view removeWithZoomOutAnimation:1.0 option:UIViewAnimationOptionCurveEaseOut];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma LossScreenDelegateMethods

- (void)closeButtonClick:(LossScreenViewController *) thiscontroller
{
    //[self dismissViewControllerAnimated:YES completion:nil];
    
    //[self.view removeFromSuperview];
    
    [self.vsSummaryDelegate dismissSummaryForNextContent:self];
}

- (void)continueButtonClick:(LossScreenViewController *) thiscontroller withGems:(NSNumber *) gems
{
    
     // [self dismissViewControllerAnimated:YES completion:nil];
    
   // [self.view removeFromSuperview];
    
    [self.vsSummaryDelegate dismissSummaryForNextContent:self];
    
  
}


@end
