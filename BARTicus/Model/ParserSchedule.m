//
//  ParserSchedule.m
//  BARTicus
//
//  Created by Neal Hardesty on 10/1/13.
//  Copyright (c) 2013 RoadWaffle Software. All rights reserved.
//

#import "ParserSchedule.h"

@interface ParserSchedule()
@property (nonatomic, strong) NSString *valueBuffer;
@property (nonatomic, strong) Train *currentTrain;
@property (nonatomic, strong) NSArray *currentTrains;
@property (nonatomic, strong) NSString *currentDestinationAbbreviation;


@end

@implementation ParserSchedule

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if([elementName isEqualToString:@"estimate"]) {
        self.currentTrain = [[Train alloc] init];
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    self.valueBuffer = string;
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if([elementName isEqualToString:@"estimate"]) {
        [self.schedule.trains addObject:self.currentTrain];
        self.currentTrain = nil;
    } else if([elementName isEqualToString:@"abbreviation"]) {
        // Current destination abbreviation
        self.currentDestinationAbbreviation = self.valueBuffer;
    } else if([elementName isEqualToString:@"minutes"]) {
        self.currentTrain.minutes = [self.valueBuffer intValue];
    } else if([elementName isEqualToString:@"platform"]) {
        self.currentTrain.platform = [self.valueBuffer intValue];
    } else if([elementName isEqualToString:@"direction"]) {
        self.currentTrain.direction = self.valueBuffer;
    } else if([elementName isEqualToString:@"length"]) {
        self.currentTrain.length = [self.valueBuffer intValue];
    } else if([elementName isEqualToString:@"hexcolor"]) {
        self.currentTrain.hexcolor = self.valueBuffer;
    } else if([elementName isEqualToString:@"bikeflag"]) {
        self.currentTrain.platform = [self.valueBuffer boolValue];
    }

    self.valueBuffer = nil;
}
@end
