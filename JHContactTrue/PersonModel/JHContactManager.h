//
// Created by junhuai on 2019/12/11.
// Copyright (c) 2019 junhuai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Contacts/Contacts.h>
#import "JHPersonModel.h"

CONTACTS_EXTERN NSString * const JHPersonsDidChangeNotification;

@interface JHContactManager : NSObject
@property(atomic, assign) BOOL authorized;
@property (nonatomic, strong) NSArray<JHPersonModel *> *persons;
@property(nonatomic, copy) NSArray *fetchKeys;

+ (instancetype)sharedInstance;

- (void)requestContactAuthorization:(void (^)(void))completion;

//-(BOOL) requestContactAuthorization;
-(BOOL) isAuthorized;
//- (NSArray<JHPersonModel *> *)persons;
@end