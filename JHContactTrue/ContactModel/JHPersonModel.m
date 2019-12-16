//
// Created by junhuai on 2019/12/11.
// Copyright (c) 2019 junhuai. All rights reserved.
//

#import "JHPersonModel.h"


@implementation JHPersonModel {

}
- (instancetype)initWithFullName:(NSString *)fullName {
    self = [super init];
    if (self) {
        self.fullName = fullName;
    }

    return self;
}

+ (instancetype)modelWithFullName:(NSString *)fullName {
    return [[self alloc] initWithFullName:fullName];
}

/**
 * 通过 contact 来初始化
 * @param contact
 * @return
 */
- (instancetype) initWithContact:(CNContact *)contact{
    self = [super init];
    if (self){
        // 获取姓名
        self.fullName = [CNContactFormatter stringFromContact:contact style:CNContactFormatterStyleFullName];  // 自动格式化名字
        self.givenName = contact.givenName;
        self.familyName = contact.familyName;
        self.nickName = contact.nickname;

//        NSLog(@"%@ : %@ : %@", self.fullName, self.givenName, self.familyName);

        // 获取电话号码
        NSArray *phones = contact.phoneNumbers;
        NSMutableArray *phonesValue = [[NSMutableArray alloc] init];
        for (CNLabeledValue *labelValue in phones) {
            CNPhoneNumber *phoneNumber = labelValue.value;
//            NSLog(@"%@ %@ ", phoneNumber.stringValue, labelValue.label);
            JHValue *value = [JHValue valueWithValue:phoneNumber.stringValue type:[self getTypes:labelValue.label]];
            [phonesValue addObject:value];
        }
        // 加入到里面
        self.phones = [phonesValue copy];  // copy 使其不可拷贝化

        // 获取邮件
        NSArray *email = contact.emailAddresses;
        NSMutableArray *emailValue = [[NSMutableArray alloc] init];
        for (CNLabeledValue *labelValue in email) {
//            NSLog(@"%@ %@ ", labelValue.value, labelValue.label);
            JHValue *value = [JHValue valueWithValue:labelValue.value type:labelValue.label];
            [emailValue addObject:value];
        }
        self.emails = [emailValue copy];

        // 图片
        if (contact.imageData){
            self.image = [UIImage imageWithData:contact.imageData];
//            NSLog(@"有图  %@", self.fullName);
        }

        if (contact.imageData) {
            self.smallImage = [UIImage imageWithData:contact.thumbnailImageData];
//            NSLog(@"小图  %@", self.fullName);
        }

    }
    return self;
}

+ (instancetype)modelWithContact:(CNContact *)contact {
    return [[self alloc] initWithContact:contact];
}

/// 标签转换
/// @param label
/// @return
-(NSString *) getTypes:(NSString *) label{
    if ([label isEqualToString:CNLabelPhoneNumberMobile])
        return [NSString stringWithFormat:@"手机"];
    else if ([label isEqualToString:CNLabelPhoneNumberMain])
        return [NSString stringWithFormat:@"主号码"];
    else if ([label isEqualToString:CNLabelHome])
        return [NSString stringWithFormat:@"家"];
    else if ([label isEqualToString:CNLabelWork])
        return [NSString stringWithFormat:@"公司"];
    else if ([label isEqualToString:CNLabelSchool])
        return [NSString stringWithFormat:@"学校"];
    else if ([label isEqualToString:CNLabelPhoneNumberiPhone])
        return [NSString stringWithFormat:@"iPhone"];
    else if ([label isEqualToString:CNLabelPhoneNumberHomeFax])
        return [NSString stringWithFormat:@"家用传真"];
    else if ([label isEqualToString:CNLabelPhoneNumberWorkFax])
        return [NSString stringWithFormat:@"工作传真"];
    else
        return [NSString stringWithFormat:@"其他"];
}

@end


///  JHValue
@implementation JHValue{

}

- (instancetype)initWithValue:(NSString *)value type:(NSString *)type {
    self = [super init];
    if (self) {
        self.value = value;
        self.type = type;
    }

    return self;
}

+ (instancetype)valueWithValue:(NSString *)value type:(NSString *)type {
    return [[self alloc] initWithValue:value type:type];
}

@end