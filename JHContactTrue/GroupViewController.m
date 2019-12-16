//
//  GroupViewController.m
//  JHContactTrue
//
//  Created by junhuai on 2019/12/10.
//  Copyright © 2019 junhuai. All rights reserved.
//

#import "GroupViewController.h"

@interface GroupViewController ()

@end

@implementation GroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:@"群组" image:[UIImage systemImageNamed:@"person.2"] tag:104];
//    self.tabBarItem = tabBarItem;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (NSArray<UIDragItem *> *)tableView:(UITableView *)tableView itemsForBeginningDragSession:(id <UIDragSession>)session atIndexPath:(NSIndexPath *)indexPath {
    return nil;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
