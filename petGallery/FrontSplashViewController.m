//
//  FrontSplashViewController.m
//  Pick Something
//
//  Created by Macbook on 2014-01-09.
//  Copyright (c) 2014 bricorp. All rights reserved.
//

#import "FrontSplashViewController.h"
#import "TuteSplashLoginViewController.h"
#import "AppDelegate.h"


@interface FrontSplashViewController ()

@end

@implementation FrontSplashViewController
@synthesize dataObject;
@synthesize index;
@synthesize criticBadgeImage,creatorBadgeImage,championBadgeImage;
@synthesize titleText,screenText;
@synthesize fsplashDelegate;
@synthesize pageControl;
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
    
    
    AppDelegate *myad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if(myad.internet==NO)
    {
        InternetOfflineViewController *iovc = [[InternetOfflineViewController alloc] init];
        
        [self addChildViewController:iovc];
        iovc.iovcdelegate = self;
        
        [self.view addSubview:iovc.view];
    }

    if(index==0)
    {
        self.titleText.text = @"Guess What's Popular";
        self.titleText.font = [UIFont fontWithName:@"CooperBlackStd" size:22];
        self.creatorBadgeImage.alpha = 0.3;
        self.championBadgeImage.alpha = 0.3;
        self.criticBadgeImage.alpha = 1;
        self.screenText.text = @"Challenge your knowledge of Pop Culture & earn gold!";
        self.screenText.font =[UIFont fontWithName:@"CooperBlackStd" size:15];
        
        NSString *crfileName = [[NSBundle mainBundle] pathForResource:@"critic-badge" ofType:@"png"];
        UIImage *crimage = [UIImage imageWithContentsOfFile:crfileName];
        
        [self.criticBadgeImage setImage:crimage];
        
        NSString *crefileName = [[NSBundle mainBundle] pathForResource:@"creator-badge" ofType:@"png"];
        UIImage *creimage = [UIImage imageWithContentsOfFile:crefileName];
        
        [self.creatorBadgeImage setImage:creimage];
        
        NSString *chmfileName = [[NSBundle mainBundle] pathForResource:@"champion-badge" ofType:@"png"];
        UIImage *chmimage = [UIImage imageWithContentsOfFile:chmfileName];
        
        [self.championBadgeImage setImage:chmimage];
        
        NSString *fileName = [[NSBundle mainBundle] pathForResource:@"critictutescreen" ofType:@"png"];
        UIImage *bgimage = [UIImage imageWithContentsOfFile:fileName];
        self.screenshot.image = bgimage;
        
        [self.fsplashDelegate makestuffnotvisible];
        
          if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
          {
                    self.titleText.font = [UIFont fontWithName:@"CooperBlackStd" size:40];
              self.screenText.font =[UIFont fontWithName:@"CooperBlackStd" size:30];
              NSString *fileName = [[NSBundle mainBundle] pathForResource:@"critictutescreen" ofType:@"png"];
              UIImage *bgimage = [UIImage imageWithContentsOfFile:fileName];
              self.screenshot.image = bgimage;
                self.screenText.numberOfLines = 2;
          }
    }
    
    if(index==1)
    {
        NSString *crfileName = [[NSBundle mainBundle] pathForResource:@"critic-badge" ofType:@"png"];
        UIImage *crimage = [UIImage imageWithContentsOfFile:crfileName];
        
        [self.criticBadgeImage setImage:crimage];
        
        NSString *crefileName = [[NSBundle mainBundle] pathForResource:@"creator-badge" ofType:@"png"];
        UIImage *creimage = [UIImage imageWithContentsOfFile:crefileName];
        
        [self.creatorBadgeImage setImage:creimage];
        
        NSString *chmfileName = [[NSBundle mainBundle] pathForResource:@"champion-badge" ofType:@"png"];
        UIImage *chmimage = [UIImage imageWithContentsOfFile:chmfileName];
        
        [self.championBadgeImage setImage:chmimage];
        
        self.titleText.text = @"Show Off Your Talent";
        self.titleText.font = [UIFont fontWithName:@"CooperBlackStd" size:22];
        self.creatorBadgeImage.alpha = 1;
        self.championBadgeImage.alpha = 0.3;
        self.criticBadgeImage.alpha = 0.3;
        self.screenText.text = @"Upload Cool Stuff & Earn Influence Points";
        self.screenText.font =[UIFont fontWithName:@"CooperBlackStd" size:15];
        NSString *fileName = [[NSBundle mainBundle] pathForResource:@"browsetutescreen" ofType:@"png"];
        UIImage *bgimage = [UIImage imageWithContentsOfFile:fileName];
        self.screenshot.image = bgimage;
        
        [self.fsplashDelegate makestuffnotvisible];
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            self.titleText.font = [UIFont fontWithName:@"CooperBlackStd" size:40];
            self.screenText.font =[UIFont fontWithName:@"CooperBlackStd" size:30];
            self.screenText.numberOfLines = 2;
            
            NSString *fileName = [[NSBundle mainBundle] pathForResource:@"ipadbrowsescreen" ofType:@"jpg"];
            UIImage *bgimage = [UIImage imageWithContentsOfFile:fileName];
            self.screenshot.image = bgimage;
            
        }
    }
    
    if(index==2)
    {
        NSString *crfileName = [[NSBundle mainBundle] pathForResource:@"critic-badge" ofType:@"png"];
        UIImage *crimage = [UIImage imageWithContentsOfFile:crfileName];
        
        [self.criticBadgeImage setImage:crimage];
        
        NSString *crefileName = [[NSBundle mainBundle] pathForResource:@"creator-badge" ofType:@"png"];
        UIImage *creimage = [UIImage imageWithContentsOfFile:crefileName];
        
        [self.creatorBadgeImage setImage:creimage];
        
        NSString *chmfileName = [[NSBundle mainBundle] pathForResource:@"champion-badge" ofType:@"png"];
        UIImage *chmimage = [UIImage imageWithContentsOfFile:chmfileName];
        
        [self.championBadgeImage setImage:chmimage];
        
        self.titleText.text = @"Buy The Best";
        self.titleText.font = [UIFont fontWithName:@"CooperBlackStd" size:22];
        self.creatorBadgeImage.alpha = 0.3;
        self.championBadgeImage.alpha = 1;
        self.criticBadgeImage.alpha = 0.3;
        self.screenText.text = @"Buy Cool Stuff, Support Others, Earn Influence Points!";
        self.screenText.font =[UIFont fontWithName:@"CooperBlackStd" size:15];
        NSString *fileName = [[NSBundle mainBundle] pathForResource:@"buytutescreen" ofType:@"png"];
        UIImage *bgimage = [UIImage imageWithContentsOfFile:fileName];
        self.screenshot.image = bgimage;
          [self.fsplashDelegate makestuffnotvisible];
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            self.titleText.font = [UIFont fontWithName:@"CooperBlackStd" size:40];
            self.screenText.font =[UIFont fontWithName:@"CooperBlackStd" size:30];
            NSString *fileName = [[NSBundle mainBundle] pathForResource:@"ipadbrowsescreen" ofType:@"jpg"];
            UIImage *bgimage = [UIImage imageWithContentsOfFile:fileName];
            self.screenshot.image = bgimage;
              self.screenText.numberOfLines = 2;
        }
    }
    
    if(index==3)
    {
        //self.view.alpha = 0;
        self.view.userInteractionEnabled = NO;
        
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewDidLayoutSubviews
{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            // iPhone Classic
            
            /*
            CGRect bdgframe = self.criticBadgeImage.frame;
            bdgframe.origin.y = bdgframe.origin.y+23;
            self.criticBadgeImage.frame = bdgframe;
            
            CGRect cbdgframe = self.championBadgeImage.frame;
            cbdgframe.origin.y = cbdgframe.origin.y+23;
            self.championBadgeImage.frame = cbdgframe;
            
            CGRect rbdgframe = self.creatorBadgeImage.frame;
            rbdgframe.origin.y = rbdgframe.origin.y+23;
            self.creatorBadgeImage.frame = rbdgframe;
            */
            
            
            
        }
        if(result.height == 568)
        {
            // iPhone 5
            //give stage extra dimensions
            NSLog(@"iphone 5");
            
            //move stage down 50 pixels on y dimension
            
            CGRect btnframe = self.startPlayingButton.frame;
            btnframe.origin.y = btnframe.origin.y+50;
            
            self.startPlayingButton.frame = btnframe;
            
            
            CGRect txtframe = self.screenText.frame;
            txtframe.origin.y = txtframe.origin.y+10;
            self.screenText.frame = txtframe;
            
            
        }
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    

    
    if(index==3)
    {
       // self.view.alpha = 0;
        
        //make login stuff visible
        //[self.fsplashDelegate makestuffvisible];
        
    }
    
   
    
	// Do any additional setup after loading the view.
}

-(IBAction) startPlayingClick:(id) sender
{
    [self.fsplashDelegate gotologin];
    
}

-(void)DismissIOVC:(InternetOfflineViewController *) iovc
{
    [iovc.view removeWithZoomOutAnimation:1 option:UIViewAnimationOptionCurveEaseIn];
    
    
}


@end
