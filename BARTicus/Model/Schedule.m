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
    NSArray *destinations = [self.trainsByDestination allValues];
    // todo, sort the destinations
    // todo, actually ensure that the order the api returned to us is sorted
    return destinations;
}
@end
