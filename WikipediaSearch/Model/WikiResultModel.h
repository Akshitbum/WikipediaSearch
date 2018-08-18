//
//  Created by Akshit Bum
//

#import <Foundation/Foundation.h>

#import "WikiResult.h"

@interface WikiResultModel : NSObject

-(instancetype) init;
-(void) addResult:(WikiResult*)aResult;
-(void) addResults:(NSArray<WikiResult*> *)results;
-(WikiResult*) resultAtIndex:(NSUInteger)index;
-(void) removeResultAtIndex:(NSUInteger)index;
-(NSUInteger) count;
-(void) reset;

@end
