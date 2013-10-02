//
//  ParserSchedule.h
//  BARTicus
//
//  Created by Neal Hardesty on 10/1/13.
//  Copyright (c) 2013 RoadWaffle Software. All rights reserved.
//

#import "ParserBase.h"
#import "Schedule.h"
#import "Train.h"

@interface ParserSchedule : ParserBase
@property (nonatomic, strong) Schedule *schedule;
@property (nonatomic, weak) Station *station;
@end
