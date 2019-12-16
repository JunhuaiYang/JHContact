//
// Created by junhuai on 2019/12/11.
// Copyright (c) 2019 junhuai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Contacts/Contacts.h>
#import "JHPersonModel.h"

@interface JHContactManager : NSObject
@property(atomic, assign) BOOL authorized;
+ (instancetype)sharedInstance;

- (void)requestContactAuthorization:(void (^)(void))completion;

//-(BOOL) requestContactAuthorization;
-(BOOL) isAuthorized;
- (NSArray<JHPersonModel *> *)getPersons;
@end