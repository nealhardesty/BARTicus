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
    return [NSString stringWithFormat:@"%@ (%@) %lu trains", self.station, self.time, (unsigned long)[self.trains count]];
}


/*
 * Decrement the schedule of each train by 1 minute, removing negative values
 */
- (void)decrementSchedule
{
    if(self.trains) {
        NSMutableArray *trainsToKeep = [NSMutableArray arrayWithCapacity:[self.trains count]];
        for(Train *train in self.trains) {
            train.minutes = train.minutes - 1;
            if(train.minutes >= 0) {
                [trainsToKeep addObject:train];
            }
        }

        [self.trains removeAllObjects];
        [self.trainsByDestination removeAllObjects];
        for(Train *train in trainsToKeep) {
            [self addTrain:train];
        }
    }
}


/*
 * Convenience method to add a new train 
 *  Adds to 'trains' and 'trainsByDestination' properties
 */
- (void)addTrain:(Train *)train
{
    [self.trains addObject:train];
    //NSLog(@"added train count:%lu train:%@", (unsigned long)[self.trains count], train);
    if(! [self.trainsByDestination objectForKey:train.destination]) {
        [self.trainsByDestination setObject:[[NSMutableArray alloc] init] forKey:train.destination];
        //NSLog(@"added new destination: %@", train.destination);
    }
    NSMutableArray *destination = [self.trainsByDestination objectForKey:train.destination];
    [destination addObject:train];
}

/*
 * Return an NSArray of NSArrays of Train
 
 First NSArray is by Destination
 Second NSArray is by Train
 
 All are sorted by the next arriving trains
 */
- (NSArray *)getTrainsGroupedByDestinationSortedByTime
{
    NSArray *destinations = [[self.trainsByDestination allValues] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSArray *trains1 = (NSArray *)obj1;
        NSArray *trains2 = (NSArray *)obj2;
        Train *trainFromTrains1 = (Train *)trains1[0];
        Train *trainFromTrains2 = (Train *)trains2[0];
        if(trainFromTrains1.minutes == trainFromTrains2.minutes) {
            return (NSComparisonResult)NSOrderedSame;
        } else if(trainFromTrains1.minutes < trainFromTrains2.minutes) {
            return (NSComparisonResult)NSOrderedAscending;
        } else {
            return (NSComparisonResult)NSOrderedDescending;
        }
    }];
    
    // todo: actually ensure that the order the api returned to us is sorted
    return destinations;
}

- (NSArray *)getTrainsForDestination:(NSString *)destinationAbbreviation
{
    return self.trainsByDestination[destinationAbbreviation];
}
@end
