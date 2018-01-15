//
//  RTPickerAssetViewController.m
//  darongtong
//
//  Created by zy on 2018/1/13.
//  Copyright © 2018年 darongtong. All rights reserved.
//

#import "RTPickerAssetViewController.h"
#import "RTPickAssetTableCell.h"
#import "RTColor.h"
#import "RTBaseModel+RTFormTableCell.h"
#import "RTPickerAssetModel.h"
#import "UtilsMacro.h"
#import "ColorMacro.h"
#import "UIView+CustomAutoLayout.h"
#import "UIView+Altar.h"
#import "RTBaseModel.h"


@interface RTPickerAssetViewController ()<UITableViewDelegate,UITableViewDataSource,HWPublishBaseViewDelegate>
@property (nonatomic,strong) UITableView *tabList;
@property (nonatomic,strong) NSMutableArray *pickerAsset;
@end

@implementation RTPickerAssetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加封面";
    [self setRightTitleNavigationBar:@"完成"];
    // Do any additional setup after loading the view.
    self.tabList = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds),CGRectGetHeight(self.view.bounds) - 64) style:UITableViewStylePlain];
    self.tabList.dataSource = self;
    self.tabList.delegate = self;
    [self.tabList registerClass:[RTPickAssetTableCell class] forCellReuseIdentifier:[RTPickAssetTableCell cellIdentity]];
    self.tabList.tableFooterView = [self tabFooterView];
    self.pickerAsset = [[NSMutableArray alloc] init];
    RTPickerAssetModel *assetModel = [RTPickerAssetModel new];
    [self.pickerAsset addObject:assetModel];
    [self.view addSubview:_tabList];
    self.tabList.backgroundColor = [RTColor rtBg28TypeColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)tabFooterView{
    UIView *addPlusBaseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,kScreenW, 64)];
    addPlusBaseView.backgroundColor = [RTColor rtBg28TypeColor];
    
    UIView *parentPlus = [[UIView alloc] initWithFrame:CGRectMake(0, 20, kScreenW, 44)];
    parentPlus.backgroundColor = kWhiteColor;
    [addPlusBaseView addSubview:parentPlus];
    
    ImageTitleButton *addPlus = [[ImageTitleButton alloc] initWithStyle:EImageLeftTitleRight maggin:UIEdgeInsetsZero padding:CGSizeMake(10., 0.)];
    [parentPlus addSubview:addPlus];
    [addPlus setSize:(CGSize){120,25}];
    [addPlus alignParentTopWithMargin:20.];
    [addPlus alignParentLeftWithMargin:10.];
    [addPlus layoutParentVerticalCenter];
    [addPlus setTitle:@"新建其他分组" forState:UIControlStateNormal];
    [addPlus.titleLabel setFont:FONT(LENGTH(12.))];
    [addPlus setTitleColor:kBlackColor forState:UIControlStateNormal];
    [addPlus setImage:[UIImage imageNamed:@"form_addPlus"] forState:UIControlStateNormal];
    [addPlus addTarget:self action:@selector(insertNewGroup) forControlEvents:UIControlEventTouchUpInside];
    
    return addPlusBaseView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   return self.pickerAsset.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   RTPickAssetTableCell *cell = [tableView dequeueReusableCellWithIdentifier:[RTPickAssetTableCell cellIdentity]];
    cell.showActionSheetViewController = self;
    cell.baseDelegate = self;
    cell.currentIndexPath = indexPath;
    RTPickerAssetModel *pickerModel = self.pickerAsset[indexPath.row];
    [cell setPickAssetImages:pickerModel.pickerAssets];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    RTPickerAssetModel *model = (RTPickerAssetModel *)[self.pickerAsset objectAtIndex:indexPath.row];
    return  [model formTableViewHeight];
}

#pragma mark - HWPublishBaseViewDelegate

- (void)refreshTableCellHeightByIndexPath:(NSIndexPath *)currentIndex arrSelected:(NSArray *)array{
    RTPickerAssetModel *pickModel = self.pickerAsset[currentIndex.row];
    @try{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tabList beginUpdates];
            pickModel.pickerAssets = array;
            [self.pickerAsset replaceObjectAtIndex:currentIndex.row withObject:pickModel];
            [self.tabList reloadRowsAtIndexPaths:@[currentIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tabList endUpdates];
        });
    }
    @catch (NSException *e){
        [self.tabList reloadData];
    }
}

- (void)insertNewGroup {
    [self.tabList beginUpdates];
    RTPickerAssetModel *assetModel = [RTPickerAssetModel new];
    [self.pickerAsset insertObject:assetModel atIndex:self.pickerAsset.count];
    [self.tabList insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.pickerAsset.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tabList endUpdates];
}
// super Method

- (void)rightBarItemClicked:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
