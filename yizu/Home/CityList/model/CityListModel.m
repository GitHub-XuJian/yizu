//
//  CityListModel.m
//  yizu
//
//  Created by myMac on 2017/10/26.
//  Copyright © 2017年 XuJian. All rights reserved.
//

#import "CityListModel.h"

@implementation CityListModel


+(instancetype)ModelWithDict:(NSDictionary *)dic
{
    
    CityListModel* model=[self new];
    
    model.cityId=dic[@"id"];
    model.name=dic[@"name"];
    //[model setValuesForKeysWithDictionary:dic];
    
    return model;
    
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{}

+(void)CityListWithUrl:(NSString *)url success:(void (^)(NSArray *))sBlock error:(void (^)())eBlock
{
    [XAFNetWork GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        //NSLog(@"city==%@",responseObject);
        NSMutableArray* mArr=[NSMutableArray array];
        [responseObject enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CityListModel* model=[self ModelWithDict:obj];
            [mArr addObject:model];
        }];
        if (sBlock) {
            sBlock(mArr.copy);
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        if (eBlock) {
            eBlock();
        }
    }];
}
@end