//
//  LocationHistory.h
//  locationTest
//
//  Created by Michael McAuley on 2/16/23.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationHistory : NSObject
 
// initialize the location history array
-(void)initLocationHistory;

// add location to history
-(void)addLocationHistory:(CLLocation *)currentLocation;

// retrieve location history
-(NSMutableArray<CLLocation*> *)getLocationHistory;

// remove location history
-(void)clearLocationHistory;

@property (strong, nonatomic) NSMutableArray *coordinateHistory;

@end
