//
//  AlertsViewController.m
//  BARTicus
//
//  Created by Neal Hardesty on 10/10/13.
//  Copyright (c) 2013 RoadWaffle Software. All rights reserved.
//

#import "AlertsViewController.h"

@interface AlertsViewController ()

@end

@implementation AlertsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.title = @"System Alerts";
    [self.theText setAttributedText:[self getMessage]];
}

- (NSAttributedString *)getMessage {
    NSMutableAttributedString *msg = [[NSMutableAttributedString alloc] init];
    UIFont *boldFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0f];
    NSDictionary *boldAttributes = @{NSFontAttributeName:boldFont};
    
    UIFont *italicFont = [UIFont fontWithName:@"HelveticaNeue-BoldItalic" size:16.0f];
    NSDictionary *italicAttributes = @{NSFontAttributeName:italicFont};
    
    UIFont *regFont = [UIFont fontWithName:@"HelveticaNeue" size:14.0f];
    NSDictionary *regAttributes = @{NSFontAttributeName:regFont};
    
    
    [msg appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@", self.alerts.dateString, self.alerts.timeString] attributes:italicAttributes]];
    
    
    if(self.alerts.emergencies && [self.alerts.emergencies count]) {
        [msg appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n\nEmergencies\n" attributes:boldAttributes]];
        for(NSString *m in self.alerts.emergencies) {
            [msg appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n",m] attributes:regAttributes]];
        }
    }
    
    if(self.alerts.delays && [self.alerts.delays count]) {
        [msg appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n\nDelays\n" attributes:boldAttributes]];
        for(NSString *m in self.alerts.delays) {
            [msg appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n",m]    attributes:regAttributes]];
        }
    }
    
    if(self.alerts.infoMessages && [self.alerts.infoMessages count]) {
        [msg appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n\nInformation\n" attributes:boldAttributes]];
        for(NSString *m in self.alerts.infoMessages) {
            [msg appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n",  m] attributes:regAttributes]];
        }
    }
    
    return msg;
}


@end
