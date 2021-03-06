//
//  HomAreaBtnController.m
//  yizu
//
//  Created by myMac on 2017/10/27.
//  Copyright © 2017年 XuJian. All rights reserved.
//

#import "HomAreaBtnController.h"
#import "AreaListModel.h"
@interface HomAreaBtnController ()

@property(nonatomic,strong)NSMutableArray* arr;

@property(nonatomic,assign)int areaPage;

@end

@implementation HomAreaBtnController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.areaPage=1;
    
    self.navigationItem.title=@"选择区域";
    UIButton* btn=[UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(cancle) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.view.backgroundColor=[UIColor whiteColor];
    self.arr=[[NSMutableArray alloc]init];
    

    NSString* url=[NSString stringWithFormat:@"%@Mobile/Index/index_district/data/%@",Main_Server,self.cityId];
    NSLog(@"区域看不见===%@",url);
  
    
        [XAFNetWork GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
          
            for (NSDictionary* dic in responseObject) {
                AreaListModel* model=[[AreaListModel alloc]init];
                model.name=dic[@"name"];
                model.areaId=dic[@"id"];
                [self.arr addObject:model];
            }
            [self.tableView reloadData];
        } fail:^(NSURLSessionDataTask *task, NSError *error) {
    
        }];
}


- (void)cancle
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.arr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* identifier=@"cell";
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    AreaListModel* model=self.arr[indexPath.row];
    
    cell.textLabel.text=model.name;
  
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
      AreaListModel* model=self.arr[indexPath.row];
    NSString* urlStr=@"";
    if (!IsLoginState)
    {
       
        urlStr=[NSString stringWithFormat:@"%@Mobile/Index/index_area/data/%@/area/%@/page/%d/personid/0/sequence/0",Main_Server,self.cityId,model.areaId,self.areaPage];
    }else
    {
        urlStr=[NSString stringWithFormat:@"%@Mobile/Index/index_area/data/%@/area/%@/page/%d/personid/%@/sequence/0",Main_Server,self.cityId,model.areaId,self.areaPage,[XSaverTool objectForKey:UserIDKey]];
    }
    
    
    ////////////Mobile/Index/index_area/data/%@/area/%@/page/1/
    
    if ([self.delegate respondsToSelector:@selector(HomAreaBtnTitleId:areaId:)]) {
        [self.delegate HomAreaBtnTitleId:model.name areaId:model.areaId];
    }
   
    //DLog(@"选择区域后的URL:%@",urlStr);
    
    NSDictionary* dict=@{@"name":model.name,@"areaId":model.areaId,@"areaUrl":urlStr,@"aCity":self.cityId};
    DLog(@"选择区域后:%@",model.name);
    [[NSNotificationCenter defaultCenter]postNotificationName:@"AreaId" object:nil userInfo:dict];
    [self dismissViewControllerAnimated:YES completion:nil];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
