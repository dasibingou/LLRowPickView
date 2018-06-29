//
//  LLRowPickView.h
//  JoySpell
//
//  Created by linl on 2018/3/26.
//  Copyright © 2018年 xkdao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LLCommonData.h"

@class LLRowPickView;

extern NSString * const kRowPickKeyName;                    //左标题
extern NSString * const kRowPickKeyType;                    //右控件类型
extern NSString * const kRowPickKeyValue;                   //值
extern NSString * const kRowPickKeyData;                    //pick数据
extern NSString * const kRowPickKeyHoldText;                //placehold
extern NSString * const kRowPickKeyDefaultSelect;           //pick默认选择
extern NSString * const kRowPickKeyHasLine;                 //是否有底线
extern NSString * const kRowPickKeyHasArrow;                //是否有箭头
extern NSString * const kRowPickKeyHeight;                  //控件高度
extern NSString * const kRowPickKeyPickNum;                 //pick控件列数
extern NSString * const kRowPickKeyIsSelection;             //数据是否供选择，即data有无加‘不限’
extern NSString * const kRowPickKeyEditable;                //控件是否可编辑
extern NSString * const kRowPickKeyShowAttrs;               //右文本属性
extern NSString * const kRowPickKeyHoldAttrs;               //右placehold文本属性

typedef void(^RowPickViewBlock)(LLRowPickView *row);

typedef NS_ENUM(NSUInteger, EnumPickType) {
    EnumPickType_none,
    EnumPickType_pick,
    EnumPickType_label,
    EnumPickType_button,
    EnumPickType_image,
    EnumPickType_textfield,
    EnumPickType_datePick,
};

@interface LLRowPickView : UIView

/** 操作回调 */
@property (nonatomic, strong) RowPickViewBlock ll_resultBlock;
/** 界面参数 */
@property (nonatomic, strong) NSMutableDictionary *ll_paramDic;
/** 左标题 */
@property (nonatomic, strong) UILabel *ll_lblTitle;
/** 控件padding */
@property (nonatomic, assign) UIEdgeInsets ll_edgeInsetsRow;
/** 头像 */
@property (nonatomic, strong) UIImage *ll_imgSelect;

/**
 更新数据
 */
- (void)ll_updateData;

/**
 只更新显示值
 */
- (void)ll_updateValue:(NSString *)result value:(NSString *)value;

@end
