//
//  EncapsulationMethod.m
//  MagicFigure
//
//  Created by 徐健 on 16/12/28.
//  Copyright © 2016年 XuJian. All rights reserved.
//

#import "EncapsulationMethod.h"
#import <objc/runtime.h>

@interface EncapsulationMethod ()


@end
@implementation EncapsulationMethod


+(EncapsulationMethod *)sharedManager{
    static dispatch_once_t predicate;
    static EncapsulationMethod * sharedManager;
    dispatch_once(&predicate, ^{
        sharedManager=[[EncapsulationMethod alloc] init];
    });
    return sharedManager;
}
+ (BOOL)JudgeTheillegalCharacter:(NSString *)content{
    
    NSString *str =@"^[A-Za-z0-9\\u4e00-\u9fa5]+$";
    
    NSPredicate* emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", str];
    
    if (![emailTest evaluateWithObject:content]) {
        
        return YES;
        
    }
    
    return NO;
    
}
// View转image
- (UIImage*) imageWithUIView:(UIView*) view
{
    UIGraphicsBeginImageContext(view.bounds.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:ctx];
    UIImage* tImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return tImage;
}
// 合成两个image
- (UIImage *)syntheticWithimageOne:(UIImage *)image1 andImageTwo:(UIImage *)image2
{
    CGSize size = CGSizeMake(70, 70);
    UIGraphicsBeginImageContext(size);
    [image1 drawInRect:CGRectMake(5, 5, 40, 40)];
    [image2 drawInRect:CGRectMake(25, 25, 40, 40)];
    UIImage *togetherImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return togetherImage;
}
// 根据字符内容计算宽度
+ (CGFloat)calculateRowWidth:(NSString *)string andFont:(NSInteger)size andHight:(CGFloat)hight{
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:size]};  //指定字号
    CGRect rect = [string boundingRectWithSize:CGSizeMake(0, hight)/*计算宽度时要确定高度*/ options:NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return rect.size.width;
}
// 根据字符内容计算高度
+ (CGFloat)calculateRowHeight:(NSString *)textStr andTexFont:(NSInteger )size andMaxWidth:(CGFloat)width
{
    NSDictionary *textAttDict = @{NSFontAttributeName : [UIFont systemFontOfSize:size]};
    CGRect rect = [textStr boundingRectWithSize:CGSizeMake(width, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:textAttDict context:nil];
    return rect.size.height;

}
/*!
 * @brief 把对象（Model）转换成字典
 * @param model 模型对象
 * @return 返回字典
 */
+ (NSDictionary *)dictionaryWithModel:(id)model {
    if (model == nil) {
        return nil;
    }
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    // 获取类名/根据类名获取类对象
    NSString *className = NSStringFromClass([model class]);
    id classObject = objc_getClass([className UTF8String]);
    
    // 获取所有属性
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList(classObject, &count);
    
    // 遍历所有属性
    for (int i = 0; i < count; i++) {
        // 取得属性
        objc_property_t property = properties[i];
        // 取得属性名
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property)
                                                          encoding:NSUTF8StringEncoding];
        // 取得属性值
        id propertyValue = nil;
        id valueObject = [model valueForKey:propertyName];
        
        if ([valueObject isKindOfClass:[NSDictionary class]]) {
            propertyValue = [NSDictionary dictionaryWithDictionary:valueObject];
        } else if ([valueObject isKindOfClass:[NSArray class]]) {
            NSMutableArray *twoArray = [NSMutableArray array];
            [valueObject enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *twoDict = [self dictionaryWithModel:obj];
                [twoArray addObject:twoDict];
            }];
            propertyValue = twoArray;
        } else {
            NSString *valueStr = [model valueForKey:propertyName];
            if (valueStr == nil) {
                valueStr = @"";
            }
            
            propertyValue = [NSString stringWithFormat:@"%@", valueStr];
        }
        
        [dict setObject:propertyValue forKey:propertyName];
    }
    return [dict copy];
}
+ (NSString *)arrayToJSONString:(NSArray *)array
{
    NSError *error = nil;
    //    NSMutableArray *muArray = [NSMutableArray array];
    //    for (NSString *userId in array) {
    //        [muArray addObject:[NSString stringWithFormat:@"\"%@\"", userId]];
    //    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    //    NSString *jsonTemp = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    //    NSString *jsonResult = [jsonTemp stringByReplacingOccurrencesOfString:@" " withString:@""];
    //    NSLog(@"json array is: %@", jsonResult);
    return jsonString;
}
// 将JSON串转化为字典或者数组
+ (id)toArrayOrNSDictionary:(NSString *)jsonStr{
    
    NSData *nsData=[jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:nsData
                                                    options:NSJSONReadingAllowFragments
                                                      error:nil];
    
    if (jsonObject != nil && error == nil){
        return jsonObject;
    }else{
        // 解析错误
        return nil;
    }
    
}
+(NSString*)changeTelephone:(NSString*)teleStr{
    
    NSRange range = [teleStr rangeOfString:@"@"];
    NSMutableString* string=[[NSMutableString alloc]initWithString:teleStr];//存在堆区，可变字符串
    [string insertString:@"***"atIndex:range.length];
    NSLog(@"string:%@",string);
    return string;
    
}
+(NSDictionary *)getObjectData:(id)obj {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    unsigned int propsCount;
    objc_property_t *props = class_copyPropertyList([obj class], &propsCount);
    for(int i = 0;i < propsCount; i++){
        objc_property_t prop = props[i];
        
        NSString *propName = [NSString stringWithUTF8String:property_getName(prop)];
        id value = [obj valueForKey:propName];
        if(value == nil){
            value = [NSNull null];
        }else{
            value = [self getObjectInternal:value];
        }
        [dic setObject:value forKey:propName];
    }
    return dic;
}
+(id)getObjectInternal:(id)obj
{
    if([obj
        isKindOfClass:[NSString class]]
       
       ||
       [obj isKindOfClass:[NSNumber class]]
       
       ||
       [obj isKindOfClass:[NSNull class]])
        
    {
        
        return
        
        obj;
        
    }
    
    
    
    if([obj
        isKindOfClass:[NSArray class]])
        
    {
        
        NSArray
        *objarr = obj;
        
        NSMutableArray
        *arr = [NSMutableArray arrayWithCapacity:objarr.count];
        
        for(int
            i = 0;i < objarr.count; i++)
            
        {
            
            [arr
             setObject:[self getObjectInternal:[objarr objectAtIndex:i]] atIndexedSubscript:i];
            
        }
        
        return
        
        arr;
        
    }
    
    
    
    if([obj
        isKindOfClass:[NSDictionary class]])
        
    {
        
        NSDictionary
        *objdic = obj;
        
        NSMutableDictionary
        *dic = [NSMutableDictionary dictionaryWithCapacity:[objdic count]];
        
        for(NSString
            *key in
            
            objdic.allKeys)
            
        {
            
            [dic
             setObject:[self getObjectInternal:[objdic objectForKey:key]] forKey:key];
            
        }     
        
        return
        
        dic;
        
    } 
    
    return
    
    [self getObjectData:obj];
    
}
+(NSDate *)dateWithString:(NSString *)str
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:str];
    return date;
}
+(NSString *)stringWithDate:(NSDate *)date
{
    NSLog(@"%@",date);//2015-11-20 00:37:40 +0000
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];//创建一个日期格式化器
    
    //    dateFormatter.dateFormat=@"yyyy-MM-dd hh:mm:ss";//指定转date得日期格式化形式
    //
    //    NSLog(@"%@",[dateFormatter stringFromDate:date]);//2015-11-20 08:24:04
    
    dateFormatter.dateFormat=@"yyyy-MM-dd";
    
    NSLog(@"%@",[dateFormatter stringFromDate:date]);//2015-11-20
    
    //    dateFormatter.dateFormat=@"yyyy-MM-dd eeee aa HH:mm:ss";
    //
    //    NSLog(@"%@",[dateFormatter stringFromDate:date]);//2015-11-20 Friday AM 08:30:28
    //
    //    dateFormatter.dateFormat=@"yyyy-MM-dd hh:mm:ss z";
    //
    //    NSLog(@"%@",[dateFormatter stringFromDate:date]);//2015-11-20 08:42:22 GMT+8
    //
    return [dateFormatter stringFromDate:date];
}


/**
 * 一个时间距现在的时间,返回天数
 */
+ (NSString *)intervalSinceNow: (NSString *) theDate
{

    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    //根据updateTime的格式，写出对应的日期格式化串
    [format setDateFormat:@"YYYY-MM-dd HH:mm"];
    [format setLocale:[NSLocale currentLocale]];
    NSDate *currentDate = [format dateFromString:theDate];
    
    //获取当前的系统时间
    NSDate *date = [NSDate date];
    //消除8小时的误差。
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    
    //追加8小时
    NSDate *localeDate = [date dateByAddingTimeInterval: interval];
    currentDate = [currentDate dateByAddingTimeInterval:interval];
    //计算时间差间隔
    NSTimeInterval timeBetween = [localeDate timeIntervalSinceDate:currentDate];
    NSInteger numberDays = timeBetween/(24 * 3600);
    
    return [NSString stringWithFormat:@"%ld",(long)numberDays];
}
//获取当前的时间
+(NSString*)getCurrentTimes{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    //现在时间,你可以输出来看下是什么格式
    
    NSDate *datenow = [NSDate date];
    
    //----------将nsdate按formatter格式转成nsstring
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    NSLog(@"currentTimeString =  %@",currentTimeString);
    
    return currentTimeString;
    
}
/**
 * 开始到结束的时间差
 */
+ (NSString *)dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime{
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *startD =[date dateFromString:startTime];
    NSDate *endD = [date dateFromString:endTime];
    NSTimeInterval start = [startD timeIntervalSince1970]*1;
    NSTimeInterval end = [endD timeIntervalSince1970]*1;
    NSTimeInterval value = end - start;
    int second = (int)value %60;//秒
    int minute = (int)value /60%60;
    int house = (int)value / (24 * 3600)%3600;
    int day = (int)value / (24 * 3600);
    NSString *str;
    if (day != 0) {
        str = [NSString stringWithFormat:@"耗时%d天%d小时%d分%d秒",day,house,minute,second];
    }else if (day==0 && house != 0) {
        str = [NSString stringWithFormat:@"耗时%d小时%d分%d秒",house,minute,second];
    }else if (day== 0 && house== 0 && minute!=0) {
        str = [NSString stringWithFormat:@"耗时%d分%d秒",minute,second];
    }else{
        str = [NSString stringWithFormat:@"耗时%d秒",second];
    }
    return str;
}
-(int)getRandomNumber:(int)from to:(int)to
{
    return (int)(from + (arc4random() % (to - from + 1)));
}

//邮箱地址的正则表达式
+ (BOOL)isValidateEmail:(NSString *)email{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
@end