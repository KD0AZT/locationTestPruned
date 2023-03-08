//
//  ViewController.m
//  locationTest
//
//  Created by Michael McAuley on 1/23/23.
//

#import "ViewController.h"
#import "TripDetection.h"

@interface ViewController() <CLLocationManagerDelegate> {
    CLLocationManager *_locationManager;
}

@end

@implementation ViewController

// Location tracking, distance calculation, and average speed calculation
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    _currentLocation = [locations lastObject];
    if ([[_locationHistoryManager getLocationHistory] count] > 2) {
        NSDate *now = [NSDate date];
        NSDateFormatter *outputFormatter = [[NSDateFormatter alloc]init];
        [outputFormatter setDateFormat:@"HH:mm:ss"];
        NSString *currentTime = [outputFormatter stringFromDate:now];
        [_debugLabel setText: [NSString stringWithFormat:@"Geocoder Last Called: %@", currentTime]];
        [_geocoderManager getAddressFromLocation:_currentLocation withAddressLabel:_locationLabel];
    }
    if (_hasGotAddress == false && _currentLocation != nil) {
        [_geocoderManager getAddressFromLocation:_currentLocation withAddressLabel:_locationLabel];
        NSDate *now = [NSDate date];
        NSDateFormatter *outputFormatter = [[NSDateFormatter alloc]init];
        [outputFormatter setDateFormat:@"HH:mm:ss"];
        NSString *currentTime = [outputFormatter stringFromDate:now];
        [_debugLabel setText: [NSString stringWithFormat:@"Geocoder Last Called: %@", currentTime]];
        _hasGotAddress = true;
    }
//    if ([_currentLocation speed] >= 0.00) {
//        _avgSpeed += [_currentLocation speed];
//    }
//    if ((int)[[_locationHistoryManager getLocationHistory] count] > 0) {
//        _avgSpeed = _avgSpeed / (float)[[_locationHistoryManager getLocationHistory] count];
//    }
    _avgSpeed = [_currentLocation speed];
    [_speedLabel setText: [NSString stringWithFormat:@"Current Speed: %0.2f MPH", _avgSpeed * 0.62137119]];
    [_locationHistoryManager addLocationHistory:_currentLocation];
    [TripDetection addLocationToTrip:_currentLocation];
}

// Check if location access has been granted by the user
-(BOOL)checkLocationAccess {
    switch (_locationManager.authorizationStatus) {
        case kCLAuthorizationStatusDenied:
            return false;
            break;
        case kCLAuthorizationStatusRestricted:
            return false;
            break;
        case kCLAuthorizationStatusNotDetermined:
            return true;
            break;
        case kCLAuthorizationStatusAuthorizedAlways:
            return true;
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            return true;
            break;
    }
}

// Start tracking location
-(void)trackingIsStarted {
    [_locationLabel setText:@"Getting location"];
    [_locationManager startUpdatingLocation];
}

// Update the distance label to show stright-line distance
-(void)showRoughDistance:(UIButton *)sender {
    _coordinateHistory = [_locationHistoryManager getLocationHistory];
    _dist = [_distanceCalculatorManager getStraightTripDistance:_coordinateHistory withCurrentLocation:_currentLocation];
    [_distanceLabel setText:[NSString stringWithFormat:@"Straight Line Distance: %0.2f", _dist]];
}

// Update the distance label to show precise distance
-(void)showPreciseDistance:(UIButton *)sender {
    _coordinateHistory = [_locationHistoryManager getLocationHistory];
    _dist = [_distanceCalculatorManager getAccurateTripDistance:_coordinateHistory];
    [_distanceLabel setText:[NSString stringWithFormat:@"Accurate Trip Distance: %0.2f", _dist]];
}

// Reset the distance and average speed
-(void)resetDistance:(UIButton *)sender {
    [_locationHistoryManager clearLocationHistory];
    [_distanceLabel setText:@"Distance Cleared"];
    [_distanceCalculatorManager clearDist];
    _avgSpeed = 0.00;
    [_speedLabel setText:[NSString stringWithFormat:@"Current Speed: %0.2f MPH", _avgSpeed * 0.62137119]];
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    // Managers and global variables
    _coordinateHistory = [[NSMutableArray alloc]init];
    _locationHistoryManager = [[LocationHistory alloc]init];
    _distanceCalculatorManager = [[DistanceCalculator alloc]init];
    _geocoderManager = [[Geocoder alloc]init];
    [_locationHistoryManager initLocationHistory];
    [TripDetection tripDetectionInit];
    [_geocoderManager initGeocoder];
    _hasGotAddress = false;
    _avgSpeed = 0.00;
    
    // Label to show the current location (City, Zip, Country)
    _locationLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, -150, self.view.frame.size.width, self.view.frame.size.height)];
    [_locationLabel setBackgroundColor:[UIColor clearColor]];
    [_locationLabel setTextAlignment:NSTextAlignmentCenter];
    _locationLabel.font = [UIFont systemFontOfSize:25];
    [[self view] addSubview:_locationLabel];
    
    // Label to show the distance travelled
    _distanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, -100, self.view.frame.size.width, self.view.frame.size.height)];
    [_distanceLabel setBackgroundColor:[UIColor clearColor]];
    [_distanceLabel setTextAlignment:NSTextAlignmentCenter];
    _distanceLabel.font = [UIFont systemFontOfSize:25];
    [[self view] addSubview:_distanceLabel];
    [_distanceLabel setText:@"Distance Not Calculated"];
    
    // Label to show the average speed
    _speedLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, -50, self.view.frame.size.width, self.view.frame.size.height)];
    [_speedLabel setBackgroundColor:[UIColor clearColor]];
    [_speedLabel setTextAlignment:NSTextAlignmentCenter];
    _speedLabel.font = [UIFont systemFontOfSize:20];
    [[self view] addSubview:_speedLabel];
    
    _buttonWidth = 150;
    _buttonHeight = 40;
    
    // Button to show the stright line distance between the start and current points
    _showRoughHistory = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_showRoughHistory setFrame:CGRectMake(_locationLabel.frame.origin.x + (_locationLabel.frame.size.width/2) - (_buttonWidth/2) - 10, (_locationLabel.frame.size.height/2) - (_buttonHeight/2) + 10, _buttonWidth + 20, _buttonHeight)];
    [_showRoughHistory setTitle:@"Rough Distance" forState:UIControlStateNormal];
    _showRoughHistory.layer.cornerRadius=8.0f;
    _showRoughHistory.layer.masksToBounds=YES;
    _showRoughHistory.layer.borderColor=[[UIColor blackColor]CGColor];
    _showRoughHistory.layer.borderWidth=1.0f;
    [_showRoughHistory setBackgroundColor:[UIColor clearColor]];
    _showRoughHistory.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_showRoughHistory addTarget:self action:@selector(showRoughDistance:) forControlEvents:UIControlEventTouchUpInside];
    [[self view] addSubview:_showRoughHistory];
    
    // Button to show the cumulative distance between all stored points
    _showAccurateHistory = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_showAccurateHistory setFrame:CGRectMake(_locationLabel.frame.origin.x + (_locationLabel.frame.size.width/2) - (_buttonWidth/2) - 10, _locationLabel.frame.size.height/2 + (_buttonHeight) + 10, _buttonWidth + 20, _buttonHeight)];
    [_showAccurateHistory setTitle:@"Precise Distance" forState:UIControlStateNormal];
    _showAccurateHistory.layer.cornerRadius=8.0f;
    _showAccurateHistory.layer.masksToBounds=YES;
    _showAccurateHistory.layer.borderColor=[[UIColor blackColor]CGColor];
    _showAccurateHistory.layer.borderWidth=1.0f;
    [_showAccurateHistory setBackgroundColor:[UIColor clearColor]];
    _showAccurateHistory.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_showAccurateHistory addTarget:self action:@selector(showPreciseDistance:) forControlEvents:UIControlEventTouchUpInside];
    [[self view] addSubview:_showAccurateHistory];
    
    // Button to reset the distance and speed to 0
    _clearDistance = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_clearDistance setFrame:CGRectMake(_locationLabel.frame.origin.x + (_locationLabel.frame.size.width/2) - (_buttonWidth/2) - 10, _locationLabel.frame.size.height/2 + (_buttonHeight*2.5) + 10, _buttonWidth + 20, _buttonHeight)];
    [_clearDistance setTitle:@"Clear Distance" forState:UIControlStateNormal];
    _clearDistance.layer.cornerRadius=8.0f;
    _clearDistance.layer.masksToBounds=YES;
    _clearDistance.layer.borderColor=[[UIColor blackColor]CGColor];
    _clearDistance.layer.borderWidth=1.0f;
    [_clearDistance setBackgroundColor:[UIColor clearColor]];
    _clearDistance.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_clearDistance addTarget:self action:@selector(resetDistance:) forControlEvents:UIControlEventTouchUpInside];
    [[self view] addSubview:_clearDistance];
    
    _debugLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, self.view.frame.size.height)];
    [_debugLabel setBackgroundColor:[UIColor clearColor]];
    [_debugLabel setTextAlignment:NSTextAlignmentCenter];
    _debugLabel.font = [UIFont systemFontOfSize:10];
    [[self view] addSubview:_debugLabel];
    
    // Set up location tracking
    if(_locationManager == nil) {
        _locationManager = [CLLocationManager new];
        _locationManager.delegate = self;
        _locationManager.distanceFilter = 10.00;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    [_locationManager requestWhenInUseAuthorization];
    [self checkLocationAccess];
    [self trackingIsStarted];
}

@end
