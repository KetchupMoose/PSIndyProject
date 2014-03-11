//
//  Pet.h
//  petGallery
//
//  Created by mac on 6/17/13.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
@interface Pet : NSObject
@property (nonatomic, copy) NSString *petNamec;
@property (nonatomic, copy) NSString *petTypec;
@property (nonatomic, copy) PFFile *petMarketThumbc;

@end
