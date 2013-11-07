//
//  BARTApi.m
//  BARTicus
//
//  Created by Neal Hardesty on 10/1/13.
//  Copyright (c) 2013 RoadWaffle Software. All rights reserved.
//

#import "BARTApi.h"
#import "ParserStations.h"
#import "ParserSchedule.h"
#import "ParserAlerts.h"


#define API_STATION @"http://api.bart.gov/api/stn.aspx?cmd=stns&key=MW9S-E7SL-26DU-VV8V"
#define API_ETD @"http://api.bart.gov/api/etd.aspx?cmd=etd&key=MW9S-E7SL-26DU-VV8V&orig=%@"
#define API_BSA @"http://api.bart.gov/api/bsa.aspx?cmd=bsa&key=MW9S-E7SL-26DU-VV8V"

@interface BARTApi()
@property (nonatomic, strong, readonly) CLLocationManager *locationManager;
@end

@implementation BARTApi

@synthesize stationsByAbbreviation = _stationsByAbbreviation;
@synthesize locationManager = _locationManager;

- (CLLocationManager *)locationManager
{

    // Note, we only keep _locationManager around so that the approval dialog sticks around.
    _locationManager = [[CLLocationManager alloc] init];
    if(!_locationManager) {
        return nil;
    }
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    
    return _locationManager;
}

// Turn on the network activity indicator
- (void)beginNetworkActivity
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

// Turn off the network activity indicator
- (void)endNetworkActivity
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

// Fetch the data from a url
// Returns nil and set's lastErrorMessage appropriately
- (NSData *)fetch:(NSString *) urlString
{
    NSURL *url = [NSURL URLWithString:urlString];
    [self beginNetworkActivity];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSURLResponse *response;
    NSError *error;
    NSData *urlData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    [self endNetworkActivity];
    if(error) {
        self.lastErrorMessage = error.description;
        NSLog(@"fetch error on %@: %@", urlString, self.lastErrorMessage);
        return nil;
    } else {
        return urlData;
    }
}

- (Alerts *)getAlerts
{
    NSData *alertsData = [self fetch:API_BSA];
    if(alertsData) {
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:alertsData];
        ParserAlerts *alertsParser = [[ParserAlerts alloc] initWithParser:parser];

        return alertsParser.alerts;
    } else {
        return nil;
    }
}

// Try to load a Schedule for the specified station
- (Schedule *)getScheduleForStation:(Station *)station
{
    NSData *scheduleData = [self fetch:[NSString stringWithFormat:API_ETD, station.abbreviation]];
    if(scheduleData) {
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:scheduleData];
        ParserSchedule *scheduleParser = [[ParserSchedule alloc] initWithParser:parser];
        scheduleParser.station = station;

        return scheduleParser.schedule;
    } else {
        return nil;
    }
}

- (NSArray *)stations
{
    if(!_stations) {
        NSData *stationsData = [self fetch:API_STATION];
        if(stationsData) {
            NSXMLParser *parser = [[NSXMLParser alloc] initWithData:stationsData];
            ParserStations *stationParser = [[ParserStations alloc] initWithParser:parser];
            [self endNetworkActivity];
            
            _stations = stationParser.stations;
            _stationsByAbbreviation = stationParser.stationsByAbbreviations;
        } else {
            return nil;
        }
    }

    return _stations;
}

- (Station *)findClosestStation
{
    CLLocationCoordinate2D currentLocation = [self getLocation];
    
    double closestDistance = DBL_MAX;
    Station *closestStation;

    for(Station *station in self.stations) {
        double distance = [self calcDistanceToStation:station withLocation:currentLocation];
        if(!closestStation || distance < closestDistance) {
            closestDistance = distance;
            closestStation = station;
        }
    }

    return closestStation;
}

#define MEAN_EARTH_RADIUS 6371.0
- (double)calcDistanceToStation:(Station *)station withLocation:(CLLocationCoordinate2D)currentLocation
{
    // Spherical Law of Cosines
    // acos(sin(lat1)*sin(lat2) + cos(lat1)*cos(lat2)*cos(lon2-lon1)) * (6371)
    CLLocationCoordinate2D coord = [self getLocation];
    double lat1 = coord.latitude;
    double lon1 = coord.longitude;
    
    double lat2 = station.latitude;
    double lon2 = station.longitude;
    
    double distance = acos(sin(lat1)*sin(lat2) + cos(lat1)*cos(lat2)*cos(lon2-lon1)) * MEAN_EARTH_RADIUS;
    
    return distance;
}

- (CLLocationCoordinate2D) getLocation
{
    [self.locationManager startUpdatingLocation];
    CLLocation *location = [self.locationManager location];
    CLLocationCoordinate2D coord = [location coordinate];
    [self.locationManager stopUpdatingLocation];
    return coord;
}

@end
