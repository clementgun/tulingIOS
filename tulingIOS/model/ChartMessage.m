//
//  ChartMessage.m
//  tulingIOS
//
//  Created by Colin on 14-8-9.
//  Copyright (c) 2014年 icephone. All rights reserved.
//


#import "ChartMessage.h"

@implementation ChartMessage

-(void)setDict:(NSDictionary *)dict
{
    _dict=dict;

    self.icon=dict[@"icon"];
//    self.time=dict[@"time"];
    self.content=dict[@"content"];
    self.messageType=[dict[@"type"] intValue];
}
@end
