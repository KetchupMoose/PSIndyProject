//
//  PickIAPHelper.m
//  funnyBusiness
//
//  Created by Macbook on 2013-11-19.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import "PickIAPHelper.h"

@implementation PickIAPHelper

+(PickIAPHelper *)sharedInstance {
    static dispatch_once_t once;
    static PickIAPHelper * sharedInstance;
    dispatch_once(&once, ^{
        NSSet * productIdentifiers = [NSSet setWithObjects:
            @"PSFunny999",
            @"PSFunny499",
            @"com.contentgames.picksomething2499",
            @"com.contentgames.picksomething9999",
            @"com.bricorp.funnyBusiness.99cG",
            @"com.contentgames.picksomething4999",
            @"com.contentgames.picksomethingdiamonds999",
            @"com.contentgames.picksomethingdiamonds499",
            @"com.contentgames.picksomethingdiamonds2499",
            @"com.contentgames.picksomethingdiamonds9999",
            @"com.contentgames.picksomethingdiamonds99c",
             @"com.contentgames.picksomethingdiamonds4999",
            nil];
        sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
    });
    return sharedInstance;
}




@end
