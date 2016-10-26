//
//  SFSInfotainmentModel.m
//  StarFashionShow
//
//  Created by qianfeng on 16/10/23.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import "SFSInfotainmentModel.h"

@implementation SFSInfotainmentModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        
        self.picId = [NSString stringWithFormat:@"%@",value];
    }
}


@end
