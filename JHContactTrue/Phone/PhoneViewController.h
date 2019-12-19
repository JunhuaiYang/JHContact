//
//  PhoneViewController.h
//  JHContactTrue
//
//  Created by junhuai on 2019/12/10.
//  Copyright © 2019 junhuai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PhoneViewController : UITableViewController
@property(nonatomic, strong) NSArray *persons;
@property(nonatomic, assign) NSInteger index;
@end

NS_ASSUME_NONNULL_END
