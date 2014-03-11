//
//  UITabBarController+TabBarControl.m
//  funnyBusiness
//
//  Created by Macbook on 2013-11-04.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import "UITabBarController+TabBarControl.h"

@implementation UITabBarController (TabBarControl)

- (void)showTabBar:(BOOL)show {
    UITabBar* tabBar = self.tabBar;
    if (show != tabBar.hidden)
        return;
    // This relies on the fact that the content view is the first subview
    // in a UITabBarController's normal view, and so is fragile in the face
    // of updates to UIKit.
    UIView* subview = [tabBar.subviews objectAtIndex:0];
    CGRect frame = subview.frame;
    if (show) {
        frame.size.height -= tabBar.frame.size.height;
    } else {
        frame.size.height += tabBar.frame.size.height;
    }
    subview.frame = frame;
    tabBar.hidden = !show;
}

@end
