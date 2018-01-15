//
//  RTPickerAssetModel.h
//  darongtong
//
//  Created by zy on 2018/1/13.
//  Copyright © 2018年 darongtong. All rights reserved.
//
// 封面模型
#import <Foundation/Foundation.h>
#import "RTBaseModel.h"
@interface RTPickerAssetModel : RTBaseModel
@property (nonatomic,strong) NSArray *pickerAssets;
@property (nonatomic,copy) NSString *groupTitle;
@property (nonatomic,copy) NSString *groupDetail;
@property (nonatomic,copy) NSString *groupType;
@end
