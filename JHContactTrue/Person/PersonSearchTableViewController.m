//
//  PersonSearchTableViewController.m
//  JHContactTrue
//
//  Created by junhuai on 2019/12/17.
//  Copyright © 2019 junhuai. All rights reserved.
//

#import "PersonSearchTableViewController.h"
#import "JHContactManager.h"
#import "ChineseToPinyin.h"
#import "PersonDetailsViewController.h"
#import "Masonry.h"

// 新建一个结构来保存富文本信息
@interface JHAttributePerson : NSObject
@property (nonatomic, copy) NSMutableAttributedString *name;
@property (nonatomic, copy) NSMutableAttributedString *number;
@property (nonatomic, strong) JHPersonModel *personModel;
@end

@implementation JHAttributePerson
@end

@interface PersonSearchTableViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray<JHAttributePerson*> *searchResult;
@property(nonatomic, strong) UILabel *footLabel;
@property (nonatomic, weak) UISearchController *searchController;
@end

@implementation PersonSearchTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.tableView];

    self.footLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    self.footLabel.textAlignment = NSTextAlignmentCenter;
    self.footLabel.textColor = [UIColor systemGray4Color];
    self.tableView.tableFooterView = self.footLabel;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];

    // 在这来布局
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(-100);
        make.bottom.equalTo(self.view).with.offset(0);
    }];

    self.title = @"搜索结果";
//    self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
//    CGRect temp = self.view.frame;
//    temp.origin.y = -50;
//    self.tableView.frame = temp;
//    [self.tableView sizeToFit];
//    self.definesPresentationContext = YES;
    // 尝试自动布局
//    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
//    NSLayoutConstraint *c1 = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeWidth
//            relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0];
//    [self.tableView addConstraint:c1];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.searchController.searchBar)
        self.searchController.searchBar.hidden = NO;
//    CGRect temp = self.tableView.frame;
//    temp.origin.y = -100;
//    self.tableView.frame = temp;

//    NSLog(@"in");
//    self.tableView.contentOffset = CGPointMake(0, 100);
//    self.extendedLayoutIncludesOpaqueBars = YES;
//    self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//    self.tableView.contentInset = UIEdgeInsetsMake(-100, 0, 0, 0);



}


- (UITableView *)tableView {
    if (_tableView == nil)
    {
        CGRect rect = self.view.frame;
        rect.origin.y = -100;
        rect.size.height+=100;
        _tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 50;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
//        _tableView.bounds = rect;
    }
    return _tableView;
}


// 只能通过视图即将消失来控制 searchBar 隐藏
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    self.searchController.searchBar.hidden = YES;
    // 尝试添加动画
//    CATransition *transition = [CATransition animation];
//    transition.duration = 0.4;
//    transition.type = @"push";
//    transition.subtype = kCATransitionFromRight;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
//
//    [self.searchController.searchBar.layer addAnimation:transition forKey:nil];



}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.searchController.searchBar.hidden = YES;
}



- (NSMutableArray<JHAttributePerson *> *)searchResult {
    if (_searchResult == nil)
        _searchResult = [[NSMutableArray alloc] init];
    return _searchResult;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchResult.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    cell.textLabel.attributedText = self.searchResult[(NSUInteger) indexPath.row].name;
    cell.detailTextLabel.attributedText = self.searchResult[indexPath.row].number;
    // Configure the cell...
    
    return cell;
}

// 选中时
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 防止重复创建  重用一个 view
    PersonDetailsViewController *personDetailsViewController = [[PersonDetailsViewController alloc] initWithStyle:UITableViewStyleInsetGrouped];
    personDetailsViewController.personModel = self.searchResult[indexPath.row].personModel;
    // 推入下一级窗口
    [self.navigationController pushViewController:personDetailsViewController animated:NO];
//    [self presentViewController:personDetailsViewController animated:YES completion:nil];
//    NSLog(@"scrollview[contentoffset:%@---frame:%@------bounds:%@",NSStringFromCGPoint(self.tableView.contentOffset), NSStringFromCGRect(self.tableView.frame),NSStringFromCGRect(self.tableView.bounds));

}


// 获取头部标题
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (_searchResult.count)
        return @"搜索结果";
    else
        return nil;
}


#pragma mark - searchBar
// search 的代理方法
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchText = searchController.searchBar.text;
    if (searchText.length>0)
        [self searchString:searchText];

//    CGRect temp = self.tableView.frame;
//    temp.origin.y = -100;
//    self.tableView.frame = temp;

//    NSLog(@"update %@", searchText);
//    self.tableView.bounds = CGRectMake(0, -0, 414, 600);
//    NSLog(@"%lf %lf",self.tableView.frame.size.width, self.tableView.frame.size.height);

}

#pragma mark - searchbar  searchController代理

// 使用代理获得 searchController
- (void)presentSearchController:(UISearchController *)searchController {
    self.searchController = searchController;
//    NSLog(@"presentSearchController");
}

//- (void)didPresentSearchController:(UISearchController *)searchController {
//    NSLog(@"didPresentSearchController");
//}

- (void)didDismissSearchController:(UISearchController *)searchController {
    NSLog(@"didDismissSearchController");
    searchController.searchBar.hidden = NO;
}
//
//- (void)willDismissSearchController:(UISearchController *)searchController {
//    NSLog(@"willDismissSearchController");
//    searchController.searchBar.hidden = NO;
//}
//
//- (void)willPresentSearchController:(UISearchController *)searchController {
//    NSLog(@"willPresentSearchController");
//}


#pragma mark - tools

- (void) searchString: (NSString *)str{
    // 先清空当前搜索结果
    [self.searchResult removeAllObjects];
    // 遍历当前所有结果
    for (JHPersonModel *person in [JHContactManager sharedInstance].persons) {
        // 先匹配手机号  只有纯数字匹配
        NSRange findResult;
        if ([self isNumber:str]){
            for (JHValue *phone in person.phones) {
                // 找到匹配
                findResult = [phone.value rangeOfString:str];
                if (findResult.location != NSNotFound){
                    JHAttributePerson *result = [[JHAttributePerson alloc] init];
                    result.personModel = person;
                    result.name = [[NSMutableAttributedString alloc] initWithString:person.fullName];
                    // 上色
                    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:phone.value];
                    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:findResult];
                    result.number = attributedString;
                    // 加入已找到队列中
                    [self.searchResult addObject:result];
                }
            }
        }

        // 全字匹配
        findResult = [person.fullName rangeOfString:str];
        if (findResult.location != NSNotFound){
            JHAttributePerson *result = [[JHAttributePerson alloc] init];
            result.personModel = person;
            if (person.phones.count != 0)
                result.number = [[NSMutableAttributedString alloc] initWithString:person.phones[0].value];
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:person.fullName];
            [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:findResult];
            result.name = attributedString;
            // 加入已找到队列中
            [self.searchResult addObject:result];
        } else{  // 简拼
            str = [str lowercaseString];
            // 先查找姓氏 简拼
            findResult = [person.py rangeOfString:str];
            if (findResult.location != NSNotFound){
                JHAttributePerson *result = [[JHAttributePerson alloc] init];
                result.personModel = person;
                if (person.phones.count != 0)
                    result.number = [[NSMutableAttributedString alloc] initWithString:person.phones[0].value];
                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:person.fullName];
                [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:findResult];
                result.name = attributedString;
                // 加入已找到队列中
                [self.searchResult addObject:result];

            }
            // 中文模糊搜索
            NSString *strPinYin;
            if ([self isChinese:str]){
                strPinYin = [ChineseToPinyin pinyinFromChineseString:str withSpace:NO];
            } else
                strPinYin = str;
            // 后查找全拼
            findResult = [person.pinyin rangeOfString:strPinYin];
            if (findResult.location != NSNotFound){
//                NSLog(@"%lu %lu", findResult.location, findResult.length);
                JHAttributePerson *result = [[JHAttributePerson alloc] init];
                result.personModel = person;
                result.name = [[NSMutableAttributedString alloc] initWithString:person.fullName];;
                if (person.phones.count != 0) {
                    result.number = [[NSMutableAttributedString alloc] initWithString:person.phones[0].value];
                }
                // 加入已找到队列中
                [self.searchResult addObject:result];
            }

        }

    }

    self.footLabel.text = [NSString stringWithFormat:@"共搜索到 %lu 条结果", self.searchResult.count];

    // 刷新表格
    [self.tableView reloadData];

}

// 使用正则表达式判断输入是否全为数字
- (BOOL) isNumber:(NSString *)str
{
    if (str.length == 0) {
        return NO;
    }
    NSString *regex = @"[0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pred evaluateWithObject:str];
}

// 判断是否是中文
- (BOOL)isChinese:(NSString *)str {
    if (str.length == 0) {
        return NO;
    }
    NSString *match = @"(^.*[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:str];
}



@end
