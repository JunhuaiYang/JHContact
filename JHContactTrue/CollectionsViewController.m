//
//  CollectionsViewController.m
//  JHContactTrue
//
//  Created by junhuai on 2019/12/10.
//  Copyright © 2019 junhuai. All rights reserved.
//

#import "CollectionsViewController.h"

@interface CollectionsViewController ()

@property NSMutableArray *tableData;
@property NSMutableArray *sectionTitle;

@end

@implementation CollectionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //    新建数据
    self.tableData = [[NSMutableArray alloc] init];
    self.sectionTitle = [[NSMutableArray alloc] init];
    for (int i = 'A'; i <= 'Z'; ++i) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [self.sectionTitle addObject:[NSString stringWithFormat:@"%c",(char)i]];
        for (int j = 1; j <= 8; ++j) {
            [array addObject:[NSString stringWithFormat:@"%c%d",(char)i, j]];
        }
        [self.tableData addObject:array];
    }

//    重新加载数据
    [self.tableView reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - Table view data source

// 返回组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.tableData.count;
}

// 返回每组的列数 section是组数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.tableData objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *str = @"Cell";
//    尝试获得可复用的 cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }

    // Configure the cell...
    cell.textLabel.text = self.tableData[indexPath.section][indexPath.row];

    return cell;
}

// 单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

// section 头部的间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

// section 尾部的间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

// 获取头部标题
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.tableData[section][0] substringToIndex:1];
}

// 开启索引显示
- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.sectionTitle;
}

// 索引
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return index;
}


@end
