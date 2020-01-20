//
//  FactoryViewController.m
//  AWKitProduct
//
//  Created by winnie on 2019/12/16.
//  Copyright © 2019 winnie. All rights reserved.
//

#import "FactoryViewController.h"
#import "FatherFactoryTableViewCell.h"
#import "FatherFactory.h"
@interface FactoryViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation FactoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITableView *table =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStyleGrouped];
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    // Do any additional setup after loading the view.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FatherFactory *factory = [FatherFactory createFactoryWithType:indexPath.section];
    NSString *modelName = [NSString stringWithUTF8String:object_getClassName(factory)];
    FatherFactoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:modelName];
    if (cell == nil) {
        cell = [FatherFactoryTableViewCell cellWithType:indexPath.section];
    }
    return cell;
}

@end
