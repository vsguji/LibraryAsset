//
//  RTBaseCell.m
//  darongtong
//
//  Created by zy on 2017/9/20.
//  Copyright © 2017年 darongtong. All rights reserved.
//

#import "RTBaseCell.h"

@interface RTBaseCell()
@property (nonatomic,strong) NSIndexPath *cellPath;
@end
@implementation RTBaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self loadViews];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        [self loadViews];
    }
    return self;
}

- (instancetype)initWithCellIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier])
    {
         // do something
         [self loadViews];
    }
    return self;
}

+ (void)regsisterCell:(UITableView *)tab{
 
    [tab registerClass:[self class] forCellReuseIdentifier:[self cellIdentity]];
}

+ (instancetype)initWithStyle:(UITableViewCellStyle)style tableView:(UITableView *)tab indexPath:(kRegister)cellRegister {
    if (cellRegister == kRegisterUse) {
         return [tab dequeueReusableCellWithIdentifier:[[self class] cellIdentity]];
    }
    return  [self initWithStyle:style indexPath:[tab indexPathForCell:(UITableViewCell*)self]];
}

+ (instancetype)initWithStyle:(UITableViewCellStyle)style indexPath:(NSIndexPath *)path{
    RTBaseCell *cell = [[RTBaseCell alloc] initWithStyle:style reuseIdentifier:[self cellIdentity]];
    cell.cellPath = path;
    
    return cell;
}

+ (NSString *)cellIdentity {
    return NSStringFromClass([self class]);
}

- (void)loadViews {
    _normal = [UIImage imageNamed:@"live_circleNormal"];
    _selected = [UIImage imageNamed:@"circleSelected"];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)baseCellSelected:(BOOL)status {
    _isSelected = status;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)customerAccessView:(UIImage *)image {
    self.accessoryView = [[UIImageView alloc] initWithImage:image];
}


- (void)prepareForReuse {
    [super prepareForReuse];
}

- (void)setTapGesture:(UIView *)gesture {
    
    if ([gesture isEqual:self.accessoryView] == NO) {
        self.accessoryView = nil;
    }
    if ([gesture isKindOfClass:[UIImageView class]]) {
        ((UIImageView *)gesture).userInteractionEnabled = YES;
    }
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureAction:)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.numberOfTouchesRequired = 1;
    [gesture addGestureRecognizer:tapGesture];
}

- (void)gestureAction:(UIGestureRecognizer *)gesture {
}

- (void)setCurrentDelegate:(id)parentVC {
    _delegate = parentVC;
}

+ (NSString *)despription {
   return @"";
}

- (void)clearBgColorCell {

}

@end

