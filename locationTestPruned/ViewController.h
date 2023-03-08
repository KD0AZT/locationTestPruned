//
//  ViewController.h
//  locationTest
//
//  Created by Michael McAuley on 1/23/23.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>
#import "LocationHistory.h"
#import "DistanceCalculator.h"
#import "Geocoder.h"

@interface ViewController : UIViewController { }

@property (strong, nonatomic) UILabel *locationLabel;
@property (strong, nonatomic) UILabel *distanceLabel;
@property (strong, nonatomic) UILabel *speedLabel;
@property (strong, nonatomic) UILabel *debugLabel;
@property (strong, nonatomic) UIButton *clearDistance;
@property (strong, nonatomic) UIButton *showRoughHistory;
@property (strong, nonatomic) UIButton *showAccurateHistory;
@property (strong, nonatomic) NSMutableArray *locationHistory;
@property (strong, nonatomic) NSMutableArray *coordinateHistory;
@property (strong, nonatomic) NSString *locationString;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) UIAlertController *alert;
@property (strong, nonatomic) LocationHistory *locationHistoryManager;
@property (strong, nonatomic) DistanceCalculator *distanceCalculatorManager;
@property (strong, nonatomic) Geocoder *geocoderManager;
@property bool hasGotAddress;
@property int buttonHeight;
@property int buttonWidth;
@property float dist;
@property float avgSpeed;

-(void)locationManager: (CLLocationManager *) manager didUpdateLocations: (NSArray *) locations;
-(BOOL)checkLocationAccess;
-(void)trackingIsStarted;
-(void)showRoughDistance: (UIButton *) sender;
-(void)showPreciseDistance: (UIButton *) sender;
-(void)resetDistance: (UIButton *) sender;

@end

