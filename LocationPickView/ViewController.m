//
//  ViewController.m
//  FunctionTest
//
//  Created by Jocelyn on 16/5/17.
//  Copyright © 2016年 Jocelyn. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIPickerView *location;
@property (strong, nonatomic) NSMutableArray *provice;
@property (strong, nonatomic) NSMutableDictionary *city;
@property (strong, nonatomic) NSMutableDictionary *district;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.location.dataSource = self;
    self.location.delegate = self;
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"address" ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:filePath];

    self.provice = [dict valueForKeyPath:@"address.name"];
    
    self.city = [NSMutableDictionary dictionaryWithObjects:[dict valueForKeyPath:@"address.sub.name"] forKeys:[dict valueForKeyPath:@"address.name"]];
//    NSLog(@"city = %@",self.city);

    self.district = [NSMutableDictionary dictionaryWithObjects:[dict valueForKeyPath:@"address.sub.sub"] forKeys:[dict valueForKeyPath:@"address.sub.name"]];
//    NSLog(@"district = %@",self.district);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/* pickview可选择数量 */
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}

/* pickview每个选择栏行数 */
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return self.provice.count;
    } else if (component == 1){
        /* 获取当前选择省份index */
        NSInteger rowProvice = [pickerView selectedRowInComponent:0];
        NSString *proviceName = self.provice[rowProvice];
        NSArray *citys = self.city[proviceName];
        return citys.count;
    } else {
        /* 获取当前选择省份index */
        NSInteger rowProvice = [pickerView selectedRowInComponent:0];
        NSString *proviceName = self.provice[rowProvice];
        NSArray *citys = self.city[proviceName];
        /* 获取当前选择城市index */
        NSInteger rowCity = [pickerView selectedRowInComponent:1];
        NSString *cityName = citys[rowCity];
        /* 获取当前选择城市在district字典中的index */
        NSInteger number = [citys indexOfObject:cityName];
        NSArray *districts = self.district[citys][number];
        return districts.count;
    }
}

/* pickview每个选择栏行标题 */
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0) {
        return self.provice[row];
    } else if (component == 1){
        /* 获取当前选择省份index */
        NSInteger rowProvice = [pickerView selectedRowInComponent:0];
        NSString *proviceName = self.provice[rowProvice];
        NSArray *citys = self.city[proviceName];
        return citys[row];
    } else{
        /* 获取当前选择省份index */
        NSInteger rowProvice = [pickerView selectedRowInComponent:0];
        NSString *proviceName = self.provice[rowProvice];
        NSArray *citys = self.city[proviceName];
        /* 获取当前选择城市index */
        NSInteger rowCity = [pickerView selectedRowInComponent:1];
        NSString *cityName = citys[rowCity];
        NSInteger number = [citys indexOfObject:cityName];
        /* 获取当前选择城市在district字典中的index */
        NSArray *districts = self.district[citys][number];
        return districts[row];
    }
}

/* pickview滚动选择时刷新对应栏目 */
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0) {
        [pickerView reloadComponent:1];
        [pickerView reloadComponent:2];
    }else if (component == 1) {
        [pickerView reloadComponent:2];
        NSInteger rowOne = [pickerView selectedRowInComponent:0];
        NSInteger rowTwo = [pickerView selectedRowInComponent:1];
        NSInteger rowThree = [pickerView selectedRowInComponent:2];
        NSString *proviceName = self.provice[rowOne];
        NSArray *citys = self.city[proviceName];
        NSString *cityName = citys[rowTwo];
        NSInteger number = [citys indexOfObject:cityName];
        NSArray *districts = self.district[citys][number];
        NSString *districtName = districts[rowThree];
        NSLog(@"%@~%@~%@",proviceName,cityName,districtName);
    } else {
        NSInteger rowOne = [pickerView selectedRowInComponent:0];
        NSInteger rowTwo = [pickerView selectedRowInComponent:1];
        NSInteger rowThree = [pickerView selectedRowInComponent:2];
        NSString *proviceName = self.provice[rowOne];
        NSArray *citys = self.city[proviceName];
        NSString *cityName = citys[rowTwo];
        NSInteger number = [citys indexOfObject:cityName];
        NSArray *districts = self.district[citys][number];
        NSString *districtName = districts[rowThree];
        NSLog(@"%@~%@~%@",proviceName,cityName,districtName);
    }
}

@end
