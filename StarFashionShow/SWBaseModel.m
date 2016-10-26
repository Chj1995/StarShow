//
//  SWBaseModel.m
//  StarWardrobes
//
//  Created by qianfeng on 16/9/27.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import "SWBaseModel.h"

@implementation SWBaseModel

+(id)modelWithDictionAry:(NSDictionary *)dictionary
{
    SWBaseModel *model = [[self alloc] init];
    
    [model setValuesForKeysWithDictionary:dictionary];
    
    return model;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
-(id)valueForUndefinedKey:(NSString *)key
{
    return nil;
}

@end
