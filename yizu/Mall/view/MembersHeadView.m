//
//  MembersHeadView.m
//  yizu
//
//  Created by 徐健 on 2017/11/10.
//  Copyright © 2017年 XuJian. All rights reserved.
//

#import "MembersHeadView.h"
@interface MembersHeadView ()
@property (nonatomic, strong) UIButton *iconBtn;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *introductionLabel;
@property (nonatomic, strong) UIImageView *crownImageView;
@end
@implementation MembersHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self createUIView];
    }
    return self;
}
- (void)createUIView
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(57/3, self.height/2-164/2/2, 164/2,164/2);
    [button addTarget:self action:@selector(headPortraitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    button.clipsToBounds=YES;
    button.layer.cornerRadius=164/2/2;
    //边框宽度
    [button.layer setBorderWidth:0.5];
    button.layer.borderColor=[UIColor whiteColor].CGColor;
    [self addSubview:button];
    self.iconBtn = button;
    
    UIImageView *crownImageView = [[UIImageView alloc] init];
    crownImageView.frame = CGRectMake(button.x+button.width-20, button.y+button.height-20, 20, 20);
    [crownImageView setImage:[UIImage imageNamed:@"UNcrown"]];
    [self addSubview:crownImageView];
    self.crownImageView = crownImageView;
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.frame = CGRectMake(button.x+button.width+10, button.y, kSCREEN_WIDTH-button.x-button.width-10, button.height/2);
    nameLabel.text = @"我的昵称";
    nameLabel.font = kCommonWithFont(20);
    nameLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    UILabel *introductionLabel = [[UILabel alloc] init];
    introductionLabel.frame =CGRectMake(button.x+button.width+10, nameLabel.y+nameLabel.height, kSCREEN_WIDTH-button.x-button.width-10, button.height/2);
    introductionLabel.text = @"您还不是会员/会员截止日期 2017-12-24";
    introductionLabel.font = kFontOther;
    introductionLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:introductionLabel];
    self.introductionLabel = introductionLabel;
}
- (void)reloadData
{
    [self.iconBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@public/%@",Main_ServerImage,[XSaverTool objectForKey:UserIconImage]]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"iconRegistered"]];
    if ([[XSaverTool objectForKey:Nickname] length]) {
        self.nameLabel.text = [XSaverTool objectForKey:Nickname];
    }else{
        self.nameLabel.text = @"我的昵称";
    }
    NSString *statevipStr = [XSaverTool objectForKey:Statevip];
    if ([statevipStr isEqualToString:@"1"]) {
        NSString *timeStr = [XSaverTool objectForKey:VipEndtime];
        NSDate *currentDate = [NSDate dateWithTimeIntervalSince1970:[timeStr doubleValue]];
        //用于格式化NSDate对象
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //设置格式：zzz表示时区
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        //NSDate转NSString
        NSString *currentDateString = [dateFormatter stringFromDate:currentDate];
        
        self.introductionLabel.text = [NSString stringWithFormat:@"会员截止日期:%@",currentDateString];
        self.crownImageView.image = [UIImage imageNamed:@"crown"];
    }else{
        self.introductionLabel.text = @"您还不是会员";
        self.crownImageView.image = [UIImage imageNamed:@"UNcrown"];
    }
}
- (void)headPortraitBtnClick:(UIButton *)btn
{
    
}
@end
