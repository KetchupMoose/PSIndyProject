//
//  PetLoginViewController.m
//  petGallery
//
//  Created by mac on 7/3/13.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import "PetLoginViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
@interface PetLoginViewController ()
@property (nonatomic, strong) UIImageView *fieldsBackground;
@end

@implementation PetLoginViewController

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
    
    
    AppDelegate *myad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if(myad.internet==NO)
    {
        InternetOfflineViewController *iovc = [[InternetOfflineViewController alloc] init];
        
        [self addChildViewController:iovc];
        iovc.iovcdelegate = self;
        
        [self.view addSubview:iovc.view];
    }
    
    //setting custom login details for Parse Login Screen
    
    NSString *fileName = [[NSBundle mainBundle] pathForResource:@"wsnew-background" ofType:@"png"];
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
        [self.logInView.signUpButton setFrame:CGRectMake(135.0f, 910.0f, 175.0f, 53.0f)];
        [self.logInView.logInButton setFrame:CGRectMake(440, 910.0f, 175.0f, 53.0f)];
        
        [self.logInView.usernameField setFrame:CGRectMake(129+55.0f, 710.0f, 400.0f, 75.0f)];
        [self.logInView.passwordField setFrame:CGRectMake(129+55.0f, 800.0f, 400.0f, 75.0f)];
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
        
        [self.logInView.usernameField setFrame:CGRectMake(50.0f, 354.0f, 214.0f, 32.0f)];
        [self.logInView.passwordField setFrame:CGRectMake(50.0f, 389.0f, 214.0f, 32.0f)];
        [self.fieldsBackground setFrame:CGRectMake(35.0f, 145.0f, 250.0f, 100.0f)];
        
    }
    
    
  
    
  
    
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
