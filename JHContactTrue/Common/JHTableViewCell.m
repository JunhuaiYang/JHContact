//
//  JHTableViewCell.m
//  JHContactTrue
//
//  Created by junhuai on 2019/12/13.
//  Copyright © 2019 junhuai. All rights reserved.
//

#import "JHTableViewCell.h"

@interface JHTableViewCell ()
@end

@implementation JHTableViewCell {
    UIImageView *_imageView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// 获取单元格高度
+ (NSInteger)getCellHeight:(JHTableViewCellStyle)style {
    switch (style) {
        case JHTableViewCellStylMain:
            return 60;
        case JHTableViewCellStyleDetail:
            return 80;
    }
    return 0;
}

- (instancetype)initWithMyStyle:(JHTableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.style = style;
        _imageView = [[UIImageView alloc] init];
        self.nameLabel = [[UILabel alloc] init];
        self.nicknameLabel = [[UILabel alloc] init];
        // 加入 cell 中
        [self.contentView addSubview:_imageView];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.nicknameLabel];

        if (style == JHTableViewCellStyleDetail) {
            self.numberLabel = [[UILabel alloc] init];
            [self.contentView addSubview:self.numberLabel];
        }
    }

    return self;
}

// 顺带刷新数据
// 不能在这里新建，否则重用的时候会产生问题
- (void)setModel {
    if (self.personModel != nil) {
        // 先看图片是否为空
        if (self.personModel.smallImage) {
            self.image = self.personModel.smallImage;
        } else {
            self.image = [UIImage systemImageNamed:@"person.circle.fill"];
        }
        switch (self.style) {
            case JHTableViewCellStylMain:
//                self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;  // 加一个箭头
//                self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 100);
                _imageView.image = self.image;
                _imageView.frame = CGRectMake(10, 10, 40, 40);
                // 将头像裁剪成圆形
                _imageView.layer.cornerRadius = _imageView.frame.size.width / 2;  // 设置圆形半径
                _imageView.layer.masksToBounds = YES;  //隐藏裁掉的部分
                // 加一个圆形边框
                _imageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
                _imageView.layer.borderWidth = 1.0f;
                // 可以改变图片颜色
                _imageView.tintColor = [self randomColor];

                // 对姓名标签赋值
                if (self.personModel.fullName != nil) {
                    self.nameLabel.text = self.personModel.fullName;
                    self.nameLabel.frame = CGRectMake(65, 20, 160, 40);
                    self.nameLabel.textColor = [UIColor blackColor];
                    self.nameLabel.font = [UIFont systemFontOfSize:18];
                } else {  // 没有姓名用电话代替
                    if (self.personModel.phones.count)
                        self.nameLabel.text = self.personModel.phones[0].value;
                    else
                        self.nameLabel.text = @"无姓名";
                    self.nameLabel.frame = CGRectMake(65, 20, 160, 40);
                    self.nameLabel.textColor = [UIColor systemGrayColor];
                    self.nameLabel.font = [UIFont systemFontOfSize:16];
                }
                [self.nameLabel sizeToFit];  // 自适应大小
//                NSLog(@"nameLabel:%@   :  %@", _personModel.fullName, self.nameLabel.frame);

                // 看是否有昵称
                if (self.personModel.nickName.length != 0) {
//                    [self.nicknameLabel addConstraint:[NSLayoutConstraint constraintWithItem:self.nameLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.nicknameLabel attribute:NSLayoutAttributeLeft multiplier:1 constant:20]];
                    // 计算布局
                    self.nicknameLabel.frame = CGRectMake( self.nameLabel.frame.origin.x + self.nameLabel.frame.size.width + 15, 20, 160, 40);
                    self.nicknameLabel.text = [NSString stringWithFormat:@"(%@)", self.personModel.nickName];
                    self.nicknameLabel.textColor = [UIColor systemGray2Color];
                    self.nicknameLabel.font = [UIFont systemFontOfSize:18];
                    [self.nicknameLabel sizeToFit];  // 自适应
                } else{
                    self.nicknameLabel.text = @"";  // 防止重用单元格时的问题
                }
                break;

            // 显示号码的格式
            case JHTableViewCellStyleDetail:
                _imageView.image = self.image;
                _imageView.frame = CGRectMake(10, 10, 60, 60);
                // 将头像裁剪成圆形
                _imageView.layer.cornerRadius = _imageView.frame.size.width / 2;  // 设置圆形半径
                _imageView.layer.masksToBounds = YES;  //隐藏裁掉的部分
                // 加一个圆形边框
                _imageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
                _imageView.layer.borderWidth = 1.0f;
                // 可以改变图片颜色
                _imageView.tintColor = [UIColor grayColor];

                // 对姓名标签赋值
                if (self.personModel.fullName != nil) {
                    self.nameLabel.text = self.personModel.fullName;
                    self.nameLabel.frame = CGRectMake(80, 10, 160, 40);
                    self.nameLabel.textColor = [UIColor blackColor];
                    self.nameLabel.font = [UIFont systemFontOfSize:16];
                }

                // 手机号副标题
                if (self.personModel.phones.count){
                    self.numberLabel.text = [NSString stringWithFormat:@"%4@%@",self.personModel.phones[0].type, self.personModel.phones[0].value];
                    self.numberLabel.frame = CGRectMake(10, 40, 200, 30);
                    self.numberLabel.textColor = [UIColor grayColor];
                    self.numberLabel.font = [UIFont systemFontOfSize:14];
                } else{
                    self.numberLabel.text = @"";
                }

                break;

            default:
                break;

        }
    }

}

- (void)setPersonModel:(JHPersonModel *)personModel {
    _personModel = personModel;
    [self setModel];
}

///  随机选择颜色  根据号码尾数
/// @return 颜色
- (UIColor *)randomColor {
    NSArray<UIColor *> *color = @[[UIColor redColor], [UIColor blueColor], [UIColor magentaColor],
            [UIColor purpleColor], [UIColor grayColor], [UIColor orangeColor], [UIColor brownColor], [UIColor cyanColor]];
    int count = 0;
    if (_personModel.phones.count) {
        NSString *temp = [_personModel.phones[0].value substringFromIndex:_personModel.phones[0].value.length - 3];
        count = [temp intValue];
    }
    return color[count % color.count];
}


@end
