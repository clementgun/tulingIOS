//
//  ChartCellFrame.h
//  tulingIOS
//
//  Created by Colin on 14-8-9.
//  Copyright (c) 2014年 icephone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChartMessage.h"
@interface ChartCellFrame : NSObject
@property (nonatomic,assign) CGRect iconRect;
@property (nonatomic,assign) CGRect chartViewRect;
@property (nonatomic,strong) ChartMessage *chartMessage;
@property (nonatomic, assign) CGFloat cellHeight; //cell高度
@end
