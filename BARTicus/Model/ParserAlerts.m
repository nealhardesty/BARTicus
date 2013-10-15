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

// INFORMATION DELAY or EMERGENCY
@property (nonatomic, strong) NSString *currentMessageType;
@property (nonatomic, strong) NSString *currentMessage;
@end

@implementation ParserAlerts

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if([elementName isEqualToString:@"root"]) {
        self.alerts = [[Alerts alloc] init];
    }
}

- (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock
{
    self.valueBuffer = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
}


-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    self.valueBuffer = string;
}

#define INFORMATION_TYPE_STRING @"INFORMATION"
#define EMERGENCY_TYPE_STRING @"EMERGENCY"
#define DELAY_TYPE_STRING @"DELAY"

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if([elementName isEqualToString:@"bsa"]) {
        if([self.currentMessageType isEqualToString:INFORMATION_TYPE_STRING]) {
            [self.alerts.infoMessages addObject:self.currentMessage];
        } else if([self.currentMessageType isEqualToString:EMERGENCY_TYPE_STRING]) {
            [self.alerts.emergencies addObject:self.currentMessage];
        } else if([self.currentMessageType isEqualToString:DELAY_TYPE_STRING]) {
            [self.alerts.delays addObject:self.currentMessage];
        }
    } else if([elementName isEqualToString:@"type"]) {
        self.currentMessageType = self.valueBuffer;
    } else if([elementName isEqualToString:@"date"]) {
        self.alerts.dateString = self.valueBuffer;
    } else if([elementName isEqualToString:@"time"]) {
        self.alerts.timeString = self.valueBuffer;
    } else if([elementName isEqualToString:@"description"]) {
        self.currentMessage = self.valueBuffer;
    }
    
    self.valueBuffer = nil;
}

@end
