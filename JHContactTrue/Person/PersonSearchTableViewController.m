//
//  PersonSearchTableViewController.m
//  JHContactTrue
//
//  Created by junhuai on 2019/12/17.
//  Copyright © 2019 junhuai. All rights reserved.
//

#import "PersonSearchTableViewController.h"

@interface PersonSearchTableViewController ()
@property (nonatomic, strong) NSArray *searchResult;
@end

@implementation PersonSearchTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(200, 400, 50, 30)];
    label.text = @"HELLO";
    [self.view addSubview:label];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return nil;
}


#pragma mark - searchBar
// search 的代理方法
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchText = searchController.searchBar.text;
    NSLog(@"update %@", searchText);
}

#pragma mark - tools



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
    NSString *match = @"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:str];
}

@end
