//
//  Created by Akshit Bum
//

#import "WikiSearchService.h"
#import "WebRequestMangaer.h"
#import "WikiResultModel.h"

@interface WikiSearchService()

@property NSUInteger queryRequestId;

@end
@implementation WikiSearchService

+ (instancetype) sharedInstance {
    static WikiSearchService *wikiSearchService;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        wikiSearchService = [[WikiSearchService alloc] init];
    });
    return wikiSearchService;
}


- (void) callToSearchWiki:(NSString *)query completionHandler:(void (^)(id result, NSError *error)) handler {
    NSURL *requestURL = [self createURLForQuery:query];
    [[WebRequestMangaer sharedInstance] cancelRequest:self.queryRequestId];
    self.queryRequestId = [[WebRequestMangaer sharedInstance] fetchUrlRequest:requestURL onCompletion:^(NSData *data) {
        NSArray<WikiResult*> *results = [self parseQueryResponse:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            handler(results , nil);
        });
    } onError:^(NSError *err, NSUInteger httpCode) {
        if(err != nil)
        {
            handler(nil, err);
            NSLog(@"Error:%@, httpCode:%lu\n",err.localizedDescription,httpCode);
            return;
        }
    }];
}

- (void) callToDownloadImage:(NSURL *)url completionHandler:(void (^)(id result, NSError *error)) handler {
    [[WebRequestMangaer sharedInstance] fetchUrlRequest:url onCompletion:^(NSData *data) {
         UIImage *image = [UIImage imageWithData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            handler(image , nil);
        });
    } onError:^(NSError *err, NSUInteger httpCode) {
        if(err != nil)
        {
            handler(nil, err);
            NSLog(@"Error:%@, httpCode:%lu\n",err.localizedDescription,httpCode);
            return;
        }
    }];
}

-(NSArray<WikiResult*> *)parseQueryResponse:(NSData*)queryResponse
{
    NSError *err;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:queryResponse options:kNilOptions error:&err];
    if(err != nil)
    {
        NSLog(@"Error parsing query response:%@\n",err.localizedDescription);
        return nil;
    }
    
    NSMutableArray<WikiResult *> *parsedResults = [NSMutableArray array];
    NSDictionary *pagesDict = jsonDict[@"query"][@"pages"];
    for(NSString *pageNumber in pagesDict.allKeys)
    {
        NSDictionary *aPage = pagesDict[pageNumber];
        NSURL *aPageRenditionURL = nil;
        if([aPage objectForKey:@"thumbnail"])
        {
            aPageRenditionURL = [NSURL URLWithString:aPage[@"thumbnail"][@"source"]];
        }
        
        WikiResult *aResult = [[WikiResult alloc] initWithTitle:aPage[@"title"] subtitle:aPage[@"extract"] renditionURL:aPageRenditionURL fullURL:[NSURL URLWithString:aPage[@"fullurl"]]];
        [parsedResults addObject:aResult];
    }
    
    return parsedResults;
}

-(NSURL*) createURLForQuery:(NSString*)query
{
    NSURLComponents *urlComponents = [NSURLComponents componentsWithString:@"https://en.wikipedia.org/w/api.php"];
    
    urlComponents.queryItems = @[[NSURLQueryItem queryItemWithName:@"format" value:@"json"],
                                 [NSURLQueryItem queryItemWithName:@"format" value:@"json"],
                                 [NSURLQueryItem queryItemWithName:@"action" value:@"query"],
                                 [NSURLQueryItem queryItemWithName:@"generator" value:@"search"],
                                 [NSURLQueryItem queryItemWithName:@"gsrnamespace" value:@"0"],
                                 [NSURLQueryItem queryItemWithName:@"gsrsearch" value:query],
                                 [NSURLQueryItem queryItemWithName:@"gsrlimit" value:@"10"],
                                 [NSURLQueryItem queryItemWithName:@"prop" value:@"pageimages|extracts|info"],
                                 [NSURLQueryItem queryItemWithName:@"inprop" value:@"url"],
                                 [NSURLQueryItem queryItemWithName:@"pilimit" value:@"max"],
                                 [NSURLQueryItem queryItemWithName:@"exintro" value:nil],
                                 [NSURLQueryItem queryItemWithName:@"explaintext" value:nil],
                                 [NSURLQueryItem queryItemWithName:@"exsentences" value:@"1"],
                                 [NSURLQueryItem queryItemWithName:@"exlimit" value:@"max"]];
    
    return urlComponents.URL;
}

@end
