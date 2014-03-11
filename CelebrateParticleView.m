//
//  CelebrateParticleView.m
//  funnyBusiness
//
//  Created by Macbook on 2013-10-29.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import "CelebrateParticleView.h"
#import <QuartzCore/QuartzCore.h>
@implementation CelebrateParticleView

{
    CAEmitterLayer* confettiLayer; //1
    CGFloat decayAmount;
    
}
- (id) initWithFrame:(CGRect)frame particlePosition:(CGPoint)position {
    if((self = [super initWithFrame:frame])) {
        self.userInteractionEnabled = NO;
        self.backgroundColor = [UIColor clearColor];
        confettiLayer= (CAEmitterLayer*)self.layer;
        
        // ...
        // set up layer shape / position
        // ...
        
        //configure the emitter layer
        confettiLayer.emitterPosition = CGPointMake(self.bounds.size.width /2, 0);
        
        confettiLayer.emitterSize = self.bounds.size;
        confettiLayer.emitterShape = kCAEmitterLayerLine;
        
        
        // ...
        // set up emitter cell
        // ...
        
        CAEmitterCell *confetti = [CAEmitterCell emitterCell];
        confetti.contents = (id)[[UIImage imageNamed:@"Confetti.png"] CGImage];
        confetti.name = @"confetti";
        confetti.birthRate = 150;
        confetti.lifetime = 3.0;
        confetti.color = [[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1.0] CGColor];
        confetti.redRange = 0.8;
        confetti.blueRange = 0.8;
        confetti.greenRange = 0.8;
        
        confetti.velocity = 250;
        confetti.velocityRange = 50;
        confetti.emissionRange = (CGFloat) M_PI_2;
        confetti.emissionLongitude = (CGFloat) M_PI;
        confetti.yAcceleration = 150;
       
        confetti.spinRange = 10.0;
        confetti.scale = 1.0;
        confetti.scaleRange = 0.2;
        
        confettiLayer.emitterCells = [NSArray arrayWithObject:confetti];

        
    }
    
    return self;
}


static NSTimeInterval const kDecayStepInterval = 0.1;

- (void) decayStep {
    confettiLayer.birthRate -=decayAmount;
    if (confettiLayer.birthRate < 0) {
        confettiLayer.birthRate = 0;
    } else {
        [self performSelector:@selector(decayStep) withObject:nil afterDelay:kDecayStepInterval ];
    }
}

- (void) decayOverTime:(NSTimeInterval)interval {
    decayAmount = (CGFloat) (confettiLayer.birthRate /  (interval / kDecayStepInterval));
    [self decayStep];
}

- (void)stopEmitting {
    confettiLayer.birthRate = 0.0;
}



+ (Class) layerClass //3
{
    //configure the UIView to have emitter layer
    return [CAEmitterLayer class];
}

@end
