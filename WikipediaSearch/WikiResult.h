//
//  Created by Akshit Bum
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WikiResult : NSObject

@property NSString *title;
@property NSString *subtitle;
@property UIImage *renditionImage;
@property NSURL *renditionURL;
@property NSURL *fullURL;

-(instancetype)initWithTitle:(NSString*)title
                    subtitle:(NSString*)subtitle
                renditionURL:(NSURL*)renditionURL
                     fullURL:(NSURL*)fullURL NS_DESIGNATED_INITIALIZER;

@end
