//
//  GoldCoinParticleEmitter.m
//  funnyBusiness
//
//  Created by Macbook on 2013-10-29.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import "GoldCoinParticleEmitter.h"
#import <QuartzCore/QuartzCore.h>

//overtime do three different animations for different tiers of gold you get

@implementation GoldCoinParticleEmitter

{
    CAEmitterLayer* goldEmitter; //1
    CGFloat decayAmount;
    
}
- (id) initWithFrame:(CGRect)frame particlePosition:(CGPoint)position {
    if((self = [super initWithFrame:frame])) {
        self.userInteractionEnabled = NO;
        self.backgroundColor = [UIColor clearColor];
        goldEmitter= (CAEmitterLayer*)self.layer;
        
        // ...
        // set up layer shape / position
        // ...
        
        //configure the emitter layer
        goldEmitter.emitterPosition = position;
        goldEmitter.emitterSize = CGSizeMake(100, 100);
        
        
        // ...
        // set up emitter cell
        // ...
        
        CAEmitterCell *emitterCell = [CAEmitterCell emitterCell];
        emitterCell.contents = (id)[[UIImage imageNamed:@"gold_coin_single_64.png"] CGImage];
        
        emitterCell.birthRate = 5;
        emitterCell.lifetime = 3.0;
        emitterCell.lifetimeRange = 0.5;
        //emitterCell.color = [[UIColor colorWithRed:0.8 green:0.4 blue:0.2 alpha:0.1] CGColor];
        
        emitterCell.velocity = 60;
        emitterCell.velocityRange = 20;
        
        emitterCell.emissionRange = (CGFloat) -M_PI/4;
        emitterCell.emissionLongitude = -M_PI_2;
        emitterCell.yAcceleration = -150;
       
        goldEmitter.emitterCells = [NSArray arrayWithObject:emitterCell];
        
        //fire.scaleSpeed = 0.3;
        //fire.spin = 0.5;
        
    }
    
    return self;
}

static NSTimeInterval const kDecayStepInterval = 0.1;

- (void) decayStep {
    goldEmitter.birthRate -=decayAmount;
    if ( goldEmitter.birthRate < 0) {
         goldEmitter.birthRate = 0;
    } else {
        [self performSelector:@selector(decayStep) withObject:nil afterDelay:kDecayStepInterval ];
    }
}

- (void) decayOverTime:(NSTimeInterval)interval {
    decayAmount = (CGFloat) (goldEmitter.birthRate /  (interval / kDecayStepInterval));
    [self decayStep];
}




- (void)stopEmitting {
    goldEmitter.birthRate = 0.0;
}

+ (Class) layerClass //3
{
    //configure the UIView to have emitter layer
    return [CAEmitterLayer class];
}


@end
