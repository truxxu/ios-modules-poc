#import "RCTFingerprintModule.h"
#import <React/RCTLog.h>

@implementation RCTFingerprintModule

RCT_EXPORT_MODULE(FingerprintModuleIOS);

RCT_EXPORT_METHOD(createFingerprintEvent:(NSString *)name location:(NSString *)location)
{
  RCTLogInfo(@"Pretending to create an event %@ at %@", name, location);
};

@end
