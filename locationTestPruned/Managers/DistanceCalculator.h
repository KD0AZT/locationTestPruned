//
//  DistanceCalculator.h
//  locationTest
//
//  Created by Michael McAuley on 2/16/23.
//

#import <MapKit/MapKit.h>
#import <Foundation/Foundation.h>

@interface DistanceCalculator : NSObject

// Get the first and last locations from location history
// and calculatre the stright-line distance between them.
-(CLLocationDistance)getStraightTripDistance:(NSMutableArray *)locationHistory withCurrentLocation:(CLLocation *)currentLocation;

// Calculate an accurate trip distance
-(CLLocationDistance)getAccurateTripDistance:(NSMutableArray *)locationHistory;

// Calculate the distance between the last two location points (one distance)
-(CLLocationDistance)getLastDistance:(NSMutableArray *)locationHistory withCurrentLocation:(CLLocation *)currentLocation;

// Clear the distance calculated
-(void)clearDist;

@property (strong, nonatomic) CLLocation *startPoint;
@property (strong, nonatomic) CLLocation *endPoint;
@property CLLocationDistance accurateDist;

@end
