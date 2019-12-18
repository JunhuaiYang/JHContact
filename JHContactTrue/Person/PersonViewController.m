//
//  PersonViewController.m
//  JHContactTrue
//
//  Created by junhuai on 2019/12/10.
//  Copyright © 2019 junhuai. All rights reserved.
//

#import <ContactsUI/ContactsUI.h>
#import "PersonViewController.h"
#import "PersonDetailsViewController.h"
#import "JHContactManager.h"
#import "JHTableViewCell.h"
#import "PersonSearchTableViewController.h"

@interface PersonViewController () < CNContactViewControllerDelegate>
@property(nonatomic, strong) NSArray<JHPersonModel * > *persons;
@property(nonatomic, strong) NSArray<NSArray * > *sortedPersons;
@property(nonatomic, strong) NSArray *sectionTitles;
@property(nonatomic, strong) UILabel *infoText;
@property(nonatomic, strong) PersonDetailsViewController *personDetailsViewController;
@property(nonatomic, strong) UILabel *footLabel;
@property (nonatomic, strong) UISearchController *searchController;
@end

@implementation PersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *barButtonItemAdd = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(buttonAddPress)];
    self.navigationItem.rightBarButtonItem = barButtonItemAdd;

//    self.navigationController.navigationBar.translucent = NO;
    // 新建 searchBar
    PersonSearchTableViewController *searchTableViewController = [[PersonSearchTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    // 应该把这个视图转变为 navigation
    UINavigationController *searchNavigation = [[UINavigationController alloc] initWithRootViewController:searchTableViewController];
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:searchNavigation];
    self.searchController.searchResultsUpdater = searchTableViewController;
    self.searchController.searchBar.placeholder = @"搜索";
    self.searchController.searchBar.autocorrectionType = UITextAutocorrectionTypeNo; // 关闭提示
    self.searchController.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone; // 关闭首字母大写
//    self.searchController.hidesNavigationBarDuringPresentation = NO;   // 隐藏导航栏
//    self.searchController.searchBar.translucent = NO;   // 设置透明
//    searchNavigation.navigationBar.translucent = NO;

//    [self.searchController.searchBar sizeToFit];
    self.searchController.definesPresentationContext = YES;   // 可以被覆盖
    self.definesPresentationContext = YES;
    searchNavigation.definesPresentationContext = YES;
    self.definesPresentationContext = YES;
//    self.extendedLayoutIncludesOpaqueBars = YES;

    // 将搜索栏添加
    self.tableView.tableHeaderView = self.searchController.searchBar;


    // 如果没有取得权限则显示该标签  标签显示
    self.infoText = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 80)];
    self.infoText.text = @"没有获得通讯录权限";
    self.infoText.font = [UIFont systemFontOfSize:20];
    self.infoText.textColor = [UIColor systemGray4Color];
    self.infoText.center = CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height / 3);
    self.infoText.textAlignment = NSTextAlignmentCenter;  // 文字居中效果
    [self.view addSubview:self.infoText];
    //调整两个cell之间的分割线的长度
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 60, 0, 20);
    // 创建下一级视图
     _personDetailsViewController = [[PersonDetailsViewController alloc] initWithStyle:UITableViewStyleInsetGrouped];

     // 页脚
     self.footLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
     self.footLabel.textAlignment = NSTextAlignmentCenter;
     self.footLabel.textColor = [UIColor systemGray4Color];
     self.tableView.tableFooterView = self.footLabel;

    // 在通知中心注册  当通讯录改变的时候再刷新通讯录  -- 改为 JHContactM 的
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:JHPersonsDidChangeNotification object:nil];

    // 初始时只刷新一次
//    [self refresh];

    dispatch_async(dispatch_get_main_queue(), ^{
        [self refresh];
//        NSLog(@"任务  %@", [NSThread currentThread]);
    });

    // 添加一个 KVO  改成回调
//    [self addObserver:[JHContactManager sharedInstance] forKeyPath:authorized options:NSKeyValueObservingOptionNew context:@selector(refresh)];
}


// 销毁时释放通知中心
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:JHPersonsDidChangeNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    self.searchController.searchBar.hidden = YES;
}


// 把数据刷新放到将要显示中来做 x
// 改为通知刷新
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)refresh {
//    NSLog(@"改变");
    // 数据刷新
    if ([self getData]) {
        // 排序
        [self sortPerson];
        // 填充数据
        [self.tableView reloadData];
        // 刷新页脚
        self.footLabel.text = [NSString stringWithFormat:@"共有%lu位联系人", _persons.count];
    }
}

- (void)sortPerson {
    UILocalizedIndexedCollation *indexedCollation = [UILocalizedIndexedCollation currentCollation];
    NSMutableArray *mutableTitles = [[NSMutableArray alloc] initWithArray:[indexedCollation sectionTitles]];
    NSMutableArray<NSMutableArray *> *mutablePersons = [NSMutableArray arrayWithCapacity:mutableTitles.count];
    // 先把 27 个数组构建出来
    for (int i = 0; i < mutableTitles.count; ++i) {
        [mutablePersons addObject:[NSMutableArray array]];
    }
//    NSLog(@"%@", mutableTitles);
    // 开始用框架排序
    for (JHPersonModel *person in self.persons) {
        NSInteger index = [indexedCollation sectionForObject:person collationStringSelector:@selector(fullName)];
        [mutablePersons[index] addObject:person];
    }

    // 移除为 0 的数组
    for (NSInteger j = [indexedCollation sectionTitles].count - 1; j >= 0; j--) {
//        NSLog(@"%d", j);
        if (mutablePersons[j].count == 0) {
            [mutablePersons removeObjectAtIndex:j];
            [mutableTitles removeObjectAtIndex:j];
        }
    }

    self.sectionTitles = [mutableTitles copy];
    self.sortedPersons = [mutablePersons copy];

}


- (BOOL)getData {
    JHContactManager *contactManager = [JHContactManager sharedInstance];
    // 没有授权的话
    if (![contactManager isAuthorized]) {
        // 尝试获得授权
        [contactManager requestContactAuthorization:^{
            // 应该把它加到主队列里来完成
            // 不能再主队列任务同步  会发生死锁   为什么没有发生？？  —— 运行时处于不同线程中
//            dispatch_sync(dispatch_get_main_queue(), ^{
//                [self refresh];
//            });
            // 应该改为异步任务
            dispatch_async(dispatch_get_main_queue(), ^{
                [self refresh];
//                NSLog(@"任务  %@", [NSThread currentThread]);
            });
        }];

        // 将背景显示为未获授权
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.scrollEnabled = NO;
        // 显示提示标签
        self.infoText.hidden = NO;
        return NO;
    } else {
        // 获取数据
        self.persons = [contactManager persons];
        // 把表格恢复为可以滑动
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.tableView.scrollEnabled = YES;
        self.infoText.hidden = YES;
    }
    return YES;
}

// 点击添加按钮
- (void)buttonAddPress {
    CNContactViewController *contactViewController = [CNContactViewController viewControllerForNewContact:[[CNContact alloc] init]];
    contactViewController.delegate = self;
    [self.navigationController pushViewController:contactViewController animated:YES];
//    [self presentViewController:contactViewController animated:YES completion:nil];
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:contactViewController];
//    [self presentViewController:nav animated:YES completion:nil];
}

// 编辑结束时推出返回
- (void)contactViewController:(CNContactViewController *)viewController didCompleteWithContact:(nullable CNContact *)contact {
    [viewController.navigationController popViewControllerAnimated:YES];  // 手动返回
}


#pragma mark Table View Delegate

// 返回组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sortedPersons.count;
}

// 返回每组的行数 section是组数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sortedPersons[(NSUInteger) section].count;
}

// 获取头部标题
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.sectionTitles[section];
}

// 开启索引显示
- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.sectionTitles;
}

// 索引
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return index;
}

// 单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [JHTableViewCell getCellHeight:JHTableViewCellStylMain];
}

// 数据刷新  获取数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *str = @"Cell";
    JHTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (cell == nil) {
        cell = [[JHTableViewCell alloc] initWithMyStyle:JHTableViewCellStylMain reuseIdentifier:str];
    }

    // Configure the cell...
    JHPersonModel *personModel = self.sortedPersons[indexPath.section][indexPath.row];
    cell.personModel = personModel;
//    NSLog(@"%@: size:%@", personModel.fullName, cell.textLabel.frame);
    return cell;
}

// 选中时
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 防止重复创建  重用一个 view
    _personDetailsViewController.personModel = self.sortedPersons[indexPath.section][indexPath.row];
    // 推入下一级窗口
    [self.navigationController pushViewController:_personDetailsViewController animated:YES];
}



@end
