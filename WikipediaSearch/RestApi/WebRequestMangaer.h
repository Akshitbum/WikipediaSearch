//
//  Created by Akshit Bum
//

#import <Foundation/Foundation.h>

typedef void (^NetworkResultCompletion)(NSData *data);
typedef void (^NetworkResultError)(NSError *err, NSUInteger httpCode);

@interface WebRequestMangaer : NSObject

+(instancetype) sharedInstance;
-(NSUInteger) fetchUrlRequest:(NSURL*)url
          onCompletion:(NetworkResultCompletion)completionCallback
         onError:(NetworkResultError)errorCallback;
-(void) cancelRequest:(NSUInteger)requestId;

@end
