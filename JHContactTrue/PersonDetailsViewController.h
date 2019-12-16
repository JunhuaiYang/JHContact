//
//  PersonDetailsViewController.h
//  JHContactTrue
//
//  Created by junhuai on 2019/12/10.
//  Copyright © 2019 junhuai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JHPersonModel;
NS_ASSUME_NONNULL_BEGIN

@interface PersonDetailsViewController : UITableViewController

@property (nonatomic, strong) JHPersonModel *personModel;

@end

NS_ASSUME_NONNULL_END
