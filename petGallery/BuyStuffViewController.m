//
//  BuyStuffViewController.m
//  funnyBusiness
//
//  Created by Macbook on 2013-11-01.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import "BuyStuffViewController.h"
#import "MarketScreenViewController.h"


@interface BuyStuffViewController ()

@end

@implementation BuyStuffViewController

@synthesize browsecontenttext;
@synthesize buygoldtext;
@synthesize browseContentbtn;
@synthesize thetopbar;
@synthesize viewMyContentbtn;
@synthesize buygoldbtn;
@synthesize mycontenttext;
UIView *tutorialview;
UIButton *closebtn;




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
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            // iPhone Classic
            //leave as normal
           
        }
        if(result.height == 568)
        {
            // iPhone 5
            //give stage extra dimensions
            NSLog(@"iphone 5s settings buy stuff page");
            
            //[submnewtext setFrame:CGRectMake(55,132, 200, 50)];
            
          
            //415
            [browseContentbtn setFrame:CGRectMake(browseContentbtn.frame.origin.x,browseContentbtn.frame.origin.y +40,browseContentbtn.frame.size.width,browseContentbtn.frame.size.height)];
            
             [viewMyContentbtn setFrame:CGRectMake(viewMyContentbtn.frame.origin.x,viewMyContentbtn.frame.origin.y +58,viewMyContentbtn.frame.size.width,viewMyContentbtn.frame.size.height)];
            
             [buygoldbtn setFrame:CGRectMake(buygoldbtn.frame.origin.x,buygoldbtn.frame.origin.y +15,buygoldbtn.frame.size.width,buygoldbtn.frame.size.height)];
            
             [buygoldtext setFrame:CGRectMake(buygoldtext.frame.origin.x,buygoldtext.frame.origin.y +15,buygoldtext.frame.size.width,buygoldtext.frame.size.height)];
            
            [mycontenttext setFrame:CGRectMake(mycontenttext.frame.origin.x,mycontenttext.frame.origin.y +54,mycontenttext.frame.size.width,mycontenttext.frame.size.height)];
            
            [browsecontenttext setFrame:CGRectMake(browsecontenttext.frame.origin.x,browsecontenttext.frame.origin.y +38,browsecontenttext.frame.size.width,browsecontenttext.frame.size.height)];
            
            
                    }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    TopBarViewController *tpvc;
    
    tpvc=[self.storyboard instantiateViewControllerWithIdentifier:@"topbar"];
    
    [self addChildViewController:tpvc];
    
    tpvc.topbardelegate = self;
    
    
    [self.thetopbar addSubview:tpvc.view];
    
    tpvc.view.frame = self.thetopbar.bounds;
    
    NSString *bgfileName = [[NSBundle mainBundle] pathForResource:@"buystuffbackground" ofType:@"png"];
    UIImage *background =[UIImage imageWithContentsOfFile:bgfileName];
    
    UIImage *b = [self imageWithImage:background scaledToSize:self.view.frame.size];
    
    
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:b]];
    
    
      if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
      {
          mycontenttext.font = [UIFont fontWithName:@"CooperBlackStd" size:12];
          browsecontenttext.font = [UIFont fontWithName:@"CooperBlackStd" size:12];
          buygoldtext.font = [UIFont fontWithName:@"CooperBlackStd" size:12];
      }
else
{
    mycontenttext.font = [UIFont fontWithName:@"CooperBlackStd" size:27];
    browsecontenttext.font = [UIFont fontWithName:@"CooperBlackStd" size:27];
    buygoldtext.font = [UIFont fontWithName:@"CooperBlackStd" size:27];
}
    
    
    
    
    
    
    //[submnewtext setFrame:CGRectMake(35,0, 200, 25)];
    
    //[mysubmisstext setFrame:CGRectMake(39,250, 200, 50)];
    //[ myfavetext setFrame:CGRectMake(45,325, 200, 50)];
    
    
    [self tutorialsetupcode];
    
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
    
    //make sure to enforce a maximum height on upload so you dont get fkin nonsense.
    
    CGSize size = newsize;
    
    
    return size;
    
}

-(void) tutorialsetupcode
{
    mycontenttext.alpha =0;
    
    int maxw;
    int maxh;
    
      if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
      {
          
        maxw = 320;
          maxh = 350;
      }
    else
    {
        maxw = 768;
        maxh = 1000;
    }
    
    
    tutorialview = [[UIView alloc] initWithFrame:self.view.bounds];
    
    
    NSString *fileName = [[NSBundle mainBundle] pathForResource:@"tutorial-buy-stuff" ofType:@"png"];
    UIImage *popimage = [UIImage imageWithContentsOfFile:fileName];
    
    
    CGSize imgsize = [self scalesize:popimage.size maxWidth:maxw maxHeight:maxh];
    UIImage *popup = [self imageWithImage:popimage scaledToSize:imgsize];
    
     if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
     {
         tutorialview.frame = CGRectMake((320-imgsize.width)/2,65,imgsize.width,imgsize.height);
     }
    else
    {
        tutorialview.frame = CGRectMake((768-imgsize.width)/2,95,imgsize.width,imgsize.height);
    }
    
    
    [tutorialview setBackgroundColor:[UIColor colorWithPatternImage:popup]];
    
    
    UIButton *fullbtn = [[UIButton alloc] initWithFrame:tutorialview.bounds];
    
    [fullbtn addTarget:self action:@selector(closetute:)
      forControlEvents:UIControlEventTouchUpInside];
    
    fullbtn.backgroundColor = [UIColor clearColor];
    
    [tutorialview addSubview:fullbtn];
    
    
    NSString *closeName = [[NSBundle mainBundle] pathForResource:@"close-button" ofType:@"png"];
    
    UIImage *closebtnimg = [UIImage imageWithContentsOfFile:closeName];
    
    CGSize btnimgsize = CGSizeMake(closebtnimg.size.width/2,closebtnimg.size.height/2);
    
    UIImage *smallerbtnimg = [self imageWithImage:closebtnimg scaledToSize:btnimgsize];
    
    
    float btnx = tutorialview.frame.origin.x + tutorialview.frame.size.width -smallerbtnimg.size.width/2;
    
    float btny = tutorialview.frame.origin.y - smallerbtnimg.size.height/2;
    
    
    closebtn = [[UIButton alloc] initWithFrame:CGRectMake(btnx,btny,smallerbtnimg.size.width,smallerbtnimg.size.height)];
    
    [closebtn setImage:smallerbtnimg forState:UIControlStateNormal];
    
    [closebtn addTarget:self action:@selector(closetuteoutofview:)
       forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [self.view addSubview:tutorialview];
    [self.view addSubview:closebtn];
}

-(void)closetute:(id) sender
{
     mycontenttext.alpha =1;
    UIButton *sendbtn = sender;
    UIView *theview = sendbtn.superview;
    
    [theview removeWithZoomOutAnimation:1.0 option:UIViewAnimationOptionCurveEaseIn];
    [closebtn removeWithSinkAnimation:1];
    
}

-(void)closetuteoutofview:(id) sender
{
     mycontenttext.alpha =1;
    UIButton *sendbtn = sender;
    
    
    [sendbtn removeWithSinkAnimation:1];
    [tutorialview removeWithZoomOutAnimation:1.0 option:UIViewAnimationOptionCurveEaseIn];
    
}


- (void)viewDidAppear:(BOOL)animated

{
    //checks to see if refresh timer on collect screen should be refreshed
    PlayerData *sharedData = [PlayerData sharedData];
    [sharedData CheckForRefresh];
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction) BuyContent:(id)sender
{
    //show the content marketplace
    
    MarketScreenViewController *mqtvc = [self.storyboard instantiateViewControllerWithIdentifier:@"marketscreen"];
    
    mqtvc.mscreendelegate = self;
    [self.navigationController pushViewController:mqtvc animated:YES];
    
}

-(IBAction) ViewContent:(id)sender
{
    MyContentViewController *mcvc = [self.storyboard instantiateViewControllerWithIdentifier:@"mycontentview"];
    
    mcvc.mycontentdelegate = self;
    mcvc.DisplayMode = @"owned";
    [self.navigationController pushViewController:mcvc animated:YES];
}

-(IBAction) BuyGold:(id)sender
{
   GoldStoreViewController *gsvc = [self.storyboard instantiateViewControllerWithIdentifier:@"gsvc"];
    
    gsvc.goldstoredelegate = self;
    
    [self.navigationController pushViewController:gsvc animated:YES];
    gsvc.view.hidden = NO;
    
}



-(void) dismissMarketScreen:(MarketScreenViewController *)controller
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) dismissMyContentScreen:(MyContentViewController *)controller
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)BackToBuyStuff:
(GoldStoreViewController *)controller
{
    [self.navigationController popViewControllerAnimated:YES];
}




@end
