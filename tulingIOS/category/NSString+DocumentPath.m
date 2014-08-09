//
//  NSString+DocumentPath.m
//  tulingIOS
//
//  Created by Colin on 14-8-9.
//  Copyright (c) 2014年 icephone. All rights reserved.
//


#import "NSString+DocumentPath.h"

@implementation NSString (DocumentPath)
+(NSString *)documentPathWith:(NSString *)fileName
{

    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",fileName]];
}
@end
