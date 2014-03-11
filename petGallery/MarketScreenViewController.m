//
//  MarketScreenViewController.m
//  funnyBusiness
//
//  Created by Macbook on 2013-11-01.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import "MarketScreenViewController.h"

#import "MarketplaceQueryTableViewController.h"
#import <parse/parse.h>


@interface MarketScreenViewController ()

@end

@implementation MarketScreenViewController
MarketplaceQueryTableViewController *mqt;
TopBarViewController *topbar;
@synthesize mscreendelegate;

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
    NSLog(@"the marketscreen loaded");
    //load top bar
    //code to add top bar to container
    
        topbar=[self.storyboard instantiateViewControllerWithIdentifier:@"topbar"];
    
    [self addChildViewController:topbar];
    
         topbar.topbardelegate = self;
    
    [self.topbararea addSubview:topbar.view];
    
       if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
       {
             topbar.view.frame = CGRectMake(0, 0, 320, 40);
       }
    else
    {
         topbar.view.frame = CGRectMake(0, 0, 768, 80);
    }
  
    
    NSString *fileName = [[NSBundle mainBundle] pathForResource:@"marketplacebackground" ofType:@"png"];
    UIImage *bgimage = [UIImage imageWithContentsOfFile:fileName];
    
    UIImage *b = [self imageWithImage:bgimage scaledToSize:self.view.bounds.size];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:b];
    
    
    self.topbararea.backgroundColor = [UIColor clearColor];
    
    //load marketplace query
    
        mqt=[self.storyboard instantiateViewControllerWithIdentifier:@"markettable"];
    
    mqt.mqdelegate = self;
    
    [self addChildViewController:mqt];
    
    [self.marketarea addSubview:mqt.tableView];
    
    mqt.view.frame = self.marketarea.bounds;
    self.marketarea.backgroundColor = [UIColor clearColor];
    
    //get only content from 10 days ago.
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:[[NSDate alloc] init]];
    
    [components setHour:-[components hour]];
    [components setMinute:-[components minute]];
    [components setSecond:-[components second]];
    NSDate *today = [cal dateByAddingComponents:components toDate:[[NSDate alloc] init] options:0]; //This variable should now be pointing at a date object that is the start of today (midnight);
    
    // [components setHour:-24];
    // [components setMinute:0];
    //[components setSecond:0];
    // NSDate *yesterday = [cal dateByAddingComponents:components toDate: today options:0];
    
    components = [cal components:NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:[[NSDate alloc] init]];
    
    //[components setDay:([components day] - ([components weekday] - 1))];
    //NSDate *thisWeek  = [cal dateFromComponents:components];
    
    //[components setDay:([components day] - 7)];
    //NSDate *lastWeek  = [cal dateFromComponents:components];
    
    [components setDay:([components day] - 10)];
    NSDate *tendaysago  = [cal dateFromComponents:components];
    
    
    [components setDay:([components day] - ([components day] -1))];
    NSDate *thisMonth = [cal dateFromComponents:components];
    
    [components setMonth:([components month] - 1)];
    NSDate *lastMonth = [cal dateFromComponents:components];
    
    //load default query.
    
        PFQuery *query;
    
    PFUser *user = [PFUser currentUser];
    query = [PFQuery queryWithClassName:@"funPhotoObject"];
    [query whereKey:@"status" equalTo:@"forSale"];
    [query whereKey:@"creator" notEqualTo:user];
    [query whereKey:@"owner" notEqualTo:user];
    [query includeKey:@"creator"];
    [query orderByDescending:@"createdAt"];
       [query whereKey:@"createdAt" greaterThan:tendaysago];
    
    mqt.querytouse = query;
    
    [mqt loadObjects];
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sortIndexChange:(id)sender {
    
    NSInteger barnum ;
    
    barnum= self.sortSegmentControl.selectedSegmentIndex;
    NSLog(@"retrieved bar number: %i", barnum);
    
    
    //get only content from 10 days ago.
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:[[NSDate alloc] init]];
    
    [components setHour:-[components hour]];
    [components setMinute:-[components minute]];
    [components setSecond:-[components second]];
    NSDate *today = [cal dateByAddingComponents:components toDate:[[NSDate alloc] init] options:0]; //This variable should now be pointing at a date object that is the start of today (midnight);
    
    // [components setHour:-24];
    // [components setMinute:0];
    //[components setSecond:0];
    // NSDate *yesterday = [cal dateByAddingComponents:components toDate: today options:0];
    
    components = [cal components:NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:[[NSDate alloc] init]];
    
    //[components setDay:([components day] - ([components weekday] - 1))];
    //NSDate *thisWeek  = [cal dateFromComponents:components];
    
    //[components setDay:([components day] - 7)];
    //NSDate *lastWeek  = [cal dateFromComponents:components];
    
    [components setDay:([components day] - 10)];
    NSDate *tendaysago  = [cal dateFromComponents:components];
    
    
    [components setDay:([components day] - ([components day] -1))];
    NSDate *thisMonth = [cal dateFromComponents:components];
    
    [components setMonth:([components month] - 1)];
    NSDate *lastMonth = [cal dateFromComponents:components];
    
    // NSLog(@"today=%@",today);
    //NSLog(@"yesterday=%@",yesterday);
    // NSLog(@"thisWeek=%@",thisWeek);
    //NSLog(@"lastWeek=%@",lastWeek);
    NSLog(@"tendaysago=%@",tendaysago);
    
    NSLog(@"thisMonth=%@",thisMonth);
    NSLog(@"lastMonth=%@",lastMonth);
    
    
    PFQuery *query;
    
    if(barnum ==0)
    {
        
        //query 0
        
        PFUser *user = [PFUser currentUser];
        query = [PFQuery queryWithClassName:@"funPhotoObject"];
        
         [query whereKey:@"status" equalTo:@"forSale"];
        [query whereKey:@"creator" notEqualTo:user];
        [query whereKey:@"owner" notEqualTo:user];
        [query includeKey:@"creator"];
     [query orderByDescending:@"createdAt"];
        [query whereKey:@"createdAt" greaterThan:tendaysago];
        
        
    }
    if(barnum==1)
    {
        
        PFUser *user = [PFUser currentUser];
        query = [PFQuery queryWithClassName:@"funPhotoObject"];
      
         [query whereKey:@"status" equalTo:@"forSale"];
        [query whereKey:@"creator" notEqualTo:user];
        [query whereKey:@"owner" notEqualTo:user];
        [query includeKey:@"creator"];
        [query orderByAscending:@"Price"];
         [query whereKey:@"createdAt" greaterThan:tendaysago];
        
        
    }
    if(barnum ==2)
    {
        
        //query for best content...most expensive for now
        
        PFUser *user = [PFUser currentUser];
       query = [PFQuery queryWithClassName:@"funPhotoObject"];
     
         [query whereKey:@"status" equalTo:@"forSale"];
        [query whereKey:@"creator" notEqualTo:user];
        [query whereKey:@"owner" notEqualTo:user];
        [query includeKey:@"creator"];
         [query orderByDescending:@"contentValue,createdAt"];
         [query whereKey:@"createdAt" greaterThan:tendaysago];
        
    }
    
    mqt.querytouse = query;
    [mqt clear];
    
    [mqt loadObjects];
    
 
}

- (void)backbtnpress
{
    //top bar just sent this function.
    NSLog(@"form got the back button");
    
    [self.mscreendelegate dismissMarketScreen:self];
    
}

-(void) updateTopNums
{
    [topbar setLabels];
    
}


@end
