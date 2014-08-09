//
//  MyChatView.m
//  tulingIOS
//
//  Created by Colin on 14-8-9.
//  Copyright (c) 2014年 icephone. All rights reserved.
//


#import "MyChatView.h"
#import "ChartMessage.h"
#import "ChartCellFrame.h"
#import "ChartCell.h"
#import "KeyBordVIew.h"

@interface MyChatView ()<UITableViewDataSource,UITableViewDelegate,KeyBordVIewDelegate,ChartCellDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) KeyBordVIew *keyBordView;
@property (nonatomic,strong) NSMutableArray *cellFrames;
@property (nonatomic,assign) BOOL recording;
@property (nonatomic,strong) NSString *fileName;

@property (nonatomic,strong) NSMutableDictionary *testDic;
@property (nonatomic,strong) NSMutableArray *testArr;

@end

static NSString *const cellIdentifier=@"chatCell";

@implementation MyChatView
@synthesize myTextField;

@synthesize testRequest;
@synthesize testArr,testDic;

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //注册通知, 键盘收起, 弹出
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}

//键盘弹出响应
-(void)keyboardShow:(NSNotification *)note
{
    CGRect keyBoardRect=[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat deltaY=keyBoardRect.size.height;
    
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        
        self.view.transform=CGAffineTransformMakeTranslation(0, -deltaY);
    }];
}

//键盘收起响应
-(void)keyboardHide:(NSNotification *)note
{
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        self.view.transform = CGAffineTransformIdentity;
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //初始化返回数据
    self.testDic = [NSMutableDictionary dictionaryWithCapacity:5];
    self.testArr = [NSMutableArray arrayWithCapacity:100];
    
    self.title=@"图灵机器人";
    self.view.backgroundColor=[UIColor whiteColor];
    
    //add UItableView
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height-88) style:UITableViewStylePlain];
    [self.tableView registerClass:[ChartCell class] forCellReuseIdentifier:cellIdentifier];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.allowsSelection = NO;
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chat_bg_default.jpg"]];
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    [self.view addSubview:self.tableView];
    
    //add keyBorad
    self.keyBordView=[[KeyBordVIew alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-44, self.view.frame.size.width, 44)];
    self.keyBordView.delegate=self;
    [self.view addSubview:self.keyBordView];
    
    //初始化聊天界面数据
    [self initwithData];
    
}

//加载messages.plist中的对话
-(void)initwithData
{
    
    self.cellFrames=[NSMutableArray array];
    
    NSString *path=[[NSBundle mainBundle] pathForResource:@"messages" ofType:@"plist"];
    NSArray *data=[NSArray arrayWithContentsOfFile:path];
    
    for(NSDictionary *dict in data)
    {
        
        ChartCellFrame *cellFrame=[[ChartCellFrame alloc]init];
        ChartMessage *chartMessage=[[ChartMessage alloc]init];
        chartMessage.dict=dict;
        cellFrame.chartMessage=chartMessage;
        [self.cellFrames addObject:cellFrame];
    }
    
}

#pragma mark - 聊天列表
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cellFrames.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChartCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.delegate=self;
    cell.cellFrame=self.cellFrames[indexPath.row];
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.cellFrames[indexPath.row] cellHeight];
}


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
    [self.view endEditing:YES];
}

//每当编辑完问题后
//1. 显示自己的问题 messageType=1
//2. 调用API，返回结果
-(void)KeyBordView:(KeyBordVIew *)keyBoardView textFiledReturn:(UITextField *)textFiled
{
    
    //显示自己的问题
    ChartCellFrame *cellFrame=[[ChartCellFrame alloc]init];
    ChartMessage *chartMessage=[[ChartMessage alloc]init];
    
    chartMessage.icon=@"icon01.png";
    chartMessage.messageType=1;
    chartMessage.content=textFiled.text;
    cellFrame.chartMessage=chartMessage;
    
    [self.cellFrames addObject:cellFrame];
    [self.tableView reloadData];
    
    //滚动到当前行
    [self tableViewScrollCurrentIndexPath];
    
    //利用用户问题, 查询结果
    
    //API请求格式。 具体格式见图灵官网
    //6c2cfaf7a7f088e843b550b0c5b89c26 替换成你申请的key即可
    NSString* urlString = [NSString stringWithFormat:@"http://www.tuling123.com/openapi/api?key=6c2cfaf7a7f088e843b550b0c5b89c26&&info=%@", textFiled.text];
    
    //NSUTF8StringEncoding编码。 避免中文错误
	urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //调用API
    NSURL *url = [NSURL URLWithString:urlString];
    testRequest = [ASIHTTPRequest requestWithURL:url];
    [testRequest setDelegate:self];
    [testRequest startAsynchronous];
    
    textFiled.text=@"";
    myTextField = textFiled;
}

#pragma mark - 返回机器人回答
//调用API完毕, 返回图灵回答结果
//1. 收起键盘
//2. 显示回答内容
- (void)requestFinished:(ASIHTTPRequest *)request
{
    
    //收起键盘
    [myTextField resignFirstResponder];
    
    // 当以文本形式读取返回内容时用这个方法
    // 解析返回的json数据
    NSString *responseString = [request responseString];
    self.testDic = [responseString objectFromJSONString];
    self.testArr = [testDic objectForKey:@"text"];
    
    
    //显示回答内容
    ChartCellFrame *cellFrame=[[ChartCellFrame alloc]init];
    ChartMessage *chartMessage=[[ChartMessage alloc]init];
    
    chartMessage.icon=@"icon02.png";
    chartMessage.messageType=0;
    chartMessage.content=[NSString stringWithFormat:@"%@", self.testArr];
    cellFrame.chartMessage=chartMessage;
    
    [self.cellFrames addObject:cellFrame];
    [self.tableView reloadData];
    
    //滚动到当前行
    [self tableViewScrollCurrentIndexPath];
    
}

// API请求失败
- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"error --- %@",error);
    
    UIAlertView *alert_ = [[UIAlertView alloc]initWithTitle:@"提示" message:@"无网络可用,请检查网络状态" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
    [alert_ show];
}

-(void)KeyBordView:(KeyBordVIew *)keyBoardView textFiledBegin:(UITextField *)textFiled
{
    [self tableViewScrollCurrentIndexPath];
    
}

-(void)tableViewScrollCurrentIndexPath
{
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:self.cellFrames.count-1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
