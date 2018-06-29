//
//  LLPickTextField.h
//  JoySpell
//
//  Created by linl on 2018/3/26.
//  Copyright © 2018年 xkdao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PickTextFieldCompletion)(NSArray *selectedTitles);

typedef NS_ENUM(NSUInteger, EnumPickField) {
    EnumPickField_label = 2,
    EnumPickField_textfield = 5,
    EnumPickField_pickview = 1,
    EnumPickField_datepick = 6
};

@interface LLPickTextField : UITextField

@property (nonatomic, assign) UIEdgeInsets ll_edgeInsets;

@property (nonatomic, assign) EnumPickField ll_type;

@property (nonatomic) NSDictionary *ll_data;

@property (nonatomic, assign) NSInteger ll_numberOfComponents;

@property (nonatomic, assign) BOOL ll_isLimit;

@property (nonatomic, copy) PickTextFieldCompletion ll_pickerCompletion;

- (void)ll_setDataIndexes:(NSArray *)indexes;

- (void)ll_addWindowBgView;

- (void)ll_doClickBg;

@end
