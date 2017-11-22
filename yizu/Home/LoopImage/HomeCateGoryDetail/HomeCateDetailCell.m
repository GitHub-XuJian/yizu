//
//  HomeCateDetailCell.m
//  yizu
//
//  Created by myMac on 2017/11/21.
//  Copyright © 2017年 XuJian. All rights reserved.
//

#import "HomeCateDetailCell.h"
#import "HomeListModel.h"


@interface HomeCateDetailCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconIma;
@property (weak, nonatomic) IBOutlet UIImageView *ima1;

@property (weak, nonatomic) IBOutlet UIImageView *ima2;

@property (weak, nonatomic) IBOutlet UIImageView *ima3;
@property (weak, nonatomic) IBOutlet UILabel *iconTitle;
@property (weak, nonatomic) IBOutlet UILabel *chamberjjLabel;
//yishou
@property (weak, nonatomic) IBOutlet UILabel *upLabel;
@property (weak, nonatomic) IBOutlet UILabel *rankingLab;
@property (weak, nonatomic) IBOutlet UILabel *distanceLab;


@end


@implementation HomeCateDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
}

-(void)setModel:(HomeListModel *)model
{
    _model=model;
    
    self.iconTitle.text=model.chambername;
    [self.ima1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@Public/%@",Main_ServerImage,model.image1]]];
    [self.ima2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@Public/%@",Main_ServerImage,model.image2]]];
    [self.ima3 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@Public/%@",Main_ServerImage,model.image3]]];
    
    //设置圆角
    self.iconIma.layer.cornerRadius = 8;
    //将多余的部分切掉
    self.iconIma.layer.masksToBounds = YES;
    [self.iconIma sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@Public/%@",Main_ServerImage,model.icon]]];
    
    
    self.upLabel.text=[NSString stringWithFormat:@"已售:%@",model.obtained];
    //一行时lab字体顶对齐
    //self.chamberjjLab.text=model.chamberjj;
    
    self.rankingLab .text=[NSString stringWithFormat:@"| 排名：%@",model.up];
    
    self.distanceLab.text=[NSString stringWithFormat:@"%@m",model.distance];

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
