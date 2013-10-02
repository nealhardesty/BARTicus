//
//  ParserStations.h
//  BARTicus
//
//  Created by Neal Hardesty on 10/1/13.
//  Copyright (c) 2013 RoadWaffle Software. All rights reserved.
//

#import "ParserBase.h"
#import "Station.h"

@interface ParserStations : ParserBase
@property (nonatomic, strong) NSMutableArray *stations;
@property (nonatomic, strong) NSMutableDictionary *stationsByAbbreviations;

@end
