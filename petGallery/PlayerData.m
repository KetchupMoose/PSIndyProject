//
//  PlayerData.m
//  funnyBusiness
//
//  Created by Macbook on 2013-11-14.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import "PlayerData.h"
#import <ParseFacebookUtils/PFFacebookUtils.h>

@implementation PlayerData
@synthesize playerscore;
@synthesize playerTopScore;

@synthesize usermaxhearts;
@synthesize userXP;
@synthesize nextXPRequired;
@synthesize userGold;
@synthesize userGems;
@synthesize userLevel;
@synthesize atmaxhearts;
@synthesize progress;
@synthesize levelupGemReward;
@synthesize levelupGoldReward;
@synthesize levelupHeartReward;
@synthesize lossCost;

@synthesize userInfluence;
@synthesize userTotalInfluence;
@synthesize userTotalCreatorInfluence;
@synthesize userTotalChampionInfluence;

@synthesize lastCollectDate;
@synthesize collectsRemaining;
@synthesize loadedhearttimedata;
@synthesize firstload;

NSTimer * countdownTimer;
NSUInteger TimerTicks;

NSMutableData *imgdata;
+ (id)sharedData {
    static PlayerData *sharedPlayerData = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedPlayerData = [[self alloc] init];
    });
    return sharedPlayerData;
}

- (id)init {
    if (self = [super init]) {
        //someProperty = [[NSString alloc] initWithString:@"Default Property Value"];
    }
    return self;
}


-(void) getPlayerData
{
   
    
    PFUser *user = [PFUser currentUser];
    
    userXP= [user objectForKey:@"exp"];
    
    if (userXP == nil) {
        // ... wasn't in dictionary, which represents empty
        
        [self setPlayerData];
        return;
        
        
    } else {
        // ... not empty
    }
    
    
    userLevel = [user objectForKey:@"level"];
    userGold = [user objectForKey:@"Currency"];
    userGems = [user objectForKey:@"Gems"];
    usermaxhearts = [user objectForKey:@"MaxHearts"];
    
     [self getHeartData];
    [self SessionStartFunData];
    firstload=YES;
    playerscore = [user objectForKey:@"currentScore"];
    self.playerTopScore = [user objectForKey:@"playerTopScore"];
    self.lossCost = [user objectForKey:@"gemCheatCost"];
    userInfluence = [user objectForKey:@"influence"];
    userTotalInfluence = [user objectForKey:@"lifetimeInfluence"];
    userTotalCreatorInfluence = [user objectForKey:@"lifetimeSubmitInfluence"];
    userTotalChampionInfluence = [user objectForKey:@"lifetimeChampionInfluence"];
    collectsRemaining = [user objectForKey:@"CollectsRemaining"];
    lastCollectDate = [user objectForKey:@"LastCollectDate"];
    
    //get player level and query for xp to next level
    PFQuery *query;
    
    
    query = [PFQuery queryWithClassName:@"funPlayerLevels"];
    [query whereKey:@"playerLevel" equalTo:userLevel];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved this object %@", object.objectId);
            // Do something with the found object
            
            //this stuff should only run if the query is successful
            nextXPRequired = [object objectForKey:@"playerXPRequired"];
            
            //calculate progress.
            
            float prog = [self.userXP floatValue]/[self.nextXPRequired floatValue];
            
            self.progress = [NSNumber numberWithFloat:prog];
            
            [self getlevelupRewardData];
            
        }
        else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
}

-(void) getHeartData
{
//get the data for hearts to draw from file

funData *myfd = [[funData alloc] init];
NSNumber *hnum = [myfd GetNumHearts];

float numh = [hnum floatValue];

    self.usercurrenthearts = [NSNumber numberWithFloat:numh];
    

if (numh==[usermaxhearts integerValue])
{
    
    self.atmaxhearts = [NSNumber numberWithInt:1];
    
}
    
}

-(float) RemoveHeart:(id) sender
{
    
    //save a timestamp of when the heart is removed to memory.
    
    funData *fd = [[funData alloc] init];
    NSDate *nd = [NSDate date];
    
    if ([atmaxhearts integerValue]==1)
    {
        [fd LoseHeartFromMax:nd];
        atmaxhearts =0;
        
    }
    else
    {
        [fd LoseHeart];
    }
    
    
    
    NSNumber *mynum = [fd GetNumHearts];
    // NSString *mystring = [NSString stringWithFormat:@"%@", mynum];
    NSLog(@"testing retrieve");
    
    // NSLog(mystring);
    
    float newheartvalue = [mynum floatValue];
    
    
    
    
    
    self.usercurrenthearts = [NSNumber numberWithFloat:newheartvalue];
    
    if(TimerTicks==0)
    {
        TimerTicks=60*20/10;
        
    }

      //need to start the timer if it's not already going.
    if(countdownTimer ==nil)
    {
         TimerTicks=60*20/10;
       countdownTimer = [NSTimer scheduledTimerWithTimeInterval: 10.0 target:self selector:@selector(mehandleTimerTick) userInfo:nil repeats:YES];
    }
    
    
  
    
    
    return newheartvalue;
    
    
    
}

-(float) RefillHeart:(id) sender
{
    //restore a heart
    
    funData *fd = [[funData alloc] init];
    
   
    
    float themaxhearts = [self.usermaxhearts floatValue];
    
    [fd RestoreAHeart:themaxhearts];
    
    //set ticks on player data shared data
    
    
    NSNumber *numhearts = [fd GetNumHearts];
    
    self.usercurrenthearts = numhearts;
    
    
    float numh = [numhearts floatValue];
    
    if(numh>=5 || numh == themaxhearts)
    {
        
        [countdownTimer invalidate];
        countdownTimer = nil;
        
      
        
    }
    else
    {
        TimerTicks = 60*20/10;

    }
    return numh;
    
}

-(float) AddGoldXPScoreVote:(NSInteger) thegold withXP:(float) xp withScore:(NSInteger) score
{
    
    //check to see if the user levelled up
    
    
   float nextxpf = [nextXPRequired floatValue];
    
    
    float curxp = [self.userXP floatValue];
    float newxp = curxp+xp;
    
    float lvlprogress = newxp/nextxpf;
    
    NSLog(@"this is the returned progress %f", lvlprogress);

    if (lvlprogress>=1)
    {
        //the user levelled up.
        
        
        NSInteger nextlevel = [userLevel integerValue] +1;
        
        userLevel = [NSNumber numberWithInt:nextlevel];
        
        
        float leftoverxp = newxp-nextxpf;
      
        userXP = [NSNumber numberWithFloat:leftoverxp];
        
        [self doLevelUpData];
        
       // lvlprogress = 0.1;
        
        
    }
    else
    {
        userXP = [NSNumber numberWithFloat:newxp];
        progress = [NSNumber numberWithFloat:lvlprogress];
        
    }
    
    
    //give rewards to user
    
    NSInteger curgold = [userGold integerValue];
    NSInteger newgold = curgold+thegold;
    
    userGold = [NSNumber numberWithInt:newgold];
    
    NSInteger curscore = [playerscore integerValue];
    NSInteger newscore = curscore+ score;
    
    playerscore = [NSNumber numberWithInt:newscore];
    if (newscore> [playerTopScore integerValue])
    {
        playerTopScore = playerscore;
        
        //save score on leaderboard.
        [self saveScoreOnLeaderboard];
        
    }
    
    userGold = [NSNumber numberWithInt:newgold];
    
    //return progress to display on top bar
    
    
    //do user saves.
    
    PFUser *user = [PFUser currentUser];
    
    [user setObject:userLevel forKey:@"level"];

    [user setObject:userGold forKey:@"Currency"];
    [user setObject:userGems forKey:@"Gems"];
    [user setObject:usermaxhearts forKey:@"MaxHearts"];
    [user setObject:userXP forKey:@"exp"];
    [user setObject:playerscore forKey:@"currentScore"];
    [user setObject:playerTopScore forKey:@"playerTopScore"];
  
    
        //@Brian note--create an art piece here for NEW Top Score!"
        
        //@Brian note--change the player top score on the leaderboard also
        
    
    NSLog(@"saving this score:%i", curscore);
    
    [user saveInBackground];
    
   
    return lvlprogress;
    
}
-(void) saveScoreOnLeaderboard
{
    PFUser *user = [PFUser currentUser];
  
   
    
    PFQuery *query = [PFQuery queryWithClassName:@"funPhotoLeaderboard"];
    
    [query whereKey:@"Player" equalTo:user];
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *leaderobj, NSError *error)
     
     {
         if(!error)
         {
             if(leaderobj)
             {
             leaderobj[@"Score"] = playerTopScore;
                 [leaderobj saveInBackground];
             }
             else
             {
                 PFObject *newplayerscoreobj = [PFObject objectWithClassName:@"funPhotoLeaderboard"];
                 newplayerscoreobj[@"Player"] = user;
                 newplayerscoreobj[@"Score"] = playerTopScore;
                 
                 [newplayerscoreobj saveInBackground];
                 
                 
             }
             
         }
         
         
         
     }
    
     ];
    
       
}

-(void) getlevelupRewardData
{
    PFQuery *query;
    
    query = [PFQuery queryWithClassName:@"funPlayerLevels"];
    [query whereKey:@"playerLevel" equalTo:userLevel];
    
   [ query getFirstObjectInBackgroundWithBlock:^(PFObject *levelobj, NSError *error) {
        //do stuff after the find completes
        
        nextXPRequired = [levelobj objectForKey:@"playerXPRequired"];
        levelupGoldReward =[levelobj objectForKey:@"coinReward"];
        //NSInteger goldReward =[levelupGoldReward integerValue];
        levelupGemReward =[levelobj objectForKey:@"gemReward"];
        //NSInteger gemReward =[ levelupGemReward integerValue];
        levelupHeartReward =[levelobj objectForKey:@"heartPieceReward"];
        
        NSInteger heartpiecereward =[levelupHeartReward integerValue];
        
        
                
        
        if(heartpiecereward==1)
        {
            usermaxhearts = [NSNumber numberWithFloat:[usermaxhearts floatValue] +0.25];
        }
        
       
        
        
    }];
    
    
    
}

-(void) setPlayerData
{
    PFUser *user = [PFUser currentUser];
    
    
    NSInteger userstartGold = 100;
    NSInteger userstartGems = 5;
    NSInteger userstartXP = 0;
    NSInteger userstartmaxhearts = 3;
    NSInteger playerstartlevel = 1;
    
    
    NSNumber *userg = [NSNumber numberWithInteger:userstartGold];
    NSNumber *thegems = [NSNumber numberWithInteger:userstartGems];
    NSNumber *xpnum = [NSNumber numberWithInteger:userstartXP];
    NSNumber *themaxhearts = [NSNumber numberWithInteger:userstartmaxhearts];
    NSNumber *theplayerlevel = [NSNumber numberWithInteger:playerstartlevel];
    NSNumber *mycollectsRemaining = [NSNumber numberWithInteger:10];
    NSDate *mylastCollectDate = [NSDate date];
    
    
    [user setObject:theplayerlevel forKey:@"gemCheatCost"];
    [user setObject:userg forKey:@"Currency"];
    [user setObject:thegems forKey:@"Gems"];
    [user setObject:themaxhearts forKey:@"MaxHearts"];
    [user setObject:xpnum forKey:@"exp"];
    [user setObject:theplayerlevel forKey:@"level"];
    [user setObject:xpnum forKey:@"currentScore"];
    [user setObject:xpnum forKey:@"playerTopScore"];
    [user setObject:xpnum forKey:@"influence"];
    [user setObject:xpnum forKey:@"lifetimeInfluence"];
    [user setObject:xpnum forKey:@"lifetimeSubmitInfluence"];
    [user setObject:xpnum forKey:@"lifetimeChampionInfluence"];
    [user setObject:user.username forKey:@"displayName"];
    [user setObject:mycollectsRemaining forKey:@"CollectsRemaining"];
    [user setObject:mylastCollectDate forKey:@"LastCollectDate"];
    
    
    funData *fdc = [[funData alloc] init];
    [fdc startUser];

    
    NSLog(@"set the player data");
    firstload=YES;
    
    
    //@Brian note--may need to come back here later to add the user to the leaderboard table or do that somewhere else.  I thinK I have that taken care of somewhere else.  we will see.
  
    
    PlayerData *sharedData = [PlayerData sharedData];
    sharedData.userGold = userg;
    sharedData.userGems = thegems;
    sharedData.userXP = xpnum;
    sharedData.usermaxhearts = themaxhearts;
    sharedData.userLevel = theplayerlevel;
    sharedData.playerscore = xpnum;
    sharedData.playerTopScore = xpnum;
    sharedData.lossCost = theplayerlevel;
    sharedData.atmaxhearts = theplayerlevel;
    sharedData.progress = xpnum;
    sharedData.userInfluence = xpnum;
    sharedData.userTotalInfluence = xpnum;
    sharedData.userTotalChampionInfluence = xpnum;
    sharedData.userTotalCreatorInfluence = xpnum;
    sharedData.collectsRemaining = mycollectsRemaining;
    sharedData.lastCollectDate = mylastCollectDate;
    sharedData.usercurrenthearts = themaxhearts;
    
    
    sharedData.levelupGoldReward = [NSNumber numberWithFloat:50];
    sharedData.levelupGemReward = [NSNumber numberWithFloat:2];
    sharedData.levelupHeartReward = [NSNumber numberWithFloat:0];
    
    //set facebook data here:
    
    
    if ([PFUser currentUser] && // Check if a user is cached
        [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) // Check if user is linked to Facebook
    {
        // Create request for user's Facebook data
        
        //add extra 500 gold.
        NSInteger userfbgold = 600;
        NSNumber *userfbg = [NSNumber numberWithInt:userfbgold];
        
        [user setObject:userfbg forKey:@"Currency"];
        sharedData.userGold = userfbg;

        
        
        FBRequest *request = [FBRequest requestForMe];
        
        
        // Send request to Facebook
        [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            // handle response
            NSDictionary *userData = (NSDictionary *)result;
            
            NSString *facebookID = userData[@"id"];
            [user setObject:facebookID forKey:@"fbID"];
            
            NSString *name = userData[@"name"];
            [user setObject:name forKey:@"fbName"];
            [user setObject:name forKey:@"displayName"];
            
            NSString *gender = userData[@"gender"];
            [user setObject:gender forKey:@"fbGender"];
            
            
            
            NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
           
            
            imgdata = [[NSMutableData alloc] init]; // the data will be loaded in here
           
            NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:pictureURL
                                                                      cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                                  timeoutInterval:2.0f];
            // Run network request asynchronously
            NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
            
            
        }];
        
    }
    
      [user saveInBackground];
    
    PFObject *newplayerscoreobj = [PFObject objectWithClassName:@"funPhotoLeaderboard"];
    newplayerscoreobj[@"Player"] = user;
    newplayerscoreobj[@"Score"] = playerTopScore;
    
    [newplayerscoreobj saveInBackground];
    
    
}
// Called every time a chunk of the data is received
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [imgdata appendData:data]; // Build the image
}

// Called when the entire image is finished downloading
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
//upload the image data to parse.
    
      PFFile *imageFile = [PFFile fileWithName:@"Image.png" data:imgdata];

    
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
           
            
          
            PFUser *user = [PFUser currentUser];
            [user setObject:imageFile forKey:@"profilePictureSmall"];
            
            
            [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    NSLog(@"image uploaded successfully");
                }
                else{
                    // Log details of the failure
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }];
        }
        else{
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }
     ];
    
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


-(void) CheckForRefresh
{
    NSDate *today = [NSDate date];
    
   //compare to last collect date if last collect date not null.
    
    if(lastCollectDate ==nil)
    {
        //give refresh
        lastCollectDate = today;
        [self addUserInfluence:0 withType:1];
        
        return;
        
    }
    
    NSInteger hourdiff = [self getDateDiffHours:lastCollectDate];
    
    if(hourdiff>=24)
    {
        //do refresh
        
        self.collectsRemaining = [NSNumber numberWithInteger:10];
        PFUser *user = [PFUser currentUser];
        
        [user setObject:collectsRemaining forKey:@"CollectsRemaining"];
        
        [user saveInBackground];
        
        
    }
    
}

-(void) SessionStartFunData
{
    
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
    
    NSInteger myinterval = 60*20;
    
    float fnusermaxhearts = [self.usermaxhearts floatValue];
    float returnedhtotal = 0;
    
    if(fnusermaxhearts>=5)
    {
        fnusermaxhearts=5;
        
    }
    
    if(time>=myinterval)
    {
        float calchearts = floorf(time/myinterval);
        
        returnedhtotal = [fd RestoreMultipleHearts:fnusermaxhearts withthismany:calchearts];
       
        NSLog(@"This many hearts after restore on initial session setup: %f",returnedhtotal);
        
        if (returnedhtotal==fnusermaxhearts || returnedhtotal >=5)
        {
            TimerTicks=0;
            
            return;
        }

        
    }
    returnedhtotal = [[fd GetNumHearts] floatValue];
    
    if (returnedhtotal==fnusermaxhearts || returnedhtotal >=5)
    {
        TimerTicks=0;
        
        return;
    }

    
    NSInteger remainingtime = myinterval-time;
    
    
    
    if (remainingtime>0)
    {
        if(remainingtime<myinterval)
        {
            TimerTicks = floor(remainingtime/10);
            
        }
        else
        {
            TimerTicks = floor(myinterval/10);
        }
        
        [self doTimer:TimerTicks];
        
        
    }
    
}


-(void) doLevelUpData
{
   
    NSInteger goldReward =[levelupGoldReward integerValue];
   
    NSInteger gemReward =[ levelupGemReward integerValue];
        NSInteger heartpiecereward =[levelupHeartReward integerValue];
    
    
    userGold = [NSNumber numberWithInt:[userGold integerValue] + goldReward];
    userGems = [NSNumber numberWithInt:[userGems integerValue] + gemReward];
    
    if(heartpiecereward==1)
    {
        usermaxhearts = [NSNumber numberWithFloat:[usermaxhearts floatValue] +0.25];
    }
    
    //need to get the rewards for the next level.  UserXP is now correctly the leftover xp.
    
    [self getlevelupRewardData];
    
    }

-(BOOL) spendUserGems:(NSInteger) gems
{
    int prevusergems = [userGems integerValue];
    
    if (gems<=prevusergems)
    {
        int newusergems = prevusergems-gems;
        
        PFUser *user = [PFUser currentUser];
        [user setObject:[NSNumber numberWithInt:newusergems] forKey:@"Gems"];
        
        self.userGems = [NSNumber numberWithInt:newusergems] ;
        
        [user saveInBackground];
        
        return YES;
        
        
    }
    else
    {
        //user didnt have enough gems.
        //return no.
        
        return NO;
        
    }
    
    
}

-(BOOL) spendUserInfluence:(NSInteger) influence
{
    int prevuserinfluence = [userInfluence integerValue];
    
    if (influence<=prevuserinfluence)
    {
        int newuserinf = prevuserinfluence -influence;
        
        PFUser *user = [PFUser currentUser];
        [user setObject:[NSNumber numberWithInt:newuserinf] forKey:@"influence"];
        
        self.userInfluence = [NSNumber numberWithInt:newuserinf] ;
        
        [user saveInBackground];
        
        return YES;
        
        
    }
    else
    {
        //user didnt have enough gems.
        //return no.
        
        return NO;
        
    }
    
    
}

-(BOOL) addUserInfluence:(NSInteger) influence withType:(NSInteger) inftype
{
   
    int prevuserinfluence = [userInfluence integerValue];
    
        int newuserinf = prevuserinfluence +influence;
        
        PFUser *user = [PFUser currentUser];
        [user setObject:[NSNumber numberWithInt:newuserinf] forKey:@"influence"];
    
    self.userInfluence =[NSNumber numberWithInt:newuserinf];
    
    
    if(inftype==1)
    {
        int prevusertotalcreatorinf = [userTotalCreatorInfluence integerValue];
        
        int newtotalcreainf = prevusertotalcreatorinf+ influence;
        
        [user setObject:[NSNumber numberWithInt:newtotalcreainf] forKey:@"lifetimeSubmitInfluence"];
        self.userTotalCreatorInfluence =[NSNumber numberWithInt:newtotalcreainf];
    }
    if(inftype==2)
    {
        int prevusertotalcreatorinf = [userTotalChampionInfluence integerValue];
        
        int newtotalchmpinf = prevusertotalcreatorinf+ influence;
        [user setObject:[NSNumber numberWithInt:newtotalchmpinf] forKey:@"lifetimeChampionInfluence"];
        self.userTotalChampionInfluence =[NSNumber numberWithInt:newtotalchmpinf];
    }
    
    int prevusertotalinf = [userTotalInfluence integerValue];
    int newtotalinf = prevusertotalinf+ influence;
     [user setObject:[NSNumber numberWithInt:newtotalinf] forKey:@"lifetimeInfluence"];
    
    
        self.userTotalInfluence = [NSNumber numberWithInt:newtotalinf];
    
    NSDate *today = [NSDate date];
    
    [user setObject:today forKey:@"LastCollectDate"];
    self.lastCollectDate = today;
    
    NSInteger collects = [collectsRemaining integerValue];
    collects=collects-1;
    
    self.collectsRemaining = [NSNumber numberWithInt:collects];
    
    [user setObject:collectsRemaining forKey:@"CollectsRemaining"];
    
    
   [user saveInBackground];
        
    return YES;
        
    
    
}

-(BOOL) addUserInfluenceOnCreate:(NSInteger) influence withType:(NSInteger) inftype
{
    
    int prevuserinfluence = [userInfluence integerValue];
    
    int newuserinf = prevuserinfluence +influence;
    
    PFUser *user = [PFUser currentUser];
    [user setObject:[NSNumber numberWithInt:newuserinf] forKey:@"influence"];
    
    self.userInfluence =[NSNumber numberWithInt:newuserinf];
    
    
    if(inftype==1)
    {
        int prevusertotalcreatorinf = [userTotalCreatorInfluence integerValue];
        
        int newtotalcreainf = prevusertotalcreatorinf+ influence;
        
        [user setObject:[NSNumber numberWithInt:newtotalcreainf] forKey:@"lifetimeSubmitInfluence"];
        self.userTotalCreatorInfluence =[NSNumber numberWithInt:newtotalcreainf];
    }
    if(inftype==2)
    {
        int prevusertotalcreatorinf = [userTotalChampionInfluence integerValue];
        
        int newtotalchmpinf = prevusertotalcreatorinf+ influence;
        [user setObject:[NSNumber numberWithInt:newtotalchmpinf] forKey:@"lifetimeChampionInfluence"];
        self.userTotalChampionInfluence =[NSNumber numberWithInt:newtotalchmpinf];
    }
    
    int prevusertotalinf = [userTotalInfluence integerValue];
    int newtotalinf = prevusertotalinf+ influence;
    [user setObject:[NSNumber numberWithInt:newtotalinf] forKey:@"lifetimeInfluence"];
    
    
    self.userTotalInfluence = [NSNumber numberWithInt:newtotalinf];
    
    
    [user saveInBackground];
    
    return YES;
    
    
    
}

-(void)LossCostReset
{
    PFUser *user = [PFUser currentUser];
    [user setObject:[NSNumber numberWithInt:1] forKey:@"gemCheatCost"];
    
    
    [user saveInBackground];
    
    
    self.lossCost = [NSNumber numberWithInt:1];
    
}


-(void)LossCostIncrease:(NSNumber *) lcost
{
    NSInteger curcost = [lcost integerValue];
    NSInteger newcost;
    if (curcost ==1)
    {
        newcost =2;
    }
    
    if (curcost ==2)
    {
        newcost =4;
    }
    
    if (curcost ==4)
    {
        newcost =12;
    }
    if (curcost ==12)
    {
        newcost =25;
    }
    if (curcost ==25)
    {
        newcost =99;
    }
    if (curcost ==99)
    {
        newcost =99;
    }
    
    self.lossCost = [NSNumber numberWithInt:newcost];
    //loss cost saved to user on the loss screen.  
    
}

-(void)doTimer:(NSUInteger) ticks;
{
    NSLog(@"doing a timer");
    
    if(!countdownTimer)
    {
        TimerTicks = ticks;
        NSLog(@"timer ticks re set");
        
        
        countdownTimer = [NSTimer scheduledTimerWithTimeInterval: 10.0 target:self selector:@selector(mehandleTimerTick) userInfo:nil repeats:YES];
        
        
    }
    
    
    
    
    
    
}



-(void)mehandleTimerTick
{
   TimerTicks--;
    
    //delegate method--update the top bar with the number
    
    if(TimerTicks==0)
    {
        [countdownTimer invalidate];
        countdownTimer = nil;
        
        
    }
    
    if(self.pddelegate !=nil)
    {
    [self.pddelegate DoTimerTick:TimerTicks];
    }
    
    
}

-(void)reduceticks
{
    TimerTicks = 1;
    
}

-(NSUInteger) getticknum
{
    return TimerTicks;
    
}


@end
