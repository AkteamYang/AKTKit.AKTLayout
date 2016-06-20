//
//  ViewController.m
//  AKTLayoutExmaple
//
//  Created by YaHaoo on 16/5/22.
//  Copyright © 2016年 YaHaoo. All rights reserved.
//

#import "ViewController.h"
#import "AKTKit.h"

//--------------------Structs statement, globle variables...--------------------
extern const int kColumns;
extern const int kLines;
//-------------------- E.n.d -------------------->Structs statement, globle variables...

@interface AKTCell: UITableViewCell
@property (strong, nonatomic) UIImageView *img;
@property (strong, nonatomic) UILabel *title;
@property (strong, nonatomic) UILabel *descriptionLabel;
@property (strong, nonatomic) NSString *classString;
@end
@implementation AKTCell
#pragma mark - property settings
//|---------------------------------------------------------
- (UIImageView *)img {
    if (_img == nil) {
        _img = [UIImageView new];
        [self addSubview:_img];
        AKTWeakOject(weakself, self);
        [_img aktLayout:^(AKTLayoutShellAttribute *layout) {
            [layout addDynamicLayoutInCondition:^BOOL{
                return mAKT_Portrait;
            } andAttribute:^(AKTLayoutShellAttribute *dynamicLayout) {
                dynamicLayout.centerY.equalTo(akt_view(weakself));
                dynamicLayout.whRatio.equalTo(akt_value(1.0));
                dynamicLayout.left.equalTo(akt_view(weakself)).offset(10);
                dynamicLayout.top.equalTo(akt_view(weakself)).offset(5);
            }];
            [layout addDynamicLayoutInCondition:^BOOL{
                return !mAKT_Portrait;
            } andAttribute:^(AKTLayoutShellAttribute *dynamicLayout) {
                dynamicLayout.centerY.equalTo(akt_view(weakself));
                dynamicLayout.whRatio.equalTo(akt_value(1.0));
                dynamicLayout.left.equalTo(akt_view(weakself)).offset(20);
                dynamicLayout.top.equalTo(akt_view(weakself)).offset(10);
            }];
        }];
        // 更新圆角大小
        [_img aktDidLayoutWithComplete:^(UIView *view) {
            view.layer.cornerRadius = view.height/2;
        }];
        _img.layer.masksToBounds = YES;
        _img.aktName = @"img";
        self.aktName = @"cell";
    }
    return _img;
}

- (UILabel* )title {
    if (_title == nil) {
        _title = [UILabel new];
        [self addSubview:_title];
        AKTWeakOject(weakself, self);
        AKTWeakOject(weakImg, self.img);
        [_title aktLayout:^(AKTLayoutShellAttribute *layout) {
            [layout addDynamicLayoutInCondition:^BOOL{
                return mAKT_Portrait;
            } andAttribute:^(AKTLayoutShellAttribute *dynamicLayout) {
                dynamicLayout.top.centerY.equalTo(akt_view(weakself));
                dynamicLayout.left.equalTo(weakself.img.akt_right).offset(20);
            }];
            [layout addDynamicLayoutInCondition:^BOOL{
                return !mAKT_Portrait;
            } andAttribute:^(AKTLayoutShellAttribute *dynamicLayout) {
                dynamicLayout.top.equalTo(akt_view(weakImg)).offset(10);
                dynamicLayout.left.equalTo(weakImg.akt_right).offset(20);
            }];
        }];
        [_title setTextColor:mAKT_Color_Text_52];
        [_title setFont:mAKT_Font_16];
        [_title setTextAlignment:(NSTextAlignmentCenter)];
        [_title setMaxWidth:@200];
//        _title.backgroundColor = mAKT_Color_Random;
        _title.text = @"title";
        _title.aktName = @"title";
    }
    return _title;
}

- (UILabel* )descriptionLabel {
    if (_descriptionLabel == nil) {
        _descriptionLabel = [UILabel new];
        [self addSubview:_descriptionLabel];
        AKTWeakOject(weakself, self);
        AKTWeakOject(weakTitle, self.title);
        [_descriptionLabel aktLayout:^(AKTLayoutShellAttribute *layout) {
            [layout addDynamicLayoutInCondition:^BOOL{
                return mAKT_Portrait;
            } andAttribute:^(AKTLayoutShellAttribute *dynamicLayout) {
                dynamicLayout.width.height.equalTo(akt_value(0));
            }];
            [layout addDynamicLayoutInCondition:^BOOL{
                return !mAKT_Portrait;
            } andAttribute:^(AKTLayoutShellAttribute *dynamicLayout) {
                dynamicLayout.left.equalTo(weakTitle.akt_left);
                dynamicLayout.right.equalTo(weakself.akt_right).offset(-150);
                dynamicLayout.top.equalTo(weakTitle.akt_bottom).offset(10);
            }];
        }];
        [_descriptionLabel setTextColor:mAKT_Color_Text_154];
        [_descriptionLabel setLineBreakMode:(NSLineBreakByTruncatingTail)];
        [_descriptionLabel setFont:mAKT_Font_14];
        [_descriptionLabel setNumberOfLines:0];
        [_descriptionLabel setMaxHeight:@36];
//        _descriptionLabel.backgroundColor = mAKT_Color_Random;
        _descriptionLabel.text = @"title";
        _descriptionLabel.aktName = @"title";
    }
    return _descriptionLabel;
}
@end

//--------------------Structs statement, globle variables...--------------------
static NSString *const cellIdentifier = @"cellIdentifier";
static NSString *const kClass = @"kClass";
static NSString *const kImg = @"kImg";
static NSString *const kTitle = @"kTitle";
static NSString *const kDescription = @"kDescription";
//-------------------- E.n.d -------------------->Structs statement, globle variables...

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *data;
@property (strong, nonatomic) UIImageView *header;
@end

@implementation ViewController
#pragma mark - property settings
//|---------------------------------------------------------
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:(CGRectZero) style:(UITableViewStylePlain)];
        _tableView.aktName = @"_tableview";
        [self.view addSubview:_tableView];
        [_tableView aktLayout:^(AKTLayoutShellAttribute *layout) {
            layout.edge.equalTo(akt_view(self.view));
        }];
        _tableView.delegate   = self;
        _tableView.dataSource = self;
        // Header
        UIImageView *imgv = [[UIImageView alloc]initWithImage:mAKT_Image(@"AKT_Header")];
        imgv.width = mAKT_SCREENWITTH;
        imgv.height = imgv.width/(imgv.image.size.width/imgv.image.size.height);
        _tableView.tableHeaderView = imgv;
        imgv.aktName = @"tableHeaderView";
        [imgv aktLayout:^(AKTLayoutShellAttribute *layout) {
            layout.top.left.equalTo(akt_value(0));
            layout.width.equalTo(_tableView.akt_width);
            layout.whRatio.equalTo(akt_value(imgv.image.size.width/imgv.image.size.height));
        }];
    }
    return _tableView;
}

- (NSMutableArray *)data {
    if (_data == nil) {
        _data = [NSMutableArray array];
    }
    return _data;
}

- (UIImageView *)header {
    if (_header == nil) {
        _header = [[UIImageView alloc]initWithImage:mAKT_Image(@"AKT_Header")];
    }
    return _header;
}
#pragma mark - life cycle
//|---------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - super methods
//|---------------------------------------------------------
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    // Header 改变了必须重新设置一遍才能生效
    dispatch_async(dispatch_get_main_queue(), ^{
        self.tableView.tableHeaderView = self.tableView.tableHeaderView;
    });
    [self.tableView reloadData];
}

#pragma mark - view settings
//|---------------------------------------------------------
- (void)initUI {
    // 设置导航
    [self.navigationController.navigationBar setBackgroundImage:mAKT_Image(@"P_Navi") forBarMetrics:(UIBarMetricsDefault)];
    [self.navigationController.navigationBar setTranslucent:YES];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:mAKT_Color_White,NSFontAttributeName:mAKT_Font_Bold_18}];
    self.title = @"AKTLayout Demo";
    self.view.aktName = @"self.view";
    // Tableview
    [self.tableView registerClass:[AKTCell class] forCellReuseIdentifier:cellIdentifier];
    [self.data addObjectsFromArray:@[
                                     @{kClass:@"ExampleMasonry",kImg:@"AKT_Test1",kTitle:[NSString stringWithFormat:@"Masonry Test x%d",kColumns*kLines*5],kDescription:@"Masonry is a light-weight layout framework which wraps AutoLayout with a nicer syntax."},
                                     @{kClass:@"ExampleAKTLayout",kImg:@"AKT_Test2",kTitle:[NSString stringWithFormat:@"AKTLayout Test x%d",kColumns*kLines*5],kDescription:@"AKTLayout is a high Performance Dynamic Auto Layout Framework."},
                                     @{kClass:@"ExamplePlayer",kImg:@"AKT_Example",kTitle:@"Interactive page", kDescription:@"In this demo, we will show it's more powerful feature: dynamic layout."},
                                     @{kClass:@"ExampleAnima",kImg:@"AKT_Anima",kTitle:@"Animation show", kDescription:@"Creat animation is easy and no different from previous ways"},
                                     ]];
}

#pragma mark - tableview datasourcce
//|---------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AKTCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL b = mAKT_SCREENWITTH>mAKT_SCREENHEIGHT;
    return b? 118:60;
}

#pragma mark - tableview delegate
//|---------------------------------------------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // Push view controller
    AKTCell *cell = (id)[tableView cellForRowAtIndexPath:indexPath];
    Class MyClass = NSClassFromString(cell.classString);
    UIViewController *vc = [[MyClass alloc]init];
    vc.title = cell.title.text;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    AKTCell *myCell = (id)cell;
    NSDictionary *dic = self.data[indexPath.row];
    myCell.img.image = mAKT_Image(dic[kImg]);
    myCell.classString = dic[kClass];
    myCell.title.text = dic[kTitle];
    myCell.descriptionLabel.text = dic[kDescription];
}
@end
