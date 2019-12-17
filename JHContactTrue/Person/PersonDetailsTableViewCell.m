//
//  PersonDetailsTableViewCell.m
//  JHContactTrue
//
//  Created by junhuai on 2019/12/16.
//  Copyright © 2019 junhuai. All rights reserved.
//

#import "PersonDetailsTableViewCell.h"

@interface PersonDetailsTableViewCell ()
@property (nonatomic, strong) UIImage *image;
//@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *givenNameLabel;
@property (nonatomic, strong) UILabel *familyNameLabel;
@property (nonatomic, strong) UILabel *nicknameLabel;
@property (nonatomic, strong) UILabel *birthdayLabel;
@end

@implementation PersonDetailsTableViewCell{
    CGFloat _baseY ;
    CGFloat _oneHeight;
    NSInteger _count;
    UIImageView * _imageView;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        // 必须把初始化放在初始化里
        _imageView = [[UIImageView alloc] init];
        self.nameLabel = [[UILabel alloc] init];
        self.nicknameLabel = [[UILabel alloc] init];
        self.birthdayLabel = [[UILabel alloc] init];
        self.givenNameLabel = [[UILabel alloc] init];
        self.familyNameLabel = [[UILabel alloc] init];
        self.birthdayLabel = [[UILabel alloc] init];
        // 加入
        [self.contentView addSubview:_imageView];
        [self.contentView addSubview:self.nicknameLabel];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.givenNameLabel];
        [self.contentView addSubview:self.familyNameLabel];
        [self.contentView addSubview:self.birthdayLabel];
    }

    return self;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setPersonModel:(JHPersonModel *)personModel {
    _personModel = personModel;
    // 先布局头像
    // 先看图片是否为空
    if (self.personModel.smallImage) {
        self.image = self.personModel.smallImage;
    } else {
        self.image = [UIImage systemImageNamed:@"person.circle.fill"];
    }
    _imageView.image = self.image;
    _imageView.frame = CGRectMake(20, 25, 100, 100);
    _imageView.layer.cornerRadius = _imageView.frame.size.width / 2;  // 设置圆形半径
    _imageView.layer.masksToBounds = YES;  //隐藏裁掉的部分
    _imageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _imageView.layer.borderWidth = 1.0f;
    _imageView.tintColor = [UIColor grayColor];  // 颜色设置为灰色

    // 布局姓名
    self.nameLabel.frame = CGRectMake(150, 20, 150, 30);
    self.nameLabel.text = self.personModel.fullName;
    self.nameLabel.textColor = [UIColor blackColor];
    self.nameLabel.font = [UIFont systemFontOfSize:20];

    _baseY = self.nameLabel.frame.origin.y + self.nameLabel.frame.size.height;
    _oneHeight = 25;
    _count = 0;
    // 布局姓和名
    self.familyNameLabel.frame = CGRectMake(150, _baseY + _oneHeight*(_count++), 150, 20);
    self.familyNameLabel.text = [NSString stringWithFormat:@"姓：%@", self.personModel.familyName];
    self.familyNameLabel.textColor = [UIColor darkGrayColor];
    self.familyNameLabel.font = [UIFont systemFontOfSize:14];

    self.givenNameLabel.frame = CGRectMake(150, _baseY + _oneHeight*(_count++), 150, 20);
    self.givenNameLabel.text = [NSString stringWithFormat:@"名：%@", self.personModel.givenName];
    self.givenNameLabel.textColor = [UIColor darkGrayColor];
    self.givenNameLabel.font = [UIFont systemFontOfSize:14];

    // 昵称
    if (self.personModel.nickName.length != 0){
        self.nicknameLabel.hidden = NO;
        self.nicknameLabel.frame = CGRectMake(150, _baseY + _oneHeight*(_count++), 250, 20);
        self.nicknameLabel.text = [NSString stringWithFormat:@"昵称：%@", self.personModel.givenName];
        self.nicknameLabel.textColor = [UIColor darkGrayColor];
        self.nicknameLabel.font = [UIFont systemFontOfSize:14];
    } else{
        self.nicknameLabel.hidden = YES;
    }

    // 生日
    if (self.personModel.birthday != nil){
        self.birthdayLabel.hidden = NO;
        self.birthdayLabel.frame = CGRectMake(150, _baseY + _oneHeight*(_count++), 250, 20);
        self.birthdayLabel.text = [NSString stringWithFormat:@"生日：%@",
                [NSDateFormatter localizedStringFromDate:self.personModel.birthday dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterNoStyle]];
        self.birthdayLabel.textColor = [UIColor darkGrayColor];
        self.birthdayLabel.font = [UIFont systemFontOfSize:14];
    } else{
        self.birthdayLabel.hidden = YES;
    }
}

- (CGFloat)height{
    return MAX((_baseY+_oneHeight*_count+15), 150.0) ;
}

@end
