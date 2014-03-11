//
//  achieveData.m
//  funnyBusiness
//
//  Created by Macbook on 2013-11-11.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import "achieveData.h"

@implementation achieveData


-(void) copyPlist
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"achievementsData.plist"];
    
    if ([fileManager fileExistsAtPath:plistPath] == NO) {
        NSString *resourcePath = [[NSBundle mainBundle] pathForResource:@"achievementsData" ofType:@"plist"];
        [fileManager copyItemAtPath:resourcePath toPath:plistPath error:&error];
    }
}

-(void) startUser
{
    [self copyPlist];
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"achievementsData.plist"];
    
    
    NSMutableDictionary *dict = [NSMutableDictionary
                                 dictionaryWithContentsOfFile:path];
    
    NSString *started = @"startedPlaying";
    
    [dict setValue:started forKey:@"Critic"];
    
    
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
    
    loveval = loveval -0.25;
    
    
    
    //write data
    
    //write the new number of hearts
    
    NSNumber *newhearts = [NSNumber numberWithFloat:loveval];
    [dict setValue:newhearts forKey:@"numHearts"];
    
    //record the timestamp for when the user lost their heart to power the timer to restore the heart
    
    
    
    [dict writeToFile:path atomically:YES];
    
    return loveval;
    
    
}

@end
