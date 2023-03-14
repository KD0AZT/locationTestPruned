//
//  DistanceCalculator.m
//  locationTest
//
//  Created by Michael McAuley on 2/16/23.
//

#import "DistanceCalculator.h"

@implementation DistanceCalculator

float meterToMile = 0.000621;  // Conversion for meters to miles

-(CLLocationDistance)getStraightTripDistance:(NSMutableArray*)locationHistory withCurrentLocation:(CLLocation *)currentLocation {
    
    if ([locationHistory count] < 1) {
        return -1.00;
    }
    
    return [currentLocation distanceFromLocation:[locationHistory firstObject]] * meterToMile;
}

-(CLLocationDistance)getAccurateTripDistance:(NSMutableArray *)locationHistory {
    
    _accurateDist = 0.00;
    
    if ([locationHistory count] < 1) {
        return -1.00;
    } else if ([locationHistory count] == 1){
        return -0.50;
    } else {
        for (int i = 0; i < [locationHistory count] - 2; i++) {
            CLLocation *lastPoint = [locationHistory objectAtIndex:i];
            CLLocation *nextPoint = [locationHistory objectAtIndex:i + 1];
            if ([lastPoint distanceFromLocation:nextPoint] > 0) {
                _accurateDist += ([lastPoint distanceFromLocation:nextPoint]);
            }
        }
    }
    
    return _accurateDist * meterToMile;
}

-(CLLocationDistance)getLastDistance:(NSMutableArray *)locationHistory withCurrentLocation:(CLLocation *)currentLocation {
    if ([locationHistory count] < 1) {
        return -1.00;
    }
    
    return [currentLocation distanceFromLocation:[locationHistory lastObject]] * meterToMile;
}

-(void)clearDist {
    _accurateDist = 0.00;
}

@end
