//
//  funData.m
//  funnyBusiness
//
//  Created by Macbook on 2013-11-06.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import "funData.h"

@implementation funData

-(void) copyPlist
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"saveData.plist"];
    
    if ([fileManager fileExistsAtPath:plistPath] == NO) {
        NSString *resourcePath = [[NSBundle mainBundle] pathForResource:@"saveData" ofType:@"plist"];
        [fileManager copyItemAtPath:resourcePath toPath:plistPath error:&error];
    }
}

-(void) startUser
{
    [self copyPlist];
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"saveData.plist"];
    
    
       NSMutableDictionary *dict = [NSMutableDictionary
                                 dictionaryWithContentsOfFile:path];
    
    float loveval = 3;
    NSDate *cd = [NSDate date];
    NSNumber *hearts = [NSNumber numberWithFloat:loveval];
    [dict setValue:cd forKey:@"lossDate"];
    [dict setValue:hearts forKey:@"numHearts"];
    
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"YYYY-MM-dd HH:mm:SS"];
    NSString *dateTime = [dateFormat stringFromDate:cd];
    
    NSLog(@"DateTimestart=%@",dateTime);
    
    
    [dict writeToFile:path atomically:YES];
    
}

-(NSString *) readFromPlist
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"saveData.plist"];
    
    
    NSMutableDictionary *dict = [NSMutableDictionary
                                 dictionaryWithContentsOfFile:path];
    
    
    NSString *bingo = [dict objectForKey:@"test1"];
    
    
    return bingo;
    
    
}

-(float) LoseHeart
{
    //get the current number of hearts
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"saveData.plist"];
    
    
    NSMutableDictionary *dict = [NSMutableDictionary
                                 dictionaryWithContentsOfFile:path];
    
    
    NSNumber *hearts = [dict objectForKey:@"numHearts"];
    
    
    //subtract the heart count by the next fraction.
    
    float loveval = [hearts floatValue];
    
    loveval = loveval -1;
    
    if (loveval<=0)
    {
        loveval=0;
        
    }
    
    //write data
    
    //write the new number of hearts
    
    NSNumber *newhearts = [NSNumber numberWithFloat:loveval];
[dict setValue:newhearts forKey:@"numHearts"];
    
    //record the timestamp for when the user lost their heart to power the timer to restore the heart
    
    
    
      [dict writeToFile:path atomically:YES];
    
    return loveval;
    
    
}

-(float) LoseHeartFromMax:(NSDate *) timestamp
{
    //get the current number of hearts
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"saveData.plist"];
    
    
    NSMutableDictionary *dict = [NSMutableDictionary
                                 dictionaryWithContentsOfFile:path];
    
    
    NSNumber *hearts = [dict objectForKey:@"numHearts"];
    
    
    //subtract the heart count by the next fraction.
    
    float loveval = [hearts floatValue];
    
    loveval = loveval -1;
    
    
    if(loveval<=0)
    {
        loveval=0;
        
    }
    //write data
    
    //write the new number of hearts
    
    NSNumber *newhearts = [NSNumber numberWithFloat:loveval];
    [dict setValue:newhearts forKey:@"numHearts"];
    
    //record the timestamp for when the user lost their heart to power the timer to restore the heart
    
    
    NSDate *lossDate = [NSDate date];
    [dict setValue:lossDate forKey:@"lossDate"];
    
    
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"YYYY-MM-dd HH:mm:SS"];
    NSString *dateTime = [dateFormat stringFromDate:lossDate];
    
    NSLog(@"DateTimeloseheart=%@",dateTime);
    
    
    [dict writeToFile:path atomically:YES];
    
    return loveval;
    
    
}
-(NSDate *) GetHeartTimestamp;
{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"saveData.plist"];
    
    
    NSMutableDictionary *dict = [NSMutableDictionary
                                 dictionaryWithContentsOfFile:path];
    
    NSDate *rdate = [dict objectForKey:@"lossDate"];
    
    return rdate;
    
    
    
}
-(NSNumber *) GetNumHearts
{
    
     [self copyPlist];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"saveData.plist"];
    
    
    NSMutableDictionary *dict = [NSMutableDictionary
                                 dictionaryWithContentsOfFile:path];
    
    NSNumber *rhearts = [dict objectForKey:@"numHearts"];
    
    if(rhearts ==nil)
    {
         [dict setValue:[NSNumber numberWithFloat:3] forKey:@"numHearts"];
         NSDate *cd = [NSDate date];
        [dict setValue:cd forKey:@"lossDate"];
        [dict writeToFile:path atomically:YES];
        
        return [NSNumber numberWithFloat:3];
       
        
    }
    return rhearts;
}

-(float) RestoreAHeart:(float) maxhearts
{
    //get number of hearts
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"saveData.plist"];
    
    
    NSMutableDictionary *dict = [NSMutableDictionary
                                 dictionaryWithContentsOfFile:path];
    
    NSNumber *rhearts = [dict objectForKey:@"numHearts"];
    
    // add 1 not exceeding max
    
    float newval = [rhearts floatValue] +1;
    
    if(newval>maxhearts)
    {
        newval=maxhearts;
    }
    
    NSNumber *newhearts = [NSNumber numberWithFloat:newval];
    
    [dict setValue:newhearts forKey:@"numHearts"];
    
    NSDate *setdate = [NSDate date];
    
    [dict setValue:setdate forKey:@"lossDate"];
    
    
   
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"YYYY-MM-dd HH:mm:SS"];
   NSString *dateTime = [dateFormat stringFromDate:setdate];
    
    NSLog(@"DateTimerestoreheart=%@",dateTime);

    
    
    
      [dict writeToFile:path atomically:YES];
    
    return newval;
    
    
}
-(float) RestoreMultipleHearts:(float) maxhearts withthismany:(float) hearts
{
    //get number of hearts
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"saveData.plist"];
    
    
    NSMutableDictionary *dict = [NSMutableDictionary
                                 dictionaryWithContentsOfFile:path];
    
    NSNumber *rhearts = [dict objectForKey:@"numHearts"];
    
    // add 1 not exceeding max
    
    float newval = [rhearts floatValue] +hearts;
    
    if(newval>maxhearts)
    {
        newval=maxhearts;
    }
    
    NSNumber *newhearts = [NSNumber numberWithFloat:newval];
    
    [dict setValue:newhearts forKey:@"numHearts"];
    
    NSDate *setdate = [NSDate date];
    
    [dict setValue:setdate forKey:@"lossDate"];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"YYYY-MM-dd HH:mm:SS"];
    NSString *dateTime = [dateFormat stringFromDate:setdate];
    
    NSLog(@"DateTimerestoreheart=%@",dateTime);
    
    
    [dict writeToFile:path atomically:YES];
    
    return newval;
    
    
}


@end
