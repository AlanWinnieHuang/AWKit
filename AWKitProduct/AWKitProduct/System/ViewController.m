//
//  ViewController.m
//  AWKitProduct
//
//  Created by winnie on 2019/12/6.
//  Copyright © 2019 winnie. All rights reserved.
//

#import "ViewController.h"
#import "HikTelescopicTableHeadTool.h"
#import "Masonry.h"
@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UIImageView *headView;
@property (nonatomic, strong)HikTelescopicTableHeadTool *headTool;
@property (nonatomic, strong)UIImageView *avatorHead;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self addAllSubviews];
    [self layoutAllSubViews];
    
    self.headTool = [HikTelescopicTableHeadTool new];
    [self.headTool telescopicTableHeadToolForTableView:self.tableView withHeadView:self.headView orSubviews:self.avatorHead];
}

- (void)addAllSubviews {
    [self.view addSubview:self.tableView];
    
}

- (void)layoutAllSubViews {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.offset(0);
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.headTool scrollViewDidScroll:scrollView];
}

- (void)viewDidLayoutSubviews
{
    [self.headTool resizeView];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"test" forIndexPath:indexPath];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"test"];
    }
    return _tableView;
}

- (UIImageView *)headView {
    if (!_headView) {
        _headView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 150)];
        [_headView setImage:[UIImage imageNamed:@"headView"]];
        [_headView addSubview:self.avatorHead];
    }
    return _headView;
}

- (UIImageView *)avatorHead {
    if (!_avatorHead) {
        _avatorHead = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        _avatorHead.center = _headView.center;
        [_avatorHead setBackgroundColor:[UIColor redColor]];
    }
    return _avatorHead;
}

@end
