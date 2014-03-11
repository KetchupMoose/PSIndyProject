//
//  UIView+Animation.m
//  funnyBusiness
//
//  Created by Macbook on 2013-10-22.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import "UIView+Animation.h"

@implementation UIView (Animation)
- (void) moveTo:(CGPoint)destination duration:(float)secs option:(UIViewAnimationOptions)option
{
    [UIView animateWithDuration:secs delay:0.0 options:option
                     animations:^{
                         self.frame = CGRectMake(destination.x,destination.y, self.frame.size.width, self.frame.size.height);
                     }
                     completion:nil];
}

- (void) downUnder:(float)secs option:(UIViewAnimationOptions)option
{
    [UIView animateWithDuration:secs delay:0.0 options:option
                     animations:^{
                         self.transform = CGAffineTransformRotate(self.transform, M_PI);
                     }
                     completion:nil];
}




- (void) addSubviewWithZoomInAnimation:(UIView*)view duration:(float)secs option:(UIViewAnimationOptions)option
{
    // first reduce the view to 1/100th of its original dimension
    CGAffineTransform trans = CGAffineTransformScale(view.transform, 0.01, 0.01);
    view.transform = trans;	// do it instantly, no animation
    [self addSubview:view];
    // now return the view to normal dimension, animating this tranformation
    [UIView animateWithDuration:secs delay:0.0 options:option
                     animations:^{
                         view.transform = CGAffineTransformScale(view.transform, 100.0, 100.0);
                     }
                     completion:nil];
}

- (void) removeWithZoomOutAnimation:(float)secs option:(UIViewAnimationOptions)option
{
	[UIView animateWithDuration:secs delay:0.0 options:option
                     animations:^{
                         self.transform = CGAffineTransformScale(self.transform, 0.01, 0.01);
                     }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
}

// add with a fade-in effect
- (void) addSubviewWithFadeAnimation:(UIView*)view duration:(float)secs option:(UIViewAnimationOptions)option
{
	view.alpha = 0.0;	// make the view transparent
	[self addSubview:view];	// add it
	[UIView animateWithDuration:secs delay:0.0 options:option
                     animations:^{view.alpha = 1.0;}
                     completion:nil];	// animate the return to visible
}

// remove self making it "drain" from the sink!
- (void) removeWithSinkAnimation:(int)steps
{
	NSTimer *timer;
	if (steps > 0 && steps < 100)	// just to avoid too much steps
		self.tag = steps;
	else
		self.tag = 50;
	timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(removeWithSinkAnimationRotateTimer:) userInfo:nil repeats:YES];
}
- (void) removeWithSinkAnimationRotateTimer:(NSTimer*) timer
{
	CGAffineTransform trans = CGAffineTransformRotate(CGAffineTransformScale(self.transform, 0.9, 0.9),0.314);
	self.transform = trans;
	self.alpha = self.alpha * 0.98;
	self.tag = self.tag - 1;
	if (self.tag <= 0)
	{
		[timer invalidate];
		[self removeFromSuperview];
	}
}

- (void) AddWithMoveTo:(UIView *) addview duration:(float) secs option:(UIViewAnimationOptions)option
{
   
    CGRect originalframe = addview.frame;
    CGRect newframe = CGRectMake(-560,0,addview.frame.size.width,addview.frame.size.height);
    
    addview.frame = newframe;
    [self addSubview:addview];
    
    [UIView animateWithDuration:secs delay:0.0 options:option
                     animations:^{
                         addview.frame = CGRectMake(originalframe.origin.x,originalframe.origin.y, originalframe.size.width, originalframe.size.height);
                     }
                     completion:nil];
}



- (void) SlideFromLeft:(UIView *) addview duration:(float) secs option:(UIViewAnimationOptions)option
{
    
    CGRect originalframe = addview.frame;
    CGRect newframe = CGRectMake(-50,addview.frame.origin.y,addview.frame.size.width,addview.frame.size.height);
    
    addview.frame = newframe;
    [self addSubview:addview];
    
    [UIView animateWithDuration:secs delay:0.0 options:option
                     animations:^{
                         addview.frame = CGRectMake(originalframe.origin.x,originalframe.origin.y, originalframe.size.width, originalframe.size.height);
                     }
                     completion:nil];
}

-(void) PopButtonForBounce:(UIButton *) view
{
    //[UIView setAnimationDuration:0.3/1.5];
    [UIView setAnimationDelegate:self];
    
    
   
  
    [UIView animateWithDuration:0.2 animations:^{
        view.transform =  view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
    }
                     completion:^(BOOL finished) {
                         
                         //create the new button
                         NSString *fileName = [[NSBundle mainBundle] pathForResource:@"guess-popular-new-design" ofType:@"png"];
                        
                         UIImage *btnimage = [UIImage imageWithContentsOfFile:fileName];
                         
                         [view setImage:btnimage forState:UIControlStateNormal];
                         
                         
                         
                         [self BounceAView:view];
                     }
     ];

}

-(void) PopButtonWithBounce:(UIButton *) view
{
    //[UIView setAnimationDuration:0.3/1.5];
    [UIView setAnimationDelegate:self];
    
    
    [UIView animateWithDuration:0.2 animations:^{
        view.transform =  view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
    }
                     completion:^(BOOL finished) {
                         [self PopButtonEnd:view];
                     }
     ];
    
}






-(void) PopButtonEnd:(UIButton *) view
{
    
    
    
    //[UIView setAnimationDuration:0.3/1.5];
    [UIView setAnimationDelegate:self];
   
    //[self addSubview:view];
   
    [UIView animateWithDuration:0.3 animations:^{
      view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
        view.alpha = 0.1;
        
    }
                     completion:^(BOOL finished) {
                         //[view removeFromSuperview];
                         view.alpha = 0;
                         
                     }
     ];


}

-(void)bounce1AnimationStopped:(UIView *) view {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.6/2];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(bounce2AnimationStopped)];
    view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
    [UIView commitAnimations];
}

- (void)bounce2AnimationStopped:(UIView *) view {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3/2];
    view.transform = CGAffineTransformIdentity;
    [UIView commitAnimations];
}

-(void) SpinAView:(UIView *) view
{
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    
    animation.fromValue = @(0);
    animation.toValue = @(-2 * M_PI);
    animation.repeatCount = 1;
    animation.duration = 0.9;
    
    [view.layer addAnimation:animation forKey:@"rotation"];
    
    
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = 1.0 / 500.0;
    view.layer.transform = transform;
}

-(void) SpinThenAdd:(UIView *) view withHeartView:(UIView *) heartView
{
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    
    animation.fromValue = @(0);
    animation.toValue = @(2 * M_PI);
    animation.repeatCount = 1;
    animation.duration = 1.2;
    
    [view.layer addAnimation:animation forKey:@"rotation"];
    
    
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = 1.0 / 500.0;
    view.layer.transform = transform;
    
    heartView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
    
    
    //[UIView setAnimationDuration:0.3/1.5];
    [UIView setAnimationDelegate:self];
    
    [view addSubview:heartView];
    
   
    [UIView animateWithDuration:0.2 delay:0.9 options:UIViewAnimationOptionCurveLinear animations:^{
      heartView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 2.1, 2.1);
   } completion:^(BOOL finished) {
         [self addHeartStopped3:heartView withCellView:view];
   }];
   }

-(void) addHeartThenSpin:(UIView *) view withCellView:(UIView *) cv
{
 
    view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
    
    
    //[UIView setAnimationDuration:0.3/1.5];
    [UIView setAnimationDelegate:self];
    
    [self addSubview:view];
    
    [UIView animateWithDuration:0.3 animations:^{
        view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 2.1, 2.1);
       
        
    }
                     completion:^(BOOL finished) {
                         [self addHeartStopped1:view withCellView:cv];
                     }
     ];

    
}
-(void)addHeartStopped1:(UIView *) view withCellView:(UIView *) thecell {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.6/2];
    [UIView setAnimationDelegate:self];
    
    
    [UIView animateWithDuration:0.3 animations:^{
        view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
        
        
    }
                     completion:^(BOOL finished) {
                         [self addHeartStopped2:view withCellView:thecell];
                     }
     ];

 
    
}

-(void)addHeartStopped2:(UIView *) view withCellView:(UIView *) thecell{
   // [UIView beginAnimations:nil context:nil];
    //[UIView setAnimationDuration:0.6/2];
    [UIView setAnimationDelegate:self];
    
    float originalx = view.frame.origin.x;
    float originaly = view.frame.origin.y;
    
    //[UIView setAnimationDidStopSelector:@selector(addHeartStopped2)];
    
    [UIView animateWithDuration:0.2
                     animations:^{
                         view.frame = CGRectMake(originalx+45,originaly-70,view.frame.size.width,view.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         [self SpinAView:thecell];
                     }
     ];
    
    [UIView commitAnimations];
    
}

-(void)addHeartStopped3:(UIView *) view withCellView:(UIView *) thecell {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.6/2];
    [UIView setAnimationDelegate:self];
    
    
    [UIView animateWithDuration:0.4 animations:^{
        view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
        
        
    }
                     completion:^(BOOL finished) {
                         [self addHeartStopped4:view withCellView:thecell];
                     }
     ];
    
    
    
}

-(void)addHeartStopped4:(UIView *) view withCellView:(UIView *) thecell{
    // [UIView beginAnimations:nil context:nil];
    //[UIView setAnimationDuration:0.6/2];
    [UIView setAnimationDelegate:self];
    
    float originalx = view.frame.origin.x;
    float originaly = view.frame.origin.y;
    
    //[UIView setAnimationDidStopSelector:@selector(addHeartStopped2)];
    
    [UIView animateWithDuration:0.2
                     animations:^{
                         view.frame = CGRectMake(originalx+45,originaly-70,view.frame.size.width,view.frame.size.height);
                     }
                     completion:nil
     ];
    
    [UIView commitAnimations];
    
}

-(void) GrowAView:(UIView *) view WithNewOrigin:(CGPoint ) newpoint
{
    CGRect origframe = view.frame;
    origframe.origin = newpoint;
   
    [UIView animateWithDuration:0.4 delay:1 options:UIViewAnimationOptionCurveLinear animations:^{
         view.frame = origframe;
        view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.5, 1.5);
    }
                     completion:nil];
    

}



-(void) BounceAddTheView:(UIView *) view
{
    
  view.transform =  view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
    
    //[UIView setAnimationDuration:0.3/1.5];
    [UIView setAnimationDelegate:self];
    
    [self addSubview:view];
    
    [UIView animateWithDuration:0.4 animations:^{
        view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 2.1, 2.1);
    }
                     completion:^(BOOL finished) {
                         [self bounce1addtheviewAnimationStopped:view];
                     }
     ];
}

-(void) BounceAView:(UIView *) view
{
    
    view.transform =  view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
    
    //[UIView setAnimationDuration:0.3/1.5];
    [UIView setAnimationDelegate:self];
    
    [self addSubview:view];
    
    [UIView animateWithDuration:0.4 animations:^{
        view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
        
    }
                     completion:^(BOOL finished) {
                         [self bounce1addtheviewAnimationStopped:view];
                     }
     ];
}


-(void)bounce1addtheviewAnimationStopped:(UIView *) view {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.6/2];
    [UIView setAnimationDelegate:self];
    
  
    [UIView setAnimationDidStopSelector:@selector(bounce2addtheviewAnimationStopped)];
    view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
    
    [UIView commitAnimations];
}

- (void)bounce2addtheviewAnimationStopped:(UIView *) view {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3/2];
 
    
    view.transform = CGAffineTransformIdentity;
   
    [UIView commitAnimations];
}


-(void) BounceViewThenFadeAlpha:(UIView *) view
{
    
    view.transform =  view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.2, 0.2);
    
    //[UIView setAnimationDuration:0.3/1.5];
    [UIView setAnimationDelegate:self];
    
    [self addSubview:view];
    
    [UIView animateWithDuration:0.6 animations:^{
        view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
    }
                     completion:^(BOOL finished) {
                         [self bouncebackbeforefade:view];
                     }
     ];
}


-(void)bouncebackbeforefade:(UIView *) view {
    [UIView setAnimationDelegate:self];
    [UIView animateWithDuration:0.4 animations:^{
        view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
    }
                     completion:^(BOOL finished) {
                         [self bouncefade:view];
                     }
     ];

}

- (void)bouncefade:(UIView *) view {
     [UIView setAnimationDelegate:self];
    [UIView animateWithDuration:2 animations:^{
        view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
        view.alpha = 0.1;
    }
                     completion:^(BOOL finished) {
                         [view removeFromSuperview];
                         
                     }
     ];

}





@end
