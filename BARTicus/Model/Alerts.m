//
//  Alerts.m
//  BARTicus
//
//  Created by Neal Hardesty on 10/9/13.
//  Copyright (c) 2013 RoadWaffle Software. All rights reserved.
//

#import "Alerts.h"

@implementation Alerts

- (BOOL) infoOnly {
    //return [self.emergencies count] > 0 || [self.delays count] > 0;
    return NO;
}

- (NSArray *) infoMessages
{
    if(!_infoMessages) {
        _infoMessages = [[NSMutableArray alloc] init];
    }
    return _infoMessages;
}

- (NSArray *) emergencies
{
    if(!_emergencies) {
        _emergencies = [[NSMutableArray alloc] init];
    }
    return _emergencies;
}

- (NSArray *) delays
{
    if(!_delays) {
        _delays = [[NSMutableArray alloc] init];
    }
    return _delays;
}

- (NSString *) description
{
    if(self.infoOnly) {
        return @"No Alerts";
    } else {
        return [NSString stringWithFormat:@"%@ %@ Info:%d Emergencies:%d Delays:%d", self.dateString, self.timeString, [self.infoMessages count], [self.emergencies count], [self.delays count]];
    }
}

@end
