//
//  NSMutableArray+NSMutableArrayShuffle.h
//  funnyBusiness
//
//  Created by Macbook on 2013-12-02.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

//  NSMutableArray_Shuffling.h

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#else
#include <Cocoa/Cocoa.h>
#endif

// This category enhances NSMutableArray by providing
// methods to randomly shuffle the elements.
@interface NSMutableArray (Shuffling)
- (void)shuffle;
@end

