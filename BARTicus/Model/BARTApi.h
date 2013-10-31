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
#import "Alerts.h"

@interface BARTApi : NSObject <CLLocationManagerDelegate>

@property (nonatomic, strong) NSArray *stations;
@property (nonatomic, strong, readonly) NSDictionary *stationsByAbbreviation;
@property (nonatomic, strong) NSString *lastErrorMessage;

- (Station *)findClosestStation;
- (Schedule *)getScheduleForStation:(Station *)station;
- (Alerts *)getAlerts;
@end
