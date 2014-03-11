//
//  GlobeParticleEmitter.m
//  funnyBusiness
//
//  Created by Macbook on 2013-11-26.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import "GlobeParticleEmitter.h"
#import <QuartzCore/QuartzCore.h>

@implementation GlobeParticleEmitter
{
    CAEmitterLayer* globeEmitter; //1
    CGFloat decayAmount;
    
}
- (id) initWithFrame:(CGRect)frame particlePosition:(CGPoint)position {
    if((self = [super initWithFrame:frame])) {
        self.userInteractionEnabled = NO;
        self.backgroundColor = [UIColor clearColor];
        globeEmitter= (CAEmitterLayer*)self.layer;
        
        // ...
        // set up layer shape / position
        // ...
        
        //configure the emitter layer
        globeEmitter.emitterPosition = position;
        globeEmitter.emitterSize = CGSizeMake(100, 100);
        
        
        // ...
        // set up emitter cell
        // ...
        
        CAEmitterCell *emitterCell = [CAEmitterCell emitterCell];
        
        //change to image with contents of file
        NSString *fileName = [[NSBundle mainBundle] pathForResource:@"topbarglobe-icon" ofType:@"png"];
        UIImage *globeimage = [UIImage imageWithContentsOfFile:fileName];
        
        emitterCell.contents = (id)[globeimage CGImage];
        
        emitterCell.birthRate = 5;
        emitterCell.lifetime = 3.0;
        emitterCell.lifetimeRange = 0.5;
        //emitterCell.color = [[UIColor colorWithRed:0.8 green:0.4 blue:0.2 alpha:0.1] CGColor];
        
        emitterCell.velocity = 60;
        emitterCell.velocityRange = 20;
        
        emitterCell.emissionRange = (CGFloat) -M_PI/4;
        emitterCell.emissionLongitude = -M_PI_2;
        emitterCell.yAcceleration = -150;
        
        globeEmitter.emitterCells = [NSArray arrayWithObject:emitterCell];
        
        //fire.scaleSpeed = 0.3;
        //fire.spin = 0.5;
        
    }
    
    return self;
}

static NSTimeInterval const kDecayStepInterval = 0.1;

- (void) decayStep {
    globeEmitter.birthRate -=decayAmount;
    if ( globeEmitter.birthRate < 0) {
        globeEmitter.birthRate = 0;
    } else {
        [self performSelector:@selector(decayStep) withObject:nil afterDelay:kDecayStepInterval ];
    }
}

- (void) decayOverTime:(NSTimeInterval)interval {
    decayAmount = (CGFloat) (globeEmitter.birthRate /  (interval / kDecayStepInterval));
    [self decayStep];
}




- (void)stopEmitting {
    globeEmitter.birthRate = 0.0;
}

+ (Class) layerClass //3
{
    //configure the UIView to have emitter layer
    return [CAEmitterLayer class];
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
