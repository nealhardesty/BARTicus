//
//  Schedule.m
//  BARTicus
//
//  Created by Neal Hardesty on 10/1/13.
//  Copyright (c) 2013 RoadWaffle Software. All rights reserved.
//

#import "Schedule.h"

@implementation Schedule
- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ (%@)", self.station, self.time];
}
@end
