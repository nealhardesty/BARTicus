//
//  Train.m
//  BARTicus
//
//  Created by Neal Hardesty on 10/1/13.
//  Copyright (c) 2013 RoadWaffle Software. All rights reserved.
//

#import "Train.h"

@implementation Train

/*@property (nonatomic) short minutes;
 @property (nonatomic, strong) NSString *destination; // abbreviation
 @property (nonatomic, strong) NSString *direction;
 @property (nonatomic) short platform;
 @property (nonatomic) short length; // # of cars
 @property (nonatomic) BOOL bikeflag; // allowed?
 @property (nonatomic, strong) NSString *hexcolor; // Icon color suggestion*/
- (NSString *)description
{
    return [NSString stringWithFormat:@"Train dest:%@ minutes:%hd direction:%@ platform:%hu length:%hu bikes:%@",
            self.destination,
            self.minutes,
            self.direction,
            self.platform,
            self.length,
            self.bikeflag ? @"yes" : @"no"];
}

@end
