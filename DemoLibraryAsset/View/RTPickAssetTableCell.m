//
//  RTPickAssetTableCell.m
//  darongtong
//
//  Created by zy on 2018/1/13.
//  Copyright © 2018年 darongtong. All rights reserved.
//

#import "RTPickAssetTableCell.h"
#import "HWCollectionViewCell.h"
#import "JJPhotoManeger.h"
#import "HWImagePickerSheet.h"
#import "UIView+Altar.h"
#import "RTColor.h"
#import <ActionSheetPicker-3.0/ActionSheetPicker.h>
#import "UIView+Altar.h"
#import "UIView+CustomAutoLayout.h"
#import "UtilsMacro.h"
#import "ColorMacro.h"
#import "ImageTitleButton.h"

@interface RTPickAssetTableCell ()<UICollectionViewDelegate,UICollectionViewDataSource,JJPhotoDelegate,HWImagePickerSheetDelegate,RTFormViewDynamicDelegate>
{
    NSString *pushImageName;
    //添加图片提示
    UILabel *addImageStrLabel;
    
    RTPickerAssetView *extensionView;
    // pickerCollectionView 排版高度变化
    BOOL     _willChangeHeight;
}
@property (nonatomic, strong) HWImagePickerSheet *imgPickerActionSheet;

@end

@implementation RTPickAssetTableCell

- (UICollectionViewFlowLayout *)flowLayout{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    return layout;
}

- (void)initPickerView {
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)loadViews {
    [super loadViews];
     _willChangeHeight = NO;
    self.headerIcon.hidden = YES;
    self.userNick.hidden = YES;
    self.userTitle.hidden = YES;
    self.pickerCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
    self.pickerCollectionView.backgroundColor = kWhiteColor;
    self.pickerCollectionView.dataSource = self;
    self.pickerCollectionView.delegate = self;
    [self addSubview:_pickerCollectionView];
   
    if(_imageArray.count == 0)
    {
        _imageArray = [NSMutableArray array];
    }
    if(_bigImageArray.count == 0)
    {
        _bigImageArray = [NSMutableArray array];
    }
    pushImageName = @"form_plus";
    
    _pickerCollectionView.scrollEnabled = NO;
    
    //上传图片提示
    addImageStrLabel = [[UILabel alloc]initWithFrame:CGRectMake(100,35, 70, 20)];
    addImageStrLabel.text = @"上传图片";
    addImageStrLabel.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
    [self.pickerCollectionView addSubview:addImageStrLabel];

    extensionView = [[RTPickerAssetView alloc] init];
    extensionView.dynamicDelegate = self;
    [self addSubview:extensionView];
    [extensionView configOwnViewsWidthInfo:nil];
    
    _maxCount = 9;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.pickerCollectionView.frame = self.bounds;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _imageArray.count+1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // Register nib file for the cell
    UINib *nib = [UINib nibWithNibName:@"HWCollectionViewCell" bundle: [NSBundle mainBundle]];
    [collectionView registerNib:nib forCellWithReuseIdentifier:@"HWCollectionViewCell"];
    // Set up the reuse identifier
    HWCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"HWCollectionViewCell" forIndexPath:indexPath];
    
    if (indexPath.row == _imageArray.count) {
        [cell.profilePhoto setImage:[UIImage imageNamed:pushImageName]];
        cell.closeButton.hidden = YES;
        
        //没有任何图片
        if (_imageArray.count == 0) {
            addImageStrLabel.hidden = NO;
        }
        else{
            addImageStrLabel.hidden = YES;
        }
    }
    else{
        [cell.profilePhoto setImage:_imageArray[indexPath.item]];
        cell.closeButton.hidden = NO;
    }
    [cell setBigImageViewWithImage:nil];
    cell.profilePhoto.tag = [indexPath item];
    
    //添加图片cell点击事件
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapProfileImage:)];
    singleTap.numberOfTapsRequired = 1;
    cell.profilePhoto .userInteractionEnabled = YES;
    [cell.profilePhoto  addGestureRecognizer:singleTap];
    cell.closeButton.tag = [indexPath item];
    [cell.closeButton addTarget:self action:@selector(deletePhoto:) forControlEvents:UIControlEventTouchUpInside];
    
   [self changeCollectionViewHeight];
    return cell;
}
#pragma mark <UICollectionViewDelegate>
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(([UIScreen mainScreen].bounds.size.width-64) /4 ,([UIScreen mainScreen].bounds.size.width-64) /4);
}

//定义每个UICollectionView 的 margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 8, 10, 8);
}

#pragma mark - 图片cell点击事件
//点击图片看大图
- (void) tapProfileImage:(UITapGestureRecognizer *)gestureRecognizer{
    [self endEditing:YES];
    
    UIImageView *tableGridImage = (UIImageView*)gestureRecognizer.view;
    NSInteger index = tableGridImage.tag;
    
    if (index == (_imageArray.count)) {
        [self endEditing:YES];
        //添加新图片
        [self addNewImg];
    }
    else{
        //点击放大查看
        HWCollectionViewCell *cell = (HWCollectionViewCell*)[_pickerCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
        if (!cell.BigImageView || !cell.BigImageView.image) {
            
            [cell setBigImageViewWithImage:[self getBigIamgeWithALAsset:_arrSelected[index]]];
        }
        
        JJPhotoManeger *mg = [JJPhotoManeger maneger];
        mg.delegate = self;
        [mg showLocalPhotoViewer:@[cell.BigImageView] selecImageindex:0];
    }
}
- (UIImage*)getBigIamgeWithALAsset:(ALAsset*)set{
    //压缩
    // 需传入方向和缩放比例，否则方向和尺寸都不对
    UIImage *img = [UIImage imageWithCGImage:set.defaultRepresentation.fullResolutionImage
                                       scale:set.defaultRepresentation.scale
                                 orientation:(UIImageOrientation)set.defaultRepresentation.orientation];
    NSData *imageData = UIImageJPEGRepresentation(img, 0.5);
    [_bigImgDataArray addObject:imageData];
    
    return [UIImage imageWithData:imageData];
}
#pragma mark - 选择图片
- (void)addNewImg{
    if (!_imgPickerActionSheet) {
        _imgPickerActionSheet = [[HWImagePickerSheet alloc] init];
        _imgPickerActionSheet.delegate = self;
    }
    if (_arrSelected) {
        _imgPickerActionSheet.arrSelected = _arrSelected;
    }
    _imgPickerActionSheet.maxCount = _maxCount;
    [_imgPickerActionSheet showImgPickerActionSheetInView:_showActionSheetViewController];
}

#pragma mark - 删除照片
- (void)deletePhoto:(UIButton *)sender{
     _willChangeHeight = YES;
    [_imageArray removeObjectAtIndex:sender.tag];
    [_arrSelected removeObjectAtIndex:sender.tag];
    
    
    [self.pickerCollectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:sender.tag inSection:0]]];
    
    for (NSInteger item = sender.tag; item <= _imageArray.count; item++) {
        HWCollectionViewCell *cell = (HWCollectionViewCell*)[self.pickerCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:0]];
        cell.closeButton.tag--;
        cell.profilePhoto.tag--;
    }
    
    [self changeCollectionViewHeight];
}


#pragma mark - 改变view，collectionView高度
- (void)changeCollectionViewHeight{
    
    if ( _willChangeHeight == NO) return;
    
    if (_collectionFrameY) {
        _pickerCollectionView.frame = CGRectMake(0, _collectionFrameY, [UIScreen mainScreen].bounds.size.width, (((float)[UIScreen mainScreen].bounds.size.width-64.0) /4.0 +20.0)* ((int)(_arrSelected.count)/4 +1)+20.0);
    }
    else{
        _pickerCollectionView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, (((float)[UIScreen mainScreen].bounds.size.width-64.0) /4.0 +20.0)* ((int)(_arrSelected.count)/4 +1)+20.0);
    }
    // 拓展功能
    [extensionView layoutBelow:self.pickerCollectionView];
    [extensionView alignParentLeft];
    [extensionView scaleToParentRight];
    [extensionView scaleToParentBottom];
    [extensionView relayoutFrameOfSubViews];
    [self pickerViewFrameChanged];
    
}
/**
 *  相册完成选择得到图片
 */
-(void)getSelectImageWithALAssetArray:(NSArray *)ALAssetArray thumbnailImageArray:(NSArray *)thumbnailImgArray{
    _willChangeHeight = YES;
    //（ALAsset）类型 Array
    _arrSelected = [NSMutableArray arrayWithArray:ALAssetArray];
    //正方形缩略图 Array
    _imageArray = [NSMutableArray arrayWithArray:thumbnailImgArray] ;
    if (_arrSelected.count && self.baseDelegate && [self.baseDelegate respondsToSelector:@selector(refreshTableCellHeightByIndexPath:arrSelected:)]) {
        [_baseDelegate performSelector:@selector(refreshTableCellHeightByIndexPath:arrSelected:) withObject:self.currentIndexPath withObject:_arrSelected];
    }
}

- (void)pickerViewFrameChanged{
    
    if (_willChangeHeight) {
        _willChangeHeight = NO;
    }
}

- (void)setPickAssetImages:(NSArray *)assets{
    if (assets &&  assets.count > 0) {
        _imageArray  = [[self getBigImageArrayWithALAssetArray:assets] mutableCopy];
        _arrSelected = [assets mutableCopy];
    }
    else {
        _arrSelected = [@[] mutableCopy];
        _imageArray = [@[] mutableCopy];
    }
    _willChangeHeight = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.pickerCollectionView reloadData];
    });
}

- (void)updatePickerViewFrameY:(CGFloat)Y{
    
    _collectionFrameY = Y;
    _pickerCollectionView.frame = CGRectMake(0, Y, [UIScreen mainScreen].bounds.size.width, (((float)[UIScreen mainScreen].bounds.size.width-64.0) /4.0 +10.0)* ((int)(_arrSelected.count)/4 +1)+20.0);
}

#pragma mark - 防止奔溃处理
-(void)photoViwerWilldealloc:(NSInteger)selecedImageViewIndex
{
    NSLog(@"最后一张观看的图片的index是:%zd",selecedImageViewIndex);
}

- (UIImage *)compressImage:(UIImage *)image toMaxFileSize:(NSInteger)maxFileSize {
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    while ([imageData length] > maxFileSize && compression > maxCompression) {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(image, compression);
    }
    
    UIImage *compressedImage = [UIImage imageWithData:imageData];
    return compressedImage;
}
//获得大图
- (NSArray*)getBigImageArrayWithALAssetArray:(NSArray*)ALAssetArray{
    _bigImgDataArray = [NSMutableArray array];
    NSMutableArray *bigImgArr = [NSMutableArray array];
    for (ALAsset *set in ALAssetArray) {
        [bigImgArr addObject:[self getBigIamgeWithALAsset:set]];
    }
    _bigImageArray = bigImgArr;
    return _bigImageArray;
}
#pragma mark - 获得选中图片各个尺寸
- (NSArray*)getALAssetArray{
    return _arrSelected;
}

- (NSArray*)getBigImageArray{
    
    return [self getBigImageArrayWithALAssetArray:_arrSelected];
}

- (NSArray*)getSmallImageArray{
    return _imageArray;
}

- (CGRect)getPickerViewFrame{
    return self.pickerCollectionView.frame;
}

#pragma mark - RTFormViewDynamicDelegate

- (void)sheetInView {
    if (self.showActionSheetViewController) {
        [ActionSheetStringPicker showPickerWithTitle:@"存储到"
                                                rows:@[@"实景图",@"实景图",@"实景图",@"实景图",@"实景图"]
                                    initialSelection:0
                                           doneBlock:^(ActionSheetStringPicker *picker,
                                                       NSInteger selectedIndex,
                                                       id selectedValue) {
            
        } cancelBlock:^(ActionSheetStringPicker *picker) {
            
        } origin:self.showActionSheetViewController.view];
    }
}

@end


@implementation RTPickerAssetGroupTitle

- (void)addOwnViews {
    _groupTitle = [[BRPlaceholderTextView alloc] init];
    [_groupTitle setPlaceholderFont:FONT(LENGTH(14.))];
    [_groupTitle setPlaceholderColor:kBlackColor];
    _groupTitle.maxTextLength = 20;
    [self addSubview:_groupTitle];
    
    _labLimit = [[UILabel alloc] init];
    _labLimit.textColor = kGrayColor;
    _labLimit.font = FONT(LENGTH(8.));
    _labLimit.textAlignment = NSTextAlignmentRight;
    [self addSubview:_labLimit];
}

- (void)configOwnViews {
    _groupTitle.backgroundColor = kClearColor;
    self.backgroundColor = [RTColor rtBg28TypeColor];
    _groupTitle.showsVerticalScrollIndicator = NO;
    _groupTitle.showsHorizontalScrollIndicator = NO;
}

- (void)configOwnViewsWidthInfo:(id<RTFormProtocol>)info {
    _groupTitle.placeholder = @"本组图片简短介绍";
    _labLimit.text = [NSString stringWithFormat:@"%d/%ld",0,_groupTitle.maxTextLength];
    __weak typeof(UILabel) *weakLimit = _labLimit;
    [_groupTitle addTextViewChangeEvent:^(BRPlaceholderTextView *text) {
        weakLimit.text = [NSString stringWithFormat:@"%ld/%ld",text.text.length,text.maxTextLength];
    }];
    [_groupTitle addMaxTextLengthWithMaxLength:_groupTitle.maxTextLength andEvent:^(BRPlaceholderTextView *text) {
        [text resignFirstResponder];
    }];
}

- (void)relayoutFrameOfSubViews {
    
    [_groupTitle setSize:(CGSize){160,14}];
    [_groupTitle alignParentTopWithMargin:2.];
    [_groupTitle scaleToParentBottomWithMargin:2.];
    [_groupTitle alignParentLeftWithMargin:10.];
    [_groupTitle layoutParentVerticalCenter];
    
    [_labLimit setSize:(CGSize){100,12}];
    [_labLimit alignParentRightWithMargin:10.];
    [_labLimit layoutParentVerticalCenter];
    
    [_groupTitle scaleToLeftOf:_labLimit margin:10.];
}

@end


@implementation RTPickerAssetGroupDetail

- (void)addOwnViews {
    _groupDetail = [[BRPlaceholderTextView alloc] init];
    [_groupDetail setPlaceholderFont:FONT(LENGTH(12.))];
    [_groupDetail setPlaceholderColor:kLightGrayColor];
    _groupDetail.maxTextLength = 100;
    [self addSubview:_groupDetail];
    
    _labLimit = [[UILabel alloc] init];
    _labLimit.textColor = kGrayColor;
    _labLimit.font = FONT(LENGTH(8.));
    _labLimit.textAlignment = NSTextAlignmentRight;
    [_groupDetail addSubview:_labLimit];
}

- (void)configOwnViews {
     self.backgroundColor = kWhiteColor;
    _groupDetail.backgroundColor = [RTColor rtBg28TypeColor];
    _groupDetail.showsVerticalScrollIndicator = NO;
    _groupDetail.showsHorizontalScrollIndicator = NO;
}

- (void)configOwnViewsWidthInfo:(id<RTFormProtocol>)info {
    _groupDetail.placeholder = @"小题目简短介绍";
    _labLimit.text = [NSString stringWithFormat:@"%d/%ld",0,_groupDetail.maxTextLength];
    __weak typeof(UILabel) *weakLimit = _labLimit;
    [_groupDetail addTextViewChangeEvent:^(BRPlaceholderTextView *text) {
        weakLimit.text = [NSString stringWithFormat:@"%ld/%ld",text.text.length,text.maxTextLength];
    }];
    [_groupDetail addMaxTextLengthWithMaxLength:_groupDetail.maxTextLength andEvent:^(BRPlaceholderTextView *text) {
        [text resignFirstResponder];
    }];
}

- (void)relayoutFrameOfSubViews {
    
    [_groupDetail alignParentTopWithMargin:10.];
    [_groupDetail alignParentLeftWithMargin:10.];
    [_groupDetail scaleToParentRightWithMargin:10.];
    [_groupDetail scaleToParentBottomWithMargin:10.];
    
    [_labLimit setSize:(CGSize){100,12}];
    [_labLimit alignParentBottomWithMargin:2.];
    [_labLimit alignParentRightWithMargin:2.];
    [_labLimit scaleToParentLeftWithMargin:10.];

}

@end

@implementation RTPickerAssetTool

- (void)addOwnViews {
    
    _topLine = [[UIView alloc] init];
    [self addSubview:_topLine];
    _topLine.alpha = 0.5;
    _topLine.backgroundColor = kGrayColor;
    
    _left = [[UILabel alloc] init];
    _left.font = FONT(12.);
    _left.textColor = kBlackColor;
    [self addSubview:_left];
    
    _accessView = [[ImageTitleButton alloc] initWithStyle:ETitleLeftImageRight maggin:UIEdgeInsetsZero padding:CGSizeMake(10., 0)];
    [self addSubview:_accessView];
    [_accessView.titleLabel setFont:FONT(12.)];
    _accessView.titleLabel.textAlignment = NSTextAlignmentRight;
    [_accessView setTitleColor:kGrayColor forState:UIControlStateNormal];
}

- (void)configOwnViews {
    [_accessView setTitle:@"实景图" forState:UIControlStateNormal];
    [_accessView setImage:[UIImage imageNamed:@"jiali_arrow"] forState:UIControlStateNormal];
    [_accessView addTarget:self.dynamicDelegate action:@selector(sheetView) forControlEvents:UIControlEventTouchUpInside];
}

- (void)configOwnViewsWidthInfo:(id<RTFormProtocol>)info {
    _left.text = @"存储到";
}

- (void)relayoutFrameOfSubViews {
    
    [_topLine setSize:(CGSize){1,1}];
    [_topLine alignParentTop];
    [_topLine alignParentLeft];
    [_topLine scaleToParentRight];
    
    [_left setSize:(CGSize){60,14}];
    [_left alignParentLeftWithMargin:10.];
    [_left layoutParentVerticalCenter];
    
    [_accessView setSize:(CGSize){80,12}];
    [_accessView alignParentRightWithMargin:10.];
    [_accessView layoutParentVerticalCenter];
}

- (void)sheetView {
    if (_dynamicDelegate && [_dynamicDelegate respondsToSelector:@selector(sheetInView)]) {
        [_dynamicDelegate performSelector:@selector(sheetInView)];
    }
}

@end

@implementation RTPickerAssetView

- (void)addOwnViews {
    _title = [[RTPickerAssetGroupTitle alloc] init];
    [self addSubview:_title];
    
    _detail = [[RTPickerAssetGroupDetail alloc] init];
    [self addSubview:_detail];
    
    _tool = [[RTPickerAssetTool alloc] init];
    [self addSubview:_tool];
}

- (void)configOwnViews {
    
}

- (void)configOwnViewsWidthInfo:(id<RTFormProtocol>)info {
    [_title configOwnViewsWidthInfo:info];
    [_detail configOwnViewsWidthInfo:info];
    [_tool configOwnViewsWidthInfo:info];
     _tool.dynamicDelegate = self.dynamicDelegate;
}

- (void)relayoutFrameOfSubViews {

    [_title setSize:(CGSize){44,44}];
    [_title alignParentTop];
    [_title alignParentLeft];
    [_title scaleToParentRight];
    [_title relayoutFrameOfSubViews];
    
    [_detail layoutBelow:_title margin:15.];
    [_detail setSize:(CGSize){115,115}];
    [_detail alignParentLeft];
    [_detail scaleToParentRight];
    
    [_tool setSize:(CGSize){44,44}];
    [_tool alignParentBottom];
    [_tool alignParentLeft];
    [_tool scaleToParentRight];
    [_tool relayoutFrameOfSubViews];
    
    [_detail scaleToAboveOf:_tool];
    [_detail relayoutFrameOfSubViews];
}

@end


