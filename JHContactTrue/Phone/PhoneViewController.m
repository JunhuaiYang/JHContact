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

@interface PhoneViewController () <CNContactPickerDelegate>
@property (nonatomic, copy) NSArray *persons;
@end

@implementation PhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *barButtonItemAdd = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(buttonAddPress)];
    self.navigationItem.rightBarButtonItem = barButtonItemAdd;

    self.persons = [[NSMutableArray alloc] init];
    self.persons = [[JHContactManager sharedInstance] persons];

}

- (void)buttonAddPress {
    CNContactPickerViewController *contactPickerViewController = [[CNContactPickerViewController alloc] init];
    contactPickerViewController.delegate = self;
    [self presentViewController:contactPickerViewController animated:YES completion:nil];
}

// ContactUI 的联系方式
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact {
    // 1. 获取姓名
    NSLog(@"Selected:\n givenNameLabel: %@, familyNameLabel: %@", contact.givenName, contact.familyName);
    // 2. 获取电话
    int count = 0;
    for (CNLabeledValue *labeledValue in contact.phoneNumbers) {
        CNPhoneNumber *phoneNumber = labeledValue.value;
        NSLog(@"phoneNumber%d: %@", ++count, phoneNumber.stringValue);
    }
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
    JHPersonModel *personModel = self.persons[indexPath.row];
    cell.personModel = personModel;
//    NSLog(@"%@: size:%@", personModel.fullName, cell.textLabel.frame);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}


@end
