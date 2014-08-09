//
//  KeyBordVIew.m
//  气泡
//
//  Created by zzy on 14-5-13.
//  Copyright (c) 2014年 zzy. All rights reserved.
//

#import "KeyBordVIew.h"
#import "ChartMessage.h"
#import "ChartCellFrame.h"
#import "Colours.h"

@interface KeyBordVIew()<UITextFieldDelegate>
@property (nonatomic,strong) UIImageView *backImageView;

@property (nonatomic,strong) UITextField *textField;
@end

@implementation KeyBordVIew

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initialData];
    }
    return self;
}

-(UIButton *)buttonWith:(NSString *)noraml hightLight:(NSString *)hightLight action:(SEL)action
{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:noraml] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:hightLight] forState:UIControlStateHighlighted];
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}
-(void)initialData
{
    self.backImageView=[[UIImageView alloc]initWithFrame:self.bounds];
    self.backImageView.image=[self createImageWithColor:[UIColor black75PercentColor]];
    [self addSubview:self.backImageView];
    
    
    
    self.textField=[[UITextField alloc]initWithFrame:CGRectMake(0, 20, 280, self.frame.size.height*0.8)];
    self.textField.returnKeyType=UIReturnKeySend;
    self.textField.center=CGPointMake(160, self.frame.size.height*0.5);
    self.textField.font=[UIFont fontWithName:@"HelveticaNeue" size:15];
    self.textField.placeholder=@"请输入您想说的话...";
    self.textField.background=[UIImage imageNamed:@"chat_bottom_textfield.png"];
    self.textField.delegate=self;
    [self addSubview:self.textField];
    
    
}

- (UIImage*) createImageWithColor: (UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage*theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if([self.delegate respondsToSelector:@selector(KeyBordView:textFiledBegin:)]){
        
        [self.delegate KeyBordView:self textFiledBegin:textField];
    }
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if([self.delegate respondsToSelector:@selector(KeyBordView:textFiledReturn:)]){
    
        [self.delegate KeyBordView:self textFiledReturn:textField];
    }
    return YES;
}
@end
