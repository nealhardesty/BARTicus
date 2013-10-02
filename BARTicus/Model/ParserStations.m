//
//  ParserStations.m
//  BARTicus
//
//  Created by Neal Hardesty on 10/1/13.
//  Copyright (c) 2013 RoadWaffle Software. All rights reserved.
//

#import "ParserStations.h"

@interface ParserStations()
@property (nonatomic, strong) NSString *valueBuffer;
@property (nonatomic, strong) Station *currentStation;
@end

@implementation ParserStations

- (NSArray *)stations
{
    if(!_stations)
        _stations = [[NSMutableArray alloc] init];
    
    return _stations;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{   
    if([elementName isEqualToString:@"station"]) {
        self.currentStation = [[Station alloc] init];
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    self.valueBuffer = string;
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if([elementName isEqualToString:@"station"]) {
        [self.stations addObject:self.currentStation];
        self.currentStation = nil;
    } else if([elementName isEqualToString:@"name"]) {
        self.currentStation.name = self.valueBuffer;
    }else if([elementName isEqualToString:@"abbr"]) {
        self.currentStation.abbreviation = self.valueBuffer;
    }else if([elementName isEqualToString:@"gtfs_latitude"]) {
        self.currentStation.latitude = [self.valueBuffer doubleValue];
    }else if([elementName isEqualToString:@"gtfs_longitude"]) {
        self.currentStation.longitude = [self.valueBuffer doubleValue];
    }else if([elementName isEqualToString:@"address"]) {
        self.currentStation.address = self.valueBuffer;
    }else if([elementName isEqualToString:@"city"]) {
        self.currentStation.city = self.valueBuffer;
    }else if([elementName isEqualToString:@"county"]) {
        self.currentStation.county = self.valueBuffer;
    }else if([elementName isEqualToString:@"state"]) {
        self.currentStation.state = self.valueBuffer;
    }else if([elementName isEqualToString:@"zipcode"]) {
        self.currentStation.zipcode = self.valueBuffer;
    }
    
    self.valueBuffer = nil;
}
@end
