//
//  RTBaseModel.h
//  darongtong
//
//  Created by zy on 2017/11/1.
//  Copyright © 2017年 darongtong. All rights reserved.
//
// 容通数据模型基类
#import <Foundation/Foundation.h>
@interface RTBaseModel : NSObject{
    @protected
    NSString *_modelType;
    NSString *_modelId;
}
@property (nonatomic,copy) NSString *modelId;
@property (nonatomic,copy) NSString *modelType;

@end
