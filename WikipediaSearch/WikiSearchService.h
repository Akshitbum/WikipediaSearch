//
//  Created by Akshit Bum
//

#import <Foundation/Foundation.h>

@interface WikiSearchService : NSObject
+ (instancetype) sharedInstance;
- (void) callToSearchWiki:(NSString *)query completionHandler:(void (^)(id result, NSError *error)) handler;
- (void) callToDownloadImage:(NSURL *)url completionHandler:(void (^)(id result, NSError *error)) handler;
@end
