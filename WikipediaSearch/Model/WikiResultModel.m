//
//  Created by Akshit Bum
//

#import "WikiResultModel.h"
#import "WikiResult.h"

@interface WikiResultModel()

@property NSMutableArray<WikiResult*> *results;

@end




@implementation WikiResultModel

-(instancetype) init
{
    self = [super init];
    if(self)
    {
        self.results = [NSMutableArray array];
    }
    return self;
}

-(void) addResult:(WikiResult*)res
{
    [self.results addObject:res];
}

-(void) addResults:(NSArray<WikiResult*> *)results
{
    [self.results addObjectsFromArray:results];
}

-(WikiResult*) resultAtIndex:(NSUInteger)index
{
    if(index >= [self.results count])
        return nil;
    return [self.results objectAtIndex:index];
}

-(void) removeResultAtIndex:(NSUInteger)index
{
    if(index >= [self.results count])
        return;
    [self.results removeObjectAtIndex:index];
}

-(void) reset
{
    [self.results removeAllObjects];
}

-(NSUInteger) count
{
    return [self.results count];
}

@end
