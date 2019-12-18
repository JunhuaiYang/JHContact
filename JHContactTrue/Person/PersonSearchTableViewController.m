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

// 新建一个结构来保存富文本信息
@interface JHAttributePerson : NSObject
@property (nonatomic, copy) NSMutableAttributedString *name;
@property (nonatomic, copy) NSMutableAttributedString *number;
@property (nonatomic, strong) JHPersonModel *personModel;
@end

@implementation JHAttributePerson
@end

@interface PersonSearchTableViewController ()
@property (nonatomic, strong) NSMutableArray<JHAttributePerson*> *searchResult;
@property(nonatomic, strong) UILabel *footLabel;
@end

@implementation PersonSearchTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.footLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    self.footLabel.textAlignment = NSTextAlignmentCenter;
    self.footLabel.textColor = [UIColor systemGray4Color];
    self.tableView.tableFooterView = self.footLabel;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];

    self.title = @"搜索结果";
//    self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
//    CGRect temp = self.view.frame;
//    temp.origin.y = -50;
//    self.tableView.frame = temp;
//    [self.tableView sizeToFit];
//    self.definesPresentationContext = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    CGRect temp = self.tableView.frame;
    temp.origin.y-=200;
    self.tableView.frame = temp;

//    self.tableView.contentOffset = CGPointMake(0, 100);
//    self.extendedLayoutIncludesOpaqueBars = YES;
//    self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//    self.tableView.contentInset = UIEdgeInsetsMake(-100, 0, 0, 0);

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
    PersonDetailsViewController *personDetailsViewController = [[PersonDetailsViewController alloc] init];
    personDetailsViewController.personModel = self.searchResult[indexPath.row].personModel;
    // 推入下一级窗口
    [self.navigationController pushViewController:personDetailsViewController animated:YES];
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
//    NSLog(@"update %@", searchText);
//    self.tableView.bounds = CGRectMake(0, -0, 414, 600);
//    NSLog(@"%lf %lf",self.tableView.frame.size.width, self.tableView.frame.size.height);

}



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
