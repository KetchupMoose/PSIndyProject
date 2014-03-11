//
//  UIView+Animation.h
//  funnyBusiness
//
//  Created by Macbook on 2013-10-22.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Animation)

- (void) moveTo:(CGPoint)destination duration:(float)secs option:(UIViewAnimationOptions)option;

- (void) downUnder:(float)secs option:(UIViewAnimationOptions)option;

- (void) addSubviewWithZoomInAnimation:(UIView*)view duration:(float)secs option:(UIViewAnimationOptions)option;
- (void) removeWithZoomOutAnimation:(float)secs option:(UIViewAnimationOptions)option;

- (void) addSubviewWithFadeAnimation:(UIView*)view duration:(float)secs option:(UIViewAnimationOptions)option;
- (void) removeWithSinkAnimation:(int)steps;
- (void) removeWithSinkAnimationRotateTimer:(NSTimer*) timer;
- (void) AddWithMoveTo:(UIView *) addview duration:(float) secs option:(UIViewAnimationOptions)option;
- (void) AddFromTop:(UIView *) addview duration:(float) secs option:(UIViewAnimationOptions)option;
-(void) BounceAView:(UIView *) view;
-(void) PopButtonForBounce:(UIView *) view;
-(void) BounceAddTheView:(UIView *) view;
- (void) SlideFromLeft:(UIView *) addview duration:(float) secs option:(UIViewAnimationOptions)option;
-(void) PopButtonWithBounce:(UIButton *) view;
-(void) BounceViewThenFadeAlpha:(UIView *) view;
-(void) addHeartThenSpin:(UIView *) view withCellView:(UIView *) cv;
-(void) SpinAView:(UIView *) view;
-(void) SpinThenAdd:(UIView *) view withHeartView:(UIView *) heartView;
-(void) GrowAView:(UIView *) view WithNewOrigin:(CGPoint ) newpoint;
@end
