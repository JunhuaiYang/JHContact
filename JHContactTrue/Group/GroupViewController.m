//
//  GroupViewController.m
//  JHContactTrue
//
//  Created by junhuai on 2019/12/10.
//  Copyright © 2019 junhuai. All rights reserved.
//

#import "GroupViewController.h"
#import "JHContactManager.h"
#import "PhoneViewController.h"

@interface GroupViewController ()
@property (nonatomic, strong) PhoneViewController *phoneViewController;
@end

@implementation GroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:@"群组" image:[UIImage systemImageNamed:@"person.2"] tag:104];
//    self.tabBarItem = tabBarItem;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (PhoneViewController *)phoneViewController {
    if (_phoneViewController == nil)
        _phoneViewController = [[PhoneViewController alloc] init];
    return _phoneViewController;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [JHContactManager sharedInstance].groups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *str = @"cell";
//    尝试获得可复用的 cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    // Configure the cell...
    cell.textLabel.text = [JHContactManager sharedInstance].groups[(NSUInteger) indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:20];
    return cell;
}

// 选中时
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 推入一个新建的列表
    self.phoneViewController.persons = [[[JHContactManager sharedInstance] groupPersons][(NSUInteger) indexPath.row] copy];
    self.phoneViewController.index = indexPath.row;
    self.phoneViewController.title = [JHContactManager sharedInstance].groups[(NSUInteger) indexPath.row];
    [self.navigationController pushViewController:self.phoneViewController animated:YES];
}


@end
