//
//  Station.m
//  BARTicus
//
//  Created by Neal Hardesty on 10/1/13.
//  Copyright (c) 2013 RoadWaffle Software. All rights reserved.
//

#import "Station.h"

@implementation Station
- (NSString *) description {
    return [NSString stringWithFormat:@"%@ (%@)", self.name, self.abbreviation];
}
@end
