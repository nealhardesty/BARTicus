//
//  ParserBase.h
//  BARTicus
//
//  Created by Neal Hardesty on 10/1/13.
//  Copyright (c) 2013 RoadWaffle Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParserBase : NSObject <NSXMLParserDelegate>
@property (nonatomic, strong) NSError *error;
- (ParserBase *)initWithParser:(NSXMLParser *)parser;
@end
