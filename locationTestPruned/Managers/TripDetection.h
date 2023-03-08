//
//  TripDetection.h
//  locationTestPruned
//
//  Created by Michael McAuley on 2/22/23.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface TripDetection : NSObject

+(BOOL)decideIfValidTripLocation:(CLLocation *)location;
+(void)addLocationToTrip:(CLLocation *)location;
+(NSMutableArray*)getTripHistory;
+(void)tripDetectionInit;
+(float)getAvgSpeed;

@end
