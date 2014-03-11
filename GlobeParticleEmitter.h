//
//  GlobeParticleEmitter.h
//  funnyBusiness
//
//  Created by Macbook on 2013-11-26.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GlobeParticleEmitter : UIView
- (id) initWithFrame:(CGRect)frame particlePosition:(CGPoint)position;
- (void) decayOverTime:(NSTimeInterval)interval;
@end