//
//  RTBaseModel+RTFormTableCell.h
//  darongtong
//
//  Created by zy on 2017/12/6.
//  Copyright © 2017年 darongtong. All rights reserved.
//
// 投模型UI
#import "RTBaseModel.h"
#import "RTCellProtocal.h"
#import "RTPickerAssetModel.h"

@interface RTBaseModel (RTFormTableCell)

// 单元样式
- (UITableViewCell<RTCellProtocal> *)formTableView:(UITableView *)tableView modelStyle:(RTBaseModel *)cellStyle;

// 单元高度
- (CGFloat)formTableViewHeight;

// 分区总数
- (NSInteger)formTableViewSections;

// 分区标题
- (NSString *)formTableViewSectionTitle;

// 水平间距
- (CGFloat)horizontalMargin;

// 垂直间距
- (CGFloat)verticalMargin;

// 顶部间距
- (CGFloat)topMargin;

// 底部间距
- (CGFloat)bottomMargin;

@end

//////////////////////////////////////////////////////////////////////////////////////////
// 添加封面
@interface RTPickerAssetModel (TableViewCell)

@end
