//
//  MyCollectionTableViewCell.m
//  yizu
//
//  Created by 徐健 on 17/10/23.
//  Copyright © 2017年 XuJian. All rights reserved.
//

#import "MyCollectionTableViewCell.h"
@interface MyCollectionTableViewCell()
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIView * lineview;
@property (nonatomic, strong) MyCollectionModel *cellmyCollectionModel;
@end

@implementation MyCollectionTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.clipsToBounds=YES;
        imageView.layer.cornerRadius=(135/2-20)/2;
        [self.contentView addSubview:imageView];
        self.iconImageView = imageView;
        
        UILabel *nameLabel = [[UILabel alloc] init];
        [self.contentView addSubview:nameLabel];
        self.nameLabel = nameLabel;
        
        UILabel *addressLabel = [[UILabel alloc] init];
        addressLabel.textColor = kLightGrayTextColor;
        addressLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:addressLabel];
        self.addressLabel = addressLabel;
        
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.textColor = kLightGrayTextColor;
        timeLabel.textAlignment = NSTextAlignmentRight;
        timeLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:timeLabel];
        self.timeLabel = timeLabel;
        
        UILabel *lineview = [[UILabel alloc] init];
        lineview.backgroundColor = kColorLine;
        [self.contentView addSubview:lineview];
        self.lineview = lineview;
    }
    return self;
}

-(void)initWithMyCollectionModel:(MyCollectionModel *)cellmyCollectionModel;
{
    self.cellmyCollectionModel = cellmyCollectionModel;
    [self createData];
    [self createFrame];
}
- (void)createData
{
    self.nameLabel.text = self.cellmyCollectionModel.nameStr;
    self.iconImageView.image = [UIImage imageNamed:self.cellmyCollectionModel.iconImage];
    self.addressLabel.text = self.cellmyCollectionModel.addressStr;
    self.timeLabel.text = self.cellmyCollectionModel.timeStr;

}
- (void)createFrame
{
    self.iconImageView.frame = CGRectMake(10, 10, 135/2-20, 135/2-20);
    self.nameLabel.frame = CGRectMake(self.iconImageView.x+self.iconImageView.width+10, 10, kSCREEN_WIDTH/2, (135/2-20)/2);
    self.addressLabel.frame = CGRectMake(self.iconImageView.x+self.iconImageView.width+10, self.nameLabel.y+self.nameLabel.height, kSCREEN_WIDTH-self.iconImageView.x+self.iconImageView.width, (135/2-20)/2);
    self.timeLabel.frame = CGRectMake(kSCREEN_WIDTH/2, 10, kSCREEN_WIDTH/2-10, (135/2-20)/2);
//    self.lineview.frame = CGRectMake(0, 135/2, kSCREEN_WIDTH, 0.5);

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
