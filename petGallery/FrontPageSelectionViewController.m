//
//  FrontPageSelectionViewController.m
//  petGallery
//
//  Created by mac on 7/26/13.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import "FrontPageSelectionViewController.h"
#import <Parse/Parse.h>
#import "ContentSelectCaptionViewController.h"
#import "ContentSelectRatingViewController.h"
#import "ContentSelectSocialViewController.h"
#import "ContentSelectHashtagsViewController.h"
#import "UIView+Animation.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "ContentSelectReportInappropriateViewController.h"


@interface FrontPageSelectionViewController ()

@property (nonatomic, strong) UIView *containerView;
@end

@implementation FrontPageSelectionViewController

@synthesize containerView = _containerView;
@synthesize delegate;
@synthesize selectedContent;
@synthesize parseObjects;
@synthesize mainscrollview;
UIImageView *imgtoshow;
@synthesize parseobjindex;
@synthesize accessToken = _accessToken;
@synthesize fpsaccessmode;


NSInteger parseobjindexint;

ContentSelectCaptionViewController *cscc;
ContentSelectRatingViewController *crcc ;
 ContentSelectSocialViewController *csocialcc ;
ContentSelectPerformanceStatsViewController *cperfcc;
ContentSelectReportInappropriateViewController *creportcc;


//setting some isntance variables to resize/reframe views easily.  Not sure if this is a good method.
UIView *captionview;
UIView *ratingview;
UIView *socialview;
UIView *perfview;
UIView *reportview;

NSMutableArray *selectviews;


//UIScrollView *mainscrview;
NSInteger votetuteshown = 0;
NSInteger browsetuteshown =0;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void) viewDidAppear:(BOOL) animated
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //set view to store background
    
    for (UIView *view in selectviews)
    {
        [view removeFromSuperview];
        
    }
    [selectviews removeAllObjects];
    
    
    //NSString *bgfileName = [[NSBundle mainBundle] pathForResource:@"blue-background" ofType:@"png"];
   // UIImage *background =[UIImage imageWithContentsOfFile:bgfileName];
    
    //UIImage *myb = [self imageWithImage:background scaledToSize:self.view.frame.size];
    
    //[self.view setBackgroundColor:[UIColor colorWithPatternImage:myb]];

   // self.view.backgroundColor = [UIColor colorWithRed:(210/255.0) green:(210/255.0) blue:(210/255.0) alpha:1];
    
    //calculate the size of the container to make based upon the height of the image in question and the additional height we add in from our other controls.  <3.
    
    //get the image and get it's mo'faking height.
    
    //I don't think I can get the image dimensions unless I store them as separate data on upload.
    parseobjindexint=[parseobjindex intValue];
    
   imgtoshow = [[UIImageView alloc] init];
    
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
    UIActivityIndicatorViewStyle activityStyle = UIActivityIndicatorViewStyleGray;

    //change to UIImage load methods
    UIImage *cellplaceholder = [UIImage imageWithContentsOfFile:@"imgloadingplaceholder.png"];
    [imgtoshow setImageWithURL:[NSURL URLWithString:imgurl] placeholderImage:cellplaceholder usingActivityIndicatorStyle:activityStyle ];
    
        //get height and width of dat WIGGA
    float imgheight = [[selectedContent objectForKey:@"imgHeight"] floatValue];
    float imgwidth = [[selectedContent objectForKey:@"imgWidth"] floatValue];
   
    float maxw;
    float maxh;
    CGSize containerSize;
      if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
      {
           maxw = 300;
          maxh = 2000;
           containerSize = CGSizeMake(320.0f, 2000.0f);
      }
    else
    {
        maxw = 700;
        maxh = 3000;
         containerSize = CGSizeMake(768.0f, 5000.0f);
    }
   
    
    CGSize currentsize = CGSizeMake(imgwidth,imgheight);
    CGSize * sizeobj = &currentsize;
    
    
    CGSize *sizeforimgcontainer = [self scalesize:sizeobj maxWidth:maxw maxHeight:maxh];
    
    //need to take this image size and calculate the proper fuggin aspect ratio to get the real height to show now, WIGGA.
    
    CGSize newsize = *sizeforimgcontainer;
    
    NSLog(@"original height: %ld", (long)imgheight);
      NSLog(@"new max height: %ld", (long)newsize.height);
    
    NSLog(@"original width: %ld", (long)imgwidth);
    NSLog(@"new max width: %ld", (long)newsize.width);
    
    //estimate total container size based on imgheight and other elements.
    
    //float totalcontainerheight = newsize.height + 400;
    
    // Set up the container view to hold your custom view hierarchy
   
    
    
    self.containerView = [[UIView alloc] initWithFrame:(CGRect){.origin=CGPointMake(0.0f, 0.0f), .size=containerSize}];
    
    [self.mainscrollview addSubview:self.containerView];
    
    // Set up your custom view hierarchy
    
    selectviews = [[NSMutableArray alloc] init];
    
    
    cscc = [self.storyboard instantiateViewControllerWithIdentifier:@"ContentDetailsCaption"];
    
    
    captionview=cscc.view;
    
          if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
          {
                [captionview setFrame:CGRectMake(10, 0, 300, 40)];
          }
    else
    {
         [captionview setFrame:CGRectMake(34, 0, 700, 60)];
    }
 
   
    
    cscc.captionLabel.text = [selectedContent objectForKey:@"Caption"];
    
    //in between these, need to programatically add the PF Imageview and set its rect to its size.
    
     [self addChildViewController:cscc];
    
    [self.containerView addSubview:captionview];
    
    [selectviews addObject:captionview];
    
    //captionview.layer.cornerRadius = 9.0;
    captionview.layer.masksToBounds = YES;
    
    //controller for images
    
       if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
       {
              [imgtoshow setFrame:CGRectMake(10,41,newsize.width , newsize.height)];
       }
else
{
        [imgtoshow setFrame:CGRectMake(34,61,newsize.width , newsize.height)];
    
    
    
}
    
    [self.containerView addSubview:imgtoshow];
    
    //imgtoshow.layer.cornerRadius = 9.0;
   imgtoshow.layer.masksToBounds = YES;
  
    
    
    //controller for ratings
    
  
    crcc = [self.storyboard instantiateViewControllerWithIdentifier:@"ContentDetailsRating"];
     [self addChildViewController:crcc];
  crcc.selectedContent = selectedContent;
    
    ratingview=crcc.view;
    
     if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
     {
       [ratingview setFrame:CGRectMake(10, newsize.height+ 41, 300, 70)];
     }
   else
   {
       [ratingview setFrame:CGRectMake(34, newsize.height+ 63, 700, 100)];
   }
    
    
    //this is a very important step to make sure that the view controller's CONTROLS are actually accessible even though you add the subview.
  
    
    //ratingview.layer.cornerRadius =9.0;
    
    
   
    
    [self.containerView addSubview:ratingview];
     [selectviews addObject:ratingview];
    //ratingview.layer.cornerRadius = 9.0;
    ratingview.layer.masksToBounds = YES;
    
    //content for social
    
    
  
    csocialcc = [self.storyboard instantiateViewControllerWithIdentifier:@"ContentDetailsSocial"];
    
    [self addChildViewController:csocialcc];
      csocialcc.selectedparsepic = self.selectedContent;
    csocialcc.theimage = imgtoshow;
    
    socialview=csocialcc.view;
    
    //float heightforsocialview = newsize.height + 100;
      //NSLog(@"heightforsocialview: %ld", (long)heightforsocialview);
    
     if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
     {
          [socialview setFrame:CGRectMake(0, newsize.height +111, 320, 200)];
     }
    else
    {
         [socialview setFrame:CGRectMake(34, newsize.height +165, 700, 200)];
    }
   
    
   
    
    [self.containerView addSubview:socialview];
   [selectviews addObject:socialview];
    
   //socialview.layer.cornerRadius = 9.0;
  socialview.layer.masksToBounds = YES;
    
    
    //add contentperformancestats
    cperfcc = [self.storyboard instantiateViewControllerWithIdentifier:@"ContentDetailsPerformanceStats"];
    [self addChildViewController:cperfcc];
    cperfcc.selectedparseobj = self.selectedContent;

    
    perfview=cperfcc.view;
    
    float heightforperfview = socialview.frame.origin.y;
    //NSLog(@"heightforperfview: %ld", (long)heightforsocialview);
    
     if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
     {
    [perfview setFrame:CGRectMake(0, heightforperfview+201, 320, 100)];
     }
    else
    {
          [perfview setFrame:CGRectMake(34, heightforperfview+203, 700, 140)];
    }
    
    
    [self.containerView addSubview:perfview];
    [selectviews addObject:perfview];
   //perfview.layer.cornerRadius = 9.0;
    perfview.layer.masksToBounds = YES;
    
    //add content report inappropriate
    creportcc = [self.storyboard instantiateViewControllerWithIdentifier:@"reportvc"];
    [self addChildViewController:creportcc];
    creportcc.selectedcontentobj = self.selectedContent;
    
    reportview= creportcc.view;
    
    float heightforreport = perfview.frame.origin.y;
    //NSLog(@"heightforperfview: %ld", (long)heightforsocialview);
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
          [reportview setFrame:CGRectMake(0, heightforreport+101, 320, 80)];
    }
    else
    {
        [reportview setFrame:CGRectMake(34, heightforreport+143, 700, 80)];
    }
  
    
    [self.containerView addSubview:reportview];
    [selectviews addObject:reportview];
    //reportview.layer.cornerRadius = 9.0;
    reportview.layer.masksToBounds = YES;

    //[self.containerView setBounds:CGRectMake(0,0, 320, 500)];
    
   // containerSize=CGSizeMake(320,500);
    
    // Tell the scroll view the size of the contents
    self.mainscrollview.contentSize = containerSize;
    
    [self setupgestures];
    
    //display a tutorial popup on the scrollview explaining the swipe left/right
    
    //show a small UI View controller with a dismiss
    
   
    
     if([fpsaccessmode isEqualToString:@"fp"])
        {
            if(browsetuteshown>1)
            {
                return;
            }
        }
    else
    if(votetuteshown>1)
    {
       
        return;
        
    }
    
   
    
    UIViewController *gestureTutorial = [[UIViewController alloc] init];
    
    [self addChildViewController:gestureTutorial];
    
      if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
      {
           gestureTutorial.view.frame = CGRectMake(60,60,200,300);
      }
   else
   {
     gestureTutorial.view.frame = CGRectMake((768-400)/2,60,400,600);
   }
    
    NSString *fileswipe = [[NSBundle mainBundle] pathForResource:@"swipe" ofType:@"png"];
   
   UIImage *bgimage = [UIImage imageWithContentsOfFile:fileswipe];
    
        bgimage = [self imageWithImage:bgimage scaledToSize:gestureTutorial.view.frame.size];
        
            gestureTutorial.view.backgroundColor = [UIColor colorWithPatternImage:bgimage];
        
    UIImageView *arrow = [[UIImageView alloc] init];
    
     NSString *fileswiper = [[NSBundle mainBundle] pathForResource:@"Swipe_Right" ofType:@"png"];
    
    UIImage *image = [UIImage imageWithContentsOfFile:fileswiper];
    
    
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClipToMask(context, rect, image.CGImage);
    //0, 148,68
    UIColor *arrowcolor = [UIColor colorWithRed:(0/255.0) green:(148/255.0) blue:(68/255.0) alpha:1];
    CGContextSetFillColorWithColor(context, [arrowcolor CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImage *flippedImage = [UIImage imageWithCGImage:img.CGImage
                                                scale:1.0 orientation: UIImageOrientationDownMirrored];
    
    arrow.image = flippedImage;
    
    
    
   
    
    UILabel *arrowtext = [[UILabel alloc] init];
    
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        arrow.frame = CGRectMake(68,65,64, 64);
          arrowtext.frame = CGRectMake(45,10,195,50);
         arrowtext.font = [UIFont fontWithName:@"HoboStd" size:12];
    }
    else
    {
        arrow.frame = CGRectMake(125,90,150, 150);
           arrowtext.frame = CGRectMake(75,25,400,100);
         arrowtext.font = [UIFont fontWithName:@"HoboStd" size:22];
    }
    
    
    
    
    
  
    
    arrowtext.text = @"Swipe Right to Dismiss";
   
    
    arrowtext.backgroundColor = [UIColor clearColor];
    
    [gestureTutorial.view addSubview:arrowtext];
    [gestureTutorial.view addSubview:arrow];
    
    if([fpsaccessmode isEqualToString:@"fp"])
    {
     
        browsetuteshown=browsetuteshown+1;
        
        
        UIImageView *rarrow = [[UIImageView alloc] init];
    
        
        
        NSString *fileswipel = [[NSBundle mainBundle] pathForResource:@"Swipe_Left" ofType:@"png"];
        
       
        UIImage *rimage = [UIImage imageWithContentsOfFile:fileswipel];
        
        CGRect rect = CGRectMake(0, 0, image.size.width, rimage.size.height);
        UIGraphicsBeginImageContext(rect.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextClipToMask(context, rect, rimage.CGImage);
        //237, 35,122
        UIColor *arrowcolor = [UIColor colorWithRed:(237/255.0) green:(35/255.0) blue:(122/255.0) alpha:1];
        CGContextSetFillColorWithColor(context, [arrowcolor CGColor]);
        CGContextFillRect(context, rect);
        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        UIImage *flippedImage = [UIImage imageWithCGImage:img.CGImage
                                                    scale:1.0 orientation: UIImageOrientationDownMirrored];
        
        rarrow.image = flippedImage;
        
        
   
     
    
    UILabel *rarrowtext = [[UILabel alloc] init];
    
  
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
             rarrow.frame = CGRectMake(68,190,64, 64);
              rarrowtext.frame = CGRectMake(15,140,195,50);
             rarrowtext.font = [UIFont fontWithName:@"HoboStd" size:12];
        }
        else
        {
            rarrow.frame = CGRectMake(125,330,150, 150);
                rarrowtext.frame = CGRectMake(45,250,400,100);
                rarrowtext.font = [UIFont fontWithName:@"HoboStd" size:22];
        }
    rarrowtext.text = @"Swipe Left For Next Content!";
    
   
    
    rarrowtext.backgroundColor = [UIColor clearColor];
    
    [gestureTutorial.view addSubview:rarrowtext];
     [gestureTutorial.view addSubview:rarrow];
    
    }
        else
        {
             votetuteshown= votetuteshown+1;
        }
    UILabel *tapclosetext = [[UILabel alloc] init];
    
      if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
      {
             tapclosetext.frame = CGRectMake(0,270,200,30);
             tapclosetext.font = [UIFont fontWithName:@"HoboStd" size:8];
      }
    else
    {
         tapclosetext.frame = CGRectMake(0,500,400,50);
        tapclosetext.font = [UIFont fontWithName:@"HoboStd" size:16];
    }
 
    
    tapclosetext.text = @"(Tap To Close This Popup)";
    
 
    
   tapclosetext.backgroundColor = [UIColor clearColor];
    
    tapclosetext.textAlignment = NSTextAlignmentCenter;
    
    [gestureTutorial.view addSubview:tapclosetext];
    
    gestureTutorial.view.layer.cornerRadius = 9.0;
    gestureTutorial.view.layer.masksToBounds = YES;
    
    UIButton *dismissbtn = [[UIButton alloc] init];
    
    [dismissbtn addTarget:self action:@selector(tutorialpopupclose:) forControlEvents:UIControlEventTouchUpInside];
    
    dismissbtn.bounds = gestureTutorial.view.frame;
    
     if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
     {
          dismissbtn.frame = CGRectMake(0,0,200,300);
     }
  else
  {
         dismissbtn.frame = CGRectMake(0,0,400,600);
  }
    
    
    dismissbtn.backgroundColor = [UIColor clearColor];
   
    [gestureTutorial.view addSubview:dismissbtn];
    
    
    
    [self.view addSubview:gestureTutorial.view];
    
    
    
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

-(void) tutorialpopupclose:(id) sender
{
    UIButton *sendbtn = sender;
    UIView *gestview = sendbtn.superview;
   
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{gestview.transform = CGAffineTransformMakeScale(0.25, 0.25);}
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.3
                                               delay:0
                                             options:0
                                          animations:^{gestview.alpha = 0.0;}
                                          completion:^(BOOL finished) {
                                              [gestview removeFromSuperview];
                                              }];
                     }];
    
}
-(void) returnfromalpha:(UIImageView *) b
{
    [UIView animateWithDuration:3
                          delay:0
                        options:0
                     animations:^{imgtoshow.alpha = 1.0;}
                     completion:^(BOOL finished) {
                         //animate return to alpha;
                     }];
}
- (void)setupscreenagain:(PFObject *) parseobj
{
    
    for (UIView *view in selectviews)
    {
        [view removeFromSuperview];
        
    }
    [selectviews removeAllObjects];
    
    
    NSString *fileswipeimgforswipe = [[NSBundle mainBundle] pathForResource:@"imgforswipe" ofType:@"png"];
    
    
   
    imgtoshow.image = [UIImage imageWithContentsOfFile:fileswipeimgforswipe];
    
    [UIView animateWithDuration:0.1
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{imgtoshow.alpha = 0.0;}
                     completion:^(BOOL finished) {
                         [self returnfromalpha:imgtoshow];
                     }];

    
    
    NSString *imglink = [parseobj objectForKey:@"imgLink"];
    NSString *imgurl;
    if(imglink.length<2)
    {
        PFFile *mydata = [parseobj objectForKey:@"imageFile"];
        imgurl = mydata.url;
        
    }
    else
    {
        imgurl =imglink;
    }
    
    NSString *imgtype = [parseobj objectForKey:@"imgURType"];
    
    CGSize result = [[UIScreen mainScreen] bounds].size;
    if(result.height == 480)
    {
        // iPhone Classic
        if([imgtype isEqualToString:@"image/gif"])
        {
            imgurl = @"http://i.imgur.com/cwAB9XA.jpg";
        }
        
    }
    
    
    UIActivityIndicatorViewStyle activityStyle = UIActivityIndicatorViewStyleGray;
    
    //change to UIImage load methods
    UIImage *cellplaceholder = [UIImage imageWithContentsOfFile:@"imgloadingplaceholder.png"];
    [imgtoshow setImageWithURL:[NSURL URLWithString:imgurl] placeholderImage:cellplaceholder usingActivityIndicatorStyle:activityStyle ];
    
    //get height and width of dat WIGGA
    float imgheight = [[parseobj objectForKey:@"imgHeight"] floatValue];
    float imgwidth = [[parseobj objectForKey:@"imgWidth"] floatValue];
    
    float maxw;
    float maxh;
    CGSize containerSize;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        maxw = 300;
        maxh = 2000;
        containerSize = CGSizeMake(320.0f, 2000.0f);
    }
    else
    {
        maxw = 700;
        maxh = 3000;
        containerSize = CGSizeMake(768.0f, 5000.0f);
    }
    
    
    CGSize currentsize = CGSizeMake(imgwidth,imgheight);
    CGSize * sizeobj = &currentsize;
    
    
    CGSize *sizeforimgcontainer = [self scalesize:sizeobj maxWidth:maxw maxHeight:maxh];
    
    //need to take this image size and calculate the proper fuggin aspect ratio to get the real height to show now, WIGGA.
    
    CGSize newsize = *sizeforimgcontainer;
    
    NSLog(@"original height: %ld", (long)imgheight);
    NSLog(@"new max height: %ld", (long)newsize.height);
    
    NSLog(@"original width: %ld", (long)imgwidth);
    NSLog(@"new max width: %ld", (long)newsize.width);
    
    //estimate total container size based on imgheight and other elements.
    
    //float totalcontainerheight = newsize.height + 400;
    
    // Set up the container view to hold your custom view hierarchy
    
    
    
    self.containerView = [[UIView alloc] initWithFrame:(CGRect){.origin=CGPointMake(0.0f, 0.0f), .size=containerSize}];
    
    [self.mainscrollview addSubview:self.containerView];
    
   
    cscc = [self.storyboard instantiateViewControllerWithIdentifier:@"ContentDetailsCaption"];
    
    
    captionview=cscc.view;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        [captionview setFrame:CGRectMake(10, 0, 300, 40)];
    }
    else
    {
        [captionview setFrame:CGRectMake(34, 0, 700, 60)];
    }
    
    
    
    cscc.captionLabel.text = [parseobj objectForKey:@"Caption"];
    
    //in between these, need to programatically add the PF Imageview and set its rect to its size.
    
    [self addChildViewController:cscc];
    
    [self.containerView addSubview:captionview];
    
    [selectviews addObject:captionview];
    
    captionview.layer.cornerRadius = 9.0;
    captionview.layer.masksToBounds = YES;
    
    //controller for images
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        [imgtoshow setFrame:CGRectMake(10,41,newsize.width , newsize.height)];
    }
    else
    {
        [imgtoshow setFrame:CGRectMake(34,61,newsize.width , newsize.height)];
        
        
        
    }
    
    [self.containerView addSubview:imgtoshow];
    
    imgtoshow.layer.cornerRadius = 9.0;
    imgtoshow.layer.masksToBounds = YES;
    
    
    
    //controller for ratings
    
    
    crcc = [self.storyboard instantiateViewControllerWithIdentifier:@"ContentDetailsRating"];
    [self addChildViewController:crcc];
    crcc.selectedContent = parseobj;
    
    ratingview=crcc.view;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        [ratingview setFrame:CGRectMake(10, newsize.height+ 42, 300, 70)];
    }
    else
    {
        [ratingview setFrame:CGRectMake(34, newsize.height+ 64, 700, 100)];
    }
    
    
    //this is a very important step to make sure that the view controller's CONTROLS are actually accessible even though you add the subview.
    
    
    //ratingview.layer.cornerRadius =9.0;
    
    
    
    
    [self.containerView addSubview:ratingview];
    [selectviews addObject:ratingview];
    ratingview.layer.cornerRadius = 9.0;
    ratingview.layer.masksToBounds = YES;
    
    //content for social
    
    
    
    csocialcc = [self.storyboard instantiateViewControllerWithIdentifier:@"ContentDetailsSocial"];
    
    [self addChildViewController:csocialcc];
    csocialcc.selectedparsepic = parseobj;
    
    csocialcc.theimage = imgtoshow;
    
    socialview=csocialcc.view;
    
    //float heightforsocialview = newsize.height + 100;
    //NSLog(@"heightforsocialview: %ld", (long)heightforsocialview);
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        [socialview setFrame:CGRectMake(0, newsize.height +114, 320, 200)];
    }
    else
    {
        [socialview setFrame:CGRectMake(34, newsize.height +169, 700, 200)];
    }
    
    
    
    
    [self.containerView addSubview:socialview];
    [selectviews addObject:socialview];
    
    socialview.layer.cornerRadius = 9.0;
    socialview.layer.masksToBounds = YES;
    
    
    //add contentperformancestats
    cperfcc = [self.storyboard instantiateViewControllerWithIdentifier:@"ContentDetailsPerformanceStats"];
    [self addChildViewController:cperfcc];
    cperfcc.selectedparseobj = parseobj;
    
    
    perfview=cperfcc.view;
    
    float heightforperfview = socialview.frame.origin.y;
    //NSLog(@"heightforperfview: %ld", (long)heightforsocialview);
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        [perfview setFrame:CGRectMake(0, heightforperfview+202, 320, 100)];
    }
    else
    {
        [perfview setFrame:CGRectMake(34, heightforperfview+204, 700, 140)];
    }
    
    
    [self.containerView addSubview:perfview];
    [selectviews addObject:perfview];
    perfview.layer.cornerRadius = 9.0;
    perfview.layer.masksToBounds = YES;
    
    //add content report inappropriate
    creportcc = [self.storyboard instantiateViewControllerWithIdentifier:@"reportvc"];
    [self addChildViewController:creportcc];
    creportcc.selectedcontentobj = parseobj;
    
    reportview= creportcc.view;
    
    float heightforreport = perfview.frame.origin.y;
    //NSLog(@"heightforperfview: %ld", (long)heightforsocialview);
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        [reportview setFrame:CGRectMake(0, heightforreport+102, 320, 80)];
    }
    else
    {
        [reportview setFrame:CGRectMake(34, heightforreport+144, 700, 80)];
    }
    
    
    [self.containerView addSubview:reportview];
    [selectviews addObject:reportview];
    reportview.layer.cornerRadius = 9.0;
    reportview.layer.masksToBounds = YES;
    
    //[self.containerView setBounds:CGRectMake(0,0, 320, 500)];
    
    // containerSize=CGSizeMake(320,500);
    
    // Tell the scroll view the size of the contents
    self.mainscrollview.contentSize = containerSize;
    
    
}

- (void) imgloadinbackground:(PFImageView *) p
{
    [p loadInBackground];
}

- (void) setupgestures
{
    UISwipeGestureRecognizer *rightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipeHandle:)];
    rightRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [rightRecognizer setNumberOfTouchesRequired:1];
    [self.mainscrollview addGestureRecognizer:rightRecognizer];
    
    UISwipeGestureRecognizer *leftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipeHandle:)];
    leftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [leftRecognizer setNumberOfTouchesRequired:1];
    [self.mainscrollview addGestureRecognizer:leftRecognizer];
    
}

- (void)rightSwipeHandle:(UISwipeGestureRecognizer*)gestureRecognizer
{
    //Do moving
    NSLog(@"swiped right");
    
    //get a new piece of content
    
    //check to see if there's content available.
    
    PFObject *newobjtoload;
    
    parseobjindexint = parseobjindexint + 1;
    
    
    if (parseobjindexint < parseObjects.count)
    {
        
         newobjtoload = [parseObjects objectAtIndex:parseobjindexint];
        
        //do loading stuff.  Need to resize image and all that jazz again.
        
        [self setupscreenagain:(newobjtoload)];
    }
    
    else
    {
        NSLog(@"END OF THE LINE PUNK");
        //add some user friendly bs to say you reached the end
         [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No more content", nil) message:NSLocalizedString(@"No More Content To Load!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
    }
   }

- (void)leftSwipeHandle:(UISwipeGestureRecognizer*)gestureRecognizer
{
    // do moving
    NSLog(@"swiped left");
    
    [self.delegate FrontPageSelectionViewControllerBackToFrontPage:self];
    //dismiss view controller
    
    
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonPress:(id)sender {
    
    [self.delegate FrontPageSelectionViewControllerBackToFrontPage:self];
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
    
   //make sure to enforce a maximum height on upload so you dont get fkin nonsense.  
    
    CGSize * size = &newsize;
    
    
    return size;
    
    }


@end
