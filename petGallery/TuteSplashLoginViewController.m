//
//  TuteSplashLoginViewController.m
//  Pick Something
//
//  Created by Macbook on 2014-01-09.
//  Copyright (c) 2014 bricorp. All rights reserved.
//

#import "TuteSplashLoginViewController.h"
#import "AppDelegate.h"
#import "InternetOfflineViewController.h"

@interface TuteSplashLoginViewController ()
@property (nonatomic, strong) UIImageView *fieldsBackground;
@end

@implementation TuteSplashLoginViewController

@synthesize pageController, pageContent, pageControl;
UIView *splashcontainer;
BOOL loginviewswiping;
NSTimer *timer;
UILabel *quoteLabel;
UILabel *quote2Label;
UIView *starscontainer;

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
    
 
    timer = [NSTimer scheduledTimerWithTimeInterval: 5
                                             target: self
                                           selector: @selector(handleTimer)
                                           userInfo: nil
                                            repeats: YES];
    
    
    /*
    AppDelegate *myad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if(myad.internet==NO)
    {
        InternetOfflineViewController *iovc = [[InternetOfflineViewController alloc] init];
        
        [self addChildViewController:iovc];
        iovc.iovcdelegate = self;
        
        [self.view addSubview:iovc.view];
    }
    */
    //setting custom login details for Parse Login Screen
    
    NSString *fileName = [[NSBundle mainBundle] pathForResource:@"new-background-for-login-screen" ofType:@"png"];
    UIImage *bgimage = [UIImage imageWithContentsOfFile:fileName];
    
    UIImage *b = [self imageWithImage:bgimage scaledToSize:self.logInView.bounds.size];
    
    [self.logInView setBackgroundColor:[UIColor colorWithPatternImage:b]];
    
    NSString *logoImageFile = [[NSBundle mainBundle] pathForResource:@"logo-login" ofType:@"png"];
    
    UIImage *logoImg = [UIImage imageWithContentsOfFile:logoImageFile];
    
    UIImageView *logoImgView = [[UIImageView alloc] initWithImage:logoImg];
    
    [self.logInView setLogo:logoImgView];
    
    NSString *fbImageFile = [[NSBundle mainBundle] pathForResource:@"facebook-login" ofType:@"png"];
    
    UIImage *fbImg = [UIImage imageWithContentsOfFile:fbImageFile];
    
    NSString *lineImageFile = [[NSBundle mainBundle] pathForResource:@"line" ofType:@"png"];
    
    UIImage *line = [UIImage imageWithContentsOfFile:lineImageFile];
    
    NSString *signupbtnFile = [[NSBundle mainBundle] pathForResource:@"signup-button" ofType:@"png"];
    
    UIImage *signupbtnimage = [UIImage imageWithContentsOfFile:signupbtnFile];
    
    NSString *loginbtnFile = [[NSBundle mainBundle] pathForResource:@"login-button" ofType:@"png"];
    
    UIImage *loginbtnimage = [UIImage imageWithContentsOfFile:loginbtnFile];
    
    // [self.logInView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"main_background.png"]]];
    //[self.logInView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]]];
    
    // Set buttons appearance
    // [self.logInView.dismissButton setImage:[UIImage imageNamed:@"exit.png"] forState:UIControlStateNormal];
    //[self.logInView.dismissButton setImage:[UIImage imageNamed:@"exit_down.png"] forState:UIControlStateHighlighted];
    
    [self.logInView.facebookButton setImage:fbImg forState:UIControlStateNormal];
    
    [self.logInView.signUpButton setImage:signupbtnimage forState:UIControlStateNormal];
    
    [self.logInView.logInButton setImage:loginbtnimage forState:UIControlStateNormal];
    
    //[self.logInView.logInButton setImage:loginbtnimage forState:UIControlStateHighlighted];
    
    
    [self.logInView.logInButton setBackgroundImage:nil forState:UIControlStateNormal];
    
    [self.logInView.logInButton setBackgroundImage:nil forState:UIControlStateHighlighted];
    
    [self.logInView.logInButton setTitle:@"" forState:UIControlStateNormal];
    
    [self.logInView.logInButton setTitle:@"" forState:UIControlStateHighlighted];
    
    //[self.logInView.facebookButton setImage:nil forState:UIControlStateHighlighted];
    [self.logInView.facebookButton setBackgroundImage:nil forState:UIControlStateHighlighted];
    [self.logInView.facebookButton setBackgroundImage:nil forState:UIControlStateNormal];
    [self.logInView.facebookButton setTitle:@"" forState:UIControlStateNormal];
    [self.logInView.facebookButton setTitle:@"" forState:UIControlStateHighlighted];
    
    // [self.logInView.twitterButton setImage:nil forState:UIControlStateNormal];
    // [self.logInView.twitterButton setImage:nil forState:UIControlStateHighlighted];
    //[self.logInView.twitterButton setBackgroundImage:[UIImage imageNamed:@"twitter.png"] forState:UIControlStateNormal];
    //[self.logInView.twitterButton setBackgroundImage:[UIImage imageNamed:@"twitter_down.png"] forState:UIControlStateHighlighted];
    //[self.logInView.twitterButton setTitle:@"" forState:UIControlStateNormal];
    // [self.logInView.twitterButton setTitle:@"" forState:UIControlStateHighlighted];
    
    //[self.logInView.signUpButton setBackgroundImage:[UIImage imageNamed:@"signup.png"] forState:UIControlStateNormal];
    // [self.logInView.signUpButton setBackgroundImage:[UIImage imageNamed:@"signup_down.png"] forState:UIControlStateHighlighted];
    // [self.logInView.signUpButton setTitle:@"" forState:UIControlStateNormal];
    //[self.logInView.signUpButton setTitle:@"" forState:UIControlStateHighlighted];
    
    // Add login field background
    //_fieldsBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
    //[self.logInView insertSubview:_fieldsBackground atIndex:1];
    
    self.logInView.signUpLabel.text = @"";
    self.logInView.signUpLabel.backgroundColor = [UIColor clearColor];
    
    self.logInView.externalLogInLabel.text = @"";
    self.logInView.externalLogInLabel.backgroundColor = [UIColor clearColor];
    
    // Remove text shadow
    CALayer *layer = self.logInView.usernameField.layer;
    layer.shadowOpacity = 0.0;
    layer.cornerRadius = 9.0f;
    layer.masksToBounds = YES;
    layer.borderColor = (__bridge CGColorRef)([UIColor blackColor]);
    layer.borderWidth=1.0;
    
    layer = self.logInView.passwordField.layer;
    layer.shadowOpacity = 0.0;
    layer.cornerRadius = 9.0f;
    layer.masksToBounds = YES;
    layer.borderColor = (__bridge CGColorRef)([UIColor blackColor]);
    layer.borderWidth=1.0;
    
    // Set field text color
    [self.logInView.usernameField setTextColor:[UIColor colorWithRed:135.0f/255.0f green:118.0f/255.0f blue:92.0f/255.0f alpha:1.0]];
    [self.logInView.passwordField setTextColor:[UIColor colorWithRed:135.0f/255.0f green:118.0f/255.0f blue:92.0f/255.0f alpha:1.0]];
    
    [self.logInView.usernameField setBackgroundColor:[UIColor whiteColor]];
    [self.logInView.passwordField setBackgroundColor:[UIColor whiteColor]];
    
    CGRect splashframe;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
  splashframe = CGRectMake(0,0,320,490);
    }
    else
    {
        splashframe = CGRectMake(0,0,768,950);
    }
    splashcontainer = [[UIView alloc] initWithFrame:splashframe];
    
    [splashcontainer setBackgroundColor:[UIColor clearColor]];
    
    [self.logInView addSubview:splashcontainer];
    
    
    quoteLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,515,320,40)];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        quoteLabel.frame = CGRectMake(0,60,768,40);
        
    }
    quoteLabel.text = @"\"5/5.  This game is so awesome you will cry with joy\"";
    quoteLabel.font = [UIFont fontWithName:@"CooperBlackStd-Italic" size:15];
    quoteLabel.numberOfLines=2;
    quoteLabel.textAlignment = NSTextAlignmentCenter;
    
    
    quoteLabel.textColor = [UIColor colorWithRed:43.0/255.0f green:57/255.0f blue:144.0/255.0f alpha:1];
    
    
    
    //quoteLabel.textColor = [UIColor redColor];
    
    quoteLabel.backgroundColor = [UIColor clearColor];
    
    quoteLabel.alpha = 0;
    
    
    [self.logInView addSubview:quoteLabel];
    
    
    quote2Label = [[UILabel alloc] initWithFrame:CGRectMake(220,535,100,40)];
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        quote2Label.frame = CGRectMake(580,75,768,40);
        
    }

    quote2Label.text = @"--Brian's Mom";
    quote2Label.font = [UIFont fontWithName:@"CooperBlackStd-Italic" size:11];
    quote2Label.numberOfLines=1;
    quote2Label.textAlignment = NSTextAlignmentLeft;
    
    
    quote2Label.textColor = [UIColor colorWithRed:43.0/255.0f green:57/255.0f blue:144.0/255.0f alpha:1];
    
    
    
    //quoteLabel.textColor = [UIColor redColor];
    
    quote2Label.backgroundColor = [UIColor clearColor];
    
    quote2Label.alpha = 0;
    
    
    [self.logInView addSubview:quote2Label];
    
  
    
    starscontainer = [[UIView alloc] initWithFrame:CGRectMake(0,485,320,40)];
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        starscontainer.frame = CGRectMake(0,10,768,80);
        
    }
    for (int i=0; i<5;i++)
    {
        
        int startx = 230+ i*60;
        
        UIImageView *star1 = [[UIImageView alloc] initWithFrame:CGRectMake(startx,0,56,54)];
        
          if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
          {
              startx = 85 + i*30;
              star1.frame = CGRectMake(startx,0,28,27);
              
          }
        
        NSString *starFile = [[NSBundle mainBundle] pathForResource:@"ratingstar" ofType:@"png"];
        
        UIImage *starFileImage = [UIImage imageWithContentsOfFile:starFile];
      
        [star1 setImage:starFileImage];
        
        [starscontainer addSubview:star1];
        
        
    }
     starscontainer.alpha = 0;
    [self.logInView addSubview:starscontainer];
    
   
    
    
    [self createContentPages];
    NSDictionary *options =
    [NSDictionary dictionaryWithObject:
     [NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin]
                                forKey: UIPageViewControllerOptionSpineLocationKey];
    
    self.pageController = [[UIPageViewController alloc]
                           initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                           navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                           options: options];
    
    pageController.dataSource = self;
    pageController.delegate = self;
    
    [[pageController view] setFrame:splashframe];
    
    
    NSArray *subviews = pageController.view.subviews;
    UIPageControl *thisControl = nil;
    for (int i=0; i<[subviews count]; i++) {
        if ([[subviews objectAtIndex:i] isKindOfClass:[UIPageControl class]]) {
            thisControl = (UIPageControl *)[subviews objectAtIndex:i];
        }
    }
    self.pageControl = thisControl;
    
    
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]];
    
    
    FrontSplashViewController *initialViewController = [self viewControllerAtIndex:0];
    
    //
    NSArray *viewControllers =
    [NSArray arrayWithObject:initialViewController];
    
    [pageController setViewControllers:viewControllers
                             direction:UIPageViewControllerNavigationDirectionForward
                              animated:NO
                            completion:nil];
    
    //pageControl = [[SMPageControl alloc] init];
    //pageControl.numberOfPages=4;
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    pageControl.backgroundColor = [UIColor clearColor];
    //[self.view addSubview:pageControl];
    
    pageController.view.backgroundColor = [UIColor clearColor];
    
    [self addChildViewController:pageController];
   [splashcontainer addSubview:pageController.view];
    [pageController didMoveToParentViewController:self];
    
    self.logInView.logo.alpha =0;
    
    UISwipeGestureRecognizer *rightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipeHandle:)];
    rightRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [rightRecognizer setNumberOfTouchesRequired:1];
    [self.logInView addGestureRecognizer:rightRecognizer];
    
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

- (void) createContentPages
{
    NSMutableArray *pageStrings = [[NSMutableArray alloc] init];
    for (int i = 1; i < 5; i++)
    {
        NSString *contentString = [[NSString alloc]
                                   initWithFormat:@"<html><head></head><body><h1>Chapter %d</h1><p>This is the page %d of content displayed using UIPageViewController in iOS 5.</p></body></html>", i, i];
        [pageStrings addObject:contentString];
    }
    pageContent = [[NSArray alloc] initWithArray:pageStrings];
}

#pragma mark delegate functions for pagecontroller data source

- (FrontSplashViewController *)viewControllerAtIndex:(NSUInteger)index
{
    // Return the data view controller for the given index.
    if (([self.pageContent count] == 0) ||
        (index >= [self.pageContent count])) {
        return nil;
    }
        
    // Create a new view controller and pass suitable data.
    UIStoryboard *sb;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
     sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]];
    }
    else
    {
        sb = [UIStoryboard storyboardWithName:@"MainStoryboard-iPad" bundle:[NSBundle mainBundle]];
    }
    
    
    FrontSplashViewController *dataViewController = [sb instantiateViewControllerWithIdentifier:@"frontsplash"];
    
    [timer invalidate];
    timer = nil;
    
    if (index<3)
    {
        timer = [NSTimer scheduledTimerWithTimeInterval: 5
                                                 target: self
                                               selector: @selector(handleTimer)
                                               userInfo: nil
                                                repeats: YES];
    }
   
    
    //set images and stuff here..
    
    dataViewController.index = index;
    dataViewController.fsplashDelegate = self;
    
    
    dataViewController.dataObject = [self.pageContent objectAtIndex:index];
    return dataViewController;
}

- (NSUInteger)indexOfViewController:(FrontSplashViewController *)viewController
{
    return [self.pageContent indexOfObject:viewController.dataObject];
}

- (UIViewController *)pageViewController:
(UIPageViewController *)pageViewController viewControllerBeforeViewController:
(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:
                        (FrontSplashViewController *)viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    
   
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:
(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:
                        (FrontSplashViewController *)viewController];
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.pageContent count]) {
        return nil;
    }
    
   
    
    return [self viewControllerAtIndex:index];
}

- (void)pageViewController:(UIPageViewController *)pvc didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    // If the page did not turn
    
    if (!completed)
    {
        // You do nothing because whatever page you thought
        // the book was on before the gesture started is still the correct page
        return;
    }
  
    FrontSplashViewController *fs =[previousViewControllers objectAtIndex:0];
    if(fs.index ==2)
    {
        [self makestuffvisible];
        
    }
    
    
    // This is where you would know the page number changed and handle it appropriately
    // [self sendPageChangeNotification:YES];
}



- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.pageContent count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    
    return 0;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.logInView.signUpLabel.text = @"";
    self.logInView.signUpLabel.backgroundColor = [UIColor clearColor];
    // Set frame for elements
    
    //might wanna set these frames more custom..
    
    NSString *loginbtnFile = [[NSBundle mainBundle] pathForResource:@"login-button" ofType:@"png"];
    
    UIImage *loginbtnimage = [UIImage imageWithContentsOfFile:loginbtnFile];
    
    [self.logInView.logInButton setImage:loginbtnimage forState:UIControlStateNormal];
    
    //[self.logInView.logInButton setImage:loginbtnimage forState:UIControlStateHighlighted];
    
    
    [self.logInView.logInButton setBackgroundImage:nil forState:UIControlStateNormal];
    
    [self.logInView.logInButton setBackgroundImage:nil forState:UIControlStateHighlighted];
    
    [self.logInView.logInButton setTitle:@"" forState:UIControlStateNormal];
    
    [self.logInView.logInButton setTitle:@"" forState:UIControlStateHighlighted];
    
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        //if ipad
        
        //set these values for iPad
        [self.logInView.dismissButton setFrame:CGRectMake(10.0f, 10.0f, 87.5f, 45.5f)];
        //[self.logInView.logo setFrame:CGRectMake(46.0f, 52.0f, 250.0f, 188.0f)];
        [self.logInView.logo setFrame:CGRectMake((768-510)/2, 100.0f, 510.0f, 376.0f)];
        
        [self.logInView.facebookButton setFrame:CGRectMake(129.0f, 520.0f, 510.0f, 148.0f)];
        //[self.logInView.twitterButton setFrame:CGRectMake(35.0f+130.0f, 287.0f, 120.0f, 40.0f)];
        [self.logInView.signUpButton setFrame:CGRectMake(135.0f, 870.0f, 175.0f, 53.0f)];
        [self.logInView.logInButton setFrame:CGRectMake(440, 870.0f, 175.0f, 53.0f)];
        
        [self.logInView.usernameField setFrame:CGRectMake(129+55.0f, 690.0f, 400.0f, 75.0f)];
        [self.logInView.passwordField setFrame:CGRectMake(129+55.0f, 780.0f, 400.0f, 75.0f)];
        [self.fieldsBackground setFrame:CGRectMake(35.0f, 145.0f, 250.0f, 100.0f)];
        
        
        
        
    }
    else
    {
        [self.logInView.dismissButton setFrame:CGRectMake(10.0f, 10.0f, 87.5f, 45.5f)];
        [self.logInView.logo setFrame:CGRectMake(46.0f, 52.0f, 250.0f, 188.0f)];
        [self.logInView.facebookButton setFrame:CGRectMake(31.5f, 251.0f, 255.0f, 74.0f)];
        //[self.logInView.twitterButton setFrame:CGRectMake(35.0f+130.0f, 287.0f, 120.0f, 40.0f)];
        [self.logInView.signUpButton setFrame:CGRectMake(40.0f, 434.0f, 87.5f, 26.5f)];
        [self.logInView.logInButton setFrame:CGRectMake(184.0f, 434.0f, 87.5f, 26.5f)];
        
        [self.logInView.usernameField setFrame:CGRectMake(50.0f, 334.0f, 214.0f, 32.0f)];
        [self.logInView.passwordField setFrame:CGRectMake(50.0f, 369.0f, 214.0f, 32.0f)];
        [self.fieldsBackground setFrame:CGRectMake(35.0f, 145.0f, 250.0f, 100.0f)];
        
        
        
        
    }
    
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
            
            CGRect spframe = splashcontainer.frame;
            spframe.size.height = spframe.size.height+80;
            
            splashcontainer.frame = spframe;
            
            NSString *fileName = [[NSBundle mainBundle] pathForResource:@"new-background-login-iphone-5" ofType:@"png"];
            UIImage *bgimage = [UIImage imageWithContentsOfFile:fileName];
            
            UIImage *b = [self imageWithImage:bgimage scaledToSize:self.logInView.bounds.size];
            
            [self.logInView setBackgroundColor:[UIColor colorWithPatternImage:b]];

            CGRect pwframe = self.logInView.passwordField.frame;
           pwframe.origin.y = pwframe.origin.y +15;
            
            self.logInView.passwordField.frame = pwframe;
            
            CGRect emframe = self.logInView.usernameField.frame;
            emframe.origin.y = emframe.origin.y +5;
            
            self.logInView.usernameField.frame = emframe;
            
           
                    }
        else
        {
            
            NSString *fileName = [[NSBundle mainBundle] pathForResource:@"new-background-login-ipad" ofType:@"png"];
            UIImage *bgimage = [UIImage imageWithContentsOfFile:fileName];
            
            UIImage *b = [self imageWithImage:bgimage scaledToSize:self.logInView.bounds.size];
            
            [self.logInView setBackgroundColor:[UIColor colorWithPatternImage:b]];
 
        }
    }

    
}

-(void) makestuffvisible
{
   //[self.view bringSubviewToFront:self.logInView];
    
    
    
    NSString *fileName = [[NSBundle mainBundle] pathForResource:@"new-background-for-login-screen" ofType:@"png"];
    UIImage *bgimage = [UIImage imageWithContentsOfFile:fileName];
    
    UIImage *b = [self imageWithImage:bgimage scaledToSize:self.logInView.bounds.size];
    
    [self.logInView setBackgroundColor:[UIColor colorWithPatternImage:b]];

    
    splashcontainer.userInteractionEnabled = FALSE;
    splashcontainer.alpha=0;
    
    
    self.logInView.logo.alpha = 1;
    self.logInView.facebookButton.alpha=1;
    self.logInView.usernameField.alpha =1;
    self.logInView.passwordField.alpha =1;
    self.logInView.logInButton.alpha = 1;
    self.logInView.signUpButton.alpha = 1;
    
    
    self.logInView.facebookButton.userInteractionEnabled = TRUE;
    self.logInView.usernameField.userInteractionEnabled = TRUE;
    self.logInView.passwordField.userInteractionEnabled = TRUE;
    self.logInView.logInButton.userInteractionEnabled = TRUE;
    self.logInView.signUpButton.userInteractionEnabled = TRUE;
    
       quoteLabel.alpha = 1;
    quote2Label.alpha=1;
    
    starscontainer.alpha=1;
    
}

-(void) makestuffnotvisible
{
    self.logInView.logo.alpha = 0;
    self.logInView.facebookButton.alpha=0;
    self.logInView.usernameField.alpha = 0;
    self.logInView.passwordField.alpha = 0;
    
    self.logInView.logInButton.alpha=0;
    self.logInView.signUpButton.alpha=0;
    
    quoteLabel.alpha = 0;
    quote2Label.alpha = 0;
    starscontainer.alpha = 0;
    
    
    loginviewswiping =FALSE;
    
    splashcontainer.userInteractionEnabled = TRUE;
    splashcontainer.alpha = 1;
    
    
}

- (void)leftSwipeHandleSplash:(UISwipeGestureRecognizer*)gestureRecognizer
{
    

}

- (void)rightSwipeHandleSplash:(UISwipeGestureRecognizer*)gestureRecognizer
{
    [timer invalidate];
    timer = nil;
    
    timer = [NSTimer scheduledTimerWithTimeInterval: 10
                                             target: self
                                           selector: @selector(handleTimer)
                                           userInfo: nil
                                            repeats: YES];
    
}
- (void)rightSwipeHandle:(UISwipeGestureRecognizer*)gestureRecognizer
{
    [timer invalidate];
    timer = nil;
    
    timer = [NSTimer scheduledTimerWithTimeInterval: 10
                                             target: self
                                           selector: @selector(handleTimer)
                                           userInfo: nil
                                            repeats: YES];
    
    
    if(splashcontainer.userInteractionEnabled ==FALSE)
   {
        //FrontSplashViewController *firstViewController = [self viewControllerAtIndex:0];
       // FrontSplashViewController *secondViewController = [self viewControllerAtIndex:1];
       FrontSplashViewController *thirdViewController = [self viewControllerAtIndex:0];
       
       
       NSArray *viewControllers =
       [NSArray arrayWithObjects:thirdViewController, nil];
       
       [pageController setViewControllers:viewControllers
                                direction:UIPageViewControllerNavigationDirectionForward
                                 animated:YES
                               completion:nil];
        splashcontainer.userInteractionEnabled = TRUE;
       
   }
}

- (void)handleTimer
{
    int page = pageControl.currentPage;
    
    
    if ( page + 1 < [pageContent count] )
    {
        page = page+ 1;
          [self changePageToIndex:page];
        if (page==3)
        {
            [self makestuffvisible];
            
        }
        self.pageControl.currentPage = page;
        
        //check if it's #4...do stuff to prevent it from screwing up if #4.
        
    }
    else
    {
        page = 0;
        self.pageControl.currentPage = page;
        
        [self changePageZero];
    }
  
    
}
-(void) changePageToIndex:(int) frog
{
    FrontSplashViewController *thisViewController = [self viewControllerAtIndex:frog];
    
    NSArray *viewControllers =
    [NSArray arrayWithObjects:thisViewController, nil];
    
    [pageController setViewControllers:viewControllers
                             direction:UIPageViewControllerNavigationDirectionForward
                              animated:YES
                            completion:nil];
    
}
- (void)changePageZero
{
    [self makestuffnotvisible];
    
    FrontSplashViewController *thirdViewController = [self viewControllerAtIndex:0];
    
    NSArray *viewControllers =
    [NSArray arrayWithObjects:thirdViewController, nil];
    
    [pageController setViewControllers:viewControllers
                             direction:UIPageViewControllerNavigationDirectionForward
                              animated:YES
                            completion:nil];
    splashcontainer.userInteractionEnabled = TRUE;
    
    
    //int page = _pageControl.currentPage;
   // [_bannerScrollView setContentOffset:CGPointMake(296 * page, 0)];
    
}

-(void)gotologin
{
    [timer invalidate];
    timer = nil;
    
    self.pageControl.currentPage = 3;
    
    FrontSplashViewController *myvc = [self viewControllerAtIndex:3];
    NSArray *viewControllers =
    
    [NSArray arrayWithObjects:myvc, nil];
   
    [pageController setViewControllers:viewControllers
                             direction:UIPageViewControllerNavigationDirectionForward
                              animated:YES
                            completion:nil];
     [self makestuffvisible];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField:textField up:YES];
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField:textField up:NO];
}


- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    int animatedDistance;
    int moveUpValue = textField.frame.origin.y+ textField.frame.size.height;
    UIInterfaceOrientation orientation =
    [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        
        animatedDistance = 216-(460-moveUpValue-5);
    }
    else
    {
        animatedDistance = 162-(320-moveUpValue-5);
    }
       if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
       {
           animatedDistance = 100;
           
       }
    
    if(animatedDistance>0)
    {
        const int movementDistance = animatedDistance;
        const float movementDuration = 0.3f;
        int movement = (up ? -movementDistance : movementDistance);
        [UIView beginAnimations: nil context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: movementDuration];
        self.view.frame = CGRectOffset(self.view.frame, 0, movement);
        [UIView commitAnimations];
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

-(void)DismissIOVC:(InternetOfflineViewController *) iovc
{
    [iovc.view removeWithZoomOutAnimation:1 option:UIViewAnimationOptionCurveEaseIn];
    
    
}


@end
