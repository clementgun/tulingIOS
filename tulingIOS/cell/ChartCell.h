//
//  ChartCell.h
//  tulingIOS
//
//  Created by Colin on 14-8-9.
//  Copyright (c) 2014年 icephone. All rights reserved.
//


#import <UIKit/UIKit.h>
@class ChartCell;

@protocol ChartCellDelegate <NSObject>

-(void)chartCell:(ChartCell *)chartCell tapContent:(NSString *)content;

@end

#import "ChartCellFrame.h"
@interface ChartCell : UITableViewCell
@property (nonatomic,strong) ChartCellFrame *cellFrame;
@property (nonatomic,assign) id<ChartCellDelegate> delegate;
@end
