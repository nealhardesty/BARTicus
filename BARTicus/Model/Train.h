//
//  Train.h
//  BARTicus
//
//  Created by Neal Hardesty on 10/1/13.
//  Copyright (c) 2013 RoadWaffle Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Train : NSObject
@property (nonatomic) short minutes;
@property (nonatomic, strong) NSString *destination; // abbreviation
@property (nonatomic, strong) NSString *direction;
@property (nonatomic) short platform;
@property (nonatomic) short length; // # of cars
@property (nonatomic) BOOL bikeflag; // allowed?
@property (nonatomic, strong) NSString *hexcolor;
@end
