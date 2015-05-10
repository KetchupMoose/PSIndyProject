//
//  ContentVotingViewController.m
//  funnyBusiness
//
//  Created by Macbook on 2013-10-18.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

//Please note the following relationships in this class.
//This viewcontroller is hosting a container called stage, which on load is filled with the contents of a VoteScreenCollectionView
//The Vote Screen Collection View is a subclass of PS Collection View, extending functionality from that.
//This View Controller will control the data side of things, getting Parse data on load and giving it to its child VoteScreenCollectionView to load cells.


//If a user submits a vote, the button vote is taken from a VoteScreenCollectionViewCell, passed to its delegate the VoteScreenCollectionView, which finally passes the data to be sent for the vote back to here.

//On this view controller, an array of ChallengePool objects are loaded.  There may come a time to reset these, after which the VoteScreenCollectionView should be reset also.  Within these challenge pool objects, there is a set of four funPhotoObjects with indexes funPhotoObj1, 2, 3, and 4.

//Animations and added details to be displayed above the individual cells should be added via the VoteScreenCollectionView class after certain actions.

#import "ContentVotingViewController.h"
#import "VoteScreenCollectionViewCell.h"
#import "TopBarViewController.h"
#import "VoteScreenCollectionView.h"
#import "VoteSummaryViewController.h"
#import "UITabBarController+TabBarControl.h"
#import "UIView+Animation.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import <QuartzCore/QuartzCore.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
@interface ContentVotingViewController ()

@end

@implementation ContentVotingViewController
@synthesize contentObjectsArray;
@synthesize categoryChallengeArray;


TopBarViewController *nametopbar;
VoteScreenCollectionView *vsCV;
PopupViewController *pvc;
WelcomeScreenViewController *wvc;
CategorySelectViewController *cvc;
TestLoadViewController *tvc;

int maxiPhoneWidth = 150;
int maxiPhoneHeight =170;
bool background = FALSE;
bool frames= FALSE;

//int maxiPhoneHeight =112;

//challenge index var counts the nth object in the series of challenge pools we are filling in the contentobjectsarray
NSInteger challengeindexvar = 0;
NSInteger challengemode = 0;
NSInteger winsinarow =0;
NSInteger challengescore;

NSInteger tabbarmode = 3;
UIButton *tabbarcontrol;
UIView *darkview;
NSMutableArray *challengevotes;
MBProgressHUD * HUD;
MBProgressHUD * HUD1;
UIView *alphaview;
UIView *refillhearts;

UIView *buymoregems;

BOOL expanding = FALSE;
NSInteger loadsdone = 0;


NSInteger firstrun=0;
NSInteger blah=0;
static int curveValues[] = {
    UIViewAnimationOptionCurveEaseInOut,
    UIViewAnimationOptionCurveEaseIn,
    UIViewAnimationOptionCurveEaseOut,
    UIViewAnimationOptionCurveLinear };


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.categoryChallengeArray = [[NSMutableArray alloc] init];
    
    
    if(background==true)
    {
        
    
    NSString *bgfileName = [[NSBundle mainBundle] pathForResource:@"blue-backgroundnosections" ofType:@"png"];
    UIImage *background =[UIImage imageWithContentsOfFile:bgfileName];
    
    UIImage *myb = [self imageWithImage:background scaledToSize:self.view.frame.size];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:myb]];
    }
    
    HUD1 = [[MBProgressHUD alloc] initWithView:self.view];
    [self.stage addSubview:HUD1];
    
    // Set determinate mode
    /*
    HUD1.mode = MBProgressHUDModeDeterminate;
    HUD1.delegate = self;
    HUD1.labelText = @"Loading Challenges";
    [HUD1 show:YES];
     */
    //hide hte tab bar controller
   
    //CGRect myframe = self.view.frame;
    
    //CGFloat tabheight = self.tabBarController.tabBar.frame.size.height;
    
    
    //self.tabBarController.tabBar.frame = CGRectMake(0, myframe.size.height + tabheight, 320, tabheight);
    
   
    vsCV = [[VoteScreenCollectionView alloc] initWithFrame:self.stage.frame];
    
    vsCV.delegate = self; // This is for UIScrollViewDelegate
    vsCV.vscollectionViewDelegate = self;  //this is for my votescreen subclass
    
    
    vsCV.collectionViewDelegate = self;
    //this is for core PSCollectionView functionality, which vsCV has extended by its subclass
    vsCV.collectionViewDataSource = self;
    
    
   // vsCV.backgroundColor = [UIColor colorWithRed:(210/255.0) green:(210/255.0) blue:(210/255.0) alpha:1];
    vsCV.backgroundColor = [UIColor clearColor];
    
    self.stage.backgroundColor = [UIColor clearColor];
    
    
    vsCV.autoresizingMask = ~UIViewAutoresizingNone;
    
    // Specify number of columns for both iPhone and iPad
    
    vsCV.numColsPortrait = 2;
    vsCV.numColsLandscape = 2;
    
    vsCV.tag=43;
    
    challengevotes = [[NSMutableArray alloc] init];

    
    //init the popup view controller and set its delegate
    pvc = [self.storyboard instantiateViewControllerWithIdentifier:@"popup1"];
    pvc.popdelegate = self;
    [self addChildViewController:pvc];
    
    /*
    cvc = [self.storyboard instantiateViewControllerWithIdentifier:@"categoryscreen"];
    cvc.csdelegate = self;
    [self addChildViewController:cvc];
    */
     
    CategorySelectViewController *generic = [self.storyboard instantiateViewControllerWithIdentifier:@"testsbload"];
 generic.csdelegate = self;
    [self addChildViewController:generic];
   
    
    
    // UIImage *pickfaveimg = [UIImage imageNamed:@"piccitscreen.png"];
    
    // pvc.imgforpopup = pickfaveimg;
    //add an black view with an alpha I can take out afterwards..
    
    darkview = [[UIView alloc] initWithFrame:self.view.frame];
    
    darkview.backgroundColor = [UIColor blackColor];
    
    darkview.alpha =0.3;
    
    //code to add top bar to container
    
    nametopbar=[self.storyboard instantiateViewControllerWithIdentifier:@"topbar"];
    
    [self addChildViewController:nametopbar];
    
    [self.topbarcontainer addSubview:nametopbar.view];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        nametopbar.view.frame = CGRectMake(0, 0, 320, 40);
    }
    else
    {
        nametopbar.view.frame = CGRectMake(0, 0, 768, 80);
    }
    
    self.topbarcontainer.backgroundColor = [UIColor clearColor];

    [self.view addSubview:darkview];
    [self.view addSubview:pvc.view];
    
    [self.view addSubview:generic.view];
    
    //[self.view addSubview:cvc.view];
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

// Method implementations
- (void)hideTabBar:(UITabBarController *) tabbarcontroller
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    
    for(UIView *view in tabbarcontroller.view.subviews)
    {
        if([view isKindOfClass:[UITabBar class]])
        {
            [view removeFromSuperview];
        }
        else
        {
           // [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 480)];
        }
    }
    
    [UIView commitAnimations];
}

- (void)viewDidLayoutSubviews
{
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
            
            self.stage.frame = CGRectMake(self.stage.frame.origin.x,self.stage.frame.origin.y+50,self.stage.frame.size.width,self.stage.frame.size.height);
            
            
            
        }
    }
    
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        pvc.view.frame = CGRectMake(75,70,pvc.view.frame.size.width,pvc.view.frame.size.height);
    }
    else
    {
        pvc.view.frame = CGRectMake(36,20,pvc.view.frame.size.width,pvc.view.frame.size.height);
    }

    //@this code was originally in view will appear...need to try to figure out why it's not takin' the proper frame for the popup.
    /*
    if (firstrun==0)
    {
        
        
      //  float popx = (320-pvc.view.frame.size.width)/2;
        
        //pvc.view.frame = CGRectMake(0,0,pvc.view.frame.size.width,pvc.view.frame.size.height);
        
        //pvc.view.center = self.view.center;
        
        firstrun=1;
        
    }
     */
}

- (void)viewDidAppear:(BOOL)animated
{
    //AppDelegate *myad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //myad.firstload=YES;
    
    
    
	// Do any additional setup after loading the view.
    
    
    if(firstrun==0)
    {
        
    
        
    
        firstrun=2;
        
    }
    //holder area: this is where the delegate function took over for loading..
   
    
    if (contentObjectsArray.count <1)
    {
           //[self getObjectsToVote];
        
        //popup a view controller saying theres no content and suggest they come back later
        
        //[[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Out Of Content", nil) message:NSLocalizedString(@"Come Back Later To Vote More!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
        //return;
    }
    
    //commenting out this code basically because I am no longer showing/hiding the bottom bar.
    if(tabbarmode ==5)
    {
    
    tabbarcontrol = [[UIButton alloc] init];
    [tabbarcontrol setImage:[UIImage imageNamed:@"show-button.png"] forState:UIControlStateNormal];
    
    tabbarcontrol.frame = CGRectMake(300,self.view.frame.size.height-20,20,20);
    
        [tabbarcontrol addTarget:self action:@selector(switchTabBar)
                forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:tabbarcontrol];
    
    [self.view bringSubviewToFront:tabbarcontrol];
    }
    
    if(tabbarmode ==77)
    {
        tabbarcontrol = [[UIButton alloc] init];
        [tabbarcontrol setImage:[UIImage imageNamed:@"hide-button.png"] forState:UIControlStateNormal];
        
        
        
        tabbarcontrol.frame = CGRectMake(300,self.view.frame.size.height-20,20,20);
        
        [tabbarcontrol addTarget:self action:@selector(switchTabBar)
                forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:tabbarcontrol];
        
        [self.view bringSubviewToFront:tabbarcontrol];
    }

    [super viewDidAppear:YES];
    
}

- (void) switchTabBar
{
    if(tabbarmode==0)
    {
        tabbarmode=1;
        //show tab bar
        [self.tabBarController.tabBar moveTo:CGPointMake(0,self.view.frame.size.height-49) duration:2.0 option:UIViewAnimationOptionCurveLinear];
        
    }
    
    else
    
    {
        tabbarmode =0;
        //remove tab bar by animating/translation
        
        [self.tabBarController.tabBar moveTo:CGPointMake(0,600) duration:2.0 option:UIViewAnimationOptionCurveLinear];
    }
}

- (void)StartLoadingData:(WelcomeScreenViewController *) thiswvc
{
   
    
        [self getObjectsToVote];
        
        [HUD1 hide:YES];
 
    
    [nametopbar TopBarRefreshLabels];
    
    
}

-(void) loadCategoryObjects
{
    if(self.categoryChallengeArray.count>0)
    {
        self.contentObjectsArray = self.categoryChallengeArray;
        [vsCV removeFromSuperview];
        [self finishsetupcategories];
    }
   
    
}

- (void) getObjectsToVote
{
     self.contentObjectsArray = [[NSMutableArray alloc] init];
    [vsCV removeFromSuperview];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.stage addSubview:HUD];
    
    // Set determinate mode
    HUD.mode = MBProgressHUDModeDeterminate;
    HUD.delegate = self;
    HUD.labelText = @"Loading Challenges";
    [HUD show:YES];
    
    //get ten funPhotoChallengePool objects the user has not voted on yet
    
    //vote history appears in UserVoteChallenges
    PFUser *user = [PFUser currentUser];
    
    PFQuery * cpquery = [PFQuery queryWithClassName:@"funPhotoChallengePool"];
    
    PFQuery *votehistoryquery = [PFQuery queryWithClassName:@"UserVoteChallenges"];
    [votehistoryquery whereKey:@"Voter" equalTo:user];
    [votehistoryquery includeKey:@"funPhotoChallengePool"];
    [votehistoryquery orderByDescending:@"createdAt"];
    votehistoryquery.limit = 500;
    NSNumber *rank1 = [NSNumber numberWithInt:1];
    
    //this part isn't working..debug
    //workaround explained here
    //https://parse.com/questions/trouble-with-nested-query-using-objectid
    [cpquery whereKey:@"objectId" doesNotMatchKey:@"funPhotoChallengePoolString" inQuery:votehistoryquery];
    [cpquery whereKey:@"rank" equalTo:rank1];
    [cpquery orderByDescending:@"createdAt"];
    [cpquery includeKey:@"funPhotoObj1"];
    [cpquery includeKey:@"funPhotoObj2"];
    [cpquery includeKey:@"funPhotoObj3"];
    [cpquery includeKey:@"funPhotoObj4"];

    int querylimit = 15;
    
    NSInteger *querylimitnum = &querylimit;
    
    cpquery.limit = *querylimitnum ;
    
    //NSArray *freepassobjs;
   [cpquery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
       if  (!error)
       {
           [self.contentObjectsArray addObjectsFromArray:objects];
           loadsdone = loadsdone+1;
           [self finishsetup];
       }
   }];
    
    
    //normal objs
    PFQuery * cpqueryr2 = [PFQuery queryWithClassName:@"funPhotoChallengePool"];
    
    
    NSNumber *rank2 = [NSNumber numberWithInt:2];
    
    //this part isn't working..debug
    //workaround explained here
    //https://parse.com/questions/trouble-with-nested-query-using-objectid
    [cpqueryr2 whereKey:@"objectId" doesNotMatchKey:@"funPhotoChallengePoolString" inQuery:votehistoryquery];
    [cpqueryr2 whereKey:@"rank" equalTo:rank2];
    [cpqueryr2 orderByDescending:@"createdAt"];
    [cpqueryr2 includeKey:@"funPhotoObj1"];
    [cpqueryr2 includeKey:@"funPhotoObj2"];
    [cpqueryr2 includeKey:@"funPhotoObj3"];
    [cpqueryr2 includeKey:@"funPhotoObj4"];
    
    int r2querylimit = 25;
    
    NSInteger *query2limitnum = &r2querylimit;
    
    cpqueryr2.limit = *query2limitnum ;
    
    [cpqueryr2 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if  (!error)
        {
            [self.contentObjectsArray addObjectsFromArray:objects];
            loadsdone=loadsdone+1;
            [self finishsetup];
        }
    }];
    
    
    //difficult objs
    PFQuery * cpqueryr3 = [PFQuery queryWithClassName:@"funPhotoChallengePool"];
    
    
    NSNumber *rank3 = [NSNumber numberWithInt:3];
    
    //this part isn't working..debug
    //workaround explained here
    //https://parse.com/questions/trouble-with-nested-query-using-objectid
    [cpqueryr3 whereKey:@"objectId" doesNotMatchKey:@"funPhotoChallengePoolString" inQuery:votehistoryquery];
    [cpqueryr3 whereKey:@"rank" equalTo:rank3];
    [cpqueryr3 orderByDescending:@"createdAt"];
    [cpqueryr3 includeKey:@"funPhotoObj1"];
    [cpqueryr3 includeKey:@"funPhotoObj2"];
    [cpqueryr3 includeKey:@"funPhotoObj3"];
    [cpqueryr3 includeKey:@"funPhotoObj4"];
    
    int r3querylimit = 10;
    
    NSInteger *query3limitnum = &r3querylimit;
    
    cpqueryr3.limit = *query3limitnum ;
    
    [cpqueryr3 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if  (!error)
        {
            [self.contentObjectsArray addObjectsFromArray:objects];
            loadsdone=loadsdone+1;
            [self finishsetup];
        }
    }];

    //getting category objs
    
    PFQuery * cpqueryc1 = [PFQuery queryWithClassName:@"funPhotoChallengePool"];
    
    NSNumber *rankc1 = [NSNumber numberWithInt:101];
    
    //this part isn't working..debug
    //workaround explained here
    //https://parse.com/questions/trouble-with-nested-query-using-objectid
    [cpqueryc1 whereKey:@"objectId" doesNotMatchKey:@"funPhotoChallengePoolString" inQuery:votehistoryquery];
    [cpqueryc1 whereKey:@"rank" equalTo:rankc1];
    [cpqueryc1 orderByDescending:@"createdAt"];
    [cpqueryc1 includeKey:@"funPhotoObj1"];
    [cpqueryc1 includeKey:@"funPhotoObj2"];
    [cpqueryc1 includeKey:@"funPhotoObj3"];
    [cpqueryc1 includeKey:@"funPhotoObj4"];
    
    int c1querylimit = 15;
    
    NSInteger *queryc1limitnum = &c1querylimit;
    
    cpqueryc1.limit = *queryc1limitnum ;
    
    [cpqueryc1 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if  (!error)
        {
            [self.contentObjectsArray addObjectsFromArray:objects];
           
            loadsdone=loadsdone+1;
            [self finishsetup];
            
        }
    }];
   
    
    /*
    [self.contentObjectsArray addObjectsFromArray:categoryobjs];
    [self.contentObjectsArray addObjectsFromArray:normalobjs];
     [self.contentObjectsArray addObjectsFromArray:rank3objs];
     [self.contentObjectsArray addObjectsFromArray:freepassobjs];
    */
   
    //NSLog(@"%i",self.contentObjectsArray.count);
    
  

    
  
    
    //commented out to speed up code, could be put back in to check on the lists
    /*
    for (int i =0;i<contentObjectsArray.count;i++)
    {
        PFObject *myobj = contentObjectsArray[i];
        
        NSLog(@"%@",myobj.objectId);
        
    }
     */
    
    
    //self.contentobjectsarray=results
}

-(void)finishsetup
{
    
    if (loadsdone<4)
    {
        return;
        
    }
    
    loadsdone=0;
    
    if(self.contentObjectsArray.count ==0)
    {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Out Of Content", nil) message:NSLocalizedString(@"Come Back Later To Vote More!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
        return;
        
    }
    
    NSLog(@"%i",self.contentObjectsArray.count);
    
    //shuffle and deal.
    //truffle shuffle!--defined in category
    [self.contentObjectsArray shuffle];
    
    [HUD hide:YES];
    
    PFObject *nextobj = self.contentObjectsArray[challengeindexvar];
    
    NSInteger nextrank = [[nextobj objectForKey:@"rank"] integerValue];
    
    //add some displays to the subview depending on the rank
    
    
    [self.stage addSubview:vsCV];
    
    [self setChallengeFrames:nextrank];
    
    
    vsCV.autoresizesSubviews = NO;
    
    vsCV.frame=self.stage.bounds;
    
    vsCV.backgroundColor = [UIColor clearColor];
    
    
    vsCV.vscontentObjectsArray =[self.contentObjectsArray mutableCopy];
    
    [vsCV reloadData:vsCV];
    
    [self setChallengeVotes];

    
}

-(void)finishsetupcategories

{
    
    
    if(self.contentObjectsArray.count ==0)
    {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Out Of Content", nil) message:NSLocalizedString(@"Come Back Later To Vote More!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
        return;
        
    }
    
    NSLog(@"%i",self.contentObjectsArray.count);
    
    //shuffle and deal.
    //truffle shuffle!--defined in category
    [self.contentObjectsArray shuffle];
    
    [HUD hide:YES];
    
    PFObject *nextobj = self.contentObjectsArray[challengeindexvar];
    
    NSInteger nextrank = [[nextobj objectForKey:@"rank"] integerValue];
    
    //add some displays to the subview depending on the rank
    
    
    [self.stage addSubview:vsCV];
    
    [self setChallengeFrames:nextrank];
    
    
    vsCV.autoresizesSubviews = NO;
    
    vsCV.frame=self.stage.bounds;
    
    vsCV.backgroundColor = [UIColor clearColor];
    
    
    vsCV.vscontentObjectsArray =[self.contentObjectsArray mutableCopy];
    
    [vsCV reloadData:vsCV];
    
    [self setChallengeVotes];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//PSCollectionView Data Source Required Methods

- (NSInteger)numberOfRowsInCollectionView:(VSCollectionView *)collectionView {
    
    //change this to a property I can set via the results of the query.
    NSInteger numofcellrows = 4;
    
    return numofcellrows;
    
    
}

//this method allows me to transform the downloaded image before it is used by the UIImageView.

- (UIImage *)imageManager:(SDWebImageManager *)imageManager transformDownloadedImage:(UIImage *)image withURL:(NSURL *)imageURL
{
    
    if(expanding==TRUE)
    {
        expanding =FALSE;
        
        return image;
    
    }
    
    
    int maxw;
    int maxh;
    
    
    
     if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
     {
         maxw = maxiPhoneWidth;
         maxh = maxiPhoneHeight;
     }
    else
    {
        maxw = 350;
        maxh = 300;
    }
    
    CGSize sizeobj = image.size;
    
    
    CGSize sizeforimgcontainer = *[self scalesize:&sizeobj maxWidth:maxw maxHeight:maxh];
    //reduce the image to its proper size.
    
    image=[self imageWithImage:image scaledToSize:sizeforimgcontainer];
    
    return image;
    
    
}

- (UIView *)collectionView:(VSCollectionView *)collectionView cellForRowAtIndex:(NSInteger)index withRect:(CGRect) expectedRect {
    
    VoteScreenCollectionViewCell *cell = [[VoteScreenCollectionViewCell alloc] init];
    
    
    
    //(VoteScreenCollectionViewCell *)
    //[collectionView dequeueReusableViewForClass:[VoteScreenCollectionViewCell class]];
    //if (cell == nil) {
       // NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"VoteScreenCollectionViewCell" owner:self options:nil];
        
        //cell = (VoteScreenCollectionViewCell *)[nib objectAtIndex:0];
    
        
        cell.autoresizingMask = UIViewAutoresizingNone;
        
        cell.autoresizesSubviews = NO;
    //46 49 146 navy blue for browse title
    UIColor *mytbcolor = [UIColor colorWithRed:46/255.0 green:49/255.0 blue:146/255.0 alpha:1];
    
    //changing...check for iPad
    cell.layer.borderColor = mytbcolor.CGColor;
    cell.layer.borderWidth = 1.0f;
        cell.frame = expectedRect;
    
        //move sizing code for sub components of cells here
        PFObject *challengepoolsobj = [self.contentObjectsArray objectAtIndex:challengeindexvar];
        
        NSString *cellIndexString = [NSString stringWithFormat:@"%i", index +1 ];
        NSString *keystring = @"funPhotoObj";
        
        NSString *concatenatedCellObjString = [keystring stringByAppendingString:cellIndexString];
        
        PFObject *cellDataObj = [challengepoolsobj objectForKey:concatenatedCellObjString];
        
        
        //cell.cellText.text = [cellDataObj objectForKey:@"Caption"];
        //cell.cellImage.file = [cellDataObj objectForKey:@"imageFile"];
        
        //resetting layout of controls to resize appropriate to image
        //get the cell image size from the balancing function
        float imgheight = [[cellDataObj  objectForKey:@"imgHeight"] floatValue];
        float imgwidth = [[cellDataObj objectForKey:@"imgWidth"] floatValue];
        
    int maxw;
    int maxh;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
      
        maxw = maxiPhoneWidth;
        maxh = maxiPhoneHeight;
        
       
    }
    else
    {
        maxw = 350;
        maxh = 300;
    }
    
        CGSize currentsize = CGSizeMake(imgwidth,imgheight);
        CGSize * sizeobj = &currentsize;
        
        
        CGSize *sizeforimgcontainer = [self scalesize:sizeobj maxWidth:maxw maxHeight:maxh];
        
        //need to take this image size and calculate the proper fuggin aspect ratio to get the real height to show now
        
        CGSize newsize = *sizeforimgcontainer;
        
    
    //allocs
    
    //come back to set font size dynamically based on text.
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
     {
        cell.thecelltxt = [[UILabel alloc] initWithFrame:CGRectMake(0,0,150,20)];
          cell.thecelltxt.numberOfLines=1;
         [cell.thecelltxt setFont:[UIFont fontWithName:@"CooperBlackStd" size:15]];
     }
    else
    {
        cell.thecelltxt = [[UILabel alloc] initWithFrame:CGRectMake(5,0,350,40)];
         cell.thecelltxt.numberOfLines=2;
        [cell.thecelltxt setFont:[UIFont fontWithName:@"HelveticaNeue-LightItalic" size:15]];
    }
    
    
    cell.thecelltxt.text = [cellDataObj objectForKey:@"Caption"];

    cell.thecelltxt.textAlignment = NSTextAlignmentCenter;
   
    
    //NSInteger rankint = [[cellDataObj objectForKey:@"challengeRank"] integerValue];
    
    float imgcellxpos;
    
    imgcellxpos=0;
    float imgypos =0;
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        
   
    if(newsize.width<150)
    {
        imgcellxpos = (maxw-newsize.width)/2;
    }
    else
    {
        imgcellxpos=0;
    }
    
   imgypos = (maxh-newsize.height)/2 + 21;
    }
    //ipad
   
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        
        
        if(newsize.width<350)
        {
            imgcellxpos = (maxw-newsize.width)/2;
            
        }
        else
        {
            imgcellxpos=0;
        }
        imgypos = (maxh-newsize.height)/2 + 41;
        
    }
    
    cell.theImgView = [[UIImageView alloc] initWithFrame:CGRectMake(imgcellxpos,imgypos,newsize.width, newsize.height)];
    
    NSString *imglink = [cellDataObj objectForKey:@"imgLink"];
    NSString *imgurl;
    if(imglink.length<2)
    {
        PFFile *mydata = [cellDataObj objectForKey:@"imageFile"];
        imgurl = mydata.url;
        
    }
    else
    {
        imgurl =imglink;
    }
    
    NSString *imgtype = [cellDataObj objectForKey:@"imgURType"];
    
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
    UIActivityIndicatorViewStyle activityStyle = UIActivityIndicatorViewStyleGray;
    
    
    
    [cell.theImgView setImageWithURL:[NSURL URLWithString:imgurl] placeholderImage:cellplaceholder options:SDWebImageRetryFailed usingActivityIndicatorStyle:(UIActivityIndicatorViewStyle)activityStyle];
    
   
     if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
     {
          cell.thevotebtn = [[UIButton alloc] initWithFrame:CGRectMake(12,24 +maxh,121.0,34.0)];
     }
    else
    {
           cell.thevotebtn = [[UIButton alloc] initWithFrame:CGRectMake(83,340,185.0,70.0)];
    }
       
    cell.thevotebtn.tag = index+1;
    
    cell.backgroundColor =[UIColor whiteColor];
    cell.thecelltxt.backgroundColor = [UIColor whiteColor];
    cell.theImgView.backgroundColor = [UIColor whiteColor];
     cell.thevotebtn.backgroundColor = [UIColor clearColor];
    
    
   
    NSString *filebtn = [[NSBundle mainBundle] pathForResource:@"pick-fave-new-design2" ofType:@"png"];
  
    UIImage *btnimg = [UIImage imageWithContentsOfFile:filebtn];
    
    [cell.thevotebtn setImage:btnimg forState:UIControlStateNormal];
    
    //[cell.thevotebtn setTitle:@"Pick Favorite" forState:UIControlStateNormal];
    [cell.thevotebtn setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cell.thevotebtn addTarget:cell action:@selector(doaclick:) forControlEvents:UIControlEventTouchUpInside];
    
   // need a method to set the shadow insets
  
    //[cell.thevotebtn setBackgroundImage:[UIImage imageNamed:@"btn_12.png"] forState:UIControlStateNormal];
    
    [cell addSubview:cell.thecelltxt];
    [cell addSubview:cell.theImgView];
    [cell addSubview:cell.thevotebtn];
    
        cell.VoteScreenCollectionViewCellDelegate = vsCV;
        
        cell.layer.cornerRadius = 9.0;
        cell.layer.masksToBounds = YES;
        
    
       //NSLog(@"got it: %i", index);
    
    return cell;
}

-(void) setChallengeVotes
{
    [challengevotes removeAllObjects];
    
    PFObject *challengepoolsobj = [self.contentObjectsArray objectAtIndex:challengeindexvar];
    
    for (int index=0;index<4;index++)
    {
   
    NSString *voteindexString = [NSString stringWithFormat:@"%i", index + 1];
    NSString *votekeystring = @"funPhotoObj";
    
    NSString *concatenatedVoteObjString = [votekeystring stringByAppendingString:voteindexString];
    
    NSString *votestring = @"Votes";
    
    NSString *totalvotestring = [concatenatedVoteObjString stringByAppendingString:votestring];
    
    
    NSNumber *votetotal = [challengepoolsobj objectForKey:totalvotestring];
    
        float thisvote= [votetotal floatValue];
        
        NSNumber *addvote = [NSNumber numberWithFloat:thisvote];
        
        
    [challengevotes addObject:addvote];
    
    //NSLog(@"added challenge vote: %i", challengevotes.count);
    
    //copying the array to the childviewcontroller also
    vsCV.vschallengeVotes = challengevotes;
    }
}

- (CGFloat)collectionView:(VSCollectionView *)collectionView heightForRowAtIndex:(NSInteger)index {
    
  
    CGFloat retval;
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
          retval = 350 +62.0;
    }
    else
    {
         retval = 112 +82.0;
    }
 
    
    return retval;
}

-(CGSize *)scalesize:(CGSize *)imgsize maxWidth:(int) maxWidth maxHeight:(int) maxHeight
{
    
    CGFloat width = imgsize->width;
    
    CGFloat height = imgsize->height;
    
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
    
    if (newsize.height> maxHeight)
    {
        CGFloat maxratio = newsize.height/maxHeight;
        if (maxratio >1)
        {
            newsize.width = newsize.width/maxratio;
            newsize.height = maxHeight;
        }
        
    }
    
    //make sure to enforce a maximum height on upload so you dont get fkin nonsense.
    
    CGSize * size = &newsize;
    
    
    return size;
    
}


- (void)FrontPageSelectionViewControllerBackToFrontPage:
(FrontPageSelectionViewController *)controller
{
    
    [self.navigationController popViewControllerAnimated:YES];
}


-(void) playRevealAnimations
{
    int i = 0;
    for (VSCollectionViewCell *cell in vsCV.subviews)
    {
        //play animations for popularity.
       i = i+1;
        
        UILabel *votepercent = [[UILabel alloc] initWithFrame:(CGRectMake((cell.frame.size.width/2)-60,(cell.frame.size.height/2)-50,180,120))];
        
        votepercent.text = @"20%";
        votepercent.font = [UIFont fontWithName:@"CooperBlackStd" size:60];
        
        votepercent.backgroundColor = [UIColor clearColor];
        
        
        votepercent.textColor = [UIColor greenColor];
        
        [cell BounceAddTheView:votepercent];
        
        
        
    }
    
   
    
}


//PScollectionview optional delegate methods

- (void)collectionView:(VSCollectionView *)collectionView didSelectCell:(VSCollectionViewCell *)cell atIndex:(NSInteger)index
{
    
    
    if(challengemode==0)
    {
        
        UIImageView *voteheartview = [[UIImageView alloc] initWithFrame:(CGRectMake((cell.frame.size.width/2)-32,(cell.frame.size.height/2)-32,64,64))];
        
        [voteheartview setImage:[UIImage imageNamed:@"heartvote.png"]];
        
        voteheartview.contentMode = UIViewContentModeScaleAspectFit;
        
        if (index==0)
        {
            [cell SpinAView:cell];
        }
        else if(index>=2)
        {
            [cell SpinThenAdd:cell withHeartView:voteheartview];
            
        }
        else
        {
            [cell addHeartThenSpin:voteheartview withCellView:cell];
        }

        challengemode=1;
    
    }
    
    
    else
        
    {
        [self playRevealAnimations];
        
        VSCollectionViewCell *baseview = cell;
        float x=0;
        float y =0;
        int j = index;
        [collectionView bringSubviewToFront:baseview];
        
        if(index==3)
        {
            x = baseview.frame.origin.x-(baseview.frame.size.width/2);
            y = baseview.frame.origin.y-(baseview.frame.size.height/2);
        }
        else if(index==2)
        {
            x = baseview.frame.origin.x+(baseview.frame.size.width/2);
            y = baseview.frame.origin.y-(baseview.frame.size.height/2);
        }
        else if(index==1)
        {
            
            x = baseview.frame.origin.x-(baseview.frame.size.width/2);
            y = baseview.frame.origin.y+(baseview.frame.size.height/2);
        }
        else if(index==0)
        {
            x = baseview.frame.origin.x+(baseview.frame.size.width/2);
            y = baseview.frame.origin.y+(baseview.frame.size.height/2);
        }
        
        CGPoint neworigin = CGPointMake(x,y);
        
        [baseview GrowAView:baseview WithNewOrigin:neworigin];
        //play animations for popularity.
        /*
          UILabel *votepercent = [[UILabel alloc] initWithFrame:(CGRectMake((cell.frame.size.width/2)-60,(cell.frame.size.height/2)-50,180,120))];
        
        votepercent.text = @"20%";
        votepercent.font = [UIFont fontWithName:@"CooperBlackStd" size:60];
        
        votepercent.backgroundColor = [UIColor clearColor];
        
        
        votepercent.textColor = [UIColor greenColor];
        
        [cell BounceAddTheView:votepercent];
         */
        challengemode=0;
        
        //after displaying each popularity, make one bigger then crumble them away to reveal the next pics.
        /*
        float x = cell.frame.origin.x-(cell.frame.size.width/2);
        float y = cell.frame.origin.y-(cell.frame.size.height/2);
        
        CGPoint neworigin = CGPointMake(x,y);
        
        [cell GrowAView:cell WithNewOrigin:neworigin];
        */
        
        
    }
    
    //[cell BounceAddTheView:voteheartview];

    //[cell SpinAView:cell];
    
    
    
    
    
    /*
     
    //invoke something with the selected cell.
    NSLog(@"selectedcellindex: %i", index);
    
    UIButton *fullimgbtn = [[UIButton alloc] init];
    UIImageView *fullimgview = [[UIImageView alloc] init];
    
    PFObject *challengepoolsobj = [self.contentObjectsArray objectAtIndex:challengeindexvar];
    
    NSString *cellIndexString = [NSString stringWithFormat:@"%i", index +1 ];
    NSString *keystring = @"funPhotoObj";
    
    NSString *concatenatedCellObjString = [keystring stringByAppendingString:cellIndexString];
    
    PFObject *selectedContent = [challengepoolsobj objectForKey:concatenatedCellObjString];
    
    float imgheight = [[selectedContent  objectForKey:@"imgHeight"] floatValue];
    float imgwidth = [[selectedContent objectForKey:@"imgWidth"] floatValue];
    
    int maxw;
    int maxh;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        maxw = 300;
        maxh = 1200;
    }
    else
    {
        maxw = 720;
        maxh = 2000;
    }
    
    CGSize currentsize = CGSizeMake(imgwidth,imgheight);
    CGSize * sizeobj = &currentsize;
    
    CGSize *sizeforimgcontainer = [self scalesize:sizeobj maxWidth:maxw maxHeight:maxh];
    
    //need to take this image size and calculate the proper fuggin aspect ratio to get the real height to show now
    
    CGSize newsize = *sizeforimgcontainer;
    
    //for iphone width
    int xposvalue;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        xposvalue = (320-newsize.width)/2;
        
    }
    else
    {
        xposvalue = (768-newsize.width)/2;
        
    }
   
    UILabel *fullimgtxt = [[UILabel alloc] initWithFrame:CGRectMake(10,10,newsize.width,50)];
    fullimgtxt.numberOfLines = 3;
    fullimgtxt.text = [selectedContent objectForKey:@"Caption"];
    CALayer *txtlayer = fullimgtxt.layer;
    txtlayer.cornerRadius = 4.0f;
    txtlayer.masksToBounds = YES;
    fullimgtxt.tag = 88;
    fullimgtxt.backgroundColor = [UIColor whiteColor];
    fullimgtxt.textAlignment = NSTextAlignmentCenter;
    fullimgtxt.font = [UIFont fontWithName:@"HelveticaNeue-LightItalic" size:16];
    
    
    CGRect btnfra = CGRectMake(10,60,newsize.width,newsize.height);
    fullimgview.frame = btnfra;
    fullimgbtn.frame = btnfra;
    fullimgview.tag = 88;
    fullimgbtn.tag = 88;
    
    [fullimgbtn addTarget:self action:@selector(closeimgexpand) forControlEvents:UIControlEventTouchUpInside];
    expanding =TRUE;
    
    NSString *imglink = [selectedContent objectForKey:@"imgLink"];
    NSString *imgurl;
    if(imglink.length<2)
    {
        PFFile *mydata = [selectedContent objectForKey:@"imageFile"];
        imgurl = mydata.url;
        
    }
    else
    {
        imgurl =imglink;
    }
    
    NSString *imgtype = [selectedContent objectForKey:@"imgURType"];
    
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
    UIActivityIndicatorViewStyle activityStyle = UIActivityIndicatorViewStyleGray;
    
    [fullimgview setImageWithURL:[NSURL URLWithString:imgurl] placeholderImage:cellplaceholder options:SDWebImageRefreshCached usingActivityIndicatorStyle:(UIActivityIndicatorViewStyle)activityStyle];
    
    
    //[self.stage addSubview:fullimgview];
    //[self.stage addSubview:fullimgbtn];
    
    //[self.stage bringSubviewToFront:fullimgview];
    
    if (collectionView.contentSize.height < newsize.height)
    {
        [collectionView setContentSize:CGSizeMake(collectionView.contentSize.width,newsize.height + 80)];
        
    }
  
    [collectionView addSubview:fullimgview];
    [collectionView addSubview:fullimgbtn];
    [collectionView addSubview:fullimgtxt];
    
    [collectionView bringSubviewToFront:fullimgview];
    [collectionView bringSubviewToFront:fullimgbtn];
    [collectionView bringSubviewToFront:fullimgtxt];
    
    
    //[fullimgbtn setBackgroundImage:cell.]
    
    */
    
    
    /*
    //going to try manually instantiating the nav & view controllers and pushing them
    FrontPageSelectionViewController * fps;
    
    //UINavigationController *navcontrol = [self.storyboard instantiateViewControllerWithIdentifier:@"navfrontdetails"];
    
    fps = [self.storyboard instantiateViewControllerWithIdentifier:@"frontPageSelection"];
    
    
    PFObject *challengepoolsobj = [self.contentObjectsArray objectAtIndex:challengeindexvar];
    
    NSString *cellIndexString = [NSString stringWithFormat:@"%i", index +1 ];
    NSString *keystring = @"funPhotoObj";
    
    NSString *concatenatedCellObjString = [keystring stringByAppendingString:cellIndexString];
    
    PFObject *selectedContent = [challengepoolsobj objectForKey:concatenatedCellObjString];
    
    
    fps.delegate = self;
    fps.selectedContent= selectedContent;
    
    
    //fps.parseObjects = self.contentObjectsArray;
    
    //NSNumber *indNum= [NSNumber numberWithInt:(index)];
    
    
    //fps.parseobjindex = indNum;
    
    [self.navigationController pushViewController:fps animated:YES];
    
    //get the PF object selected and invoke a method to segue or popup another form from this cell..
    //Perform a segue.
    
    //[self performSegueWithIdentifier: @"twoPagetoDetailsSegue" sender:self];
    */
    
   
};

-(void) closeimgexpand
{
    for (UIView *view in vsCV.subviews)
    {
        if(view.tag==88)
        {
            [view removeFromSuperview];
        }
    }
}

- (void) doOpenGraphVoteAction:(NSMutableDictionary<FBGraphObject>*) pvote
{
    //vote on the picture
    
    NSMutableDictionary<FBGraphObject> *action = [FBGraphObject graphObject];
    action[@"picture"] = pvote;
    
    [FBRequestConnection startForPostWithGraphPath:@"me/picksomethingapp:vote"
                                       graphObject:action
                                 completionHandler:^(FBRequestConnection *connection,
                                                     id result,
                                                     NSError *error) {
                                     // handle the result
                                     
                                    // NSLog(@"this is the post result:%@ ", [result objectForKey:@"id"]);
                                 }];

}
-(void)closebtnclick:(id)sender
{
    NSLog(@"closebtnclicked");
    
    UIButton *sendbtn = sender;
    UIView *theview = sendbtn.superview;
    
    
    [theview removeWithZoomOutAnimation:1.0 option:UIViewAnimationOptionCurveEaseOut];
    
    [alphaview removeFromSuperview];
    self.stage.userInteractionEnabled = YES;
    
    
}

-(void)buygemsbtnclick:(id)sender
{
    NSLog(@"buy gems butttnclicked");
    
   
    
    //bring up the gold store
    GoldStoreViewController *gsvc = [self.storyboard instantiateViewControllerWithIdentifier:@"gsvc"];
    
    gsvc.goldstoredelegate = self;
    
    [self.navigationController pushViewController:gsvc animated:YES];
    gsvc.view.hidden = NO;
    
    
    UIButton *sendbtn = sender;
    //UIView *theview = sendbtn.superview;
    [buymoregems removeWithZoomOutAnimation:1.0 option:UIViewAnimationOptionCurveEaseOut];
    [alphaview removeFromSuperview];
    
    self.stage.userInteractionEnabled=YES;
    
}

-(void)closegemsbtnclick:(id)sender
{
    NSLog(@"closebtnclicked");
    
    UIButton *sendbtn = sender;
    //UIView *theview = sendbtn.superview;
    
    [buymoregems removeWithZoomOutAnimation:1.0 option:UIViewAnimationOptionCurveEaseOut];
     [alphaview removeFromSuperview];
    
    self.stage.userInteractionEnabled=YES;
    
}


-(void)buybtnclick:(id)sender
{
    NSLog(@"buybtnclicked");
    UIButton *thisbtn = sender;
    //UIView *thisview = thisbtn.superview;
    
    PlayerData *sharedData = [PlayerData sharedData];
    
    NSInteger thegems = 5;
    
    BOOL payresult = [sharedData spendUserGems:thegems];
    
    //@Brian note--need to show the top bar removing the gems somehow.
    
    if (payresult)
    {
        //loss cost goes up
        
        //user score becomes the current score.
        
      //restore all the players hearts
        
        funData *fd = [[funData alloc] init];
        
        float usermaxhearts = [sharedData.usermaxhearts floatValue];
        float restoredvalue = [fd RestoreMultipleHearts:usermaxhearts withthismany:5];
        
        
        sharedData.usercurrenthearts = [NSNumber numberWithFloat:restoredvalue];
        
        UIButton *sendbtn = sender;
        //UIView *theview = sendbtn.superview;
        [refillhearts removeWithSinkAnimation:1];
        [alphaview removeWithSinkAnimation:1];
        self.stage.userInteractionEnabled = TRUE;
        
    }
    else
    {
        //buy more gems!
        //show the gem screen
        NSLog(@"user needs more gems");
        
        [refillhearts removeFromSuperview];
        
        
        buymoregems = [[UIView alloc] initWithFrame:refillhearts.frame];
        
        NSString *fileName = [[NSBundle mainBundle] pathForResource:@"out-of-diamonds" ofType:@"png"];
        UIImage *bgimage = [UIImage imageWithContentsOfFile:fileName];
        
        UIImage *b = [self imageWithImage:bgimage scaledToSize:buymoregems.bounds.size];
        
        buymoregems.backgroundColor = [UIColor colorWithPatternImage:b];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(180,0,222-180,30)];
        
        btn.backgroundColor = [UIColor clearColor];
        
        
        [btn addTarget:self action:@selector(closegemsbtnclick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *btnmid = [[UIButton alloc] initWithFrame:CGRectMake(83,40,51,52)];
        
        btnmid.backgroundColor = [UIColor clearColor];
        
        
        [btnmid addTarget:self action:@selector(buygemsbtnclick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(180,90,222-180,126-90)];
        
        btn2.backgroundColor = [UIColor clearColor];
        //size 136,38 div 2
        btn2.frame = CGRectMake((buymoregems.frame.size.width-68)/2,buymoregems.frame.size.height-29,68,19);
        
        [btn2 addTarget:self action:@selector(buygemsbtnclick:) forControlEvents:UIControlEventTouchUpInside];
        
        NSString *btnfileName = [[NSBundle mainBundle] pathForResource:@"buy-more-button" ofType:@"png"];
        UIImage *btnimage = [UIImage imageWithContentsOfFile:btnfileName];
        
        UIImage *bb = [self imageWithImage:btnimage scaledToSize:btn2.bounds.size];
        
        [btn2 setImage:bb forState:UIControlStateNormal];
        
        
        [buymoregems addSubview:btn];
        [buymoregems addSubview:btn2];
        [buymoregems addSubview:btnmid];
        
        [self.view addSubview:buymoregems];
        [self.view bringSubviewToFront:buymoregems];
        
    }
    
  
    
}



-(void) showoutofhearts
{
    //PlayerData *sharedData = [PlayerData sharedData];
    
    //float myhearts = [sharedData.usercurrenthearts floatValue];
    
    
   alphaview = [[UIView alloc] initWithFrame:self.view.frame];
    alphaview.backgroundColor = [UIColor blackColor];
    alphaview.alpha = 0.7;
    
    
    self.stage.userInteractionEnabled = NO;
    
    NSLog(@"user out of hearts");
    
   refillhearts = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-222)/2,100,222,126)];
    
    NSString *fileName = [[NSBundle mainBundle] pathForResource:@"out-of-hearts" ofType:@"png"];
    UIImage *bgimage = [UIImage imageWithContentsOfFile:fileName];
    
    UIImage *b = [self imageWithImage:bgimage scaledToSize:refillhearts.bounds.size];
    
    refillhearts.backgroundColor = [UIColor colorWithPatternImage:b];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(180,0,222-180,30)];
    
    btn.backgroundColor = [UIColor clearColor];
    
    
    [btn addTarget:self action:@selector(closebtnclick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btnmid = [[UIButton alloc] initWithFrame:CGRectMake(83,40,51,52)];
    
    btnmid.backgroundColor = [UIColor clearColor];
    
    
    [btnmid addTarget:self action:@selector(buybtnclick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(84,90,105.5,19)];
    
    btn2.backgroundColor = [UIColor clearColor];
    //size 136,38 div 2
    btn2.frame = CGRectMake((refillhearts.frame.size.width-105.5)/2,refillhearts.frame.size.height-29,105.5,19);
    
    [btn2 addTarget:self action:@selector(buybtnclick:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *btnfileName = [[NSBundle mainBundle] pathForResource:@"refill-button" ofType:@"png"];
    UIImage *btnimage = [UIImage imageWithContentsOfFile:btnfileName];
    
    UIImage *bb = [self imageWithImage:btnimage scaledToSize:btn2.bounds.size];
    
    [btn2 setImage:bb forState:UIControlStateNormal];
    
    UILabel *refillcostlabel = [[UILabel alloc] init];
    
    refillcostlabel.text = @"5";
    
    refillcostlabel.backgroundColor = [UIColor clearColor];
    
    refillcostlabel.font = [UIFont fontWithName:@"CooperBlackStd" size:14];
    
    refillcostlabel.textColor = [UIColor whiteColor];
    
    refillcostlabel.frame = CGRectMake(btn2.frame.size.width-23,0,20,19);
    
    refillcostlabel.textAlignment=NSTextAlignmentCenter;
    
    
    [btn2 addSubview:refillcostlabel];
    [refillhearts addSubview:btn];
    [refillhearts addSubview:btn2];
    [refillhearts addSubview:btnmid];
  
    [self.view addSubview:alphaview];
    [self.view addSubview:refillhearts];
    
    [self.view bringSubviewToFront:refillhearts];
    
    
}
- (void)VoteScreenNewVote:(VoteScreenCollectionView *)collectionView voteIndex:(NSInteger)index
{
    
    AppDelegate *myad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if(myad.internet==NO)
    {
        InternetOfflineViewController *iovc = [[InternetOfflineViewController alloc] init];
        
        [self addChildViewController:iovc];
        
        [self.view addSubview:iovc.view];
        
        return;
        
    }
    
    // NSInteger vote = [challengevotes[index-1] integerValue];
    //vote=vote+1;
    //challengevotes[index-1] = [NSNumber numberWithInteger:vote];
    
    
    PFObject *challengepoolsobj = [self.contentObjectsArray objectAtIndex:challengeindexvar];
    
    NSLog(@"Challenge Pool Obj:%@", challengepoolsobj.objectId);
    
    NSString *cellIndexString = [NSString stringWithFormat:@"%i", index];
    NSString *keystring = @"funPhotoObj";
    
    NSString *concatenatedCellObjString = [keystring stringByAppendingString:cellIndexString];
    
    //brian note--modify this open graph event
    
    PFObject *selectedContent = [challengepoolsobj objectForKey:concatenatedCellObjString];
    
   NSString *captionstring= [selectedContent objectForKey:@"Caption"];
    
    
    NSString *imglink = [selectedContent objectForKey:@"imgLink"];
    NSString *imgurl;
    if(imglink.length<2)
    {
        PFFile *mydata = [selectedContent objectForKey:@"imageFile"];
        imgurl = mydata.url;
        
    }
    else
    {
        imgurl =imglink;
    }
    
    NSMutableDictionary<FBGraphObject> *pic =
    [FBGraphObject openGraphObjectForPostWithType:@"picksomethingapp:picture"
                                            title:@"This was the favorite"
                                            image:imgurl
                                              url:@"https://itunes.apple.com/us/app/pick-something/id757934816"
                                      description:captionstring];;
    
    pic[@"create_object"] = @"1";
    pic[@"fbsdk:create_object"] = @"1";
    
    
  [FBRequestConnection startForPostWithGraphPath:@"me/objects/picksomethingapp:picture"
                                       graphObject:pic
                                 completionHandler:^(FBRequestConnection *connection,
                                                     id result,
                                                     NSError *error) {
                                     // handle the result
                                  //   NSLog(@"this is the result:%@ ", [result objectForKey:@"id"]);
                                     //NSString *resultID= [result objectForKey:@"id"];
                                     
                                     [self doOpenGraphVoteAction:pic];
                                                                      }];
    
   // NSLog(@"SAVING A VOTE!");
    
    PFUser *user = [PFUser currentUser];
    
    
    PFObject *funPhotoCP = [self.contentObjectsArray objectAtIndex:challengeindexvar];
    
    //build string for funPhotoObj#Votes
    
    NSString *voteIndexString = [NSString stringWithFormat:@"%i", index];
    NSString *keystring2 = @"funPhotoObj";
    
    NSString *concatenatedCellObjString2 = [keystring2 stringByAppendingString:voteIndexString];
    
    NSString *votestring = @"Votes";
    
    NSString *totalstring = [concatenatedCellObjString2 stringByAppendingString:votestring];
    
    
    [funPhotoCP incrementKey:totalstring];
    [funPhotoCP incrementKey:@"totalVotes"];
    
    [funPhotoCP saveInBackground];
    
    //step 2: add a UserVoteChallenges object with the pool object as the foreign key
    
    PFObject *uservotechallenge =[PFObject objectWithClassName:@"UserVoteChallenges"];
    
    [uservotechallenge setObject:user forKey:@"Voter"];
    [uservotechallenge setObject:funPhotoCP forKey:@"funPhotoChallengePool"];
    [uservotechallenge setObject:funPhotoCP.objectId forKey:@"funPhotoChallengePoolString"];
    
    NSNumber *uservote =  [NSNumber numberWithInteger:index];
    
    [uservotechallenge setObject:uservote forKey:@"personalVote"];
    
    [uservotechallenge saveInBackground];
        
}

- (void)displayVoteFave:(VoteScreenCollectionView *)collectionView
{
   
}
- (void)displayGuessNow:(VoteScreenCollectionView *)collectionView
{
    //@Brian Note:consider adding something to save to the user's plist to not see the tutorial again after 3 times.
    
    firstrun=3;
    
    if (firstrun==1)
    {
        //init the popup view controller and set its delegate
        PopupViewController *pvc = [self.storyboard instantiateViewControllerWithIdentifier:@"popup1"];
        pvc.popdelegate = self;
        
        NSString *filepopular = [[NSBundle mainBundle] pathForResource:@"Second-screen" ofType:@"png"];
       
        UIImage *popularimg = [UIImage imageWithContentsOfFile:filepopular];
        
        pvc.imgforpopup = popularimg;
        
       // [pvc.fullScreenBtn setImage:popularimg forState:UIControlStateNormal];
        
        
        [self addChildViewController:pvc];
        [self.view addSubview:pvc.view];
        firstrun=2;
        
    }
    
    
    
}
- (void)getNextData:(VoteScreenCollectionView *)collectionView
{
    
}
- (void) onAdColonyAdStartedInZone:(NSString *)zoneID
{
    MainLoadTabBarController *mvc = (MainLoadTabBarController *)self.tabBarController;
    [mvc.theAudio stop];
    
    
}

- (void) onAdColonyAdAttemptFinished:(BOOL)shown inZone:(NSString *)zoneID
{
    MainLoadTabBarController *mvc = (MainLoadTabBarController *)self.tabBarController;
    [mvc.theAudio prepareToPlay];
    [mvc.theAudio play];
    
    
    //give gold rewards
    
}
- (void)getNextChallenge:(NSString *)winorfail
{
    [challengevotes removeAllObjects];
    
    
    
    if ([winorfail  isEqual: @"win"])
    {
        //move to next challenge index and reload data.
        //trigger next challengeindex..add a check to see if less than 10, else re-query for MO'
        NSInteger challengecount = self.contentObjectsArray.count;
        
        challengeindexvar = challengeindexvar+1;
        
        AppDelegate *myad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        if(challengeindexvar==5 || challengeindexvar==10 || challengeindexvar ==15)
        {
            //show an ad.
            [AdColony playVideoAdForZone:@"vzea23b03bdc304d0ea9" withDelegate:myad];
        }
        
        
        if (challengeindexvar <challengecount)
        {
        
            NSNumber *numtransfer = [NSNumber numberWithInt:challengeindexvar];
            
            vsCV.challengeIndexNSNumber = numtransfer;
            
            NSInteger chgmode = 0;
            vsCV.vschallengeMode =[NSNumber numberWithInt:chgmode];

            [self displayVoteFave:vsCV];
            //need a method in between here to animate or show a smoother transition
            
            
            //this reload data is not cuttin it.  It needs to wipe the screen and then re do.
           
            for (UIView * view in vsCV.subviews)
            {
              //  NSLog(@"higher level subview: %@", [view.class description]);
                
                [view removeFromSuperview];
            }
            
            for (UIView * view in self.stage.subviews)
            {
                //  NSLog(@"higher level subview: %@", [view.class description]);
                
                [view removeFromSuperview];
            }
            
            
            
            [vsCV reloadData:vsCV];
            
            //add some code to add custom frames to the stage depending on the mode of the next challenge.
            PFObject *nextobj = self.contentObjectsArray[challengeindexvar];
            
            NSInteger nextrank = [[nextobj objectForKey:@"rank"] integerValue];
            
            //add some displays to the subview depending on the rank
           
            
            [self setChallengeVotes];
            
            [self.stage addSubview:vsCV];
            [self setChallengeFrames:nextrank];
            
        }
        else
        {
            //do something to get more data or display a control explaining there's no more content to vote on at the moment
            [self.contentObjectsArray removeAllObjects];
            challengeindexvar = 0;
            NSNumber *numtransfer = [NSNumber numberWithInt:challengeindexvar];
            
            vsCV.challengeIndexNSNumber = numtransfer;

            [self getObjectsToVote];
            
              NSInteger challengecount = self.contentObjectsArray.count;
            
            if(challengecount > 0)
            {
                
                
                NSInteger chgmode = 0;
                vsCV.vschallengeMode =[NSNumber numberWithInt:chgmode];
            [self displayVoteFave:vsCV];
            }
            else
            {
                //didn't get any data
               // NSLog(@"no data sir");
                
                //show a new view controller and suggest they browse the top content
                
                
            }
            
        }
        
    }
}

-(void) setChallengeFrames:(NSInteger) challengeRank
{
    if(frames==TRUE)
    {
        
   
    
    AppDelegate *myad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if(myad.internet==NO)
    {
        InternetOfflineViewController *iovc = [[InternetOfflineViewController alloc] init];
        
        [self addChildViewController:iovc];
        
        [self.view addSubview:iovc.view];
    }

    
    if(challengeRank==1)
    {
        //display free frames
        
        
        //entire view takes background
        NSString *bgfileName = [[NSBundle mainBundle] pathForResource:@"free-pass-background" ofType:@"png"];
        UIImage *background =[UIImage imageWithContentsOfFile:bgfileName];
        
        UIImage *b = [self imageWithImage:background scaledToSize:self.view.frame.size];
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:b]];
        
        //add frames
      NSString *framesfileName = [[NSBundle mainBundle] pathForResource:@"free-pass-frame-new-size" ofType:@"png"];
     

        UIImage *frames =[UIImage imageWithContentsOfFile:framesfileName];
        
        UIImage *framesresized = [self imageWithImage:frames scaledToSize:CGSizeMake(314,370.5)];
        
        UIImageView *framesimage = [[UIImageView alloc] initWithFrame:CGRectMake(4,3,314,370.5)];
       // CGRect bds = self.stage.bounds;
        
        framesimage.image = framesresized;
        
        
        framesimage.backgroundColor = [UIColor clearColor];
        
        //@brian note--this isnt working.
        
         if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
         {
              [self.stage addSubview:framesimage];
         }
      
        
        [self.stage bringSubviewToFront:vsCV];
        
        //[vsCV bringSubviewToFront:framesimage];
        
        //[vsCV addSubview:framesimage];
        
        
    }
    
    if(challengeRank==3)
    {
        //entire view takes background
        NSString *bgfileName = [[NSBundle mainBundle] pathForResource:@"difficult-challenge-background" ofType:@"png"];
        UIImage *background =[UIImage imageWithContentsOfFile:bgfileName];
        
        UIImage *b = [self imageWithImage:background scaledToSize:self.view.frame.size];
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:b]];
        
        //add frames
        NSString *framesfileName = [[NSBundle mainBundle] pathForResource:@"difficult-frame-new-size" ofType:@"png"];
        UIImage *frames =[UIImage imageWithContentsOfFile:framesfileName];
        
        UIImage *framesresized = [self imageWithImage:frames scaledToSize:CGSizeMake(314,370.5)];
        
        UIImageView *framesimage = [[UIImageView alloc] initWithFrame:CGRectMake(4,3,314,370.5)];
        //CGRect bds = self.stage.bounds;
        
        framesimage.image = framesresized;
        
        
        framesimage.backgroundColor = [UIColor clearColor];
        
        //@brian note--this isnt working.
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            [self.stage addSubview:framesimage];
        }
        
        [self.stage bringSubviewToFront:vsCV];
        
    }
    
    
    //set frames background
    if(challengeRank==101)
    {
        //entire view takes background
        NSString *bgfileName = [[NSBundle mainBundle] pathForResource:@"category-challenge-background" ofType:@"png"];
        UIImage *background =[UIImage imageWithContentsOfFile:bgfileName];
        
        UIImage *b = [self imageWithImage:background scaledToSize:self.view.frame.size];
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:b]];
        
        //add frames
        NSString *framesfileName = [[NSBundle mainBundle] pathForResource:@"category-challenge-new-size" ofType:@"png"];
        UIImage *frames =[UIImage imageWithContentsOfFile:framesfileName];
        
        UIImage *framesresized = [self imageWithImage:frames scaledToSize:CGSizeMake(314,370.5)];
        
        UIImageView *framesimage = [[UIImageView alloc] initWithFrame:CGRectMake(4,3,314,370.5)];
        //CGRect bds = self.stage.bounds;
        
        framesimage.image = framesresized;
        
        
        framesimage.backgroundColor = [UIColor clearColor];
        
        //@brian note--this isnt working.
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            [self.stage addSubview:framesimage];
        }
        
        [self.stage bringSubviewToFront:vsCV];
        

    }
    
    [self PopUpChallengeText:challengeRank];
 }
}

-(void) PopUpChallengeText:(NSInteger) chgrank
{
    
    if(chgrank==1)
    {
        UIImageView *imgtoadd= [[UIImageView alloc] init];        NSString *textimageName = [[NSBundle mainBundle] pathForResource:@"free-pass-text" ofType:@"png"];
        UIImage *textimage =[UIImage imageWithContentsOfFile:textimageName];
        imgtoadd.image = textimage;
        
        imgtoadd.frame = CGRectMake(self.stage.frame.size.width/2 -textimage.size.width/4,self.stage.frame.size.height/2 -textimage.size.height/2 -30,textimage.size.width/2,textimage.size.height/2);
        
        [self.stage BounceViewThenFadeAlpha:imgtoadd];
        
       
        
        
    }
    if(chgrank==3)
    {
        UIImageView *imgtoadd = [[UIImageView alloc] init];
        NSString *textimageName = [[NSBundle mainBundle] pathForResource:@"difficult-challenge-text" ofType:@"png"];
        UIImage *textimage =[UIImage imageWithContentsOfFile:textimageName];
        imgtoadd.image = textimage;
        
         imgtoadd.frame = CGRectMake(self.stage.frame.size.width/2 -textimage.size.width/4,self.stage.frame.size.height/2 -textimage.size.height/2,textimage.size.width/2,textimage.size.height/2);
        
        [self.stage BounceViewThenFadeAlpha:imgtoadd];
    }
    
    if (chgrank==101)
    {
        UIImageView *imgtoadd = [[UIImageView alloc] init];
        
        NSString *textimageName = [[NSBundle mainBundle] pathForResource:@"category-challenge-text" ofType:@"png"];
        UIImage *textimage =[UIImage imageWithContentsOfFile:textimageName];
        imgtoadd.image = textimage;
        
        imgtoadd.frame = CGRectMake(self.stage.frame.size.width/2 -textimage.size.width/4,self.stage.frame.size.height/2 -textimage.size.height/2,textimage.size.width/2,textimage.size.height/2);
        
        //imgtoadd.center = self.stage.center;
        
        [self.stage BounceViewThenFadeAlpha:imgtoadd];
    }
    
    
    
    
}


- (NSArray *)getChallengeVotes:(VoteScreenCollectionView *) vscv
{
    NSArray *frogarray;
    
    frogarray = [[NSArray alloc] initWithArray:(challengevotes)];
    
    return frogarray;
    
    
}


- (void)dismissSummaryForNextContent:(VoteSummaryViewController *)summaryView
{
     
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
    
    [self getNextChallenge:@"win"];
    
    
    
    
}

- (void) showSummaryScreen:(VoteScreenCollectionView *) vscv withWinMode:(NSInteger) wmode withChoice:(NSInteger) choice;


{
    //present the win or loss text with a quick pop-out
    UILabel *feedbacktext = [[UILabel alloc] init];
    feedbacktext.font = [UIFont fontWithName:@"CooperBlackStd" size:20];
    feedbacktext.numberOfLines = 2;
   
    feedbacktext.shadowColor = [UIColor blackColor];
    feedbacktext.backgroundColor = [UIColor clearColor];
    
    
    feedbacktext.frame = CGRectMake(100,self.stage.frame.size.height/2-75,120, 50);
    feedbacktext.textAlignment = NSTextAlignmentCenter;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
      feedbacktext.font = [UIFont fontWithName:@"CooperBlackStd" size:40];
        feedbacktext.frame = CGRectMake(334-80,self.stage.frame.size.height/2-75,250, 50);
    }

    
    if(wmode==1)
    {
          feedbacktext.text = [self decideWinText];
       
         feedbacktext.textColor =  [UIColor colorWithRed:153/255.0f green:202/255.0f blue:60/255.0f alpha:1];
        
    }
    else
    {
        feedbacktext.text = [self decideLossText];
        feedbacktext.textColor = [UIColor redColor];
    }
    
      [self animatetextsizeincrease:feedbacktext];
    
        //change this to a points system based on the challenge pool value later instead of wins in a row.
    
    NSLog(@"presenting the vote summary screen");
    
    VoteSummaryViewController *sumscreen = [self.storyboard instantiateViewControllerWithIdentifier:@"vssumview"];
    sumscreen.vsSummaryDelegate = self;
    sumscreen.contentobjs = self.contentObjectsArray;
    sumscreen.votecounts = challengevotes;
    
    sumscreen.chosenobj = [NSNumber numberWithInteger:choice];
    
    NSNumber *justappear = [NSNumber numberWithInt:0];
    sumscreen.justappeared = justappear;
    
    NSNumber *thisnsnum = [NSNumber numberWithInt:challengeindexvar];
    
    sumscreen.vsummarychallengeIndexNSNumber= thisnsnum;
    
    if(wmode==0)
    {
        winsinarow = 0;
        
          }
    else
    {
        winsinarow = winsinarow+ 1;
        NSString *fileName = [[NSBundle mainBundle] pathForResource:@"summarynext-button" ofType:@"png"];
        UIImage *bgimage = [UIImage imageWithContentsOfFile:fileName];
        
          [sumscreen.nextBtn setBackgroundImage:bgimage forState:UIControlStateNormal];
    }
    NSNumber *winmode = [NSNumber numberWithInteger:(wmode)];
    NSNumber *sumwinsinarow = [NSNumber numberWithInteger:winsinarow];
    
    sumscreen.WinorFailMode = winmode;
    sumscreen.winsinarow = sumwinsinarow;
    
    [self performSelector:@selector(doSumScreenShow:) withObject:sumscreen afterDelay:1];
    

    
}

-(void) doSumScreenShow:(VoteSummaryViewController *) sums
{
    [self.navigationController pushViewController:sums animated:YES];
}

-(void) animatetextsizeincrease:(UILabel *) mylabel
{
    [self.stage addSubview:mylabel];
    //[UIView beginAnimations:nil context:nil/*contextPoint*/];
    //mylabel.transform = CGAffineTransformMakeScale(2, 2); //increase the size by 2
    //etc etc same procedure for the other labels.
    //[UIView setAnimationDelegate:self];
    //[UIView setAnimationDelay:0.2];
    //[UIView setAnimationDuration:0.5];
    //[UIView setAnimationRepeatCount:4];
    //[UIView setAnimationCurve:UIViewAnimationCurveLinear];
    //[UIView commitAnimations];
    
    
    [UIView animateWithDuration:0.5f
                          delay:0.2f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         mylabel.transform = CGAffineTransformMakeScale(2, 2);
                     }
                     completion:^(BOOL finished) {
                         [self animateMoveAndAlphaOff:mylabel];
                     }];
    
}

-(void) animateMoveAndAlphaOff:(UILabel *) mylabel
{
    [UIView animateWithDuration:0.5f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         mylabel.frame = CGRectMake(mylabel.frame.origin.x, mylabel.frame.origin.y-20,mylabel.frame.size.width,mylabel.frame.size.height);
                         mylabel.alpha = 0.1;
                         
                     }
                     completion:^(BOOL finished) {
                         [mylabel removeFromSuperview];
                     }];
}


-(NSString *) decideWinText
{
    NSArray *winstrings = [NSArray arrayWithObjects:@"Great",@"Perfect!",@"Yes",@"Nice!",@"Right!" ,nil];
    
    return [winstrings objectAtIndex: arc4random() % [winstrings count]];
    
}

-(NSString *) decideLossText
{
    NSArray *lossstrings = [NSArray arrayWithObjects:@"Nope", @"Wrong",@"Next", @"Good Try", nil];
    
    return [lossstrings objectAtIndex: arc4random() % [lossstrings count]];
    
}

-(NSString *) decideLossSound
{
    NSArray *lossstrings = [NSArray arrayWithObjects:@"no",@"practice", @"sowellohwaitno",@"youchosepoorly", nil];
    
    return [lossstrings objectAtIndex: arc4random() % [lossstrings count]];
    
}
-(NSString *) decideWinSound
{
    NSArray *winstrings = [NSArray arrayWithObjects:@"goodjob",@"nice", @"youchosewisely",@"yourock", nil];
    
    return [winstrings objectAtIndex: arc4random() % [winstrings count]];
    
}


-(IBAction) reportbtnpress:(id)sender
{
    
     //WinParticleView *wpv = [[WinParticleView alloc] initWithFrame:self.view.frame particlePosition:self.view.frame.origin];
    
    //[self.view addSubview:wpv];
    
  
    
    
    
    for (UIView * view in vsCV.subviews)
    {
        NSLog(@"vscv subview: %@", [view.class description]);
        
        NSLog(@"height: %f", view.frame.size.height);
         NSLog(@"width: %f", view.frame.size.width);
         NSLog(@"x: %f", view.frame.origin.x);
         NSLog(@"y: %f", view.frame.origin.y);
        UIView *twolevelview = view;
        
        for (UIView *twoview in twolevelview.subviews)
        {
            NSLog(@"vscv subview: %@", [twoview.class description]);
            
            NSLog(@"height: %f", twoview.frame.size.height);
            NSLog(@"width: %f", twoview.frame.size.width);
            NSLog(@"x: %f", twoview.frame.origin.x);
            NSLog(@"y: %f", twoview.frame.origin.y);
        }
        
        
    }
}

- (void)fullScreenButtonClick:(PopupViewController *) thiscontroller
{
   
    [thiscontroller.view removeFromSuperview];
                                                                
    [self dismissViewControllerAnimated:YES completion:nil];
    
    darkview.alpha=0;
    
    
}

- (void)PlayBtnClick:(WelcomeScreenViewController *) thiscontroller
{
    [thiscontroller.view removeFromSuperview];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

//category picker delegate functions

- (void)CategoryPick:(CategorySelectViewController *) thiscontroller
{
    [thiscontroller.view removeFromSuperview];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setParentChallenges:(NSArray *) challenges
{
    [self.categoryChallengeArray removeAllObjects];
    
    [self.categoryChallengeArray addObjectsFromArray:challenges];
    
    [self loadCategoryObjects];
    
}

-(void) viewDidUnload
{
    
}

-(void) dealloc
{
    NSLog(@"the voting controller was dealloced");
    
}

- (void)BackToBuyStuff:
(GoldStoreViewController *)controller
{
    [self.navigationController popViewControllerAnimated:YES];
}



@end
