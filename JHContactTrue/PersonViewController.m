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

@interface PersonViewController ()  <CNContactPickerDelegate>
@property (nonatomic, strong) NSArray<JHPersonModel* > *persons;
@property (nonatomic, strong) NSArray<NSArray* > *sortedPersons;
@property (nonatomic, strong) NSArray *sectionTitles;
@property (nonatomic, strong) UILabel *infoText;
@end

@implementation PersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     UIBarButtonItem *barButtonItemAdd = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(buttonAddPress)];
     self.navigationItem.rightBarButtonItem = barButtonItemAdd;

     // 如果没有取得权限则显示该标签
    self.infoText = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 80)];
    self.infoText.text = @"没有获得通讯录权限";
    self.infoText.font = [UIFont systemFontOfSize:20];
    self.infoText.textColor = [UIColor systemGray4Color];
    self.infoText.center = CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height / 3 );
    self.infoText.textAlignment = NSTextAlignmentCenter;  // 文字居中效果
    [self.view addSubview:self.infoText];

    // 在通知中心注册  当通讯录改变的时候再刷新通讯录
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:CNContactStoreDidChangeNotification object:nil];

    // 初始时只刷新一次
//    [self refresh];

    dispatch_async(dispatch_get_main_queue(), ^{
        [self refresh];
        NSLog(@"任务  %@", [NSThread currentThread]);
    });

    // 添加一个 KVO  改成回调
//    [self addObserver:[JHContactManager sharedInstance] forKeyPath:authorized options:NSKeyValueObservingOptionNew context:@selector(refresh)];
}



// 把数据刷新放到将要显示中来做 x
// 改为通知刷新
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

-(void) refresh{
//    NSLog(@"改变");
    // 数据刷新
    if ([self getData]){
        // 排序
        [self sortPerson];
        // 填充数据
        [self.tableView reloadData];
    }
}

-(void) sortPerson{
    UILocalizedIndexedCollation *indexedCollation = [UILocalizedIndexedCollation currentCollation];
    NSMutableArray *mutableTitles = [[NSMutableArray alloc] initWithArray:[indexedCollation sectionTitles]];
    NSMutableArray<NSMutableArray*> *mutablePersons = [NSMutableArray arrayWithCapacity:mutableTitles.count];
    // 先把 27 个数组构建出来
    for (int i = 0; i < mutableTitles.count; ++i) {
        [mutablePersons addObject:[NSMutableArray array]];
    }
//    NSLog(@"%@", mutableTitles);
    // 开始用框架排序
    for (JHPersonModel * person in self.persons) {
        NSInteger index = [indexedCollation sectionForObject:person collationStringSelector:@selector(fullName)];
        [mutablePersons[index] addObject:person];
    }

    // 移除为 0 的数组
    for (NSInteger j = [indexedCollation sectionTitles].count - 1; j >= 0 ; j--) {
//        NSLog(@"%d", j);
        if (mutablePersons[j].count == 0){
            [mutablePersons removeObjectAtIndex:j];
            [mutableTitles removeObjectAtIndex:j];
        }
    }

    self.sectionTitles = [mutableTitles copy];
    self.sortedPersons = [mutablePersons copy];

}


- (BOOL) getData{
    JHContactManager *contactManager = [JHContactManager sharedInstance];
        // 没有授权的话
    if (![contactManager isAuthorized]){
        // 尝试获得授权
        [contactManager requestContactAuthorization:^{
            // 应该把它加到主队列里来完成
            // 不能再主队列任务同步  会发生死锁   为什么没有发生？？
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
    } else{
        // 获取数据
        self.persons = [contactManager getPersons];
        // 把表格恢复为可以滑动
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.tableView.scrollEnabled = YES;
        self.infoText.hidden = YES;
    }
    return YES;
}

- (void)buttonAddPress {
    PersonDetailsViewController *personDetailsViewController = [[PersonDetailsViewController alloc] init];
    // 推入下一级窗口
//    [self.navigationController pushViewController:personDetailsViewController animated:YES];
}


#pragma mark Table View Delegate
// 返回组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sortedPersons.count;
}

// 返回每组的列数 section是组数
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

// 数据刷新
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *str = @"Cell";
    JHTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if(cell == nil){
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
    PersonDetailsViewController *personDetailsViewController = [[PersonDetailsViewController alloc] init];
    // 推入下一级窗口
    [self.navigationController pushViewController:personDetailsViewController animated:YES];
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
