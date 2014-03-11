//
//  AppDelegate.m
//  petGallery
//
//  Created by mac on 6/17/13.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import "AppDelegate.h"
#import "Pet.h"
#import <Parse/Parse.h>
#import "MarketplaceQueryTableViewController.h"
//only importing this to try sharing data with it
#import "MarketplaceTableViewController.h"
#import "FrontPageViewController.h"
#import "funData.h"
#import "PickIAPHelper.h"
#import "InternetOfflineViewController.h"
#import "MainLoadTabBarController.h"

@implementation AppDelegate
{
    NSMutableArray *pets;
   
    }
@synthesize viewController = _viewController;
@synthesize internet;
@synthesize firstload;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
   [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    
    
    // Assign tab bar item with titles
    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    UITabBar *tabBar = tabBarController.tabBar;
    
    
    // Allocate a reachability object
    Reachability* reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    // Set the blocks
    firstload=NO;
    
    reach.reachableBlock = ^(Reachability*reach)
    {
        NSLog(@"REACHABLE!");
        internet = YES;
        
       
        // [thisvc presentViewController:iovc animated:YES completion:nil];
        
        
        
    };
    
    reach.unreachableBlock = ^(Reachability*reach)
    {
        NSLog(@"UNREACHABLE!");
        internet = NO;
        
        // [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Internet Connection Failed", nil) message:NSLocalizedString(@"Please Restore Your Internet Connection To Continue Playing Pick Something!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
        
        
    if(firstload==YES)
        
    {
        UINavigationController *mynav = (UINavigationController *)tabBarController.selectedViewController;
        UIViewController *myview = mynav.topViewController;
        
        InternetOfflineViewController *iovc = [[InternetOfflineViewController alloc] init];
        
        [myview addChildViewController:iovc];
        [myview.view addSubview:iovc.view];
        
        
    }
        
        
        
        
    };
    
    [reach startNotifier];

    //ad colony implementation
    [AdColony configureWithAppID:@"appeff82c401e32493f87"
                         zoneIDs:@[@"vzea23b03bdc304d0ea9"]
                        delegate:self
                         logging:YES];
    
    [PickIAPHelper sharedInstance];
    
    
    
    CGSize size = tabBar.frame.size;
    
    UIImage *tabbarbackground;
      if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
      {
           tabbarbackground = [UIImage imageNamed:@"new-bottom-bar-browse.png"];
      }
    else
    {
         tabbarbackground = [UIImage imageNamed:@"pad-bottom-bar-browse.png"];
    }
  
    UIImage *tabbarresized = [self imageWithImage:tabbarbackground scaledToSize:size];
    
    [tabBar setBackgroundImage:tabbarresized];
    
    tabBarController.view.backgroundColor = [UIColor clearColor];
    tabBar.backgroundColor = [UIColor clearColor];
  
    //tabBar.translucent = YES;
    
     
    
  //  UITabBarItem *tabBarItem1 = [tabBar.items objectAtIndex:0];
   // UITabBarItem *tabBarItem2 = [tabBar.items objectAtIndex:1];
    //UITabBarItem *tabBarItem3 = [tabBar.items objectAtIndex:2];
    //UITabBarItem *tabBarItem4 = [tabBar.items objectAtIndex:3];
     // UITabBarItem *tabBarItem5 = [tabBar.items objectAtIndex:4];
    
    //tabBarItem1.title = @"Vote";
    //tabBarItem2.title = @"Browse";
    //tabBarItem3.title = @"My Stuff";
    //tabBarItem4.title = @"Buy";
      //tabBarItem5.title = @"Progress";
    
    //[tabBarItem1 setFinishedSelectedImage:[UIImage imageNamed:@"Vote.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"Vote.png"]];
   //[tabBarItem2 setFinishedSelectedImage:[UIImage imageNamed:@"Browse.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"Browse.png"]];
    //[tabBarItem3 setFinishedSelectedImage:[UIImage imageNamed:@"My-stuff.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"My-stuff.png"]];
    //[tabBarItem4 setFinishedSelectedImage:[UIImage imageNamed:@"Buy.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"Buy.png"]];
      //[tabBarItem5 setFinishedSelectedImage:[UIImage imageNamed:@"Progress.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"Progress.png"]];
    
     UINavigationController *navigation0Controller = [tabBarController viewControllers][0];
    UINavigationController *navigationController = [tabBarController viewControllers][1];
    FrontPageViewController *fpViewController = [navigationController viewControllers][0];
    
    [Parse setApplicationId:@"X6Gpdbw0LhLLUWNAkhYiRlmoZrY6HiSoRhbSfQDW"
                  clientKey:@"sQ9PGdYjUsiKsZkdr6l5pI0BSOv56teq38GG8rzI"];
    
[PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
     [PFFacebookUtils initializeFacebook];
    
    
    // Wipe out old user defaults
    //
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"objectIDArray"]){
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"objectIDArray"];
    }
    
   [PFUser logOut];
   // [[NSUserDefaults standardUserDefaults] synchronize];
   
    // Simple way to create a user or log in the existing user
    // For your app, you will probably want to present your own login screen
   
    
    
    return YES;
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

- ( void ) onAdColonyV4VCReward:(BOOL)success currencyName:(NSString*)currencyName currencyAmount:(int)amount inZone:(NSString*)zoneID {
	NSLog(@"AdColony zone %@ reward %i %i %@", zoneID, success, amount, currencyName);
	
	if (success) {
        PlayerData *sharedData = [PlayerData sharedData];
        
        NSInteger coinBalance = [sharedData.userGold integerValue];
        
        NSInteger diamondBalance = [sharedData.userGems integerValue];
        
        coinBalance = coinBalance + (amount*20);
        
        diamondBalance = diamondBalance +amount;
        
        sharedData.userGold = [NSNumber numberWithInt:coinBalance];
          sharedData.userGems = [NSNumber numberWithInt:diamondBalance];
        
        PFUser *user = [PFUser currentUser];
        
        [user setObject:sharedData.userGold forKey:@"Currency"];
        [user setObject:sharedData.userGems forKey:@"Gems"];
		
        [user saveInBackground];
        
}
}

- (void) onAdColonyAdStartedInZone:(NSString *)zoneID
{
    MainLoadTabBarController *mvc = (MainLoadTabBarController *)self.window.rootViewController;
    
    [mvc stopaudio];
    
    
    
}

- (void) onAdColonyAdAttemptFinished:(BOOL)shown inZone:(NSString *)zoneID
{
    MainLoadTabBarController *mvc = (MainLoadTabBarController *)self.tabBarController;
    [mvc playaudio];
    
    
    
    //give gold rewards
    
}



- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [[PFInstallation currentInstallation] setObject:[PFUser currentUser] forKey:@"user"];
    [currentInstallation setDeviceTokenFromData:newDeviceToken];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
  
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [PFFacebookUtils handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [PFFacebookUtils handleOpenURL:url];
    
}


@end
