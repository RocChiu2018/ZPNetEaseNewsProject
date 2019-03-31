//
//  ZPTableViewController.m
//  网易新闻首页
//
//  Created by apple on 2016/12/27.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ZPTableViewController.h"

@interface ZPTableViewController ()

@end

@implementation ZPTableViewController

static NSString *ID = @"cell";

#pragma mark ————— 生命周期 —————
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"viewDidLoad - %@", self.title);
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ID];
}

#pragma mark ————— UITableViewDataSource —————
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ - %ld", self.title, (long)indexPath.row];
    
    return cell;
}

@end
