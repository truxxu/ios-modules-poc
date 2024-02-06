#import "RCTFingerprintModule.h"
#import <React/RCTLog.h>
#import "FPDiOS_ObjC.h"
#import "INTULocationManager.h"

@implementation RCTFingerprintModule

RCT_EXPORT_MODULE(FingerprintModuleIOS);

RCT_EXPORT_METHOD(createFingerprintEvent:(NSString *)name location:(NSString *)location)
{
  RCTLogInfo(@"Pretending to create an event %@ at %@", name, location);
};

@end
