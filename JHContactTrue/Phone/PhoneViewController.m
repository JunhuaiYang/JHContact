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



@end
