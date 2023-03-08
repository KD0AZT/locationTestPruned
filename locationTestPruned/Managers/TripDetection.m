//
//  TripDetection.m
//  locationTestPruned
//
//  Created by Michael McAuley on 2/22/23.
//

#import "TripDetection.h"

@implementation TripDetection

NSMutableArray<CLLocation*> *tripHistory;
float avgSpeed;

+(BOOL)decideIfValidTripLocation:(CLLocation *)location {
    if ([tripHistory count] > 9) {
        for (int i = (int)[tripHistory count] - 1; i > (int)[tripHistory count] - 9; i--) {
            avgSpeed += [[tripHistory objectAtIndex:i] speed];
        }
    }
    
    
    avgSpeed = avgSpeed / 10;
    
    if ((avgSpeed * 3.6 > 16 || [location speed] * 3.6 > 16) && [location speed] * 3.6 > 8) {
        return true;
    }
    return false;
}

+(void)addLocationToTrip:(CLLocation *)location {
    if ([tripHistory count] > 0) {
        if ([self decideIfValidTripLocation:location]) {
            [tripHistory addObject:location];
        }
    }
}

+(NSMutableArray*)getTripHistory {
    return tripHistory;
}

+(float)getAvgSpeed {
    return avgSpeed;
}

+(void)tripDetectionInit {
    tripHistory = [[NSMutableArray alloc]init];
    avgSpeed = 0.00;
}

@end
