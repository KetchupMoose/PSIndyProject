//
//  TopBarViewController.m
//  funnyBusiness
//
//  Created by Macbook on 2013-10-09.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import "TopBarViewController.h"
#import <Parse/Parse.h>
#import "funData.h"
#import "xpBarProgressView.h"
#import "UIView+Animation.h"
#import "DACircularProgressView.h"

@interface TopBarViewController ()

@end

@implementation TopBarViewController

@synthesize xpbarbutton;
@synthesize goldbutton;
@synthesize levelbutton;
@synthesize xpBarStar;
@synthesize heartsview;
@synthesize heartTimer;
@synthesize leveltitleLabel;
xpBarProgressView *xpBar;
DACircularProgressView *xpCircle;

NSTimer * countdownTimer;
NSUInteger remainingTicks;
BOOL gottimestamp;

NSTimer *progressmovetimer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)setupTimerDataFromPlayerData
{
    
   
    PlayerData *sharedData = [PlayerData sharedData];
    
    BOOL firstloadsd = [sharedData firstload];
    if(firstloadsd ==YES)
    {
    //get number of hearts
    float numh = [sharedData.usercurrenthearts floatValue];
    float usermaxh = [sharedData.usermaxhearts floatValue];
        
        [self doHeartLayoutChangingProperties:numh withmaxhearts:usermaxh];
    
    NSLog(@"updated numh for setuptimer:%f",numh);
    
    
    remainingTicks = [sharedData getticknum];
    
    [self updateLabel];
    }
    
    //get number of ticks for label
}
-(void)setupTimerData
{
  
       //if the user already started this session...no need to get this again
    
   
        funData *fd = [[funData alloc] init];
        NSDate *heartdate = [fd GetHeartTimestamp];
        
        NSDate *curdate = [NSDate date];
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"YYYY-MM-dd HH:mm:SS"];
        NSString *dateTime = [dateFormat stringFromDate:heartdate];
        
        NSLog(@"DateTimeheartdate=%@",dateTime);
        
        dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"YYYY-MM-dd HH:mm:SS"];
        dateTime = [dateFormat stringFromDate:curdate];
        
        NSLog(@"DateTimecurdate=%@",dateTime);
        
        NSTimeInterval secondsBetween = [curdate timeIntervalSinceDate:heartdate];
        
        NSInteger time = round(secondsBetween);
        
    
        int myinterval = 60*20;
        //if the time was greater than the interval, loop to give hearts until user is at max.
        PlayerData *sharedData = [PlayerData sharedData];
        
    float usermaxhearts = [sharedData.usermaxhearts floatValue];
    
        float returnedhtotal = [sharedData.usercurrenthearts floatValue];
        
        if(time>myinterval)
        {
            float calchearts = floorf(time/myinterval);
            
            returnedhtotal = [fd RestoreMultipleHearts:usermaxhearts withthismany:calchearts];
            [self doHeartLayout:returnedhtotal];
            NSLog(@"This many hearts on docountdown: %f",returnedhtotal);
        }
        
        if (returnedhtotal==usermaxhearts || returnedhtotal >=5)
        {
            
            sharedData.atmaxhearts = [NSNumber numberWithInt:1];
            
            
            heartTimer.text = @"At Max!";
            
            [self doHeartLayout:returnedhtotal];
             NSLog(@"This many hearts on docountdown #2: %f",returnedhtotal);
            
            
            remainingTicks=0;
            
            
            return;
        }
    
    
     NSLog(@"This many hearts on docountdown #3: %f",returnedhtotal);
    [self doHeartLayout:returnedhtotal];
    
    
    NSInteger remainingtime = myinterval-time;
        
        
        
        if (remainingtime>0)
        {
            if(remainingtime<myinterval)
            {
                remainingTicks = floor(remainingtime/10);
                
            }
            else
            {
                remainingTicks = floor(myinterval/10);
            }
            
            
            [sharedData doTimer:remainingTicks];
            
            
            [self updateLabel];
            
            NSLog(@"Updating Label from do countdown");
                        
        }

           
}

- (void)viewWillDisappear:(BOOL)animated {
    //[countdownTimer invalidate];
    //countdownTimer = nil;
    
}

-(void)DoTimerTick:(NSUInteger)Time
{
    remainingTicks = Time;
    [self updateLabel];
    
    if (remainingTicks <= 0) {
        
        //restore a heart
   
        
        PlayerData *sharedData = [PlayerData sharedData];
        
        float nummaxh = [sharedData.usermaxhearts floatValue];
        
        float numh = [sharedData RefillHeart:self];
        
        
        if(numh>=5 || numh == nummaxh)
        {
            heartTimer.text = @"At Max!";
            
            //[countdownTimer invalidate];
           // countdownTimer = nil;
            
            remainingTicks=0;
            
            
        }
        else
        {
        heartTimer.text = @"20m 0s";
            
        }
        
        [self doHeartLayoutChangingProperties:numh withmaxhearts:nummaxh];
        NSLog(@"This many hearts on handletimertick: %f",numh);
        
    }
    

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
    
    NSString *fileName = [[NSBundle mainBundle] pathForResource:@"xp-bar-test2" ofType:@"png"];
    UIImage *bgimage = [UIImage imageWithContentsOfFile:fileName];
        
    UIImageView *xpcirclebackground = [[UIImageView alloc] initWithFrame:CGRectMake(23.0f,1,35.0f,35.0f)];
        
    [xpcirclebackground setImage:bgimage];
    
    [self.view addSubview:xpcirclebackground];
        
    xpCircle = [[DACircularProgressView alloc] initWithFrame:CGRectMake(23.0f, 1.0f, 31.0f, 31.0f)];
        xpCircle.center = xpcirclebackground.center;
        
    xpCircle.roundedCorners = YES;
    xpCircle.trackTintColor = [UIColor whiteColor];
    xpCircle.progressTintColor = [UIColor yellowColor];
    
    xpCircle.backgroundColor = [UIColor clearColor];
    //xpCircle.tintColor = [UIColor yellowColor];
    [self.view addSubview:xpCircle];
        [self.view bringSubviewToFront:xpCircle];
        
    xpCircle.progress = 0.7;
    }
    else
    {
        NSString *fileName = [[NSBundle mainBundle] pathForResource:@"xp-bar-test2" ofType:@"png"];
        UIImage *bgimage = [UIImage imageWithContentsOfFile:fileName];
        
        UIImageView *xpcirclebackground = [[UIImageView alloc] initWithFrame:CGRectMake(60.0f,2,70.0f,70.0f)];
        
        [xpcirclebackground setImage:bgimage];
        
        [self.view addSubview:xpcirclebackground];
        
        
        xpCircle = [[DACircularProgressView alloc] initWithFrame:CGRectMake(60.0f, 2.0f, 62.0f, 62.0f)];
        xpCircle.center = xpcirclebackground.center;
        
        xpCircle.roundedCorners = YES;
        xpCircle.trackTintColor = [UIColor whiteColor];
        xpCircle.progressTintColor = [UIColor yellowColor];
        
        xpCircle.backgroundColor = [UIColor clearColor];
        //xpCircle.tintColor = [UIColor yellowColor];
        [self.view addSubview:xpCircle];
        [self.view bringSubviewToFront:xpCircle];
        
        xpCircle.progress = 0.7;
    }

    //start heartsview in top right of frame
    heartsview.frame = CGRectMake(218,1,100,20);
    
    heartsview.contentMode = UIViewContentModeScaleAspectFit;
    
    
    
    heartTimer.frame = CGRectMake(225,20,120,20);
    heartTimer.backgroundColor = [UIColor clearColor];
    

    heartsview.backgroundColor = [UIColor clearColor];
    
     [self.view addSubview:heartsview];
    
  //font color 38 34 98
    
     if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
     {
          self.gemsLabel.font = [UIFont fontWithName:@"CooperBlackStd" size:12];
          self.goldLabel.font =[UIFont fontWithName:@"CooperBlackStd" size:12];
          self.influenceLabel.font =[UIFont fontWithName:@"CooperBlackStd" size:12];
          heartTimer.font =[UIFont fontWithName:@"CooperBlackStd" size:14];
          self.levelLabel.font =[UIFont fontWithName:@"CooperBlackStd" size:14];
         
        self.leveltitleLabel.font= [UIFont fontWithName:@"CooperBlackStd" size:5];

     }
    else
    {
         self.gemsLabel.font = [UIFont fontWithName:@"CooperBlackStd" size:15];
        self.goldLabel.font =[UIFont fontWithName:@"CooperBlackStd" size:15];
         self.influenceLabel.font =[UIFont fontWithName:@"CooperBlackStd" size:15];
         heartTimer.font =[UIFont fontWithName:@"CooperBlackStd" size:17];
    self.levelLabel.font =[UIFont fontWithName:@"CooperBlackStd" size:24];
    self.leveltitleLabel.font= [UIFont fontWithName:@"CooperBlackStd" size:11];
    }
   
    self.gemsLabel.textColor = [UIColor colorWithRed:38/255.0 green:34/255.0 blue:98/255.0 alpha:1];
    
    
   
    self.goldLabel.textColor = [UIColor colorWithRed:38/255.0 green:34/255.0 blue:98/255.0 alpha:1];
    
     self.levelLabel.textColor = [UIColor colorWithRed:38/255.0 green:34/255.0 blue:98/255.0 alpha:1];
   
    self.influenceLabel.textColor = [UIColor colorWithRed:38/255.0 green:34/255.0 blue:98/255.0 alpha:1];
    
   
   heartTimer.textColor = [UIColor colorWithRed:38/255.0 green:34/255.0 blue:98/255.0 alpha:1];

   
    
    
    self.levelLabel.text = @"";
    self.goldLabel.text = @"";
    self.gemsLabel.text = @"";
    self.influenceLabel.text = @"";
    self.heartTimer.text = @"";
    
    
    //[self.view addSubview:heartTimer];
    
    /*
     if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
     {
           xpBar = [[xpBarProgressView alloc] initWithFrame:CGRectMake(27,15,40,9)];
     }
    else
    {
        xpBar = [[xpBarProgressView alloc] initWithFrame:CGRectMake(51,38,72,25)];
        CALayer *xb = xpBar.layer;
        xb.cornerRadius = 8.0f;
        xb.masksToBounds = YES;
    }
   
     */
   
    
    
    
    
    //query and get some sexy player data!
    
    //[self getProfileInfo];
      UIImage *b;
    UIImage *bgimage;
     if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
     {
         NSString *fileName = [[NSBundle mainBundle] pathForResource:@"Top-bar-background" ofType:@"png"];
         bgimage = [UIImage imageWithContentsOfFile:fileName];
         
         
       
     }
    else
    {
        NSString *fileName = [[NSBundle mainBundle] pathForResource:@"ipadtop-with-parts" ofType:@"png"];
        bgimage = [UIImage imageWithContentsOfFile:fileName];
        
    }
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
          b = [self imageWithImage:bgimage scaledToSize:CGSizeMake(320, 40)];
    }
    else
    {
          b = [self imageWithImage:bgimage scaledToSize:CGSizeMake(768, 80)];
    }

    
    self.view.backgroundColor = [UIColor colorWithPatternImage:b];
    
    //[self.view addSubview:xpBar];
    
    [self.view bringSubviewToFront:(xpBarStar)];
    
    [self.view bringSubviewToFront:(self.levelLabel)];
    
    
    }
- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
            //UIGraphicsBeginImageContext(newSize);
            // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
            // Pass 1.0 to force exact pixel size.
            UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
            [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
            UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            return newImage;
}
                           

- (void)viewWillAppear:(BOOL)animated
{
   
	
    
    // Do any additional setup after loading the view.
    //[self levelupRewardData];
    NSLog(@"gonna appear");
    
    
    //get the data for hearts to draw from file
    
    //funData *myfd = [[funData alloc] init];
    //NSNumber *hnum = [myfd GetNumHearts];
    
    //float numh = [hnum floatValue];
    
     PlayerData *sharedData = [PlayerData sharedData];
    sharedData.pddelegate = self;
    
    /*
    if (numh==[sharedData.usermaxhearts floatValue])
    {
        sharedData.atmaxhearts = [NSNumber numberWithInt:1];
         
        heartTimer.text = @"At Max";
        
        [countdownTimer invalidate];
        
        //stop the timer until it needs to start again
        
    }
     */
  
        //get the timer going
    [self setupTimerDataFromPlayerData];
    
    // NSLog(@"This many hearts on did appear: %f",numh);
    
    [self setLabels];
    
    
    float curprogress = [sharedData.progress floatValue];
    
     //xpBar.progress = 1;
    [self doXPBar:curprogress];
        
}



-(void) levelupRewardData
{
   
    //this is now done directly on vote summary
    
   // [self dolevelup:plyrlvl withGold:goldRewardNum withGems:gemRewardNum withHearts:heartpiecerewardNum];
    
    //these are set in data on the rest of "xp to progress"
    
}


-(void) dolevelup:(NSNumber *) lvl withGold:(NSNumber *) gold withGems:(NSNumber *) gems withHearts:(NSNumber *) hearts
{
    [self.topbardelegate showalevelup:lvl withGold:gold withGems:gems withHearts:hearts];
    
}

-(void) setLabels
{
    NSLog(@"Igotcalled");
    
     PlayerData *sharedData = [PlayerData sharedData];
    
    if (sharedData.userGold == nil)
    {
        return;
    }
    
    NSString *gstring = [NSString stringWithFormat:@"%@",sharedData.userGold];
     NSString *levelstring = [NSString stringWithFormat:@"%@",sharedData.userLevel];
     NSString *gemstring = [NSString stringWithFormat:@"%@",sharedData.userGems];
    
    NSString *influstring = [NSString stringWithFormat:@"%@",sharedData.userInfluence];
    
    
    [self.levelLabel setText:levelstring];
    
    [self.goldLabel setText:gstring];
    [self.gemsLabel setText:gemstring];
    [self.influenceLabel setText:influstring];
    
}

-(void) doXPBar:(float) progress
{
    
    xpCircle.progress = progress;
    NSLog(@"setting xp bar");
        
}

-(void) TopBarRefreshLabels
{
    [self setLabels];
    [self setupTimerDataFromPlayerData];
    
}

-(void) doHeartLayout:(float) numhearts
{
    //[heartsview removeFromSuperview];
    
    //convert float to integer
  
   
    
    //start heartsview in top right of frame
    heartsview.frame = CGRectMake(223,3,100,20);
    
    heartsview.contentMode = UIViewContentModeScaleAspectFit;
    
    heartsview.backgroundColor = [UIColor clearColor];
    
    
    int maxfull = floorf(numhearts);
    
    float extrafract = numhearts-maxfull;
    
    
    for(int i=0;i<5;i++)
    {
        UIImageView *heart;
       
        
        if (i<maxfull)
        {
            
           
            heart = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ipadnew-heart.png"]];
            
        }
        
        else
        {
            if(i==maxfull)
            {
                if (extrafract == 0)
                {
                heart = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"empty-heart.png"]];
                }
                if (extrafract == 0.25)
                {
                    heart = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"new-quarter-heart.png"]];
                }
                if (extrafract == 0.5)
                {
                    heart = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"half-heart.png"]];
                }
                if (extrafract == 0.75)
                {
                    heart = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"new-34-heart.png"]];
                }
            }
           
            else
            {
                heart = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"empty-heart.png"]];
            }
        }
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            float layoutx = (16* (i)) + 2;
            
            heart.frame = CGRectMake(layoutx,0,15.5,14);

        }
        else
        {
            float layoutx = (40* (i)) + 4;
            
            heart.frame = CGRectMake(layoutx,0,37,35);
        }
        
       
        
        [heartsview addSubview:heart];
        
        
    }
    
}

-(void) doHeartLayoutChangingProperties:(float) numhearts withmaxhearts:(float) maxh
{
    for (UIView *view in heartsview.subviews)
    {
        [view removeFromSuperview];
        
    }
    
    //convert float to integer
    
    
    int maxfull = floorf(numhearts);
    
    float extrafract = numhearts-maxfull;
    
    
    for(int i=0;i<5;i++)
    {
        UIImageView *heart;
        
        
        if (i<maxfull)
        {
            
            
            heart = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ipadnew-heart.png"]];
            
        }
        
        else
        {
            if(i==maxfull)
            {
                if (extrafract == 0)
                {
                    if(i+1>maxh)
                    {
                        heart = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ipadlocked-heart.png"]];
                    }
                    else
                    {
                        heart = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"empty-heart.png"]];
                    }
                    
                }
                if (extrafract == 0.25)
                {
                    heart = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"new-quarter-heart.png"]];
                }
                if (extrafract == 0.5)
                {
                    heart = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"half-heart.png"]];
                }
                if (extrafract == 0.75)
                {
                    heart = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"new-34-heart.png"]];
                }
            }
            else
            {
                if(i+1>maxh)
                {
                    heart = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ipadlocked-heart.png"]];
                }
                else
                {
                    heart = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"empty-heart.png"]];
                }
            }
        }
        
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            float layoutx = (16* (i)) + 2;
            
            heart.frame = CGRectMake(layoutx,0,15.5,14);
            
        }
        else
        {
            float layoutx = (40* (i)) + 4;
            
            heart.frame = CGRectMake(layoutx,0,37,35);
        }
        
        [heartsview addSubview:heart];
        
        
    }
    
    
    
}





-(float) RemoveHeartTopBar:(id) sender;
{
    //save a timestamp of when the heart is removed to memory.
    PlayerData *sharedData = [PlayerData sharedData];

    float newheartval = [sharedData RemoveHeart:self];
    
    float usermaxh = [[sharedData usermaxhearts] floatValue];
    
    [self doHeartLayoutChangingProperties:newheartval withmaxhearts:usermaxh];
    
    NSLog(@"this many hearts on remove %f",newheartval);
    
                
    return newheartval;
    
}
//wont get called anymore..
-(void)handleTimerTick
{
    remainingTicks--;
    [self updateLabel];
    
    if (remainingTicks <= 0) {
        
        //restore a heart
        
        funData *fd = [[funData alloc] init];
        
        PlayerData *sharedData = [PlayerData sharedData];
        
        float themaxhearts = [sharedData.usermaxhearts floatValue];
        
        [fd RestoreAHeart:themaxhearts];
        
        
        remainingTicks = 60*20/10;
        
        
        NSNumber *numhearts = [fd GetNumHearts];
        
        sharedData.usercurrenthearts = numhearts;
        
        
        float numh = [numhearts floatValue];
        
        if(numh>=5 || numh == themaxhearts)
        {
            heartTimer.text = @"At Max!";
            
            [countdownTimer invalidate];
            countdownTimer = nil;
            
            remainingTicks=0;
            
            
        }
        
        [self doHeartLayoutChangingProperties:numh withmaxhearts:themaxhearts];
        NSLog(@"This many hearts on handletimertick: %f",numh);
        
    }
    
    
    
    
}

-(void)updateLabel
{
    
    
    if(remainingTicks==0)
    {
        heartTimer.text = @"At Max";
        return;
        
    }
   
    NSInteger minutes = floor(remainingTicks/6);
    
    NSInteger seconds = (remainingTicks -(6*minutes)) *10;
    
    
   NSString *mins = @" m ";
    
    NSString *secs = @" s";
    
    NSString *fullmins = [[NSString stringWithFormat:@"%d", minutes] stringByAppendingString:mins];
    
    NSString *fullsecs = [[NSString stringWithFormat:@"%d", seconds] stringByAppendingString:secs];
    
    NSString *fullstring = [fullmins stringByAppendingString:fullsecs];
    
    
    heartTimer.text = fullstring;
    NSLog(@"%@",fullstring);
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) moveXPBar: (float) xp
{
    
    //not doing this move function for now
    
    //rewriting this to ignore the progress part.  this can be changed to an xp value actually...
    
   
    
   // float newxp = xp+userXP;
    
   //userXP = userXP +xp;
    
    
   // float newprogress = [self xptoprogress:newxp];
    

    
    //[xpBar setProgress:newprogress animated:YES];
    
   
    
    //update PF user to new xp value
    
    
    
    
}
//always add gold before xp
-(void) AddGoldTopBar:(NSInteger) thegold

{
   //used on other function now, all added at once
    
    //userGold = userGold + thegold;
    
}



- (IBAction)levelbuttonclick:(id)sender {
    NSLog(@"Ticks down to 2");
    
    PlayerData *sharedData = [PlayerData sharedData];
    
    
    sharedData.usercurrenthearts = [NSNumber numberWithFloat:0];
     
    
    
}


@end
