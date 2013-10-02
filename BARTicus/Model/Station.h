//
//  Station.h
//  BARTicus
//
//  Created by Neal Hardesty on 10/1/13.
//  Copyright (c) 2013 RoadWaffle Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Station : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *abbreviation;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *county;
@property (nonatomic, strong) NSString *zipcode;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@end
