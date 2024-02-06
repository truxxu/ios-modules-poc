//
//  FPDiOS.m
//  FPDiOS
//
//  Created by Fernando Godinez Alvarado on 7/10/15.
//  Copyright © 2017 Plus Holding International, Inc. www.plusti.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FPDiOS_ObjC.h"
#include <CommonCrypto/CommonDigest.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <net/if.h>
#import <netdb.h>
#import <sys/utsname.h>
#import <sys/sysctl.h>
#import <CoreLocation/CoreLocation.h>
#import <CFNetwork/CFNetwork.h>
#import <CoreNFC/CoreNFC.h>

@implementation FPDiOS

@synthesize locationManager = _locationManager;
@synthesize vSummary = _vSummary;
@synthesize vSumIPAddress = _vSumIPAddress;
@synthesize vSumOperativeSystem = _vSumOperativeSystem;
@synthesize vSumScreenResolution  = _vSumScreenResolution;
@synthesize vSumClientTimeStamp =_vSumClientTimeStamp;
@synthesize vSumDeviceID = _vSumDeviceID;
@synthesize vSumNavigPluginList = _vSumNavigPluginList;
@synthesize vSumNavigPluginListArr = _vSumNavigPluginListArr;
//@synthesize vSumPhoneNumber = _vSumPhoneNumber;
@synthesize vGeoLocation = _vGeoLocation;
@synthesize vGeoPostalCode = _vGeoPostalCode;
@synthesize vGeoContinent = _vGeoContinent;
@synthesize vGeoCountry = _vGeoCountry;
@synthesize vGeoRegion = _vGeoRegion;
@synthesize vGeoCity = _vGeoCity;
@synthesize vGeoTimeZone = _vGeoTimeZone;
@synthesize vGeoISP = _vGeoISP;
@synthesize vGeoLatitude = _vGeoLatitude;
@synthesize vGeoLongitude = _vGeoLongitude;
@synthesize vJSData = _vJSData;
@synthesize vJSDDeviceBrand = _vJSDDeviceBrand;
@synthesize vJSDDeviceModel = _vJSDDeviceModel;
@synthesize vJSDDeviceOS = _vJSDDeviceOS;
@synthesize vJSDDeviceOSVersion = _vJSDDeviceOSVersion;
@synthesize vJSDAppName = _vJSDAppName;
@synthesize vJSDAppVersion = _vJSDAppVersion;
@synthesize vJSDKernel = _vJSDKernel;
@synthesize vJSDLanguage = _vJSDLanguage;
@synthesize vJSDGeolocation = _vJSDGeolocation;
@synthesize vJSDFingerPrint = _vJSDFingerPrint;
@synthesize vFPD = _vFPD;
@synthesize vFPDID = _vFPDID;

- (FPDiOS *)init {
    self = [super init];
    if (self) {
        // Initialize self
        
        _locationManager = [[CLLocationManager alloc] init];
        
        [_locationManager setDelegate:self];
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        [_locationManager setDistanceFilter:kCLLocationAccuracyNearestTenMeters];
        
        /*
        [_locationManager requestAlwaysAuthorization];
        if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [self.locationManager requestAlwaysAuthorization];
        }*/
        
        //[_locationManager requestAlwaysAuthorization];
        [self.locationManager startUpdatingLocation];
        NSLog(@"2");        
        
        _vGeoLatitude = [[NSMutableString alloc] initWithString:@""];
        _vGeoLongitude = [[NSMutableString alloc] initWithString:@""];
        _vGeoISP = [[NSMutableString alloc] initWithString:@""];
        _vGeoPostalCode = [[NSMutableString alloc] initWithString:@""];
        _vGeoCountry = [[NSMutableString alloc] initWithString:@""];
        _vGeoRegion = [[NSMutableString alloc] initWithString:@""];
        _vGeoCity = [[NSMutableString alloc] initWithString:@""];
        _vGeoTimeZone = [[NSMutableString alloc] initWithString:@""];
        
        NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://ip-api.com/json"]];
        [urlRequest setHTTPMethod:@"GET"];
        
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            NSString *strResponse = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
            
            NSData *data1 = [strResponse dataUsingEncoding:NSUTF8StringEncoding];
            id json = [NSJSONSerialization JSONObjectWithData:data1 options:0 error:nil];
            
            _vGeoCity = [json objectForKey:@"city"];
            _vGeoCountry = [json objectForKey:@"country"];
            _vSumIPAddress = [json objectForKey:@"query"];
            
            NSLog(@"%@",[json objectForKey:@"query"]);
            NSLog(@"%@",[json objectForKey:@"city"]);
            NSLog(@"%@",[json objectForKey:@"country"]);
        }];
        
        [dataTask resume];
        
    }
    return self;
}

-(NSString *)strTrimmer:(NSString*)input
{
    NSMutableString *returnResult = [[NSMutableString alloc] initWithString:@""];
    if (input == nil)
    {
        returnResult = [[NSMutableString alloc] initWithString:@"nil"];
    }
    else
    {
        returnResult = [[NSMutableString alloc] initWithString:input];
    }
    return returnResult;
}


-(NSString *)getFPDWithAppAction:(NSString*)appAction
{
    NSString *strName =  [[UIDevice currentDevice] name];
    //NSLog(@"%@", strName);//e.g. "My iPhone"
    NSString *returnResult;
    
    //_vSumIPAddress = [[NSMutableString alloc] initWithString:[self strTrimmer:[self getSumIPAddress]]];
    //_vSumIPAddress = [[NSMutableString alloc] initWithString:[self strTrimmer:[self getSumPublicIPAddress]]];
    //_vSumIPAddress = [[NSMutableString alloc] initWithString:[self strTrimmer:[self getSumPublicIPAddress]]];
    _vSumOperativeSystem  = [[NSMutableString alloc] initWithString:[self strTrimmer:[self getSumOperativeSystem]]];
    _vSumScreenResolution  = [[NSMutableString alloc] initWithString:[self strTrimmer:[self getSumScreenResolution]]];
    _vSumClientTimeStamp  = [[NSMutableString alloc] initWithString:[self strTrimmer:[self getSumClientTimeStamp]]];
    _vSumDeviceID  = [[NSMutableString alloc] initWithString:[self strTrimmer:[self getSumDeviceID]]];
    
    _vJSDDeviceBrand  = [[NSMutableString alloc] initWithString:[self strTrimmer:[self getJSDDeviceBrand]]];
    _vJSDDeviceModel  = [[NSMutableString alloc] initWithString:[self strTrimmer:[self getJSDDeviceModel]]];
    _vJSDDeviceOS  = [[NSMutableString alloc] initWithString:[self strTrimmer:[self getJSDDeviceOS]]];
    _vJSDDeviceOSVersion  = [[NSMutableString alloc] initWithString:[self strTrimmer:[self getJSDDeviceOSVersion]]];
    _vJSDAppName  = [[NSMutableString alloc] initWithString:[self strTrimmer:[self getJSDAppName]]];
    _vJSDAppVersion  = [[NSMutableString alloc] initWithString:[self strTrimmer:[self getJSDAppVersion]]];
    _vJSDKernel  = [[NSMutableString alloc] initWithString:[self strTrimmer:[self getJSDKernel]]];
    _vJSDLanguage  = [[NSMutableString alloc] initWithString:[self strTrimmer:[self getJSDLanguage]]];
    _vJSDGeolocation  = [[NSMutableString alloc] initWithString:[self strTrimmer:@"true"]];
    _vJSDFingerPrint  = [[NSMutableString alloc] initWithString:[self strTrimmer:[self getJSDFingerPrint]]];
    
    _vSummary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                 _vSumDeviceID, @"deviceId",
                 strName,@"hostname",
                 @"No Disponible",@"macAddress",
                 @"No Disponible",@"passiveId",
                 nil];
    
    _vGeoLocation = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                     _vGeoCountry, @"country",
                     _vGeoCity, @"city",
                     _vGeoISP, @"isp",
                     _vSumIPAddress, @"ip"
                     , nil];
    
    NSString *allforFPDID = [NSString stringWithFormat:@" %@%@%@%@%@%@%@%@%@",
                             _vJSDDeviceModel,
                             _vSumDeviceID,
                             _vGeoISP,
                             _vJSDDeviceBrand,
                             _vJSDDeviceOS,
                             _vJSDAppName,
                             _vJSDKernel,
                             _vJSDLanguage,
                             _vJSDFingerPrint
                             ];
    
    _vFPDID = [self sha256HashFor:allforFPDID];
    
    _vFPD = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
             _vFPDID,@"id"
             , nil];
    
    NSDictionary *allVarDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                      _vSummary,@"General",
                                      _vGeoLocation, @"Geolocation",
                                      _vFPD,@"Hash"
                                      , nil];
    
    NSData *jsonReturn = [NSJSONSerialization dataWithJSONObject:allVarDictionary options:NSJSONWritingPrettyPrinted error:nil];

    returnResult = [[NSString alloc] initWithData:jsonReturn encoding:NSUTF8StringEncoding];
    return returnResult;
}



/************  GETTING INFO METHODS  *********************/

-(NSMutableString*)sha256HashFor:(NSString*)input
{
    const char* str = [input UTF8String];
    unsigned char result[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(str, (CC_LONG)strlen(str), result);
    
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH*2];
    for(int i = 0; i<CC_SHA256_DIGEST_LENGTH; i++)
    {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
}

-(NSString *)getSumPublicIPAddress
{
    NSString *publicIP = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"https://icanhazip.com/"] encoding:NSUTF8StringEncoding error:nil];
    publicIP = [publicIP stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]]; // IP comes with a newline for some reason
    return publicIP;
}

-(NSString *)getSumIPAddress
{
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    NSString *wifiAddress = nil;
    NSString *cellAddress = nil;
    
    // retrieve the current interfaces - returns 0 on success
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            sa_family_t sa_type = temp_addr->ifa_addr->sa_family;
            if(sa_type == AF_INET || sa_type == AF_INET6) {
                NSString *name = [NSString stringWithUTF8String:temp_addr->ifa_name];
                NSString *addr = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)]; // pdp_ip0
                //NSLog(@"NAME: \"%@\" addr: %@", name, addr); // see for yourself
                
                if([name isEqualToString:@"en0"]) {
                    // Interface is the wifi connection on the iPhone
                    wifiAddress = addr;
                } else
                    if([name isEqualToString:@"pdp_ip0"]) {
                        // Interface is the cell connection on the iPhone
                        cellAddress = addr;
                    }
            }
            temp_addr = temp_addr->ifa_next;
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    NSString *addr = wifiAddress ? wifiAddress : cellAddress;
    return addr;
}

-(NSString *)getSumOperativeSystem
{
    NSMutableString *returnResult = [NSMutableString stringWithString:[[UIDevice currentDevice] systemName]];
    return returnResult;
}

-(NSString *)getSumScreenResolution
{
    NSMutableString *returnResult;
    //NSString *width = [NSString stringWithFormat:@"%.0f",[UIScreen mainScreen].nativeBounds.size.width];
    //NSString *height = [NSString stringWithFormat:@"%.0f",[UIScreen mainScreen].nativeBounds.size.height];
    NSString *width = [NSString stringWithFormat:@"%.0f",[UIScreen mainScreen].bounds.size.width];
    NSString *height = [NSString stringWithFormat:@"%.0f",[UIScreen mainScreen].bounds.size.height];
    returnResult = [NSMutableString stringWithFormat:@"%@x%@",width,height];
    return returnResult;
}

-(NSString *)getSumClientTimeStamp
{
    NSString *returnResult;
    NSDate *date = [[NSDate alloc] init];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    returnResult = [NSString stringWithString:[formatter stringFromDate:date]];
    return returnResult;
}


-(NSString *)getSumDeviceID
{
    NSString *returnResult = [NSString stringWithString:[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
    return returnResult;
}

/******************************************************************************/

/*--------------*/

-(NSString *)getJSDDeviceBrand
{
    NSString *returnResult = @"Apple Inc.";
    return returnResult;
}

-(NSString *)getJSDDeviceModel
{
    //NSString *returnResult = [[NSString alloc] init];
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *code = [NSString stringWithUTF8String:systemInfo.machine];
    static NSDictionary *deviceNamesByCode;
    if (!deviceNamesByCode) {
        deviceNamesByCode = @{@"i386"      :@"Simulator",
                              @"iPod1,1"   :@"iPod Touch",      // (Original)
                              @"iPod2,1"   :@"iPod Touch",      // (Second Generation)
                              @"iPod3,1"   :@"iPod Touch",      // (Third Generation)
                              @"iPod4,1"   :@"iPod Touch",      // (Fourth Generation)
                              @"iPhone1,1" :@"iPhone",          // (Original)
                              @"iPhone1,2" :@"iPhone",          // (3G)
                              @"iPhone2,1" :@"iPhone",          // (3GS)
                              @"iPad1,1"   :@"iPad",            // (Original)
                              @"iPad2,1"   :@"iPad 2",          //
                              @"iPad3,1"   :@"iPad",            // (3rd Generation)
                              @"iPhone3,1" :@"iPhone 4",        // (GSM)
                              @"iPhone3,3" :@"iPhone 4",        // (CDMA/Verizon/Sprint)
                              @"iPhone4,1" :@"iPhone 4S",       //
                              @"iPhone5,1" :@"iPhone 5",        // (model A1428, AT&T/Canada)
                              @"iPhone5,2" :@"iPhone 5",        // (model A1429, everything else)
                              @"iPad3,4"   :@"iPad",            // (4th Generation)
                              @"iPad2,5"   :@"iPad Mini",       // (Original)
                              @"iPhone5,3" :@"iPhone 5c",       // (model A1456, A1532 | GSM)
                              @"iPhone5,4" :@"iPhone 5c",       // (model A1507, A1516, A1526 (China), A1529 | Global)
                              @"iPhone6,1" :@"iPhone 5s",       // (model A1433, A1533 | GSM)
                              @"iPhone6,2" :@"iPhone 5s",       // (model A1457, A1518, A1528 (China), A1530 | Global)
                              @"iPhone7,1" :@"iPhone 6 Plus",   //
                              @"iPhone7,2" :@"iPhone 6",        //
                              @"iPad4,1"   :@"iPad Air",        // 5th Generation iPad (iPad Air) - Wifi
                              @"iPad4,2"   :@"iPad Air",        // 5th Generation iPad (iPad Air) - Cellular
                              @"iPad4,4"   :@"iPad Mini",       // (2nd Generation iPad Mini - Wifi)
                              @"iPad4,5"   :@"iPad Mini"        // (2nd Generation iPad Mini - Cellular)
                              };
    }
    
    NSString* deviceName = [deviceNamesByCode objectForKey:code];
    
    if (!deviceName) {
        // Not found on database. At least guess main device type from string contents:
        if ([code rangeOfString:@"iPod"].location != NSNotFound) {
            deviceName = @"iPod Touch";
        }
        else if([code rangeOfString:@"iPad"].location != NSNotFound) {
            deviceName = @"iPad";
        }
        else if([code rangeOfString:@"iPhone"].location != NSNotFound){
            deviceName = @"iPhone";
        }
    }
    
    return deviceName;
    
}

-(NSString *)getJSDDeviceOS
{
    NSString *returnResult = [[NSString alloc] initWithString:[[UIDevice currentDevice] systemName]];
    return returnResult;
    
}

-(NSString *)getJSDDeviceOSVersion
{
    NSString *returnResult = [NSString stringWithString:[[UIDevice currentDevice] systemVersion]];
    return returnResult;
}

-(NSString *)getJSDAppName
{
    //NSString *returnResult = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"CFBundleDisplayName"];
    NSString *returnResult = [[[NSBundle mainBundle] infoDictionary] objectForKey:(id)kCFBundleExecutableKey];
    return returnResult;
    
}

-(NSString *)getJSDAppVersion
{
    //NSString *returnResult = [[NSBundle mainBundle] localizedInfoDictionary][@"CFBundleShortVersionString"];
    NSString *returnResult =  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    return returnResult;
    
}

-(NSString *)getJSDKernel
{
    //NSString *returnResult = @"";
    NSString *returnResult;
    int mib[2] = {CTL_KERN, KERN_OSVERSION};
    u_int namelen = sizeof(mib) / sizeof(mib[0]);
    size_t bufferSize = 0;
    
    // Get the size for the buffer
    sysctl(mib, namelen, NULL, &bufferSize, NULL, 0);
    
    u_char buildBuffer[bufferSize];
    int result = sysctl(mib, namelen, buildBuffer, &bufferSize, NULL, 0);
    
    if (result >= 0) {
        returnResult = [[NSString alloc] initWithBytes:buildBuffer length:bufferSize encoding:NSUTF8StringEncoding];
    }
    
    return returnResult;
}

-(NSString *)getJSDLanguage
{
    NSString *returnResult = [[NSLocale preferredLanguages] objectAtIndex:0];
    return returnResult;
}

-(NSString *)getJSDFingerPrint
{
    NSString *returnResult = @"";
    LAContext *context = [[LAContext alloc] init];
    
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil])
    {
        
        returnResult = @"true";
    }
    else
    {
        returnResult = @"false";
    }
    return returnResult;
}

/************** CORE LOCATION DELEGATE METHODS *************/
-(CLLocationCoordinate2D) getLocation{
    
    /*_locationManager.delegate = self;
     locationManager.desiredAccuracy = kCLLocationAccuracyBest;
     locationManager.distanceFilter = kCLDistanceFilterNone;
     [locationManager startUpdatingLocation];*/
    [_locationManager setDelegate:self];
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [_locationManager setDistanceFilter:kCLDistanceFilterNone];
    [_locationManager requestWhenInUseAuthorization];
    //[_locationManager requestAlwaysAuthorization];
    [_locationManager startUpdatingLocation];
    NSLog(@"4");
    CLLocation *location = [_locationManager location];
    CLLocationCoordinate2D coordinate = [location coordinate];
    
    return coordinate;
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    NSLog(@"3");
    
    CLLocation *currentLocation;
    currentLocation = [locations objectAtIndex:0];
    [_locationManager stopUpdatingLocation];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (currentLocation != nil) {
             double currentLatitude = [[NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude] doubleValue];
             double currentLongitude = [[NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude] doubleValue];
             CLPlacemark *placemark = [[CLPlacemark alloc] initWithPlacemark:[placemarks lastObject]];
             //CLPlacemark *placemark = [[CLPlacemark alloc] initWithPlacemark:[placemarks objectAtIndex:0]];
             
             if (placemark.location != nil){
                 
                 //NSLog(@" %f", currentLatitude);
                 
                 //_vGeoLatitude = [[NSMutableString alloc] initWithFormat:@"%f", currentLatitude];
                 //_vGeoLongitude = [[NSMutableString alloc] initWithFormat:@"%f", currentLongitude];
                 //_vGeoContinent = [[NSMutableString alloc] initWithString: placemark.ISOcountryCode.capitalizedString ? placemark.ISOcountryCode.capitalizedString : @""];
                 //_vGeoCountry = [[NSMutableString alloc] initWithString:placemark.country.description ? placemark.country.description : @"" ];
                 //_vGeoCity = [[NSMutableString alloc] initWithString: placemark.locality.description ? placemark.locality.description : @"" ];
                 //_vGeoRegion = [[NSMutableString alloc] initWithString:placemark.region.description ? placemark.region.description: @"" ];
                 //_vGeoPostalCode = [[NSMutableString alloc] initWithString: placemark.postalCode.description ? placemark.postalCode.description: @"" ];
                 //_vGeoTimeZone = [[NSMutableString alloc] initWithString:placemark.timeZone.description ? placemark.timeZone.description: @"" ];
                 
                 NSLog(@"Termino la geolocalizacion");
             }
             
             CTTelephonyNetworkInfo *netinfo = [[CTTelephonyNetworkInfo alloc] init];
             CTCarrier *carrier = [netinfo subscriberCellularProvider];
             
             
             //_vGeoISP = [NSMutableString stringWithString:carrier.carrierName];
             
             _vGeoISP = [NSMutableString stringWithString: carrier.carrierName ? carrier.carrierName : @""];            
         }
     }];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    _vJSDGeolocation = [NSMutableString stringWithString:@"GeoLocalization false"];
    NSLog(@" fail locations");
}

@end
