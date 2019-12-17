//
//  PersonDetailsViewController.m
//  JHContactTrue
//
//  Created by junhuai on 2019/12/10.
//  Copyright © 2019 junhuai. All rights reserved.
//

#import "PersonDetailsViewController.h"
#import "PersonDetailsTableViewCell.h"

@interface PersonDetailsViewController ()
@property (nonatomic, strong) PersonDetailsTableViewCell *personDetailsTableViewCell;
@property (nonatomic, copy) NSMutableArray *data;
@property (nonatomic, copy) NSMutableArray *tags;

@end

@implementation PersonDetailsViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        // 初始化 data！
        _data = [[NSMutableArray alloc] init];
        _tags = [[NSMutableArray alloc] init];
        self.personDetailsTableViewCell = [[PersonDetailsTableViewCell alloc] init];
    }

    return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // 初始化 data！
        _data = [[NSMutableArray alloc] init];
        _tags = [[NSMutableArray alloc] init];
        self.personDetailsTableViewCell = [[PersonDetailsTableViewCell alloc] init];
    }

    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 可以隐藏 tabar
    self.tabBarController.tabBar.hidden = YES;

    // 设置预估高度
//    self.tableView.estimatedRowHeight = 150;
//    self.tableView.rowHeight = UITableViewAutomaticDimension;
    // 不显示多余的 cell
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;  // 编辑按钮
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

- (void)setPersonModel:(JHPersonModel *)personModel {
    _personModel = personModel;
    // 设置 cell 的 model
    self.personDetailsTableViewCell.personModel = personModel;
    // 先移除所有
    [self.data removeAllObjects];
    [self.tags removeAllObjects];
    // 添加电话号码 和 邮箱
    for (JHValue *phone in personModel.phones) {
        [self.data addObject:[NSString stringWithString:phone.value]];
        [self.tags addObject:[NSString stringWithString:phone.type]];
    }
    for (JHValue *email in personModel.emails) {
        [self.data addObject:[NSString stringWithString:email.value]];
        [self.tags addObject:[NSString stringWithString:email.type]];
    }
    // 记得 reload。。。
    [self.tableView reloadData];

}

#pragma mark Table View Delegate
// 返回组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

// 返回每组的行数 section是组数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section ? self.data.count : 1;
}

// 单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"%lf", [self.personDetailsTableViewCell height]);
    if (indexPath.section == 0)
        return [self.personDetailsTableViewCell height];
    else
        return 80;
}

// 数据刷新  获取数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0){
        return _personDetailsTableViewCell;
    } else{
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.textLabel.text = self.tags[indexPath.row ];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.detailTextLabel.text = self.data[indexPath.row];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:18];
        cell.detailTextLabel.textColor = [UIColor darkTextColor];
        if ([self.data[indexPath.row] rangeOfString:@"@"].location == NSNotFound)
            cell.image = [UIImage systemImageNamed:@"phone.fill"];
        else
            cell.image = [UIImage systemImageNamed:@"envelope.fill"];
        return cell;
    }
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return section ? @"详细信息" : @"";
}


@end
