//
//  BARTApi.h
//  BARTicus
//
//  Created by Neal Hardesty on 10/1/13.
//  Copyright (c) 2013 RoadWaffle Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "Station.h"
#import "Schedule.h"

@interface BARTApi : NSObject <CLLocationManagerDelegate>

@property (nonatomic, strong) NSArray *stations;
@property (nonatomic, strong, readonly) NSDictionary *stationsByAbbreviation;

- (Station *)findClosestStation;
- (Schedule *)getScheduleForStation:(Station *)station;
@end
