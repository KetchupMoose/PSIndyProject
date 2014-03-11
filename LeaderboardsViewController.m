//
//  LeaderboardsViewController.m
//  funnyBusiness
//
//  Created by Macbook on 2013-11-18.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import "LeaderboardsViewController.h"

@interface LeaderboardsViewController ()

@end

@implementation LeaderboardsViewController
@synthesize mytopbar;
@synthesize stage;
@synthesize boardpick;
LeaderboardPFQueryTableViewController *lbtable;


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
    
    TopBarViewController *thetopbar;
    
    thetopbar=[self.storyboard instantiateViewControllerWithIdentifier:@"topbar"];
    
    
    
    [self addChildViewController:thetopbar];
    
    thetopbar.topbardelegate = self;
    
    [self.mytopbar addSubview:thetopbar.view];
    
      if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
      {
          thetopbar.view.frame = CGRectMake(0, 0, 320, 40);
      }
    else
    {
         thetopbar.view.frame = CGRectMake(0, 0, 768, 80);
    }
   
    
    //load marketplace query
    
    lbtable=[self.storyboard instantiateViewControllerWithIdentifier:@"lpqvc"];
    
    [self addChildViewController:lbtable];
    
    [self.stage addSubview:lbtable.tableView];
    
    lbtable.view.frame = self.stage.bounds;
    
    
    //load default query.
    
    PFQuery *query;
    
    
    query = [PFQuery queryWithClassName:@"funPhotoLeaderboard"];
    [query includeKey:@"Player"];
    [query orderByDescending:@"Score"];
    
    lbtable.querytouse = query;
    
   lbtable.leaderMode = [NSNumber numberWithInteger:1];
    
    [lbtable loadObjects];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)badgetypechoice:(id)sender
{
    NSLog(@"%i",boardpick.selectedSegmentIndex);
    
    if(boardpick.selectedSegmentIndex==0)
    {
        //order by creator influence
       lbtable.leaderMode = [NSNumber numberWithInteger:1];
        
        PFQuery *query;
        
        query = [PFQuery queryWithClassName:@"funPhotoLeaderboard"];
        [query includeKey:@"Player"];
        [query orderByDescending:@"Score"];
        
        lbtable.querytouse = query;
        
      
        
        [lbtable refreshControl];
        [lbtable loadObjects];
        
        
    }

    
    
    
    if(boardpick.selectedSegmentIndex==1)
   {
       //order by creator influence
        lbtable.leaderMode = [NSNumber numberWithInteger:2];
       
       PFQuery *query = [PFUser query];
       
       
      
       [query orderByDescending:@"lifetimeSubmitInfluence"];
       
       lbtable.querytouse = query;
       
      
       
       
        [lbtable clear];
       [lbtable loadObjects];
       
       
   }
    
    if(boardpick.selectedSegmentIndex==2)
    {
        //order by creator influence
         lbtable.leaderMode = [NSNumber numberWithInteger:3];
        
        PFQuery *query = [PFUser query];

        
           [query orderByDescending:@"lifetimeChampionInfluence"];
        
        lbtable.querytouse = query;
        
     
        
         [lbtable clear];
        [lbtable loadObjects];
        
        
    }

    
}

-(IBAction)backbtnpress:(id)sender
{
     [self.lvcdelegate dismissLVC:self];
}


@end
