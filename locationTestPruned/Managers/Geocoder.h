//
//  Geocoder.h
//  locationTestPruned
//
//  Created by Michael McAuley on 2/25/23.
//

#import <QuartzCore/QuartzCore.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

@interface Geocoder : NSObject

@property (strong, nonatomic) CLGeocoder *geocoder;
@property (strong, nonatomic) NSString *address;

-(void)getAddressFromLocation:(CLLocation *)currentLocation withAddressLabel:(UILabel *)addressLabel;

-(void)initGeocoder;

@end
