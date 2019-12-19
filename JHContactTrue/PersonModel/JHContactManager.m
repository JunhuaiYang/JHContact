//
// Created by junhuai on 2019/12/11.
// Copyright (c) 2019 junhuai. All rights reserved.
//

#import "JHContactManager.h"
#import <ContactsUI/ContactsUI.h>

NSString * const JHPersonsDidChangeNotification = @"JHPersonsDidChangeNotification";

@implementation JHContactManager {
    CNContactStore *_store;
    NSMutableArray<JHPersonModel * > *_mutablePersons;
}

/**
 * 获取关键字
 * @return
 */
- (NSArray *)fetchKeys {
    if (!_fetchKeys) {
        _fetchKeys = @[[CNContactFormatter descriptorForRequiredKeysForStyle:CNContactFormatterStyleFullName],   // 这个可以自动生成姓名格式
                CNContactGivenNameKey, CNContactFamilyNameKey, CNContactNicknameKey, CNContactPhoneNumbersKey,
                CNContactEmailAddressesKey, CNContactBirthdayKey, CNContactImageDataKey, CNContactThumbnailImageDataKey,
                CNContactViewController.descriptorForRequiredKeys];  // 这个用于进入系统编辑页面
    }
    return _fetchKeys;
}


- (instancetype)init {
    self = [super init];
    if (self) {
        _store = [[CNContactStore alloc] init];
        _mutablePersons = [[NSMutableArray alloc] init];
        // 在通知中心注册
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getAllPerson) name:CNContactStoreDidChangeNotification object:nil];

    }

    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CNContactStoreDidChangeNotification object:nil];
}


// 单例模式
+ (instancetype)sharedInstance {
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

// 请求授权
- (void)requestContactAuthorization:(void (^)(void))completion {
    // 获得授权状态
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    // 如果是未授权，则请求授权  这里是并行的，回调
    if (status == CNAuthorizationStatusNotDetermined) {
//        NSLog(@"in");
        [_store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError *error) {
            if (granted) {
                NSLog(@"授权成功");
                completion();  // 回调刷新
//                NSLog(@"回调时 %@", [NSThread currentThread]);
            } else
                NSLog(@"授权失败");
//            result = granted;
            self.authorized = granted;
        }];
    }
}

// 看是否已授权
- (BOOL)isAuthorized {
    return [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusAuthorized ? YES : NO;
}

// 获得所有联系人
- (void)getAllPerson {
    // 先确定要请求的 keys
    // 创建请求对象
    CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:self.fetchKeys];
    // 应该移除所有子数组
    [_mutablePersons removeAllObjects];
    // 请求
    NSError *error = nil;
    [_store enumerateContactsWithFetchRequest:request error:&error usingBlock:^(CNContact *contact, BOOL *stop) {
        // stop是决定是否要停止
        JHPersonModel *personModel = [JHPersonModel modelWithContact:contact];
        [_mutablePersons addObject:personModel];
    }];
    if (error == nil){
        NSLog(@"成功更新联系人");
        // 在通知中心注册改变
        _persons = [_mutablePersons copy];
        [[NSNotificationCenter defaultCenter] postNotificationName:JHPersonsDidChangeNotification object:nil]; // 慢慢通知
    }
//    NSLog(@"%@", error);
}

- (NSArray<JHPersonModel *> *)persons {
    // 未获授权时
//    if (![self isAuthorized])
//    {
//        if (![self requestContactAuthorization]){
//            NSLog(@"获取授权失败！");
//            return nil;
//        }
//    }
    // 改成直接从本地获取
    if (_persons.count == 0){
        [self getAllPerson];
    }
    // 返回不可改变的对象
    return _persons;
}


@end