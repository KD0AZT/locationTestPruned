//
//  LocationHistory.m
//  locationTest
//
//  Created by Michael McAuley on 2/16/23.
//

#import "LocationHistory.h"

@implementation LocationHistory

-(void)addLocationHistory:(CLLocation *) currentLocation {
    [_coordinateHistory addObject:currentLocation];
}

-(NSMutableArray<CLLocation*> *)getLocationHistory {
    return _coordinateHistory;
}

-(void)initLocationHistory {
    _coordinateHistory = [[NSMutableArray alloc]init];
}

-(void)clearLocationHistory {
    [_coordinateHistory removeAllObjects];
}

@end
