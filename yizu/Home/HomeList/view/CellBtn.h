//
//  CellBtn.h
//  yizu
//
//  Created by myMac on 2017/10/30.
//  Copyright © 2017年 XuJian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LikeBtnViewDelegate <NSObject>

-(void)ClickLikeBtn:(BOOL)start;

@end

@interface CellBtn : UIButton

@property (nonatomic) BOOL islike;                  //当前状态

@property (nonatomic,copy) NSString *requestID;     //点赞请求ID

@property (nonatomic) NSInteger  likeCount;         //设置赞数

@property (nonatomic,copy)NSString* chambername;    //保存店铺名字

@property (nonatomic,copy)NSString* userId;         //保存用户id

@property (nonatomic,copy) void (^onClick)(CellBtn *btn);


@property (nonatomic,copy) id<LikeBtnViewDelegate> delegate;

+ (instancetype)likeCountViewWithCount:(NSInteger)count requestID:(NSString *)ID;

@end
