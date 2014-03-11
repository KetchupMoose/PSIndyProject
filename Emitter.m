//
//  Emitter.m
//  
//
//  Created by Jay Hilgert on 2/21/12.
//  Copyright (c) 2012 46 Media. All rights reserved.
//

#import "Emitter.h"
#import <QuartzCore/QuartzCore.h>

@implementation Emitter
{
    CAEmitterLayer* starsEmitter; //1
}

- (id) initWithFrame:(CGRect)frame particlePosition:(CGPoint)position {
    if((self = [super initWithFrame:frame])) {
        self.userInteractionEnabled = NO;
        self.backgroundColor = [UIColor clearColor];
        
        
        //set ref to the layer
        starsEmitter = (CAEmitterLayer*)self.layer; //2
        
        //configure the emitter layer
        starsEmitter.emitterPosition = CGPointMake(160, 240);
        starsEmitter.emitterSize = CGSizeMake(self.superview.bounds.size.width,self.superview.bounds.size.height);
        NSLog(@"width = %f, height = %f", starsEmitter.emitterSize.width, starsEmitter.emitterSize.height);
        starsEmitter.renderMode = kCAEmitterLayerPoints;
        starsEmitter.emitterShape = kCAEmitterLayerRectangle;
        starsEmitter.emitterMode = kCAEmitterLayerUnordered;
        
        CAEmitterCell* stars = [CAEmitterCell emitterCell];
        stars.birthRate = 50;
        stars.lifetime = 10;
        stars.lifetimeRange = 0.5;
        stars.color = [[UIColor colorWithRed:255 green:255 blue:255 alpha:0]
                       CGColor];
        stars.contents = (id)[[UIImage imageNamed:@"particle.png"] CGImage];
        stars.velocityRange = 200;
        stars.emissionRange = 360;
        stars.scale = 0.2;
        stars.scaleRange = 0.1;
        stars.alphaRange = 0.3;
        stars.alphaSpeed  = 0.5;
        
        [stars setName:@"stars"];
        
        //add the cell to the layer and we're done
        starsEmitter.emitterCells = [NSArray arrayWithObject:stars];
        
    }
    
    return self;
}


+ (Class) layerClass //3
{
    //configure the UIView to have emitter layer
    return [CAEmitterLayer class];
}

-(void)setIsEmitting:(BOOL)isEmitting
{
    //turn on/off the emitting of particles
    [starsEmitter setValue:[NSNumber numberWithInt:isEmitting?2:0] 
             forKeyPath:@"emitterCells.stars.birthRate"];
}

-(void)stopAnimations {

    [starsEmitter removeAllAnimations];
}

@end