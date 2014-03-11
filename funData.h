//
//  funData.h
//  funnyBusiness
//
//  Created by Macbook on 2013-11-06.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface funData : NSObject

-(void) copyPlist;
-(void) writeToPlist;
-(NSString *) readFromPlist;

-(float) LoseHeart ;
-(NSDate *) GetHeartTimestamp;
-(NSNumber *) GetNumHearts;
-(void) startUser;
-(float) RestoreAHeart:(float) maxhearts;
-(float) LoseHeartFromMax:(NSDate *) timestamp;
-(float) RestoreMultipleHearts:(float) maxhearts withthismany:(float) hearts;
@end
