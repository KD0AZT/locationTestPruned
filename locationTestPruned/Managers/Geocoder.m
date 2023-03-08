//
//  Geocoder.m
//  locationTestPruned
//
//  Created by Michael McAuley on 2/25/23.
//

#import "Geocoder.h"

@implementation Geocoder

-(void)getAddressFromLocation:(CLLocation *)currentLocation withAddressLabel:(UILabel *)addressLabel {
    [_geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
            if (error) {
                NSLog(@"Geocode failed with error: %@", error);
                return;
            }
        CLPlacemark *placemark = [placemarks objectAtIndex:0];
        self->_address = [NSString stringWithFormat:@"%@ %@ %@", placemark.locality, placemark.postalCode, placemark.ISOcountryCode];
        if (self->_address != nil) {
            [addressLabel setText:self->_address];
        }
    }];
}

-(void)initGeocoder {
    _geocoder = [[CLGeocoder alloc] init];
}

@end
