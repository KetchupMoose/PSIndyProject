//
//  MyStuffViewController.m
//  funnyBusiness
//
//  Created by Macbook on 2013-11-01.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import "MyStuffViewController.h"
#import "AddContentViewController.h"
#import "TopBarViewController.h"



@interface MyStuffViewController ()

@end

@implementation MyStuffViewController

@synthesize myfavoritestext;
@synthesize mysubmissionstext;
@synthesize submitnewtext;
@synthesize thetopbar;
@synthesize viewmyfavesbtn;
@synthesize submitnewbtn;
@synthesize viewmysubmitsbtn;
@synthesize musicbtn;
NSArray *faveobjs;
UIView *stufftutorialview;
UIButton *stuffclosebtn;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLayoutSubviews
{
    UILabel *myfavetext = self.myfavoritestext;
    UILabel *submnewtext = self.submitnewtext;
    UILabel *mysubmisstext = self.mysubmissionstext;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            // iPhone Classic
            //leave as normal
            //[submnewtext setFrame:CGRectMake(35,0, 200, 25)];
            
            //[mysubmisstext setFrame:CGRectMake(39,250, 200, 50)];
            //[ myfavetext setFrame:CGRectMake(45,325, 200, 50)];
        }
        if(result.height == 568)
        {
            // iPhone 5
            //give stage extra dimensions
            NSLog(@"iphone 5s settings my stuff page");
            
            [submnewtext setFrame:CGRectMake(55,132, 200, 50)];
            
            [mysubmisstext setFrame:CGRectMake(55,277, 200, 50)];
            [ myfavetext setFrame:CGRectMake(57,399, 200, 50)];
            //415
            [viewmyfavesbtn setFrame:CGRectMake(viewmyfavesbtn.frame.origin.x,viewmyfavesbtn.frame.origin.y +54,viewmyfavesbtn.frame.size.width,viewmyfavesbtn.frame.size.height)];
            
            [viewmysubmitsbtn setFrame:CGRectMake(viewmysubmitsbtn.frame.origin.x,viewmysubmitsbtn.frame.origin.y +30,viewmysubmitsbtn.frame.size.width,viewmysubmitsbtn.frame.size.height)];
            
            [submitnewbtn setFrame:CGRectMake(submitnewbtn.frame.origin.x,submitnewbtn.frame.origin.y,submitnewbtn.frame.size.width,submitnewbtn.frame.size.height)];
            
            
            mysubmissionstext.textAlignment = NSTextAlignmentCenter;
            submitnewtext.textAlignment = NSTextAlignmentCenter;
            myfavoritestext.textAlignment = NSTextAlignmentCenter;
            
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    //code to add top bar to container
    
    TopBarViewController *tpvc;
    
    tpvc=[self.storyboard instantiateViewControllerWithIdentifier:@"topbar"];
    
    [self addChildViewController:tpvc];
    
    tpvc.topbardelegate = self;
    
    
    [self.thetopbar addSubview:tpvc.view];
    
    
    self.thetopbar.backgroundColor = [UIColor clearColor];
    
    
    tpvc.view.frame = self.thetopbar.bounds;

        NSString *bgfileName = [[NSBundle mainBundle] pathForResource:@"background" ofType:@"png"];
    UIImage *background =[UIImage imageWithContentsOfFile:bgfileName];
    
    UIImage *b = [self imageWithImage:background scaledToSize:self.view.frame.size];
    

    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:b]];
    
    UILabel *myfavetext = self.myfavoritestext;
    UILabel *submnewtext = self.submitnewtext;
    UILabel *mysubmisstext = self.mysubmissionstext;
    
    
    
    
   myfavetext.font = [UIFont fontWithName:@"CooperBlackStd" size:27];
     submnewtext.font = [UIFont fontWithName:@"CooperBlackStd" size:27];
    mysubmisstext.font = [UIFont fontWithName:@"CooperBlackStd" size:27];
    
   self.musictext.font = [UIFont fontWithName:@"CooperBlackStd" size:16];
    self.musictext.backgroundColor = [UIColor clearColor];
    self.musictext.text = @"Music Off";
    
    //CGRect tuteframe = CGRectMake(5,50,310,340);
    int maxw;
    int maxh;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        myfavetext.font = [UIFont fontWithName:@"CooperBlackStd" size:12];
        submnewtext.font = [UIFont fontWithName:@"CooperBlackStd" size:12];
        mysubmisstext.font = [UIFont fontWithName:@"CooperBlackStd" size:12];
        
        self.musictext.font = [UIFont fontWithName:@"CooperBlackStd" size:12];
        
        maxw = 320;
        maxh = 350;
    }
    else
    {
        maxw = 768;
        maxh = 1000;
        
        myfavetext.font = [UIFont fontWithName:@"CooperBlackStd" size:27];
        submnewtext.font = [UIFont fontWithName:@"CooperBlackStd" size:27];
        mysubmisstext.font = [UIFont fontWithName:@"CooperBlackStd" size:27];
   self.musictext.font = [UIFont fontWithName:@"CooperBlackStd" size:16];
    }

  
    //tutorial display code
    stufftutorialview = [[UIView alloc] initWithFrame:self.view.bounds];
    self.mysubmissionstext.alpha = 0;
    self.myfavoritestext.alpha=0;
    
    NSString *fileName = [[NSBundle mainBundle] pathForResource:@"submit-tutorial" ofType:@"png"];
    UIImage *popimage = [UIImage imageWithContentsOfFile:fileName];
   
    
    CGSize imgsize = [self scalesize:popimage.size maxWidth:maxw maxHeight:maxh];
    UIImage *popup = [self imageWithImage:popimage scaledToSize:imgsize];
    
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        stufftutorialview.frame = CGRectMake((320-imgsize.width)/2,65,imgsize.width,imgsize.height);
    }
    else
    {
        stufftutorialview.frame = CGRectMake((768-imgsize.width)/2,95,imgsize.width,imgsize.height);
    }

    
     [stufftutorialview setBackgroundColor:[UIColor colorWithPatternImage:popup]];

    
    UIButton *fullbtn = [[UIButton alloc] initWithFrame:stufftutorialview.bounds];
    
    [fullbtn addTarget:self action:@selector(closetute:)
   forControlEvents:UIControlEventTouchUpInside];
    
    fullbtn.backgroundColor = [UIColor clearColor];
    
    [stufftutorialview addSubview:fullbtn];
    
    
    NSString *closeName = [[NSBundle mainBundle] pathForResource:@"close-button" ofType:@"png"];
    
    UIImage *closebtnimg = [UIImage imageWithContentsOfFile:closeName];
    
    CGSize btnimgsize = CGSizeMake(closebtnimg.size.width/2,closebtnimg.size.height/2);
    
    UIImage *smallerbtnimg = [self imageWithImage:closebtnimg scaledToSize:btnimgsize];

    
    float btnx = stufftutorialview.frame.origin.x + stufftutorialview.frame.size.width -smallerbtnimg.size.width/2;
    
    float btny = stufftutorialview.frame.origin.y - smallerbtnimg.size.height/2;
    
    
    stuffclosebtn = [[UIButton alloc] initWithFrame:CGRectMake(btnx,btny,smallerbtnimg.size.width,smallerbtnimg.size.height)];
    
    [stuffclosebtn setImage:smallerbtnimg forState:UIControlStateNormal];
    
    [stuffclosebtn addTarget:self action:@selector(closetuteoutofview:)
       forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [self.view addSubview:stufftutorialview];
    [self.view addSubview:stuffclosebtn];
    
    
}

-(CGSize )scalesize:(CGSize )imgsize maxWidth:(int) maxWidth maxHeight:(int) maxHeight
{
    
    CGFloat width = imgsize.width;
    
    CGFloat height = imgsize.height;
    
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
    
    
    
    CGSize size = newsize;
    
    
    return size;
    
}

-(void)closetute:(id) sender
{
    self.mysubmissionstext.alpha = 1;
    self.myfavoritestext.alpha=1;
    UIButton *sendbtn = sender;
    UIView *theview = sendbtn.superview;
      [stuffclosebtn removeWithSinkAnimation:1];
    [theview removeWithZoomOutAnimation:1.0 option:UIViewAnimationOptionCurveEaseIn];
}

-(void)closetuteoutofview:(id) sender
{
    self.mysubmissionstext.alpha = 1;
    self.myfavoritestext.alpha=1;
    
    UIButton *sendbtn = sender;
    
    
    [sendbtn removeWithSinkAnimation:1];
    [stufftutorialview removeWithZoomOutAnimation:1.0 option:UIViewAnimationOptionCurveEaseIn];
    
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


- (void)viewDidAppear:(BOOL)animated

{
    PlayerData *sharedData = [PlayerData sharedData];
    [sharedData CheckForRefresh];
    
    
    

    
    // Register for push notifications
    
   // if([UIApplication sharedApplication].enabledRemoteNotificationTypes == UIRemoteNotificationTypeNone)
    //{
    
      // [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"People Like You!", nil) message:NSLocalizedString(@"Get notified when your submits are liked or purchased!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
    
    //[[UIApplication sharedApplication]  registerForRemoteNotificationTypes:
    // UIRemoteNotificationTypeBadge |
    //UIRemoteNotificationTypeAlert |
     //UIRemoteNotificationTypeSound];
    //}

}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction) SubmitNew:id;
{
    
    //instant from storybord and popup
    AddContentViewController *acvc = [self.storyboard instantiateViewControllerWithIdentifier:@"addcontent"];
  
    acvc.acvdelegate = self;
   
    
    
   [self.navigationController pushViewController:acvc animated:YES];

    
    
    
}

-(IBAction) ViewSubmissions:id
{
    MyContentViewController *mcvc = [self.storyboard instantiateViewControllerWithIdentifier:@"mycontentview"];
    
    mcvc.mycontentdelegate = self;
    mcvc.DisplayMode = @"submits";
    
    
    [self.navigationController pushViewController:mcvc animated:YES];
    
}

-(IBAction) ViewFaves:(id) sender
{
    //get the favorites
    
    PFUser *user = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"funPhotoLike"];
    [query whereKey:@"contentLiker" equalTo:user];
    [query includeKey:@"funPhotoObject"];
    [query orderByDescending:@"createdAt"];
    
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if(!error)
        {
            //NSArray *hashfunobjs = objects;
            
            
            NSMutableArray *funphotoobjs = [[NSMutableArray alloc] init];
            
            for (id obj in objects)
            {
                [funphotoobjs addObject:[obj objectForKey:@"funPhotoObject"]];
                
            }
            
            faveobjs = [funphotoobjs copy];
            
          
            [self performSegueWithIdentifier:@"favesSegue" sender:sender];

            
        }
        else
        {
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"Could Not Retrieve Favorites!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
            return;
        }
        
    }
     ];

    
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"favesSegue"])
	{
		UINavigationController *navigationController =
        segue.destinationViewController;
		SearchResultsViewController
        *ssrViewController =
        [[navigationController viewControllers]
         objectAtIndex:0];
		ssrViewController.srdelegate = self;
        
          ssrViewController.parseobjs = faveobjs;
    }
}




- (void)Dismissacv:
(AddContentViewController *)controller
{
    [self.navigationController popViewControllerAnimated:YES];
    
    
}

-(void) dismissMyContentScreen:(MyContentViewController *)controller
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) dealloc
{
    NSLog(@"the My Stuff controller was dealloced");
    
}


//delegate for the myfaves search results
- (void)dismissResults:(UIViewController *)dismissingvc
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction) ChangeMusic:(id)sender
{
    
    MainLoadTabBarController *ml = (MainLoadTabBarController *)self.tabBarController;
    
    BOOL musicstate = ml.audioplaying;
    
    if(musicstate==YES)
    {
        
        NSString *fileName = [[NSBundle mainBundle] pathForResource:@"speaker" ofType:@"png"];
        UIImage *btnimage = [UIImage imageWithContentsOfFile:fileName];
           self.musictext.text = @"Music On";
        [self.musicbtn setImage:btnimage forState:UIControlStateNormal];
 
        [ml stopaudio];
        
        
    }
    else
    {
        NSString *filebtnName = [[NSBundle mainBundle] pathForResource:@"speaker-mute" ofType:@"png"];
        UIImage *btnoffimage = [UIImage imageWithContentsOfFile:filebtnName];
           self.musictext.text = @"Music Off";
        [self.musicbtn setImage:btnoffimage forState:UIControlStateNormal];
        [ml playaudio];
        
    }
}



@end
