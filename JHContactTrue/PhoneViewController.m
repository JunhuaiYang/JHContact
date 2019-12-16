//
//  PhoneViewController.m
//  JHContactTrue
//
//  Created by junhuai on 2019/12/10.
//  Copyright © 2019 junhuai. All rights reserved.
//

#import <ContactsUI/ContactsUI.h>
#import "PhoneViewController.h"

@interface PhoneViewController () <CNContactPickerDelegate>

@end

@implementation PhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:@"电话" image:[UIImage systemImageNamed:@"phone"] tag:101];
//    self.tabBarItem = tabBarItem;
    UIBarButtonItem *barButtonItemAdd = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(buttonAddPress)];
    self.navigationItem.rightBarButtonItem = barButtonItemAdd;
}

- (void)buttonAddPress {
    CNContactPickerViewController *contactPickerViewController = [[CNContactPickerViewController alloc] init];
    contactPickerViewController.delegate = self;
    [self presentViewController:contactPickerViewController animated:YES completion:nil];
}

// ContactUI 的联系方式
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact {
    // 1. 获取姓名
    NSLog(@"Selected:\n givenName: %@, familyName: %@", contact.givenName, contact.familyName);
    // 2. 获取电话
    int count = 0;
    for (CNLabeledValue *labeledValue in contact.phoneNumbers) {
        CNPhoneNumber *phoneNumber = labeledValue.value;
        NSLog(@"phoneNumber%d: %@",++count, phoneNumber.stringValue);
    }
}

// mark 实现了此方法就可以选择多个联系人
//- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContacts:(NSArray<CNContact *> *)contacts {
//    for (CNContact *contact in contacts) {
//
//        NSLog(@"givenName: %@, familyName: %@", contact.givenName, contact.familyName);
//        for (CNLabeledValue *labeledValue in contact.phoneNumbers) {
//            NSLog(@"label: %@", labeledValue.label);
//            CNPhoneNumber *phoneNumber = labeledValue.value;
//            NSLog(@"phoneNumber: %@", phoneNumber.stringValue);
//        }
//    }
//}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
