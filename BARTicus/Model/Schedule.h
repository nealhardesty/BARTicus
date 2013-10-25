//
//  Schedule.h
//  BARTicus
//
//  Created by Neal Hardesty on 10/1/13.
//  Copyright (c) 2013 RoadWaffle Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Station.h"
#import "Train.h"

@interface Schedule : NSObject
@property (nonatomic, strong) NSDate *time;
@property (nonatomic, strong) NSString *station; // station abbreviation
@property (nonatomic, strong) NSMutableArray *trains;
@property (nonatomic, strong) NSMutableDictionary *trainsByDestination; // dict of trains by station abbr

- (void)addTrain:(Train *)train;
- (NSArray *)getTrainsGroupedByDestinationSortedByTime;
- (NSArray *)getTrainsForDestination:(NSString *)destinationAbbreviation;
- (void)decrementSchedule;
@end
