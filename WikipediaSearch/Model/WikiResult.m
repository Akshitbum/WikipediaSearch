//
//  Created by Akshit Bum
//

#import "WikiResult.h"

@implementation WikiResult

-(instancetype)initWithTitle:(NSString*)title
                    subtitle:(NSString*)subtitle
                renditionURL:(NSURL*)renditionURL
                     fullURL:(NSURL*)fullURL
{
    if(self)
    {
        self.title = title;
        self.subtitle = subtitle;
        self.renditionURL = renditionURL;
        self.fullURL = fullURL;
    }
    
    return self;
}

-(instancetype)init
{
    return [self initWithTitle:nil subtitle:nil renditionURL:nil fullURL:nil];
}

@end
