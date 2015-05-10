//
//  LossScreenViewController.m
//  funnyBusiness
//
//  Created by Macbook on 2013-11-13.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import "LossScreenViewController.h"
#import <Parse/Parse.h>
#import "UIImageView+WebCache.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import <ParseFacebookUtils/PFFacebookUtils.h>
@interface LossScreenViewController ()

@end

@implementation LossScreenViewController

@synthesize friendName1;
@synthesize friendName2;
@synthesize friendName3;
@synthesize friendScore1;
@synthesize friendScore2;
@synthesize friendScore3;
@synthesize YouLoseLabel;
@synthesize ScoreTitleLabel;
@synthesize ScoreLabel;
@synthesize BestScoreTitleLabel;
@synthesize BestScoreLabel;
@synthesize LeaderboardLabel;
@synthesize friendRank1;
@synthesize friendRank2;
@synthesize friendRank3;


@synthesize myallBtn;
@synthesize myFriendsBtn;
@synthesize myContinueBtn;
@synthesize myCloseBtn;

@synthesize friendImage1;
@synthesize friendImage2;
@synthesize friendImage3;

@synthesize bgImageView;

@synthesize gemsForContinue;
@synthesize LossScreenPlayerScore;
@synthesize LossScreenPlayerTopScore;
@synthesize lsdelegate;

NSNumber * rank1score;
NSNumber * rank2score;
NSNumber * rank3score;

NSNumber * rank1;
NSNumber * rank2;
NSNumber * rank3;

MBProgressHUD *HUD;


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
    
	// Do any additional setup after loading the view.
    
    //self.view.backgroundColor = [UIColor clearColor];
    
         if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
         {
               YouLoseLabel.font =[UIFont fontWithName:@"CooperBlackStd" size:16];
             ScoreTitleLabel.font = [UIFont fontWithName:@"CooperBlackStd" size:10];
             BestScoreTitleLabel.font = [UIFont fontWithName:@"CooperBlackStd" size:10];
             ScoreLabel.font = [UIFont fontWithName:@"CooperBlackStd" size:10];
             BestScoreLabel.font = [UIFont fontWithName:@"CooperBlackStd" size:10];
              LeaderboardLabel.font = [UIFont fontWithName:@"CooperBlackStd" size:12];
             friendName1.font =[UIFont fontWithName:@"Copperplate-Bold" size:7];
             friendName2.font =[UIFont fontWithName:@"Copperplate-Bold" size:7];
             friendName3.font =[UIFont fontWithName:@"Copperplate-Bold" size:7];
             
             friendScore1.font =[UIFont fontWithName:@"Copperplate" size:10];
             friendScore2.font =[UIFont fontWithName:@"Copperplate" size:10];
             friendScore3.font =[UIFont fontWithName:@"Copperplate" size:10];
             
             friendRank1.font =[UIFont fontWithName:@"CooperBlackStd" size:12];
             friendRank2.font =[UIFont fontWithName:@"CooperBlackStd" size:12];
             friendRank3.font =[UIFont fontWithName:@"CooperBlackStd" size:12];
         }
    else
    {
        YouLoseLabel.font =[UIFont fontWithName:@"CooperBlackStd" size:40];
        ScoreTitleLabel.font = [UIFont fontWithName:@"CooperBlackStd" size:24];
        BestScoreTitleLabel.font = [UIFont fontWithName:@"CooperBlackStd" size:24];
        ScoreLabel.font = [UIFont fontWithName:@"CooperBlackStd" size:40];
        BestScoreLabel.font = [UIFont fontWithName:@"CooperBlackStd" size:40];
        LeaderboardLabel.font = [UIFont fontWithName:@"CooperBlackStd" size:25];
        friendName1.font =[UIFont fontWithName:@"Copperplate-Bold" size:12];
        friendName2.font =[UIFont fontWithName:@"Copperplate-Bold" size:12];
        friendName3.font =[UIFont fontWithName:@"Copperplate-Bold" size:12];
        
        friendScore1.font =[UIFont fontWithName:@"Copperplate" size:20];
        friendScore2.font =[UIFont fontWithName:@"Copperplate" size:20];
        friendScore3.font =[UIFont fontWithName:@"Copperplate" size:20];
        
        friendRank1.font =[UIFont fontWithName:@"CooperBlackStd" size:20];
        friendRank2.font =[UIFont fontWithName:@"CooperBlackStd" size:20];
        friendRank3.font =[UIFont fontWithName:@"CooperBlackStd" size:20];
    }
  
     YouLoseLabel.textColor = [UIColor whiteColor];
    
    
    ScoreTitleLabel.textColor = [UIColor whiteColor];
    BestScoreTitleLabel.textColor = [UIColor whiteColor];
    
    ScoreLabel.textColor = [UIColor colorWithRed:65/255.f green:186/255.f blue:236/255.f alpha:1];
    //score color rgb(65,186,236)
        BestScoreLabel.textColor = [UIColor colorWithRed:65/255.f green:186/255.f blue:236/255.f alpha:1];
        
   
    
    
    //leaderboard text rgb(238,42,123)
   
    LeaderboardLabel.textColor = [UIColor colorWithRed:238/255.f green:42/255.f blue:123/255.f alpha:1];
    
    
        /*
     2013-11-13 12:01:26.319 funnyBusiness[668:a0b] Copperplate
    2013-11-13 12:01:26.327 funnyBusiness[668:a0b]   Copperplate
    2013-11-13 12:01:26.328 funnyBusiness[668:a0b]   Copperplate-Light
    2013-11-13 12:01:26.329 funnyBusiness[668:a0b]   Copperplate-Bold
    */
    
   
    
    //153,202,60)
    
    friendRank1.textColor = [UIColor colorWithRed:153/255.f green:202/255.f blue:60/255.f alpha:1];
     friendRank2.textColor = [UIColor colorWithRed:153/255.f green:202/255.f blue:60/255.f alpha:1];
     friendRank3.textColor = [UIColor colorWithRed:153/255.f green:202/255.f blue:60/255.f alpha:1];
    
    friendRank1.shadowColor = [UIColor whiteColor];
    friendRank1.shadowOffset = CGSizeMake(1,1);
    friendRank2.shadowColor = [UIColor whiteColor];
    friendRank2.shadowOffset = CGSizeMake(1,1);
    friendRank3.shadowColor = [UIColor whiteColor];
    friendRank3.shadowOffset = CGSizeMake(1,1);
    
    friendName1.backgroundColor = [UIColor clearColor];
      friendName2.backgroundColor = [UIColor clearColor];
      friendName3.backgroundColor = [UIColor clearColor];
    
    friendName3.text = @"You!";
    
    
    friendScore1.backgroundColor = [UIColor clearColor];
    friendScore2.backgroundColor = [UIColor clearColor];
    friendScore3.backgroundColor = [UIColor clearColor];
    
    LeaderboardLabel.backgroundColor = [UIColor clearColor];
    BestScoreLabel.backgroundColor = [UIColor clearColor];
    BestScoreTitleLabel.backgroundColor = [UIColor clearColor];
    ScoreLabel.backgroundColor = [UIColor clearColor];
    ScoreTitleLabel.backgroundColor = [UIColor clearColor];
    
    YouLoseLabel.backgroundColor = [UIColor clearColor];
    
    
    ScoreLabel.text = [LossScreenPlayerScore stringValue];
    
    friendScore3.text = [LossScreenPlayerTopScore stringValue];
    
    BestScoreLabel.text = [LossScreenPlayerTopScore stringValue];
    
    
    UILabel *btnlabel1 = [[UILabel alloc] init];
    UILabel *btnlabel2 = [[UILabel alloc] init];
    
    
    btnlabel1.text = @"Save Score";
    PlayerData *sharedData = [PlayerData sharedData];
    

    btnlabel2.text =   [sharedData.lossCost stringValue];
    
    btnlabel1.textColor = [UIColor whiteColor];
    btnlabel2.textColor = [UIColor whiteColor];
    
    
    
     NSString *fileName = [[NSBundle mainBundle] pathForResource:@"lossscreendiamond" ofType:@"png"];
    UIImage *btndiamondimg = [[UIImage alloc] initWithContentsOfFile:fileName];
    
    UIImageView *btnimgview = [[UIImageView alloc] init];
    
    btnimgview.image = btndiamondimg;
    
    
    btnimgview.backgroundColor = [UIColor clearColor];
    
    btnlabel1.backgroundColor = [UIColor clearColor];
        btnlabel2.backgroundColor = [UIColor clearColor];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        btnlabel1.frame = CGRectMake(10,5,100,30);
        btnimgview.frame = CGRectMake(110,5,25,25);
        btnlabel2.frame = CGRectMake(160,7,20,30);
        btnlabel1.font = [UIFont fontWithName:@"CooperBlackStd" size:14];
        btnlabel2.font = [UIFont fontWithName:@"CooperBlackStd" size:14];
    }
    else
    {
        btnlabel1.frame = CGRectMake(90,20,140,30);
        btnimgview.frame = CGRectMake(210,10,50,50);
        btnlabel2.frame = CGRectMake(339,20,50,30);
       
        
        btnlabel1.font = [UIFont fontWithName:@"CooperBlackStd" size:20];
        btnlabel2.font = [UIFont fontWithName:@"CooperBlackStd" size:20];
        
    }
    
    /*
    UILabel *closebtnlabel = [[UILabel alloc] initWithFrame:CGRectMake(0,5,self.myCloseBtn.frame.size.width,30)];
    closebtnlabel.font =[UIFont fontWithName:@"CooperBlackStd" size:14];
    
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            closebtnlabel.frame = CGRectMake(0,20,self.myCloseBtn.frame.size.width,40);
           closebtnlabel.font =[UIFont fontWithName:@"CooperBlackStd" size:20];
        }
    
    closebtnlabel.backgroundColor = [UIColor clearColor];
    closebtnlabel.textColor =[UIColor whiteColor];
    
    closebtnlabel.text = @"Start Over";
    closebtnlabel.textAlignment = NSTextAlignmentCenter;
    
    */
    
    UIColor *borderColor = [UIColor colorWithRed:65/255.f green:186/255.f blue:236/255.f alpha:1.0];
    
    PFUser *user = [PFUser currentUser];
    
    PFFile *playerimg = [user objectForKey:@"profilePictureSmall"];
    NSString *filesil = [[NSBundle mainBundle] pathForResource:@"profile-sillhouette" ofType:@"png"];
    UIImage *profplaceholder = [UIImage imageWithContentsOfFile:filesil];
    if(playerimg ==nil)
    {
       
        [friendImage3 setImage:profplaceholder];

    }
    else
    {
        
        UIActivityIndicatorViewStyle activityStyle = UIActivityIndicatorViewStyleGray;
        
        [friendImage3 setImageWithURL:[NSURL URLWithString:playerimg.url] placeholderImage:profplaceholder usingActivityIndicatorStyle:activityStyle];

    }
    
    
    [friendImage3.layer setBorderColor:borderColor.CGColor];
    [friendImage3.layer setBorderWidth:3.0];
    friendImage3.layer.cornerRadius = 5.0;
    
    friendImage3.layer.masksToBounds = YES;
    
    
    self.view.backgroundColor = [UIColor clearColor];
    
    
    //[self.myContinueBtn addSubview:btnlabel1];
    [self.myContinueBtn addSubview:btnlabel2];
    //[self.myContinueBtn addSubview:btnimgview];
    
    //[self.myCloseBtn addSubview:closebtnlabel];
    
    [self getPlayerRank:LossScreenPlayerTopScore];
    
    
    [self resetPlayerScore];
    
    AppDelegate *myad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if(myad.internet==NO)
    {
        InternetOfflineViewController *iovc = [[InternetOfflineViewController alloc] init];
        
        [self addChildViewController:iovc];
        
        [self.view addSubview:iovc.view];
    }

    [super viewDidLoad];
        
}
- (void)getPlayerRank:(NSNumber *) score
{
    PFUser *user = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"funPhotoLeaderboard"];
    [query whereKey:@"Score" greaterThan:score];
    //NSLog(@"Username: %@", user.objectId);
    
    [query countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
       
        if(!error)
        {
            rank3 = [NSNumber numberWithInt:number +1];
            
        
            int r2 = number-1 +1;
            int r1 = number-2+1;
            if (number>=2)
            {
             
                rank2 = [NSNumber numberWithInt:r2];
                rank1 = [NSNumber numberWithInt:r1];
                
            }
            else
            if(number==1)
            {
                rank2= [NSNumber numberWithInt:r2];
            }
            
            //set labels
            self.friendRank1.text = [rank1 stringValue];
            self.friendRank2.text = [rank2 stringValue];
            self.friendRank3.text = [rank3 stringValue];
            
            //get the scores of these objects
            
            
            
            [self getAdjacentPlayers:score];
            
            
        }
        else
        {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    
}
-(void) resetPlayerScore
{
    //this function immediately sets the player score on the server to 0.  It can be changed to hold their previous score if they end up paying the continue btn.
    PFUser *user = [PFUser currentUser];
    [user setObject:[NSNumber numberWithInt:0] forKey:@"currentScore"];
    
    PlayerData *sharedData = [PlayerData sharedData];
    
     sharedData.playerscore = [NSNumber numberWithInt:0];
    
    [user saveInBackground];
    
    
}

-(void)getAdjacentPlayers:(NSNumber *) score
{
    //change this to be based on the loss screen player top score
    
    
    PFQuery *query = [PFQuery queryWithClassName:@"funPhotoLeaderboard"];
    [query whereKey:@"Score" greaterThan:score];
    [query orderByAscending:@"Score"];
    [query includeKey:@"Player"];
     query.limit = 2;
    
    //65, 186, 236
    
    UIColor *borderColor = [UIColor colorWithRed:65/255.f green:186/255.f blue:236/255.f alpha:1.0];
    
    
    
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if (!error) {
             // The find succeeded.
             int i = 1;
             for (PFObject *myobj in objects)
             {
                 PFObject *userobj = [myobj objectForKey:@"Player"];
                 
                 if (i==1)
                 {
                     rank2score = [myobj objectForKey:@"Score"];
                     friendScore2.text = [rank2score stringValue];
                     
                     PFFile *playerimg = [userobj objectForKey:@"profilePictureSmall"];
                    
                     NSString *fileName = [[NSBundle mainBundle] pathForResource:@"profile-sillhouette" ofType:@"png"];
                     UIImage *profplaceholder = [UIImage imageWithContentsOfFile:fileName];
                     if(playerimg ==nil)
                     {
                         
                         [friendImage2 setImage:profplaceholder];
                         
                     }
                     else
                     {
                         
                         UIActivityIndicatorViewStyle activityStyle = UIActivityIndicatorViewStyleGray;
                         
                         [friendImage2 setImageWithURL:[NSURL URLWithString:playerimg.url] placeholderImage:profplaceholder usingActivityIndicatorStyle:activityStyle];
                         
                     }
                    
                    
                     [friendImage2.layer setBorderColor:borderColor.CGColor];
                     [friendImage2.layer setBorderWidth:3.0];
                     friendImage2.layer.cornerRadius = 5.0;
                       friendImage2.layer.masksToBounds = YES;
                     
                     NSString *friendstring =[userobj objectForKey:@"displayName"];
                      if (friendstring == nil) {
                          
                          friendName2.text = [userobj objectForKey:@"username"];
                      }
                     else
                     {
                         friendName2.text = friendstring;
                     }
                    

                     
                 }
                 if (i==2)
                 {
                     rank1score = [myobj objectForKey:@"Score"];
                     friendScore1.text = [rank1score stringValue];
                     
                     PFFile *playerimg = [userobj objectForKey:@"profilePictureSmall"];
                     
                     
                     NSString *fileName = [[NSBundle mainBundle] pathForResource:@"profile-sillhouette" ofType:@"png"];
                     UIImage *profplaceholder = [UIImage imageWithContentsOfFile:fileName];
                  
                     
                     if(playerimg ==nil)
                     {
                         
                         [friendImage1 setImage:profplaceholder];
                         
                     }
                     else
                     {
                         
                         UIActivityIndicatorViewStyle activityStyle = UIActivityIndicatorViewStyleGray;
                         
                         [friendImage1 setImageWithURL:[NSURL URLWithString:playerimg.url] placeholderImage:profplaceholder usingActivityIndicatorStyle:activityStyle];
                         
                     }

                     
                     
                     
                     
                     [friendImage1.layer setBorderColor:borderColor.CGColor];
                     [friendImage1.layer setBorderWidth:3.0];
                      friendImage1.layer.cornerRadius = 5.0;
                       friendImage1.layer.masksToBounds = YES;
                     
                     NSString *friendstring =[userobj objectForKey:@"displayName"];
                     if (friendstring == nil) {
                         
                         friendName1.text = [userobj objectForKey:@"username"];
                     }
                     else
                     {
                         friendName1.text = friendstring;
                     }
                     
                 }
                 i=i+1;
                 
             }
             
         } else {
             // Log details of the failure
             NSLog(@"Error: %@ %@", error, [error userInfo]);
         }
     }];

    
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)ContinueBtn:(id)sender
{
    //get number of gems to reduce.
   
    //@Brian note--clean this up
    //[self.lsdelegate continueButtonClick:self withGems:gems];
    
    //reduce number of gems on player data
    //reduce number of gems on server
    //let the player continue
    PlayerData *sharedData = [PlayerData sharedData];
    
    NSInteger thegems = [sharedData.lossCost integerValue];
    
    BOOL payresult = [sharedData spendUserGems:thegems];
    
    //@Brian note--need to show the top bar removing the gems somehow.
    
    if (payresult)
    {
        //loss cost goes up
       [sharedData LossCostIncrease:sharedData.lossCost];
        
        //user score becomes the current score.
        
        PFUser *user = [PFUser currentUser];
        
        
        sharedData.playerscore = self.LossScreenPlayerScore;
        
        [user setObject:sharedData.playerscore forKey:@"currentScore"];
       

        
        [user setObject:sharedData.lossCost forKey:@"gemCheatCost"];
        
         [user saveInBackground];
        
        //dismiss both this screen and the summary screen
        [self.lsdelegate continueButtonClick:self withGems:[NSNumber numberWithInt:0]];
        
        
    }
    else
    {
        //buy more gems!
        //show the gem screen
        NSLog(@"user needs more gems");
        
        
        
        UIView *buymoregems = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-222)/2,100,222,126)];
        
        NSString *fileName = [[NSBundle mainBundle] pathForResource:@"out-of-diamonds" ofType:@"png"];
        UIImage *bgimage = [UIImage imageWithContentsOfFile:fileName];
        
        UIImage *b = [self imageWithImage:bgimage scaledToSize:buymoregems.bounds.size];
        
       buymoregems.backgroundColor = [UIColor colorWithPatternImage:b];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(180,0,222-180,30)];
        
        btn.backgroundColor = [UIColor clearColor];
        
        
        [btn addTarget:self action:@selector(closebtnclick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *btnmid = [[UIButton alloc] initWithFrame:CGRectMake(83,40,51,52)];
        
        btnmid.backgroundColor = [UIColor clearColor];
        
        
        [btnmid addTarget:self action:@selector(buybtnclick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(180,90,222-180,126-90)];
        
        btn2.backgroundColor = [UIColor clearColor];
        //size 136,38 div 2
        btn2.frame = CGRectMake((buymoregems.frame.size.width-68)/2,buymoregems.frame.size.height-29,68,19);
        
        [btn2 addTarget:self action:@selector(buybtnclick:) forControlEvents:UIControlEventTouchUpInside];
        
        NSString *btnfileName = [[NSBundle mainBundle] pathForResource:@"buy-more-button" ofType:@"png"];
        UIImage *btnimage = [UIImage imageWithContentsOfFile:btnfileName];
        
        UIImage *bb = [self imageWithImage:btnimage scaledToSize:btn2.bounds.size];

        [btn2 setImage:bb forState:UIControlStateNormal];
        
        
        [buymoregems addSubview:btn];
        [buymoregems addSubview:btn2];
        [buymoregems addSubview:btnmid];
        
        [self.view addSubview:buymoregems];
        
    }
    
    
    
}
-(void)closebtnclick:(id)sender
{
    NSLog(@"closebtnclicked");
    
    UIButton *sendbtn = sender;
    UIView *theview = sendbtn.superview;
    
    [theview removeWithSinkAnimation:1];
    
}

-(void)buybtnclick:(id)sender
{
    NSLog(@"buybtnclicked");
    
    //bring up the gold store
    GoldStoreViewController *gsvc = [self.storyboard instantiateViewControllerWithIdentifier:@"gsvc"];
    
    gsvc.goldstoredelegate = self;
    
    [self.navigationController pushViewController:gsvc animated:YES];
    gsvc.view.hidden = NO;
    
    
    UIButton *sendbtn = sender;
    UIView *theview = sendbtn.superview;
    
    [theview removeWithSinkAnimation:1];
    
}

- (void)BackToBuyStuff:
(GoldStoreViewController *)controller
{
    [self.navigationController popViewControllerAnimated:YES];
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

-(IBAction)CloseBtn:(id) sender
{
    
    //reset the loss cost.
    PlayerData *sharedData = [PlayerData sharedData];
    [sharedData LossCostReset];
    
    
    
    [self.lsdelegate closeButtonClick:self];
    
}
-(IBAction)AllBtn:(id) sender
{
    
    [self getAdjacentPlayers:LossScreenPlayerTopScore];
     
     
}
-(IBAction)FriendsBtn:(id)sender
{
    
    //65, 186, 236
    
    UIColor *borderColor = [UIColor colorWithRed:65/255.f green:186/255.f blue:236/255.f alpha:1.0];
    
    //return query of sorted scores by friends
    [FBRequestConnection startForMyFriendsWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // result will contain an array with your user's friends in the "data" key
            NSArray *friendObjects = [result objectForKey:@"data"];
            NSMutableArray *friendIds = [NSMutableArray arrayWithCapacity:friendObjects.count];
            // Create a list of friends' Facebook IDs
            for (NSDictionary *friendObject in friendObjects) {
                [friendIds addObject:[friendObject objectForKey:@"id"]];
            }
            
            // Construct a PFUser query that will find friends whose facebook ids
            // are contained in the current user's friend list.
            PFQuery *friendQuery = [PFUser query];
            [friendQuery whereKey:@"fbID" containedIn:friendIds];
            
            // findObjects will return a list of PFUsers that are friends
            // with the current user
            NSArray *friendUsers = [friendQuery findObjects];
            NSLog(@"%i",friendUsers.count);
            
            if(friendUsers.count ==0)
            {
                //hide hud
                return;
            }
            //take these users and query for their scores for the adjacent object...
            
            PFQuery *query = [PFQuery queryWithClassName:@"funPhotoLeaderboard"];
            [query whereKey:@"Player" containedIn:friendUsers];
            [query orderByDescending:@"Score"];
            [query includeKey:@"Player"];
            query.limit = 2;
            
            NSArray *thesePlayers = [query findObjects];
            
            if(thesePlayers.count==0)
            {
                
                //hide hud
                return;
                
            }
              int i = 1;
            for (PFObject *obj in thesePlayers)
              
            
            {
                PFObject *userobj = [obj objectForKey:@"Player"];
                
                if (i==1)
                {
                    rank2score = [obj objectForKey:@"Score"];
                    friendScore2.text = [rank2score stringValue];
                    
                    PFFile *playerimg = [userobj objectForKey:@"profilePictureSmall"];
                    
                    NSString *fileName = [[NSBundle mainBundle] pathForResource:@"profile-sillhouette" ofType:@"png"];
                    UIImage *profplaceholder = [UIImage imageWithContentsOfFile:fileName];
                    if(playerimg ==nil)
                    {
                        
                        [friendImage2 setImage:profplaceholder];
                        
                    }
                    else
                    {
                        
                        UIActivityIndicatorViewStyle activityStyle = UIActivityIndicatorViewStyleGray;
                        
                        [friendImage2 setImageWithURL:[NSURL URLWithString:playerimg.url] placeholderImage:profplaceholder usingActivityIndicatorStyle:activityStyle];
                        
                    }
                    
                    
                    [friendImage2.layer setBorderColor:borderColor.CGColor];
                    [friendImage2.layer setBorderWidth:3.0];
                    friendImage2.layer.cornerRadius = 5.0;
                    friendImage2.layer.masksToBounds = YES;
                    
                    NSString *friendstring =[userobj objectForKey:@"displayName"];
                    if (friendstring == nil) {
                        
                        friendName2.text = [userobj objectForKey:@"username"];
                    }
                    else
                    {
                        friendName2.text = friendstring;
                    }
                    
                    
                    
                }
                if (i==2)
                {
                    rank1score = [obj objectForKey:@"Score"];
                    friendScore1.text = [rank1score stringValue];
                    
                    PFFile *playerimg = [userobj objectForKey:@"profilePictureSmall"];
                    
                    
                    NSString *fileName = [[NSBundle mainBundle] pathForResource:@"profile-sillhouette" ofType:@"png"];
                    UIImage *profplaceholder = [UIImage imageWithContentsOfFile:fileName];
                    
                    
                    if(playerimg ==nil)
                    {
                        
                        [friendImage1 setImage:profplaceholder];
                        
                    }
                    else
                    {
                        
                        UIActivityIndicatorViewStyle activityStyle = UIActivityIndicatorViewStyleGray;
                        
                        [friendImage1 setImageWithURL:[NSURL URLWithString:playerimg.url] placeholderImage:profplaceholder usingActivityIndicatorStyle:activityStyle];
                        
                    }
                    
                    [friendImage1.layer setBorderColor:borderColor.CGColor];
                    [friendImage1.layer setBorderWidth:3.0];
                    friendImage1.layer.cornerRadius = 5.0;
                    friendImage1.layer.masksToBounds = YES;
                    
                    NSString *friendstring =[userobj objectForKey:@"displayName"];
                    if (friendstring == nil) {
                        
                        friendName1.text = [userobj objectForKey:@"username"];
                    }
                    else
                    {
                        friendName1.text = friendstring;
                    }
                    
                }
                i=i+1;
                
                
            }
                        
        }
    }];
    
    
    
    
}

@end
