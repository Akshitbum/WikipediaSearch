//
//  Created by Akshit Bum
//

#import <UIKit/UIKit.h>

@interface ResultCell : UITableViewCell

@property NSString *title;
@property NSString *subtitle;
@property UIImage *renditionImage;

-(void)startActivity;
-(void)stopActivity;

@end
