//
//  PhoneViewController.m
//  JHContactTrue
//
//  Created by junhuai on 2019/12/10.
//  Copyright © 2019 junhuai. All rights reserved.
//

#import <ContactsUI/ContactsUI.h>
#import "PhoneViewController.h"
#import "JHPersonModel.h"
#import "JHContactManager.h"
#import "JHTableViewCell.h"
#import "PersonDetailsViewController.h"

@interface PhoneViewController () <CNContactPickerDelegate>
@property (nonatomic, strong) UILabel *footLabel;
@property (nonatomic, strong) PersonDetailsViewController *personDetailsViewController;
@end

@implementation PhoneViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        _index =  -1; // 初始化索引为-1  用以区别
    }

    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *barButtonItemAdd = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(buttonAddPress)];
    self.navigationItem.rightBarButtonItem = barButtonItemAdd;

//    self.persons = [[NSMutableArray alloc] init];
    if (self.persons == nil)
        self.persons = [[JHContactManager sharedInstance] persons];

    // 在通知中心注册
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:JHPersonsDidChangeNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:JHPersonsDidChangeNotification object:nil];
}


- (void)refresh {
    // 如果是电话页
    if (_index == -1){
        self.persons = [JHContactManager sharedInstance].persons;
    } else{
        self.persons = [JHContactManager sharedInstance].groupPersons[(NSUInteger) _index];
    }
    [self.tableView reloadData];
}

- (void)buttonAddPress {
    CNContactPickerViewController *contactPickerViewController = [[CNContactPickerViewController alloc] init];
    contactPickerViewController.delegate = self;
    [self presentViewController:contactPickerViewController animated:YES completion:nil];
}

// ContactUI 的联系方式  选中联系人
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact {
    // 1. 获取姓名
    NSLog(@"选中联系人:\n givenNameLabel: %@, familyNameLabel: %@", contact.givenName, contact.familyName);

    // 先看此时 index 是否》0
    // 若此时在群组中
    if (_index>=0){
        [[JHContactManager sharedInstance] addPersonToGroup:contact index:(NSUInteger) _index];
    }


}

- (UILabel *)footLabel {
    if (!_footLabel){
        _footLabel = [[UILabel alloc] init];
        _footLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
        _footLabel.textAlignment = NSTextAlignmentCenter;
        _footLabel.textColor = [UIColor systemGray4Color];
        self.tableView.tableFooterView = _footLabel;
    }
    return _footLabel;
}

- (PersonDetailsViewController *)personDetailsViewController {
    if (!_personDetailsViewController)
        _personDetailsViewController = [[PersonDetailsViewController alloc] initWithStyle:UITableViewStyleInsetGrouped];
    return _personDetailsViewController;
}


- (void)setPersons:(NSArray *)persons {
    _persons = persons;
    if (persons.count)
        self.footLabel.text = [NSString stringWithFormat:@"群组共有 %lu 位联系人", persons.count];
    else
        self.footLabel.text = [NSString stringWithFormat:@"无联系人"];
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

#pragma mark Table View Delegate

// 返回组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// 返回每组的行数 section是组数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.persons.count;
}

// 数据刷新  获取数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *str = @"detail";
    JHTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (cell == nil) {
        cell = [[JHTableViewCell alloc] initWithMyStyle:JHTableViewCellStyleDetail reuseIdentifier:str];
    }
    // Configure the cell...
    JHPersonModel *personModel = self.persons[(NSUInteger) indexPath.row];
    cell.personModel = personModel;
//    NSLog(@"%@: size:%@", personModel.fullName, cell.textLabel.frame);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

// 选中时
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 推入一个新建的列表
    self.personDetailsViewController.personModel = self.persons[(NSUInteger) indexPath.row];
    [self.navigationController pushViewController:self.personDetailsViewController animated:YES];
}


@end
