//
//  InternetOfflineViewController.h
//  funnyBusiness
//
//  Created by Macbook on 2013-12-07.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "UIView+Animation.h"

@class InternetOfflineViewController;

@protocol InternetOfflineViewControllerDelegate <NSObject>

@required
-(void)DismissIOVC:(InternetOfflineViewController *) iovc;


@end


@interface InternetOfflineViewController : UIViewController
@property (nonatomic, strong) id <InternetOfflineViewControllerDelegate> iovcdelegate;

@end
