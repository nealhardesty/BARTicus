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
@property (nonatomic, strong) NSString *dateString;
@property (nonatomic, strong) NSString *timeString;
@property (nonatomic, strong) NSMutableArray *infoMessages;
@property (nonatomic, strong) NSMutableArray *emergencies;
@property (nonatomic, strong) NSMutableArray *delays;
@end
