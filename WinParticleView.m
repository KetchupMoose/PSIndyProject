//
//  WinParticleView.m
//  funnyBusiness
//
//  Created by Macbook on 2013-10-29.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import "WinParticleView.h"
#import <QuartzCore/QuartzCore.h>

@implementation WinParticleView
{
    CAEmitterLayer* fireEmitter; //1
    
}
- (id) initWithFrame:(CGRect)frame particlePosition:(CGPoint)position {
    if((self = [super initWithFrame:frame])) {
        self.userInteractionEnabled = NO;
        self.backgroundColor = [UIColor clearColor];
        fireEmitter= (CAEmitterLayer*)self.layer;
        
        // ...
        // set up layer shape / position
        // ...
        
        //configure the emitter layer
        fireEmitter.emitterPosition = CGPointMake(50, 50);
        fireEmitter.emitterSize = CGSizeMake(10, 10);
        
        
        // ...
        // set up emitter cell
        // ...
        
        CAEmitterCell *emitterCell = [CAEmitterCell emitterCell];
        emitterCell.contents = (id)[[UIImage imageNamed:@"Particles_fire.png"] CGImage];
        
        emitterCell.birthRate = 200;
        emitterCell.lifetime = 3.0;
        emitterCell.lifetimeRange = 0.5;
        emitterCell.color = [[UIColor colorWithRed:0.8 green:0.4 blue:0.2 alpha:0.1] CGColor];
        
        emitterCell.velocity = 10;
        emitterCell.velocityRange = 20;
        emitterCell.emissionRange = M_PI_2;
        
        fireEmitter.emitterCells = [NSArray arrayWithObject:emitterCell];
        
        //fire.scaleSpeed = 0.3;
        //fire.spin = 0.5;
        
    }
    
    return self;
}

- (void)stopEmitting {
    fireEmitter.birthRate = 0.0;
}

-(void)awakeFromNib
{
    //set ref to the layer
    fireEmitter = (CAEmitterLayer*)self.layer; //2
    
    //configure the emitter layer
    fireEmitter.emitterPosition = CGPointMake(50, 50);
    fireEmitter.emitterSize = CGSizeMake(10, 10);
    
    CAEmitterCell* fire = [CAEmitterCell emitterCell];
    fire.birthRate = 200;
    fire.lifetime = 3.0;
    fire.lifetimeRange = 0.5;
    fire.color = [[UIColor colorWithRed:0.8 green:0.4 blue:0.2 alpha:0.1]
                  CGColor];
    fire.contents = (id)[[UIImage imageNamed:@"Particles_fire.png"] CGImage];
    [fire setName:@"fire"];
    
    //add the cell to the layer and we're done
    fireEmitter.emitterCells = [NSArray arrayWithObject:fire];
    
    
}

+ (Class) layerClass //3
{
    //configure the UIView to have emitter layer
    return [CAEmitterLayer class];
}

@end