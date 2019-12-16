//
//  PersonDetailsViewController.m
//  JHContactTrue
//
//  Created by junhuai on 2019/12/10.
//  Copyright © 2019 junhuai. All rights reserved.
//

#import "PersonDetailsViewController.h"

@interface PersonDetailsViewController ()
@property UIImageView *imageView;
@property UILabel *name;

@end

@implementation PersonDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 可以隐藏 tabar
    self.tabBarController.tabBar.hidden = YES;

    // 设置预估高度
    self.tableView.estimatedRowHeight = 150;
    self.tableView.rowHeight = UITableViewAutomaticDimension;

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 可以隐藏 tabBar
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 取消隐藏
    self.tabBarController.tabBar.hidden = NO;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
