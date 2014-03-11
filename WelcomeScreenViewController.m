//
//  WelcomeScreenViewController.m
//  funnyBusiness
//
//  Created by Macbook on 2013-11-29.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import "WelcomeScreenViewController.h"

@interface WelcomeScreenViewController ()

@end

@implementation WelcomeScreenViewController
@synthesize topBar;
TopBarViewController *tb;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init
{
    self = [super initWithNibName:@"welcomescreen" bundle:nil];
    if (self != nil)
    {
        // Further initialization if needed
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //load the top bar
  // tb=[self.storyboard instantiateViewControllerWithIdentifier:@"topbar"];
    
    //[self addChildViewController:tb];
    
   // [self.topBar addSubview:tb.view];
    
    //tb.view.frame = self.topBar.bounds;
    
    topBar.backgroundColor = [UIColor clearColor];
    
    self.bgImage.frame = self.view.bounds;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
         self.featurefrom.font = [UIFont fontWithName:@"CooperBlackStd" size:12];
    }
    else
    {
       self.featurefrom.font = [UIFont fontWithName:@"CooperBlackStd" size:34];
        self.featurefrom.numberOfLines=2;
        
    }
    self.featurefrom.backgroundColor = [UIColor clearColor];
    
}

-(void) viewDidLayoutSubviews
{
   self.bgImage.frame = self.view.bounds;
    
    //add code to change layout for iphone 5.
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            // iPhone Classic
        }
        if(result.height == 568)
        {
            // iPhone 5
            //give stage extra dimensions
            NSLog(@"iphone 5");
            
            //move stage down 50 pixels on y dimension
            CGRect btnframe = self.startvotebtn.frame;
            
            btnframe.origin.y = 415;
            
            self.startvotebtn.frame = btnframe;
            
            CGRect logoframe = self.logoImage.frame;
            
            logoframe.origin.y=146.5;
            
            self.logoImage.frame = logoframe;
            
            CGRect textframe = self.featurefrom.frame;
            
            textframe.origin.y = 415+50;
            
            self.featurefrom.frame = textframe;
            
            CGRect imgurframe = self.imgurLogo.frame;
            
            imgurframe.origin.y = 415+59;
            
            self.imgurLogo.frame = imgurframe;
            
           // self.stage.frame = CGRectMake(self.stage.frame.origin.x,self.stage.frame.origin.y+50,self.stage.frame.size.width,self.stage.frame.size.height);
            
            
            
        }
    }

    
    
    
    
}

-(void) viewDidAppear:(BOOL)animated
{
    [[UIApplication sharedApplication]  registerForRemoteNotificationTypes:
      UIRemoteNotificationTypeBadge |
     UIRemoteNotificationTypeAlert |
     UIRemoteNotificationTypeSound];
    
    [self.wsdelegate StartLoadingData:self];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)statvote:(id)sender
{
    [self.wsdelegate PlayBtnClick:self];
    
}

-(void) viewDidUnload
{
    [self.topBar removeFromSuperview];
    
}

@end
