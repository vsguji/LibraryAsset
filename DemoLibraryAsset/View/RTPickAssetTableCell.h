//
//  RTPickAssetTableCell.h
//  darongtong
//
//  Created by zy on 2018/1/13.
//  Copyright © 2018年 darongtong. All rights reserved.
//
//  选择图片,建立分组
#import <UIKit/UIKit.h>
#import "RTBaseCell.h"
#import "RTBaseView.h"
#import "BRPlaceholderTextView.h"
#import "ImageTitleButton.h"

@protocol HWPublishBaseViewDelegate <NSObject>
@optional
- (void)refreshTableCellHeightByIndexPath:(NSIndexPath *)currentIndex arrSelected:(NSArray *)array;
@end

@interface RTPickAssetTableCell : RTBaseCell

@property (nonatomic, assign) id<HWPublishBaseViewDelegate> baseDelegate;

@property (nonatomic, strong) UICollectionView *pickerCollectionView;

@property (nonatomic, assign) CGFloat collectionFrameY;

//选择的图片数据
@property(nonatomic,strong) NSMutableArray *arrSelected;

//方形压缩图image 数组
@property(nonatomic,strong) NSMutableArray * imageArray;

//大图image 数组
@property(nonatomic,strong) NSMutableArray * bigImageArray;

//大图image 二进制
@property(nonatomic,strong) NSMutableArray * bigImgDataArray;

//图片选择器
@property(nonatomic,strong) UIViewController *showActionSheetViewController;

//collectionView所在view
@property(nonatomic,strong) UIView *showInView;

//图片总数量限制
@property(nonatomic,assign) NSInteger maxCount;

// 当前分区
@property (nonatomic,strong) NSIndexPath *currentIndexPath;

//初始化collectionView
- (void)initPickerView;

//获得collectionView 的 Frame
- (CGRect)getPickerViewFrame;

//获取选中的所有图片信息
- (NSArray*)getSmallImageArray;
- (NSArray*)getBigImageArray;
- (NSArray*)getALAssetArray;

- (void)pickerViewFrameChanged;

- (void)setPickAssetImages:(NSArray *)assets;


@end


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 底部扩展
@interface RTPickerAssetGroupTitle:RTBaseView{
@protected
    BRPlaceholderTextView *_groupTitle;
    UILabel *_labLimit;
}
@end

@interface RTPickerAssetGroupDetail:RTBaseView{
@protected
    BRPlaceholderTextView *_groupDetail;
     UILabel *_labLimit;
}
@end

@interface RTPickerAssetTool:RTBaseView{
    @protected
    UIView *_topLine;
    UILabel *_left;
    ImageTitleButton *_accessView;
}
@end

@interface RTPickerAssetView:RTBaseView{
@protected
    RTPickerAssetGroupTitle *_title;
    RTPickerAssetGroupDetail *_detail;
    RTPickerAssetTool *_tool;
}
@end
