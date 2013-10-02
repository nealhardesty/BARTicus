//
//  ParserStations.m
//  BARTicus
//
//  Created by Neal Hardesty on 10/1/13.
//  Copyright (c) 2013 RoadWaffle Software. All rights reserved.
//

#import "ParserBase.h"

@implementation ParserBase

- (ParserBase *)initWithParser:(NSXMLParser *)parser
{
    self = [super init];
    
    [parser setDelegate:self];

    [parser parse];
    
    return self;
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    self.error = parseError;
}
@end
