EMV TLV decoder for iOS. Base on https://github.com/unwiredbrain/php-emv.

Import SGTLVDecode folder into your project.

```objc
#import "SGTLVDecode.h"

//some of your code
//usage it

NSDictionary *value = [SGTLVDecode decodeWithString:@"Your TLV String"];

NSLog(@"TLV %@",value);

```