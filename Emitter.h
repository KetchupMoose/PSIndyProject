//
//  Emitter.h
//  
//
//  Created by Jay Hilgert on 2/21/12.
//  Copyright (c) 2012 46 Media. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Emitter : UIView

- (id) initWithFrame:(CGRect)frame particlePosition:(CGPoint)position;
-(void)setIsEmitting:(BOOL)isEmitting;
-(void)stopAnimations;

@end
