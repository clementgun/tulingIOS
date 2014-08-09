//
//  ChartMessage.h
//  tulingIOS
//
//  Created by Colin on 14-8-9.
//  Copyright (c) 2014年 icephone. All rights reserved.
//

typedef enum {
  
    kMessageFrom=0,
    kMessageTo
 
}ChartMessageType;
#import <Foundation/Foundation.h>

@interface ChartMessage : NSObject
@property (nonatomic,assign) ChartMessageType messageType;
@property (nonatomic, copy) NSString *icon;
//@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSDictionary *dict;
@end
