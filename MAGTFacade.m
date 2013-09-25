#import "MAGTFacade.h"

// Singleton to make using the Facade easier.
@implementation MAGTFacade 
id<MAGTFacade> _defaultFacade;

+(id<MAGTFacade>) defaultFacade { return _defaultFacade;}
+(void) setDefaultFacade:(id<MAGTFacade>)facade { _defaultFacade = facade; };
@end