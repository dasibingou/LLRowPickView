//
//  LLRowPickLogic.m
//  JoySpell
//
//  Created by linl on 2018/3/26.
//  Copyright © 2018年 xkdao. All rights reserved.
//

#import "LLRowPickLogic.h"
#import "LLCommonData.h"
//#import "NSString+Emoji.h"

#import "LLRowPickView.h"

#define LL_NULLString(string) ((![string isKindOfClass:[NSString class]])||[string isEqualToString:@""] || (string == nil) || [string isEqualToString:@""] || [string isKindOfClass:[NSNull class]]||[[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0)

@interface LLRowPickLogic ()
{
    NSString *pickName;
    NSString *pickValue;
    BOOL pickSelect;
    NSInteger pickNum;
    
    BOOL isNew;
}

@end

@implementation LLRowPickLogic

- (void)ll_initData:(NSMutableDictionary *)dic
{
    pickName = dic[kRowPickKeyName];
    pickValue = [NSString stringWithFormat:@"%@",dic[kRowPickKeyValue]];
    pickSelect = [dic[kRowPickKeyIsSelection] boolValue];
    pickNum = [dic[kRowPickKeyPickNum] integerValue];
}

#pragma mark - 获取指定文本属性集
- (NSMutableAttributedString *)ll_attributedStr:(NSString *)text selectText:(id)selectText selectAttr:(id)selectAttr
{
    NSMutableAttributedString *atStr = [[NSMutableAttributedString alloc] initWithString:text];
    
    if ([selectText isKindOfClass:[NSString class]]) {
        NSString *str = selectText;
        NSRange range = [text rangeOfString:str];
        [atStr addAttributes:selectAttr range:range];
    }
    
    if ([selectText isKindOfClass:[NSArray class]]) {
        NSArray *array = selectText;
        for (int i = 0; i < array.count; i++) {
            NSRange range = [text rangeOfString:array[i]];
            [atStr addAttributes:selectAttr[i] range:range];
        }
    }
    
    return atStr;
}

#pragma mark - 获取pick默认数据集合
- (NSArray *)ll_getPickArray
{
    if ([pickName isEqualToString:kCommonData_Age])
    {
        return isNew ? [LLCommonData getAgeNew] : [LLCommonData getAge];
    }
    if ([pickName isEqualToString:kCommonData_Height])
    {
        return isNew ? [LLCommonData getHeightNew:pickSelect] : [LLCommonData getHeight:pickSelect];
    }
    if ([pickName isEqualToString:kCommonData_Weight])
    {
        return isNew ? [LLCommonData getWeightNew:pickSelect] : [LLCommonData getWeight:pickSelect];
    }
    if ([pickName isEqualToString:kCommonData_Income])
    {
        return [LLCommonData getIncome:pickSelect];
    }
    if ([pickName isEqualToString:kCommonData_ExpectedMarriageTime])
    {
        return [LLCommonData getExpectedMarriageTime:pickSelect];
    }
    if ([pickName isEqualToString:kCommonData_Abode])
    {
        return [LLCommonData getAbode:pickSelect];
    }
    if ([pickName isEqualToString:kCommonData_Workplace])
    {
        return [LLCommonData getAbode:pickSelect];
    }
    if ([pickName isEqualToString:kCommonData_HomeCity])
    {
        return [LLCommonData getAbode:pickSelect];
    }
    if ([pickName isEqualToString:kCommonData_Nation])
    {
        return [LLCommonData getNation:pickSelect];
    }
    if ([pickName isEqualToString:kCommonData_MaritalStatus])
    {
        return [LLCommonData getMaritalStatus:pickSelect];
    }
    if ([pickName isEqualToString:kCommonData_Faith])
    {
        return [LLCommonData getFaith:pickSelect];
    }
    if ([pickName isEqualToString:kCommonData_Potation])
    {
        return [LLCommonData getPotation:pickSelect];
    }
    if ([pickName isEqualToString:kCommonData_Smoke])
    {
        return [LLCommonData getSmoke:pickSelect];
    }
    if ([pickName isEqualToString:kCommonData_ChildrenStauts])
    {
        return [LLCommonData getChildrenStauts:pickSelect];
    }
    if ([pickName isEqualToString:kCommonData_BirthAndCon])
    {
        return [LLCommonData getBirthAndCon:pickSelect];
    }
    if ([pickName isEqualToString:kCommonData_Constellation]) {
        return [LLCommonData getConstellation:pickSelect];
    }
    if ([pickName isEqualToString:kCommonData_ZhaoBei]) {
        return [LLCommonData getZhaoBei:pickSelect];
    }
    
    return [NSArray new];
}

#pragma mark - 获取pick选中indexs数据集合
- (NSArray *)ll_getPickIndexs:(NSArray *)array
{
    NSArray *result = [[NSArray alloc] init];
    
    if (pickNum == 1)
    {
        if (!LL_NULLString(pickValue) && ![pickValue isEqualToString:@"0"])
        {
            NSString *text = [self ll_getShowValue];
            
            if ([array containsObject:text])
            {
                result = @[@([array indexOfObject:text])];
            }
            else
            {
                result = @[@(0)];
            }
        }
        else
        {
            //默认值设置
            if ([pickName isEqualToString:kCommonData_Height])
            {
//                MRUGender gender = [RunTimeSetting sharedInstance].currentUser.profile.gender;
//
//                NSInteger index = [array indexOfObject:gender == MRUGender_Female ? @"165cm" : @"172cm"];
//
//                result = @[@(index)];
            }
            else
            {
                result = @[@(0)];
            }
        }
    }
    else
    {
        if (!LL_NULLString(pickValue) && ![pickValue isEqualToString:@"0"] && ![pickValue isEqualToString:@"不限"])
        {
            NSString *text = [self ll_getShowValue];
            
            NSArray *selects;
            
            if ([pickName isEqualToString:kCommonData_Abode] || [pickName isEqualToString:kCommonData_Workplace] || [pickName isEqualToString:kCommonData_HomeCity] || [pickName isEqualToString:kCommonData_BirthAndCon])
            {
                selects = [text componentsSeparatedByString:@"-"];
            }
            else
            {
                selects = [text componentsSeparatedByString:@"-"];
            }
            
            NSString *min = @"";
            
            NSString *max = @"";
            
            if (selects.count < 2)
            {
                min = selects.firstObject;
            }
            else
            {
                min = selects.firstObject;
                
                max = [selects objectAtIndex:1];
            }
            
            NSInteger first = 0;
            
            NSInteger second = 0;
            
            for (int i = 0; i < array.count; i++)
            {
                if ([array[i] isKindOfClass:[NSDictionary class]])
                {
                    NSDictionary *dic = array[i];
                    
                    if ([dic.allKeys[0] isEqualToString:min])
                    {
                        first = i;
                        
                        second = [dic.allValues[0] indexOfObject:max];
                        
                        break;
                    }
                }
                else if ([array[i] isKindOfClass:[NSString class]])
                {
                    NSString *str = array[i];
                    
                    if ([str isEqualToString:min])
                    {
                        first = i;
                    }
                    
                    if ([str isEqualToString:max])
                    {
                        second = i - first;
                        break;
                    }
                }
            }
            
            result = @[@(first),@(second)];
        }
        else
        {
            result = @[@(0),@(0)];
        }
    }
    
    return result;
}

#pragma mark - 获取pick展示值
- (NSString *)ll_getShowValue
{
    //    if ([pickName isEqualToString:kCommonData_Age])
    //    {
    //        if ([pickValue rangeOfString:@"-"].location != NSNotFound)
    //        {
    //            return [pickValue stringByReplacingOccurrencesOfString:@"-" withString:@"~"];
    //        }
    //    }
    if ([pickValue isEqualToString:@"不限"])
    {
        return pickValue;
    }
    if ([pickName isEqualToString:kCommonData_Height])
    {
        if (pickSelect)
        {
            if ([pickValue rangeOfString:@"-"].location != NSNotFound)
            {
                NSArray *arr = [pickValue componentsSeparatedByString:@"-"];
                
                return [NSString stringWithFormat:@"%@cm-%@cm",arr[0],arr[1]];
            }
        }
        else
        {
            return [NSString stringWithFormat:@"%@cm",pickValue];
        }
    }
    if ([pickName isEqualToString:kCommonData_Weight])
    {
        if (pickSelect)
        {
            if ([pickValue rangeOfString:@"-"].location != NSNotFound)
            {
                NSArray *arr = [pickValue componentsSeparatedByString:@"-"];
                
                return [NSString stringWithFormat:@"%@kg~%@kg",arr[0],arr[1]];
            }
        }
        else
        {
            return [NSString stringWithFormat:@"%@kg",pickValue];
        }
    }
    
    return pickValue;
}

#pragma mark - 获取pick实际值
- (NSString *)ll_getTrueValue:(NSString *)showVaule
{
    //    if ([pickName isEqualToString:kCommonData_Age])
    //    {
    //        if ([showVaule rangeOfString:@"~"].location != NSNotFound)
    //        {
    //            return [showVaule stringByReplacingOccurrencesOfString:@"~" withString:@"-"];
    //        }
    //    }
    if ([pickName isEqualToString:kCommonData_Height])
    {
        if (pickSelect)
        {
            if ([showVaule rangeOfString:@"-"].location != NSNotFound)
            {
                NSArray *array = [showVaule componentsSeparatedByString:@"-"];
                
                NSString *min = array.firstObject;
                
                min = [min substringToIndex:[min rangeOfString:@"cm"].location];
                
                NSString *max = [array objectAtIndex:1];
                
                max = [max substringToIndex:[max rangeOfString:@"cm"].location];
                
                return [NSString stringWithFormat:@"%@-%@", min, max];
            }
        }
        else
        {
            return [showVaule substringToIndex:[showVaule rangeOfString:@"cm"].location];
        }
    }
    if ([pickName isEqualToString:kCommonData_Weight])
    {
        if (pickSelect)
        {
            if ([showVaule rangeOfString:@"-"].location != NSNotFound)
            {
                NSArray *array = [showVaule componentsSeparatedByString:@"-"];
                
                NSString *min = array.firstObject;
                
                min = [min substringToIndex:[min rangeOfString:@"kg"].location];
                
                NSString *max = [array objectAtIndex:1];
                
                max = [max substringToIndex:[max rangeOfString:@"kg"].location];
                
                return [NSString stringWithFormat:@"%@-%@", min, max];
            }
        }
        else
        {
            return [showVaule substringToIndex:[showVaule rangeOfString:@"kg"].location];
        }
    }
//    if ([pickName isEqualToString:kCommonData_Birthday] || [pickName isEqualToString:kCommonData_Birthday1])
//    {
//        NSDate *date = [self dateWithMYDateString:showVaule];
//        
//        return [NSString stringWithFormat:@"%f",[date timeIntervalSince1970]*1000];
//    }
    
    return showVaule;
}

- (NSDate *)dateWithMYDateString:(NSString *)string
{
    NSDate *date = nil;
    
    if ([string length])
    {
        NSArray *components = [string componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"- :"]];
        
        if ([components count] == 3)
        {
            NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
            
            dateComponents.year = [[components objectAtIndex:0] integerValue];
            
            dateComponents.month = [[components objectAtIndex:1] integerValue];
            
            dateComponents.day = [[components objectAtIndex:2] integerValue];
            
            date = [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
        }
    }
    
    return date;
}

#pragma mark - 处理pick确认返回的值
- (NSString *)ll_handlePickValue:(NSArray *)selectedTitles
{
    NSString *result = selectedTitles.firstObject;
    
    if (([pickName isEqualToString:kCommonData_Abode] || [pickName isEqualToString:kCommonData_Workplace] || [pickName isEqualToString:kCommonData_HomeCity] || [pickName isEqualToString:kCommonData_BirthAndCon]) && selectedTitles.count == 2)
    {
        NSString *province = selectedTitles.firstObject;
        
        NSString *city = [selectedTitles objectAtIndex:1];
        
        NSString *text = nil;
        
        if ([province length] && [city length])
        {
            if ([province isEqualToString:city] && ![city isEqualToString:@"吉林"]) {
                text = province;
            }
            else {
                text = [NSString stringWithFormat:@"%@-%@", province, city];
            }
        }
        else if ([province length])
        {
            text = [province copy];
        }
        else if ([city length])
        {
            text = [city copy];
        }
        
        result = text;
        
    }
    if (([pickName isEqualToString:kCommonData_Age] || [pickName isEqualToString:kCommonData_Height] || [pickName isEqualToString:kCommonData_Weight]) && selectedTitles.count == 2)
    {
        NSString *min = selectedTitles.firstObject;
        
        NSString *max = [selectedTitles objectAtIndex:1];
        
        if ([min isEqualToString:@"不限"] || [max isEqualToString:@"不限"])
        {
            result = @"不限";
        }
        else
        {
            result = [NSString stringWithFormat:@"%@-%@", min, max];
        }
    }
    
    return result;
}

#pragma mark - 处理pickDate确认返回的值
- (NSString *)ll_handlePickDateValue:(NSDate *)date
{
    NSString *result = @"";
    
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    
    result = [NSString stringWithFormat:@"%ld-%ld-%ld", (long)dateComponents.year, (long)dateComponents.month, (long)dateComponents.day];
    
    return result;
}

#pragma mark - 判断pick是否是范围选择
- (BOOL)ll_isPickLimit
{
    isNew = NO;
    if (pickSelect && ([pickName isEqualToString:kCommonData_Age] || [pickName isEqualToString:kCommonData_Height] || [pickName isEqualToString:kCommonData_Weight]))
    {
        isNew = YES;
        return YES;
    }
    return NO;
}

#pragma mark - textField委托处理
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([pickName isEqualToString:kCommonData_Nickname] || [pickName isEqualToString:kCommonData_Name] || [pickName isEqualToString:kCommonData_HomeCity])
    {
        if ([string isEqualToString:@" "])
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if ([pickName isEqualToString:kCommonData_Nickname] || [pickName isEqualToString:kCommonData_Name])
    {
        NSInteger textLength = 0;
        
        if ([[textField.textInputMode primaryLanguage] isEqualToString:@"zh-Hans"])
        {
            UITextRange *selectedRange = [textField markedTextRange];
            
            UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
            
            if (!position)
            {
                textLength = [textField.text lengthOfBytesUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
            }
        }
        else
        {
            textLength = [textField.text lengthOfBytesUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
        }
        
        if (textLength > 16)
        {
//            while (textLength > 16)
//            {
//                textField.text = [[textField.text substringToIndex:[textField.text length] - 1] stringRemoveEmoji];
//
//                textLength = [textField.text lengthOfBytesUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
//            }
        }
        else
        {
//            if (![[textField.text stringRemoveEmoji] isEqualToString:textField.text])
//            {
//                textField.text = [textField.text stringRemoveEmoji];
//            }
        }
    }
}

@end
