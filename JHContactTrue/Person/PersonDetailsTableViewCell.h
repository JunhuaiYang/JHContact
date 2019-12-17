//
//  PersonDetailsTableViewCell.h
//  JHContactTrue
//
//  Created by junhuai on 2019/12/16.
//  Copyright © 2019 junhuai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHPersonModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PersonDetailsTableViewCell : UITableViewCell

@property (nonatomic, strong) JHPersonModel *personModel;

- (CGFloat)height;
@end

NS_ASSUME_NONNULL_END
