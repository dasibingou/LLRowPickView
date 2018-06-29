//
//  LLRowPickLogic.h
//  JoySpell
//
//  Created by linl on 2018/3/26.
//  Copyright © 2018年 xkdao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LLRowPickLogic : NSObject

- (void)ll_initData:(NSMutableDictionary *)dic;

- (NSMutableAttributedString *)ll_attributedStr:(NSString *)text selectText:(id)selectText selectAttr:(id)selectAttr;

- (NSArray *)ll_getPickArray;

- (NSArray *)ll_getPickIndexs:(NSArray *)array;

- (NSString *)ll_getShowValue;

- (NSString *)ll_getTrueValue:(NSString *)showVaule;

- (NSString *)ll_handlePickValue:(NSArray *)selectedTitles;

- (NSString *)ll_handlePickDateValue:(NSDate *)date;

- (BOOL)ll_isPickLimit;

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

- (void)textFieldDidChange:(UITextField *)textField;

@end
