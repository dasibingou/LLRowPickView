//
//  LLCommonData.h
//  JoySpell
//
//  Created by linl on 2018/3/26.
//  Copyright © 2018年 xkdao. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const kCommonData_HeadImg = @"头像";
static NSString * const kCommonData_Name = @"姓名";
static NSString * const kCommonData_Nickname = @"昵称";
static NSString * const kCommonData_Job = @"行业";
static NSString * const kCommonData_Abode = @"所在地";
static NSString * const kCommonData_Workplace = @"工作生活在";
static NSString * const kCommonData_Birthday = @"生日";
static NSString * const kCommonData_Birthday1 = @"出生年月";
static NSString * const kCommonData_Height = @"身高";
static NSString * const kCommonData_Weight = @"体重";
static NSString * const kCommonData_Income = @"年收入";
static NSString * const kCommonData_ExpectedMarriageTime = @"期望结婚时间";
static NSString * const kCommonData_Nation = @"民族";
static NSString * const kCommonData_HomeCity = @"户籍(老家)";
static NSString * const kCommonData_MaritalStatus = @"婚姻状况";
static NSString * const kCommonData_Faith = @"信仰";
static NSString * const kCommonData_Potation = @"饮酒";
static NSString * const kCommonData_Smoke = @"吸烟";
static NSString * const kCommonData_ChildrenStauts = @"有无子女";
static NSString * const kCommonData_Constellation = @"星座";
static NSString * const kCommonData_Age = @"年龄";
static NSString * const kCommonData_Phone = @"手机号码";
static NSString * const kCommonData_BirthAndCon = @"生日-星座";
static NSString * const kCommonData_ZhaoBei = @"罩杯";
static NSString * const kCommonData_MarkType = @"标签类型";

@interface LLCommonData : NSObject

+ (NSArray *)getAgeNew;

+ (NSArray *)getHeightNew:(BOOL)select;

+ (NSArray *)getWeightNew:(BOOL)select;

+ (NSArray *)getAge;

+ (NSArray *)getHeight:(BOOL)select;

+ (NSArray *)getWeight:(BOOL)select;

+ (NSArray *)getIncome:(BOOL)select;

+ (NSArray *)getExpectedMarriageTime:(BOOL)select;

+ (NSArray *)getAbode:(BOOL)select;

+ (NSArray *)getNation:(BOOL)select;

+ (NSArray *)getMaritalStatus:(BOOL)select;

+ (NSArray *)getFaith:(BOOL)select;

+ (NSArray *)getPotation:(BOOL)select;

+ (NSArray *)getSmoke:(BOOL)select;

+ (NSArray *)getChildrenStauts:(BOOL)select;

+ (NSArray *)getBirthAndCon:(BOOL)select;

+ (NSArray *)getConstellation:(BOOL)select;

+ (NSArray *)getZhaoBei:(BOOL)select;

@end
