//
//  ContentSelectPerformanceStatsViewController.m
//  funnyBusiness
//
//  Created by Macbook on 2013-11-28.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import "ContentSelectPerformanceStatsViewController.h"

@interface ContentSelectPerformanceStatsViewController ()

@end

@implementation ContentSelectPerformanceStatsViewController
@synthesize selectedparseobj;


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
          self.contentInfluenceLabel.font =  [UIFont fontWithName:@"CooperBlackStd" size:11];
          self.contentPriceLabel.font =  [UIFont fontWithName:@"CooperBlackStd" size:11];
          self.contentPicksLabel.font =  [UIFont fontWithName:@"CooperBlackStd" size:8];
          self.contentPctLabel.font =  [UIFont fontWithName:@"CooperBlackStd" size:8];
          self.voteDaysLeftLabel.font =  [UIFont fontWithName:@"CooperBlackStd" size:8];
          self.headerLabel.font =  [UIFont fontWithName:@"CooperBlackStd" size:12];
      }
    else
    {
        self.contentInfluenceLabel.font =  [UIFont fontWithName:@"CooperBlackStd" size:15];
        self.contentPriceLabel.font =  [UIFont fontWithName:@"CooperBlackStd" size:15];
        self.contentPicksLabel.font =  [UIFont fontWithName:@"CooperBlackStd" size:15];
        self.contentPctLabel.font =  [UIFont fontWithName:@"CooperBlackStd" size:15];
        self.voteDaysLeftLabel.font =  [UIFont fontWithName:@"CooperBlackStd" size:15];
        self.headerLabel.font =  [UIFont fontWithName:@"CooperBlackStd" size:20];
    }
 
    
    self.voteDaysLeftLabel.backgroundColor = [UIColor clearColor];
    
    self.contentPicksLabel.textAlignment = NSTextAlignmentCenter;
    
    
    self.contentInfluenceLabel.text = [[selectedparseobj objectForKey:@"contentValue"] stringValue];
    
    self.contentPriceLabel.text = [[selectedparseobj objectForKey:@"Price"] stringValue];
    
    self.contentPctLabel.text = @"Buy to See";
      self.contentPicksLabel.text = @"Buy to See";
    //self.contentPicksLabel.text = [[selectedparseobj objectForKey:@"Buy To See"] stringValue];
    
    //self.contentPctLabel.text = [[selectedparseobj objectForKey:@"Buy To See"] stringValue];
   
    //PFUser *user = [PFUser currentUser];
  
    
    self.buybtn.userInteractionEnabled = FALSE;
    
    PFQuery *query = [PFQuery queryWithClassName:@"funPhotoObject"];
    [query whereKey:@"objectId" equalTo:selectedparseobj.objectId];
    
   [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        //do code
       self.buybtn.userInteractionEnabled = TRUE;
       BOOL canbuy;
       
        if(!error)
        {
            canbuy=true;
            if(object==nil)
            {
                NSLog(@"nothing");
                canbuy = false;
                
            }
            else
            {
                PFUser *user = [PFUser currentUser];
                
                PFUser *creator = [object objectForKey:@"creator"];
                PFUser *owner = [object objectForKey:@"owner"];
                NSString *status = [object objectForKey:@"status"];
                NSDate *createdDate = object.createdAt;
                
                NSInteger diff = [self getDateDiffDays:createdDate];
                
                if(diff>=10)
                {
                    NSLog(@"content expired");
                    canbuy=false;
                }
                
                NSString *useridstring = user.objectId;
                NSString *owneridstring = owner.objectId;
                NSString *creatoridstring = creator.objectId;
                
                if ([useridstring isEqualToString:creatoridstring])
                {
                    NSLog(@"you created this");
                    canbuy=false;
                    
                }
                if ([useridstring isEqualToString:owneridstring])
                {
                    NSLog(@"you own this");
                    canbuy=false;
                }
                
                if([status isEqual:@"sold"])
                {
                    NSLog(@"not for sale");
                    canbuy=false;
                    
                }
            }
            
            
            if(canbuy)
            {
                UILabel *buybtnlabel = [[UILabel alloc] initWithFrame:self.buybtn.bounds];
                if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
                {
                    buybtnlabel.font = [UIFont fontWithName:@"CooperBlackStd" size:12];
                }
                else
                {
                    buybtnlabel.font = [UIFont fontWithName:@"CooperBlackStd" size:16];
                }
                
                buybtnlabel.textAlignment = NSTextAlignmentCenter;
                
                buybtnlabel.text = @"Buy Now!";
                buybtnlabel.backgroundColor = [UIColor clearColor];
                
                
                
                //[self.buybtn addSubview:buybtnlabel];
            }
            
            else
            {
                UILabel *buybtnlabel = [[UILabel alloc] initWithFrame:self.buybtn.frame];
                
                if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
                {
                    buybtnlabel.font = [UIFont fontWithName:@"CooperBlackStd" size:12];
                }
                else
                {
                    buybtnlabel.font = [UIFont fontWithName:@"CooperBlackStd" size:16];
                }
                
                buybtnlabel.textAlignment = NSTextAlignmentCenter;
                
                buybtnlabel.text = @"Cannot Buy";
                buybtnlabel.backgroundColor = [UIColor clearColor];
                
                [self.view addSubview:buybtnlabel];
                [self.buybtn removeFromSuperview];
                
            }
            
            NSDate *crdate = selectedparseobj.createdAt;
            
            NSInteger dayssince = [self getDateDiffDays:crdate];
            
            NSInteger daysleft = 10-dayssince;
            
            NSString *daysremainingstring = [NSString stringWithFormat:@"%i",daysleft];
            
            NSString *str2 = @" Vote Days Left";
            
            self.voteDaysLeftLabel.text = [daysremainingstring stringByAppendingString:str2];
            

        }
        }];
    
  
    
    //BOOL available = [self AvailableForPurchase];
       
    
}

-(void) viewWillAppear:(BOOL) animated
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger) getDateDiffDays:(NSDate *) lastdate
{
    NSDate *datenow = [NSDate date];
    NSDate *dateB = lastdate;
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit
                                               fromDate:dateB
                                                 toDate:datenow
                                                options:0];
    
    // NSLog(@"Difference in date components: %i/%i/%i", components.day, components.hour, components.second);
    NSInteger thedate;
    
    return components.day;
    
}




-(BOOL) AvailableForPurchase
{
    
    
}




- (IBAction)buyContent:(id)sender
{
    //do buy content..
    // PFObject *petdataobj = selectedPet;
    
    
  
    PFUser *user = [PFUser currentUser];
    
    NSString *useridstring = user.objectId;
    
    NSString *idstring = selectedparseobj.objectId;
    
    MBProgressHUD *HUD;
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    // Set determinate mode
    HUD.mode = MBProgressHUDModeDeterminate;
    HUD.delegate = self;
    HUD.labelText = @"Processing";
    [HUD show:YES];
    
    HUD.progress = (float)25/100;
    //cloud function to test if the user can buy
    [PFCloud callFunctionInBackground:@"buyObjectFromCreatorForInfluence"
                       withParameters:@{@"user":useridstring,@"objID":idstring}
                                block:^(NSString *success, NSError *error) {
                                    if (!error) {
                                        // ratings is 4.5
                                        //NSString *myString = success;
                                       // NSLog(myString);
                                        
                                        //update the top bar to show the new currency.
                                        
                                        PlayerData *sharedData = [PlayerData sharedData];
                                        
                                        NSInteger usergold =  [sharedData.userGold integerValue];
                                        
                                        NSInteger price = [[self.selectedparseobj objectForKey:@"Price"] integerValue];
                                        
                                        NSInteger usernewgold = usergold-price;
                                        
                                        sharedData.userGold = [NSNumber numberWithInt:usernewgold];
                                        
                                        //not done currently...no top bar on current content details.
                                        //[self.mqdelegate updateTopNums];
                                        
                                        [HUD hide:YES];
                                        //play an animation to show you bought it and draw over the button for this content.
                                        //remove button with bounce
                                        
                                         UILabel *boughtlabel = [[UILabel alloc] initWithFrame:self.buybtn.frame];
                                        
                                        
                                        [self.view PopButtonWithBounce:self.buybtn];
                                        
                                        boughtlabel.text = @"You Bought This! Congrats!";
                                        //46 49 146 navy blue for browse title
                                        UIColor *mytbcolor = [UIColor colorWithRed:46/255.0 green:49/255.0 blue:146/255.0 alpha:1];
                                        boughtlabel.textColor = mytbcolor;
                                        
                                        boughtlabel.numberOfLines = 2;
                                        
                                            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
                                            {
                                                    boughtlabel.font= [UIFont fontWithName:@"CooperBlackStd" size:10];
                                                    
                                            }
                                        else
                                        {
                                          boughtlabel.font= [UIFont fontWithName:@"CooperBlackStd" size:18];
                                        }
                                    
                                        
                                        
                                        boughtlabel.alpha=1;
                                        
                                        [self.view addSubview:boughtlabel];
                                        
                                        
                                    }
                                    else
                                    {
                                        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Something Went Wrong!", nil) message:NSLocalizedString(@"Something went wrong, try purchasing a different piece of content", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
                                    }
                                }];

    
}



@end
