//
//  MySignUpViewController.m
//  LogInAndSignUpDemo
//
//  Created by Mattieu Gamache-Asselin on 6/15/12.
//

#import "MySignUpViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "InternetOfflineViewController.h"
@interface MySignUpViewController ()
@property (nonatomic, strong) UIImageView *fieldsBackground;
@end

@implementation MySignUpViewController

@synthesize fieldsBackground;

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    
    NSString *fileName = [[NSBundle mainBundle] pathForResource:@"background-login" ofType:@"png"];
    UIImage *bgimage = [UIImage imageWithContentsOfFile:fileName];
    
    UIImage *b = [self imageWithImage:bgimage scaledToSize:self.signUpView.bounds.size];
    
    [self.signUpView setBackgroundColor:[UIColor colorWithPatternImage:b]];

    
    NSString *logoImageFile = [[NSBundle mainBundle] pathForResource:@"logo-login" ofType:@"png"];
    
    UIImage *logoImg = [UIImage imageWithContentsOfFile:logoImageFile];
    
    UIImageView *logoImgView = [[UIImageView alloc] initWithImage:logoImg];
    
    
    [self.signUpView setLogo:logoImgView];
     self.signUpView.signUpButton.titleLabel.text = @"";
    
    // Change button apperance
    //[self.signUpView.dismissButton setImage:[UIImage imageNamed:@"Exit.png"] forState:UIControlStateNormal];
    //[self.signUpView.dismissButton setImage:[UIImage imageNamed:@"ExitDown.png"] forState:UIControlStateHighlighted];
    
    //[self.signUpView.signUpButton setBackgroundImage:[UIImage imageNamed:@"SignUp.png"] forState:UIControlStateNormal];
    //[self.signUpView.signUpButton setBackgroundImage:[UIImage imageNamed:@"SignUpDown.png"] forState:UIControlStateHighlighted];
    [self.signUpView.signUpButton setTitle:@"" forState:UIControlStateNormal];
    [self.signUpView.signUpButton setTitle:@"" forState:UIControlStateHighlighted];
    
    // Add background for fields
   // [self setFieldsBackground:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SignUpFieldBG.png"]]];
    //[self.signUpView insertSubview:fieldsBackground atIndex:1];
    
    // Remove text shadow
    CALayer *layer = self.signUpView.usernameField.layer;
    layer.shadowOpacity = 0.0f;
    layer.cornerRadius=9.0f;
     layer.borderColor = [[UIColor blackColor]CGColor];
    layer.borderWidth = 2.0f;
    
    layer.masksToBounds = YES;
   
    
    
    layer = self.signUpView.passwordField.layer;
    layer.shadowOpacity = 0.0f;
    layer.cornerRadius=9.0f;
     layer.borderColor = [[UIColor blackColor]CGColor];
    layer.borderWidth = 2.0f;
    layer.masksToBounds = YES;
 
    layer = self.signUpView.emailField.layer;
    layer.shadowOpacity = 0.0f;
    layer.cornerRadius=9.0f;
     layer.borderColor = [[UIColor blackColor]CGColor];
    layer.borderWidth = 2.0f;
    layer.masksToBounds = YES;
    
    layer = self.signUpView.additionalField.layer;
    layer.shadowOpacity = 0.0f;
    layer.cornerRadius=9.0f;
     layer.borderColor = [[UIColor blackColor]CGColor];
    layer.borderWidth = 2.0f;
    layer.masksToBounds = YES;
  
    
    // Set text color
    [self.signUpView.usernameField setTextColor:[UIColor colorWithRed:135.0f/255.0f green:118.0f/255.0f blue:92.0f/255.0f alpha:1.0]];
    [self.signUpView.passwordField setTextColor:[UIColor colorWithRed:135.0f/255.0f green:118.0f/255.0f blue:92.0f/255.0f alpha:1.0]];
    [self.signUpView.emailField setTextColor:[UIColor colorWithRed:135.0f/255.0f green:118.0f/255.0f blue:92.0f/255.0f alpha:1.0]];
    [self.signUpView.additionalField setTextColor:[UIColor colorWithRed:135.0f/255.0f green:118.0f/255.0f blue:92.0f/255.0f alpha:1.0]];
    
    [self.signUpView.usernameField setBackgroundColor:[UIColor whiteColor]];
      [self.signUpView.passwordField setBackgroundColor:[UIColor whiteColor]];
      [self.signUpView.emailField setBackgroundColor:[UIColor whiteColor]];
    
    
    //self.signUpView.signUpButton.titleLabel.font = [UIFont fontWithName:@"CooperBlackStd" size:24];
    self.signUpView.signUpButton.titleLabel.textColor = [UIColor clearColor];
    
   
    // Change "Additional" to match our use
    //[self.signUpView.additionalField setPlaceholder:@"Phone number"];
    
    
    AppDelegate *myad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if(myad.internet==NO)
    {
        InternetOfflineViewController *iovc = [[InternetOfflineViewController alloc] init];
        
        [self addChildViewController:iovc];
        
        [self.view addSubview:iovc.view];
    }
    
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


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    // Move all fields down on smaller screen sizes
    //float yOffset = [UIScreen mainScreen].bounds.size.height <= 480.0f ? 30.0f : 0.0f;
   if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
   {
       CGRect btnfra = self.signUpView.signUpButton.frame;
       btnfra.size = CGSizeMake(404,80);
       self.signUpView.signUpButton.frame = btnfra;
   }
    else
    {
        CGRect btnfra = self.signUpView.signUpButton.frame;
        btnfra = CGRectMake(59,btnfra.origin.y,202,40);
        self.signUpView.signUpButton.frame = btnfra;
    }
 
    
    NSString *filesignbtn = [[NSBundle mainBundle] pathForResource:@"newsignup-button" ofType:@"png"];
    UIImage *btnimage = [UIImage imageWithContentsOfFile:filesignbtn];
    
    UIImage *b2 = [self imageWithImage:btnimage scaledToSize:self.signUpView.signUpButton.bounds.size];
    
    [self.signUpView.signUpButton setBackgroundImage:b2 forState:UIControlStateNormal];
    
    self.signUpView.signUpButton.titleLabel.text = @"";
    
    
    
    CGRect fieldFrame = self.signUpView.usernameField.frame;

   if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
   {
       [self.signUpView.dismissButton setFrame:CGRectMake(140.0f, 460.0f, 87.5f, 45.5f)];
       [self.signUpView.logo setFrame:CGRectMake(150.0f, 52.0f, 500.0f, 376.0f)];
       [self.signUpView.signUpButton setFrame:CGRectMake(115.0f, 685.0f, 500.0f, 80.0f)];
       
       [self.signUpView.usernameField setFrame:CGRectMake(170.0f, 500.0f, 400.0f, 40.0f)];
       [self.signUpView.passwordField setFrame:CGRectMake(170.0f, 555.0f, 400.0f, 40.0f)];
       [self.signUpView.emailField setFrame:CGRectMake(170.0f, 605.0f, 400.0f, 40.0f)];
   }
    else
    {
        [self.signUpView.dismissButton setFrame:CGRectMake(25.0f, 235.0f, 87.5f, 45.5f)];
        [self.signUpView.logo setFrame:CGRectMake(46.0f, 52.0f, 250.0f, 188.0f)];
        [self.signUpView.signUpButton setFrame:CGRectMake(35.0f, 385.0f, 250.0f, 40.0f)];
        
        [self.signUpView.usernameField setFrame:CGRectMake(50.0f, 270.0f, 214.0f, 32.0f)];
        [self.signUpView.passwordField setFrame:CGRectMake(50.0f, 305.0f, 214.0f, 32.0f)];
        [self.signUpView.emailField setFrame:CGRectMake(50.0f, 340.0f, 214.0f, 32.0f)];
    }
    
    
   // [self.signUpView.usernameField setFrame:CGRectMake(fieldFrame.origin.x + 5.0f,fieldFrame.origin.y + yOffset,fieldFrame.size.width - 10.0f,fieldFrame.size.height)];
   
    
    //[self.signUpView.passwordField setFrame:CGRectMake(fieldFrame.origin.x + 5.0f,fieldFrame.origin.y + yOffset,fieldFrame.size.width - 10.0f,fieldFrame.size.height)];
    
    //[self.signUpView.emailField setFrame:CGRectMake(fieldFrame.origin.x + 5.0f,fieldFrame.origin.y + yOffset,fieldFrame.size.width - 10.0f,fieldFrame.size.height)];
    for (UIView * view in self.view.subviews)
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
