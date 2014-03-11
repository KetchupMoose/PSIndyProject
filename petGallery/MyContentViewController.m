//
//  MyContentViewController.m
//  funnyBusiness
//
//  Created by Macbook on 2013-11-02.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import "MyContentViewController.h"



@interface MyContentViewController ()

@end

@implementation MyContentViewController
@synthesize topbararea;
@synthesize contenttableview;
@synthesize mycontentdelegate;
@synthesize DisplayMode;
TopBarViewController *topbar;
@synthesize collectsRemainLabel;
@synthesize timerLabel;
@synthesize moreInLabel;
MyPetsQueryTableViewController *mypets;

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
    
     if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
     {
         collectsRemainLabel.font = [UIFont fontWithName:@"CooperBlackStd" size:12];
         
         timerLabel.font = [UIFont fontWithName:@"CooperBlackStd" size:15];
         moreInLabel.font = [UIFont fontWithName:@"CooperBlackStd" size:9];
     }
    else
    {
        collectsRemainLabel.font = [UIFont fontWithName:@"CooperBlackStd" size:20];
        
        timerLabel.font = [UIFont fontWithName:@"CooperBlackStd" size:18];
        moreInLabel.font = [UIFont fontWithName:@"CooperBlackStd" size:11];
    }
   
    
    collectsRemainLabel.backgroundColor = [UIColor clearColor];
    timerLabel.backgroundColor = [UIColor clearColor];
    moreInLabel.backgroundColor = [UIColor clearColor];

    
    
    //load top bar
    //code to add top bar to container
    
    
    topbar=[self.storyboard instantiateViewControllerWithIdentifier:@"topbar"];
    
    
    
    [self addChildViewController:topbar];
    
    self.topbararea.backgroundColor = [UIColor clearColor];
    
    
    
    [self.topbararea addSubview:topbar.view];
    
       if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
       {
           topbar.view.frame = CGRectMake(0, 0, 320, 40);
       }
    else
    {
         topbar.view.frame = CGRectMake(0, 0, 768, 80);
    }
  
   
    if([self.DisplayMode isEqualToString:@"submits"])
    {
        NSString *fileName = [[NSBundle mainBundle] pathForResource:@"my-submissions-background" ofType:@"png"];
        UIImage *bgimage = [UIImage imageWithContentsOfFile:fileName];
        
        UIImage *b = [self imageWithImage:bgimage scaledToSize:self.view.bounds.size];
        
        self.view.backgroundColor = [UIColor colorWithPatternImage:b];
    }
    else
    {
        NSString *fileName = [[NSBundle mainBundle] pathForResource:@"mpbackground" ofType:@"png"];
        UIImage *bgimage = [UIImage imageWithContentsOfFile:fileName];
        
        UIImage *b = [self imageWithImage:bgimage scaledToSize:self.view.bounds.size];
        
        self.view.backgroundColor = [UIColor colorWithPatternImage:b];
    }
   
    //load marketplace query
    
    mypets=[self.storyboard instantiateViewControllerWithIdentifier:@"mycontenttable"];
    mypets.mypqtdelegate = self;
    [self addChildViewController:mypets];
    
    mypets.displayMode = self.DisplayMode;
    
    
    [self.contenttableview addSubview:mypets.tableView];
    
    self.contenttableview.backgroundColor = [UIColor clearColor];
    
    mypets.view.frame = self.contenttableview.bounds;
    
  
}

-(void) viewDidAppear:(BOOL)animated
{
    //get the collect time remaining and use to instantiate label
    [self setLabelCollects];
    
    //[mypets loadObjects];
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


-(void) setLabelCollects
{
    PlayerData *sharedData = [PlayerData sharedData];
    
    
    NSNumber *collects = sharedData.collectsRemaining;
    
    NSInteger collectsint = [collects intValue];
    
    if(collectsint==10)
    {
        collectsRemainLabel.text = @"10 Collects Remaining";
        moreInLabel.text = @"Refresh Time";
        timerLabel.text = @"24h";
    }
    else
    {
        //get time remaining.
        NSDate *mylastCollectDate = sharedData.lastCollectDate;
        
        NSString *first = [NSString stringWithFormat:@"%i",collectsint];
        NSString *second = @" Collects Remaining";
        collectsRemainLabel.text = [first stringByAppendingString:second];
        
        NSInteger hourssince = [self getDateDiffHours:mylastCollectDate];
        
        NSInteger hoursremain = 24-hourssince;
        
        NSString *hours = [NSString stringWithFormat:@"%i",hoursremain];
        
        timerLabel.text = [hours stringByAppendingString:@"h"];
        
        moreInLabel.text = @"More In";
        
    }
   
    //rgb = 46, 49, 146
    timerLabel.textColor = [UIColor colorWithRed:(46/255.0) green:(49/255.0) blue:(146/255.0) alpha:1];

    moreInLabel.textColor =[UIColor colorWithRed:(46/255.0) green:(49/255.0) blue:(146/255.0) alpha:1];
    
    collectsRemainLabel.textColor =[UIColor colorWithRed:(46/255.0) green:(49/255.0) blue:(146/255.0) alpha:1];
    
    
}

-(NSInteger) getDateDiffHours:(NSDate *) lastdate
{
    NSDate *datenow = [NSDate date];
    NSDate *dateB = lastdate;
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit
                                               fromDate:dateB
                                                 toDate:datenow
                                                options:0];
    
    NSLog(@"Difference in date components: %i/%i/%i", components.day, components.hour, components.second);
    NSInteger thedate;
    
    NSInteger hours = components.hour + components.day*24;
    
    return hours;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backbtnpress:
(UIButton*)btn
{
    //top bar just sent this function.
    NSLog(@"form got the back button");
    
    [self.mycontentdelegate dismissMyContentScreen:self];
    
}

-(IBAction) back:(id) sender

{
     [self.mycontentdelegate dismissMyContentScreen:self];
}

//delegate protocol of mypqt
-(void) ValueChange
{
    [topbar setLabels];
    [self setLabelCollects];
    
}

-(void) DoCollect
{
    //save last collected date to user
    
    
    //save contentcollects remaining to user.
    
    // if diff between cur date and last collected date are >1, refresh back to 10.
    
    
}



@end
