//
//  MainLoadTabBarController.h
//  petGallery
//
//  Created by mac on 7/3/13.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <AVFoundation/AVFoundation.h>
#import "funData.h"
#import "PlayerData.h"
#import "InternetOfflineViewController.h"
#import "WelcomeScreenViewController.h"

@interface MainLoadTabBarController : UITabBarController <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate,AVAudioPlayerDelegate,WelcomeScreenViewControllerDelegate,UITabBarControllerDelegate>
- (IBAction)logOutButtonTapAction:(id)sender;
@property (nonatomic, strong) AVAudioPlayer *theAudio;
-(void) playaudio;
-(void) stopaudio;
@property (nonatomic) BOOL audioplaying;

@end
