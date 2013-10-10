//
//  ParserAlerts.m
//  BARTicus
//
//  Created by Neal Hardesty on 10/9/13.
//  Copyright (c) 2013 RoadWaffle Software. All rights reserved.
//

#import "ParserAlerts.h"

@interface ParserAlerts()
@property (nonatomic, strong) NSString *valueBuffer;
@end

@implementation ParserAlerts

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if([elementName isEqualToString:@"estimate"]) {
        //self.currentTrain = [[Train alloc] init];
    }
}

- (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock
{
    self.valueBuffer = [CDATABlock description];
}


-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    self.valueBuffer = string;
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if([elementName isEqualToString:@"estimate"]) {
        //self.currentTrain.destination = self.currentDestinationAbbreviation;
        //NSLog(@"got train: %@", self.currentTrain);
        //[self.schedule addTrain:self.currentTrain];
        //self.currentTrain = nil;
    }
    
    self.valueBuffer = nil;
}

@end
