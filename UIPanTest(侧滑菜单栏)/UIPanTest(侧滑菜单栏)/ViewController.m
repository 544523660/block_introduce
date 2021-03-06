//
//  ViewController.m
//  UIPanTest(侧滑菜单栏)
//
//  Created by lk on 16/4/18.
//  Copyright © 2016年 LK. All rights reserved.
//

#import "ViewController.h"
#import "UIView+Extension.h"
static NSString *const cellID = @"cell_id";
#define tagBtn 2020
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, assign) NSIndexPath *lastIndex;

@property (nonatomic, strong) NSMutableDictionary *VCdic;
@end

@implementation ViewController
- (UITableView *)menuTableView{
    if (!_menuTableView) {
        _menuTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 100, self.view.height) style:UITableViewStylePlain];
        _menuTableView.delegate = self;
        _menuTableView.dataSource = self;
        _menuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _menuTableView.tableFooterView = [[UIView alloc] init];
    }
    return _menuTableView;
}
- (UIView *)contentDetailView{
    if (!_contentDetailView) {
        _contentDetailView = [[UIView alloc] initWithFrame:CGRectMake(100, 0, self.view.width, self.view.frame.size.height)];
//        _contentDetailView.backgroundColor = [UIColor clearColor];
    }
    return _contentDetailView;
}
- (NSArray *)dataArray{
    if (!_dataArray) {
        _dataArray = @[@"TestViewController",@"OneViewController",@"TwoViewController",@"111",@"11"];
    }
    return _dataArray;
}
- (NSMutableDictionary *)VCdic{
    if (!_VCdic) {
        _VCdic = [NSMutableDictionary dictionary];
    }
    return _VCdic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.menuTableView];
    [self.view addSubview:self.contentDetailView];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGesture:)];
    [self.contentDetailView addGestureRecognizer:panGesture];
    
    //添加第一个默认页面
//    [self.contentDetailView addSubview:self.redVC.view];
//    [self addChildViewController:self.redVC];
    
}


-(void)panGesture:(UIPanGestureRecognizer *)sender{
    [UIView animateWithDuration:0.2 animations:^{
        CGPoint point = [sender translationInView:self.view];
    
        if (point.x>0){
            self.menuTableView.x = 0;
            self.contentDetailView.x =self.menuTableView.width;
        }else{
            self.menuTableView.x= 0 - self.menuTableView.x;
            self.contentDetailView.x = 0;
        }
    }];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    UIButton *iconBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    
    [iconBtn setBackgroundImage:[UIImage imageNamed:@"222"] forState:UIControlStateNormal];
    [iconBtn setBackgroundImage:[UIImage imageNamed:@"111"] forState:UIControlStateSelected];
    
    iconBtn.tag = tagBtn+indexPath.row;
    
    [iconBtn addTarget:self action:@selector(menuClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.contentView addSubview:iconBtn];
    
    if (indexPath.row == 0) {
        iconBtn.selected = YES;
        self.lastIndex = indexPath;
        [self menuClick:iconBtn];
    }else{
        iconBtn.selected = NO;
    }
    
    return cell;
}
- (void)menuClick:(UIButton *)sender{
    //设置单选效果
    UITableViewCell *lastCell = [self.menuTableView cellForRowAtIndexPath:self.lastIndex];
    UIButton *lastBtn = (UIButton *)[lastCell viewWithTag:self.lastIndex.row +tagBtn];
    if (sender.isSelected == NO) {
        lastBtn.selected = NO;
    }
    sender.selected = YES;
    NSInteger currentView = sender.tag-tagBtn;
    //记录点击button
    self.lastIndex = [NSIndexPath indexPathForRow:currentView inSection:0];
    
    [self customViewWithClassName:currentView];
    
}
- (void)customViewWithClassName:(NSInteger)currentView{
    UIViewController *vc = nil;
    NSString *vcName = self.dataArray[currentView];
    
    if ([[self.VCdic allKeys] containsObject:vcName] ) {
        vc = self.VCdic[vcName];
    }else{
        vc = [self creatViewController:vcName];
        [self.VCdic setObject:vc forKey:vcName];
    }
    [self.contentDetailView addSubview:vc.view];
    
    //选中页面
    //    switch (sender.tag - tagBtn) {
    //        case 0:
    //            [self.contentDetailView addSubview:self.redVC.view];
    //            [self addChildViewController:self.redVC];
    //            break;
    //        case 1:
    //            [self.contentDetailView addSubview:self.blackVC.view];
    //            [self addChildViewController:self.blackVC];
    //            break;
    //        case 2:{
    //            Class viewControllerClass = NSClassFromString(@"TestViewController");
    //
    //            UIViewController *vc = [[viewControllerClass alloc] init];
    //            [self.contentDetailView addSubview:vc.view];
    //            [self addChildViewController:vc];
    //
    //
    //        }break;
    //        default:
    //            break;
    //    }
    
}
- (UIViewController *)creatViewController:(NSString *)className{
    Class VCClass = NSClassFromString(className);
    UIViewController *vc = [[VCClass alloc] init];
    [self addChildViewController:vc];
    return vc;
    
}





@end
