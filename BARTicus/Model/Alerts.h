//
//  Alerts.h
//  BARTicus
//
//  Created by Neal Hardesty on 10/9/13.
//  Copyright (c) 2013 RoadWaffle Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Alerts : NSObject
@property (nonatomic, readonly) BOOL infoOnly;
@property (nonatomic, strong) NSArray *infoMessages;
@property (nonatomic, strong) NSArray *emergencies;
@property (nonatomic, strong) NSArray *delays;
@end
