//
//  NSMutableArray+NSMutableArrayShuffle.m
//  funnyBusiness
//
//  Created by Macbook on 2013-12-02.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

//  NSMutableArray_Shuffling.m

#import "NSMutableArray+NSMutableArrayShuffle.h"

@implementation NSMutableArray (Shuffling)

- (void)shuffle
{
    NSUInteger count = [self count];
    for (NSUInteger i = 0; i < count; ++i) {
        // Select a random element between i and end of array to swap with.
        NSInteger nElements = count - i;
        NSInteger n = arc4random_uniform(nElements) + i;
        [self exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
}

@end