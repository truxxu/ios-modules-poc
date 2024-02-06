#import "RCTFingerprintModule.h"
#import <React/RCTLog.h>
#import "FPDiOS_ObjC.h"
#import "INTULocationManager.h"

@implementation RCTFingerprintModule

RCT_EXPORT_MODULE(FingerprintModuleIOS);

FPDiOS *fingerPrint;

RCT_EXPORT_METHOD(createFingerprintEvent:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject)
{
  
  fingerPrint = [[FPDiOS alloc] init];
  
  @try {
    resolve([fingerPrint getFPDWithAppAction:@"Login"]);
  }
  @catch (NSException *exception) {
      reject(@"Error", exception.reason, nil);
    }
//  INTULocationManager *locMgr = [INTULocationManager sharedInstance];
//  
//  [locMgr requestLocationWithDesiredAccuracy:INTULocationAccuracyCity timeout:10.0 delayUntilAuthorized:YES block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
//    if (status == INTULocationStatusSuccess) {
//      RCTLogInfo(@"Ha permitido acceso a la ubicacion");
//    }
//    else if (status == INTULocationStatusTimedOut) {
//      RCTLogInfo(@"Ha denegado el acceso por tiempo de solicitud a la ubicacion");
//    }
//    else {
//      RCTLogInfo(@"Ha denegado el acceso a la ubicacion");
//    }
//  }];
};

@end
