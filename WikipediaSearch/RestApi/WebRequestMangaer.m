//
//  
//

#import "WebRequestMangaer.h"

@interface WebRequestMangaer ()

@property NSURLSession *session;

@end



@implementation WebRequestMangaer

-(instancetype) init
{
    return [WebRequestMangaer sharedInstance];
}

+(instancetype) sharedInstance
{
    static WebRequestMangaer *sInstance = nil;
    if(!sInstance)
    {
        sInstance = [[WebRequestMangaer alloc] initPrivate];
    }
    return sInstance;
}

-(instancetype) initPrivate
{
    if(self)
    {
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.session = [NSURLSession sessionWithConfiguration:sessionConfig];
    }
    return self;
}

-(NSUInteger) fetchUrlRequest:(NSURL*)requestURL
                 onCompletion:(NetworkResultCompletion)completionCallback
                      onError:(NetworkResultError)errorCallback
{
    NSMutableURLRequest *httpRequest = [[NSMutableURLRequest alloc] init];
    [httpRequest setHTTPMethod:@"GET"];
    [httpRequest setURL:requestURL];
    
    NSURLSessionDataTask *requestTask = [self.session dataTaskWithRequest:httpRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSHTTPURLResponse *httpResponse = nil;
        if([response isKindOfClass:[NSHTTPURLResponse class]])
            httpResponse= (NSHTTPURLResponse*)response;
        
        if(error != nil)
        {
            NSLog(@"Error:%@",error.localizedDescription);
            errorCallback(error, httpResponse.statusCode);
            return;
        }
        completionCallback(data);
    }];
    
    [requestTask resume];
    
    return requestTask.taskIdentifier;
}

-(void) cancelRequest:(NSUInteger)requestId
{
    [self.session getAllTasksWithCompletionHandler:^(NSArray<__kindof NSURLSessionTask *> * _Nonnull tasks) {
        for(NSURLSessionTask *aTask in tasks)
        {
            if(aTask.taskIdentifier == requestId)
                [aTask cancel];
        }
    }];
}

@end
