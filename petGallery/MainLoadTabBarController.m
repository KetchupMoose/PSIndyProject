//
//  MainLoadTabBarController.m
//  petGallery
//
//  Created by mac on 7/3/13.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import "MainLoadTabBarController.h"
#import <Parse/Parse.h>
#import "PetLogInViewController.h"
#import "TuteSplashLoginViewController.h"
#import "MySignUpViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"
#import "Reachability.h"
#import "WelcomeScreenViewController.h"

@interface MainLoadTabBarController ()

@end

@implementation MainLoadTabBarController
@synthesize theAudio;
@synthesize audioplaying;

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
    
   
	
    self.selectedIndex = 1;
    
    //self.navigationController.navigationBar.translucent = YES;
    NSString *shutterplayerPath = [[NSBundle mainBundle] pathForResource:@"POL-confident-long" ofType:@"aiff"];
   
    self.theAudio =  [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSURL alloc] initFileURLWithPath: shutterplayerPath] error:NULL];
    
    self.theAudio.volume = 1.0;
    
    self.theAudio.delegate = self;

   /*
   [self.theAudio prepareToPlay];
    
    [theAudio setNumberOfLoops: -1];
    
    [theAudio play];
    */
  audioplaying = YES;
    
    self.delegate = self;
    UITabBar *tabBar = self.tabBar;
    
        
        CGSize size = tabBar.frame.size;
        
        UIImage *tabbarbackground;

    NSString *fileName;
    
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
           // tabbarbackground = [UIImage imageNamed:@"new-bottom-bar-browse.png"];
            
            fileName = [[NSBundle mainBundle] pathForResource:@"new-bottom-bar-browse" ofType:@"png"];
           tabbarbackground = [UIImage imageWithContentsOfFile:fileName];

        }
        else
        {
            fileName = [[NSBundle mainBundle] pathForResource:@"pad-bottom-bar-browse" ofType:@"png"];
            tabbarbackground = [UIImage imageWithContentsOfFile:fileName];
        }
        
        UIImage *tabbarresized = [self imageWithImage:tabbarbackground scaledToSize:size];
        
        
        
        [tabBar setBackgroundImage:tabbarresized];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
   NSLog(@"retrieved image: %@", [PFUser currentUser].username);
    
    // Start the notifier, which will cause the reachability object to retain itself!
       
    
    
    // Check if user is logged in
    if (![PFUser currentUser]) {
        
        
        
        // Instantiate our custom log in view controller
        TuteSplashLoginViewController *logInViewController = [[TuteSplashLoginViewController alloc] init];
        [logInViewController setDelegate:self];
        [logInViewController setFacebookPermissions:[NSArray arrayWithObjects:@"friends_about_me,publish_actions", nil]];
        [logInViewController setFields:PFLogInFieldsUsernameAndPassword
         | PFLogInFieldsFacebook
         | PFLogInFieldsSignUpButton
         | PFLogInFieldsLogInButton
         ];
        
        // Instantiate our custom sign up view controller
       MySignUpViewController *signUpViewController = [[MySignUpViewController alloc] init];
        [signUpViewController setDelegate:self];
        [signUpViewController setFields:PFSignUpFieldsDefault];
        
        // Link the sign up view controller
        [logInViewController setSignUpController:signUpViewController];
        
        // Present log in view controller
        
        [self presentViewController:logInViewController animated:YES completion:NULL];
        
    }
    else
    {
        //get data for user.
       
        PlayerData *sharedData = [PlayerData sharedData];
        //
        
        [sharedData getPlayerData];
       
    }
  
}

#pragma mark - PFLogInViewControllerDelegate

// Sent to the delegate to determine whether the log in request should be submitted to the server.
- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
    // Check if both fields are completed
    if (username && password && username.length && password.length) {
        return YES; // Begin login process
    }
    
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Missing Information", nil) message:NSLocalizedString(@"Make sure you fill out all of the information!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
    return NO; // Interrupt login process
}

// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    
      //set all the relevant user data here
    PlayerData *sharedData = [PlayerData sharedData];

    [sharedData getPlayerData];
    
    [self dismissViewControllerAnimated:YES completion:NULL];

}



// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    NSLog(@"Failed to log in...");
}

// Sent to the delegate when the log in screen is dismissed.
- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - PFSignUpViewControllerDelegate

// Sent to the delegate to determine whether the sign up request should be submitted to the server.
- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info {
    BOOL informationComplete = YES;
    
    // loop through all of the submitted data
    for (id key in info) {
        NSString *field = [info objectForKey:key];
        if (!field || !field.length) { // check completion
            informationComplete = NO;
            break;
        }
    }
    
    // Display an alert if a field wasn't completed
    if (!informationComplete) {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Missing Information", nil) message:NSLocalizedString(@"Make sure you fill out all of the information!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
    }
    
    return informationComplete;
}

// Sent to the delegate when a PFUser is signed up.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    
      [self setUserGameData:user];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    
  }

-(void) setUserGameData:(PFUser *) user
{
       PlayerData *sharedData = [PlayerData sharedData];
    [sharedData setPlayerData];
    
    
}



// Sent to the delegate when the sign up attempt fails.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error {
    NSLog(@"Failed to sign up...");
}

// Sent to the delegate when the sign up screen is dismissed.
- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    NSLog(@"User dismissed the signUpViewController");
}


#pragma mark - ()

- (IBAction)logOutButtonTapAction:(id)sender {
    [PFUser logOut];
    [self.navigationController popViewControllerAnimated:YES];
}


-(void) playaudio
{
    [self.theAudio prepareToPlay];
    [theAudio setNumberOfLoops: -1];
    [self.theAudio play];
    audioplaying = YES;
}

-(void) stopaudio
{
    [self.theAudio stop];
    audioplaying = NO;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
  
    NSInteger theindex = tabBarController.selectedIndex;
       UITabBar *tabBar = tabBarController.tabBar;
    NSString *fileName;
    
    
    if(theindex==0)
    {
     
        CGSize size = tabBar.frame.size;
        
        UIImage *tabbarbackground;
        
        
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            fileName = [[NSBundle mainBundle] pathForResource:@"new-bottom-bar-vote" ofType:@"png"];
             tabbarbackground = [UIImage imageWithContentsOfFile:fileName];
            
            //tabbarbackground = [UIImage imageNamed:@"new-bottom-bar-vote.png"];
        }
        else
        {
             fileName = [[NSBundle mainBundle] pathForResource:@"pad-bottom-bar-vote" ofType:@"png"];
             tabbarbackground = [UIImage imageWithContentsOfFile:fileName];
           // tabbarbackground = [UIImage imageNamed:@"pad-bottom-bar-vote.png"];
        }
        
        UIImage *tabbarresized = [self imageWithImage:tabbarbackground scaledToSize:size];
        
        
        
        [tabBar setBackgroundImage:tabbarresized];

    }
    if(theindex==1)
    {
        
        CGSize size = tabBar.frame.size;
        
        UIImage *tabbarbackground;
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            fileName = [[NSBundle mainBundle] pathForResource:@"new-bottom-bar-browse" ofType:@"png"];
            tabbarbackground = [UIImage imageWithContentsOfFile:fileName];
        }
        else
        {
             fileName = [[NSBundle mainBundle] pathForResource:@"pad-bottom-bar-browse" ofType:@"png"];
             tabbarbackground = [UIImage imageWithContentsOfFile:fileName];
            //tabbarbackground = [UIImage imageNamed:@"pad-bottom-bar-browse.png"];
        }
        
        UIImage *tabbarresized = [self imageWithImage:tabbarbackground scaledToSize:size];
        
        
        
        [tabBar setBackgroundImage:tabbarresized];
        
    }
    if(theindex==2)
    {
        
        CGSize size = tabBar.frame.size;
        
        UIImage *tabbarbackground;
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
           fileName = [[NSBundle mainBundle] pathForResource:@"new-bottom-bar-my-stuff" ofType:@"png"];
             tabbarbackground = [UIImage imageWithContentsOfFile:fileName];
            //tabbarbackground = [UIImage imageNamed:@"new-bottom-bar-my-stuff.png"];
        }
        else
        {
            fileName = [[NSBundle mainBundle] pathForResource:@"pad-bottom-bar-my-stuff" ofType:@"png"];
            tabbarbackground = [UIImage imageWithContentsOfFile:fileName];
            
            //tabbarbackground = [UIImage imageNamed:@"pad-bottom-bar-my-stuff.png"];
        }
        
        UIImage *tabbarresized = [self imageWithImage:tabbarbackground scaledToSize:size];
        
        
        
        [tabBar setBackgroundImage:tabbarresized];
        
    }
    if(theindex==3)
    {
        
        CGSize size = tabBar.frame.size;
        
        UIImage *tabbarbackground;
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            fileName = [[NSBundle mainBundle] pathForResource:@"new-bottom-bar-buy" ofType:@"png"];
            tabbarbackground = [UIImage imageWithContentsOfFile:fileName];
            //tabbarbackground = [UIImage imageNamed:@"new-bottom-bar-buy.png"];
        }
        else
        {
            fileName = [[NSBundle mainBundle] pathForResource:@"pad-bottom-bar-buy" ofType:@"png"];
            tabbarbackground = [UIImage imageWithContentsOfFile:fileName];
            //tabbarbackground = [UIImage imageNamed:@"pad-bottom-bar-buy.png"];
        }
        
        UIImage *tabbarresized = [self imageWithImage:tabbarbackground scaledToSize:size];
        
        
        
        [tabBar setBackgroundImage:tabbarresized];
        
    }
    if(theindex==4)
    {
        
        CGSize size = tabBar.frame.size;
        
        UIImage *tabbarbackground;
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            fileName = [[NSBundle mainBundle] pathForResource:@"new-bottom-bar-progress" ofType:@"png"];
            tabbarbackground = [UIImage imageWithContentsOfFile:fileName];
            
            //tabbarbackground = [UIImage imageNamed:@"new-bottom-bar-progress.png"];
        }
        else
        {
            fileName = [[NSBundle mainBundle] pathForResource:@"pad-bottom-bar-progress" ofType:@"png"];
            tabbarbackground = [UIImage imageWithContentsOfFile:fileName];
            //tabbarbackground = [UIImage imageNamed:@"pad-bottom-bar-progress.png"];
        }
        
        UIImage *tabbarresized = [self imageWithImage:tabbarbackground scaledToSize:size];
        
        
        
        [tabBar setBackgroundImage:tabbarresized];
        
    }
    
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


@end
