//
//  RTBaseModel+RTFormTableCell.m
//  darongtong
//
//  Created by zy on 2017/12/6.
//  Copyright © 2017年 darongtong. All rights reserved.
//

#import "RTBaseModel+RTFormTableCell.h"
#import "RTCellProtocal.h"
#import "UtilsMacro.h"

@implementation RTPickerAssetModel (TableViewCell)

- (CGFloat)formTableViewHeight {
    CGFloat height = 220.;
    height +=  ((float)(kScreenW-64.0) /4.0 +20.0) * ((int)(self.pickerAssets.count)/4 +1)+20.0;
    return height;
}

@end
