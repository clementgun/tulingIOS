//
//  MyChatView.h
//  tulingIOS
//
//  Created by Colin on 14-8-9.
//  Copyright (c) 2014年 icephone. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "JSONKit.h"
#import "ASIHTTPRequest.h"

@interface MyChatView : UIViewController

@property (nonatomic,strong) ASIHTTPRequest *testRequest;
@property (nonatomic,strong) UITextField *myTextField;

@end
