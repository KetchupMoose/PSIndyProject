//
//  AppDelegate.h
//  petGallery
//
//  Created by mac on 6/17/13.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import <AdColony/AdColony.h>
#import "PlayerData.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate,AdColonyDelegate,AdColonyAdDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UIViewController *viewController;
@property (strong,nonatomic) UITabBarController *tabBarController;
@property (nonatomic) BOOL internet;
@property (nonatomic) BOOL firstload;

@end
