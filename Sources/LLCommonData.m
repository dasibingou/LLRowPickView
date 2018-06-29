//
//  LLCommonData.m
//  JoySpell
//
//  Created by linl on 2018/3/26.
//  Copyright © 2018年 xkdao. All rights reserved.
//

#import "LLCommonData.h"

@implementation LLCommonData

+ (NSArray *)getAgeNew
{
    NSMutableArray *minAges = [[NSMutableArray alloc] init];
    
    for (int i = 17; i <= 100; i ++) {
        
        NSString *iString = i == 17 ? @"不限" : [NSString stringWithFormat:@"%d", i];
        
        [minAges addObject:iString];
    }
    
    return [minAges copy];
}

+ (NSArray *)getHeightNew:(BOOL)select
{
    NSMutableArray *heights = [[NSMutableArray alloc] init];
    
    for (int i = 139; i <= 200; i ++)
    {
        NSString *iString = [NSString stringWithFormat:@"%dcm", i];
        
        if (i == 139)
        {
            if (select)
            {
                iString = @"不限";
            }
            else
            {
                continue;
            }
        }
        
        [heights addObject:iString];
    }
    return [heights copy];
}

+ (NSArray *)getWeightNew:(BOOL)select
{
    NSMutableArray *weights = [[NSMutableArray alloc] init];
    
    for (int i = 29; i <= 200; i ++)
    {
        NSString *iString = [NSString stringWithFormat:@"%dkg", i];
        
        if (i == 29)
        {
            if (select)
            {
                iString = @"不限";
            }
            else
            {
                continue;
            }
        }
        
        [weights addObject:iString];
    }
    return [weights copy];
}

+ (NSArray *)getAge
{
    NSMutableArray *minAges = [[NSMutableArray alloc] init];
    
    for (int i = 18; i <= 100; i ++) {
        
        NSMutableArray *maxAges = [[NSMutableArray alloc] init];
        
        for (int j = i; j <= 100; j++)
        {
            NSString *iString = [NSString stringWithFormat:@"%d", j];
            
            [maxAges addObject:iString];
        }
        
        NSString *iString = nil;
        
        NSMutableDictionary *agesDic = [NSMutableDictionary dictionary];
        
//        if (i == 17) {
//
//            iString = @"不限";
//
//            [agesDic setValue:@[@""] forKey:iString];
//
//        }else {
        
            iString = [NSString stringWithFormat:@"%d", i];
            
            [agesDic setValue:maxAges forKey:iString];
            
//        }
        
        [minAges addObject:agesDic];
    }
    
    return [minAges copy];
}

+ (NSArray *)getHeight:(BOOL)select
{
    if (select)
    {
        NSMutableArray *minHeights = [[NSMutableArray alloc] init];
        
        for (int i = 139; i <= 200; i ++) {
            
            NSMutableArray *maxHeights = [[NSMutableArray alloc] init];
            
            for (int j = i; j <= 200; j ++) {
                
                NSString *iString = [NSString stringWithFormat:@"%dcm", j];
                
                [maxHeights addObject:iString];
                
            }
            
            NSString *iString = nil;
            
            NSMutableDictionary *heightsDic = [NSMutableDictionary dictionary];
            
            if (i == 139) {
                
                iString = @"不限";
                
                [heightsDic setValue:@[@""] forKey:iString];
                
            }else {
                
                iString = [NSString stringWithFormat:@"%dcm", i];
                
                [heightsDic setValue:maxHeights forKey:iString];
                
            }
            
            [minHeights addObject:heightsDic];
            
        }
        return [minHeights copy];
    }
    else
    {
        NSMutableArray *heights = [[NSMutableArray alloc] init];
        
        for (int i = 140; i <= 200; i ++)
        {
            NSString *iString = [NSString stringWithFormat:@"%dcm", i];
            
            [heights addObject:iString];
        }
        return [heights copy];
    }
}

+ (NSArray *)getWeight:(BOOL)select
{
    if (select)
    {
        NSMutableArray *minWeights = [[NSMutableArray alloc] init];
        
        for (int i = 29; i <= 200; i ++)
        {
            NSMutableArray *maxWeights = [[NSMutableArray alloc] init];
            
            for (int j = i; j <= 200; j ++)
            {
                NSString *iString = [NSString stringWithFormat:@"%dkg", j];
                
                [maxWeights addObject:iString];
            }
            
            NSString *iString = nil;
            
            NSMutableDictionary *agesDic = [NSMutableDictionary dictionary];
            
            if (i == 29) {
                
                iString = @"不限";
                
                [agesDic setValue:@[@""] forKey:iString];
                
            }else {
                
                iString = [NSString stringWithFormat:@"%dkg", i];
                
                [agesDic setValue:maxWeights forKey:iString];
                
            }
            
            [minWeights addObject:agesDic];
            
        }
        return [minWeights copy];
    }
    else
    {
        NSMutableArray *weights = [[NSMutableArray alloc] init];
        
        for (int i = 30; i <= 200; i ++)
        {
            NSString *iString = [NSString stringWithFormat:@"%dkg", i];
            
            [weights addObject:iString];
        }
        return [weights copy];
    }
    
}

+ (NSArray *)getIncome:(BOOL)select
{
    return select ? @[@"不限",@"10W以下", @"10W~20W", @"20W~30W", @"30W~50W", @"50W~100W", @"100W以上"] : @[@"10W以下", @"10W~20W", @"20W~30W", @"30W~50W", @"50W~100W", @"100W以上"];
}

+ (NSArray *)getExpectedMarriageTime:(BOOL)select
{
    return select ? @[@"不限", @"半年内", @"一年内", @"两年内"] : @[@"半年内", @"一年内", @"两年内"];
}

+ (NSArray *)getAbode:(BOOL)select
{
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    [dataArray addObjectsFromArray:[[[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"scity" ofType:@"plist"]] mutableCopy]];
    
    if (!dataArray.count)
    {
        return [dataArray copy];
    }
    
    if (!select)
    {
        [dataArray removeObjectAtIndex:0];
    }
    else
    {
        NSArray *provinces = [dataArray copy];
        
        NSMutableArray *newProvinces = [[NSMutableArray alloc] initWithArray:provinces];
        
        for (int i = 0; i < [provinces count]; i ++)
        {
            NSDictionary *provinceT = [provinces objectAtIndex:i];
            
            NSArray *cities = [[provinceT allValues] firstObject];
            
            if ([[cities firstObject] length] > 0)
            {
                NSString *proviceName = [[provinceT allKeys] firstObject];
                
                NSMutableArray *newCities = [[NSMutableArray alloc] init];
                
                NSString *charteredCities = [[provinceT allKeys] firstObject];
                
                NSArray *charteredCitiesArray = @[@"北京", @"上海", @"天津", @"重庆"];
                
                NSString *tagString = [charteredCitiesArray containsObject:charteredCities] ? @"全市" : @"全省";
                
                [newCities addObject:tagString];
                
                [newCities addObjectsFromArray:cities];
                
                provinceT = [[NSDictionary alloc] initWithObjectsAndKeys:newCities, proviceName, nil];
                
                [newProvinces replaceObjectAtIndex:i withObject:provinceT];
            }
        }
        return [newProvinces copy];
    }
    
    return [dataArray copy];
}

+ (NSArray *)getNation:(BOOL)select
{
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    [dataArray addObjectsFromArray:[[[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"nation" ofType:@"plist"]] mutableCopy]];
    
    if (!select) {
        [dataArray removeObjectAtIndex:0];
    }
    
    return [dataArray copy];
}

+ (NSArray *)getMaritalStatus:(BOOL)select
{
    return select ? @[@"不限", @"离异", @"从未结婚"] : @[@"离异", @"丧偶", @"从未结婚"];
}

+ (NSArray *)getFaith:(BOOL)select
{
    return select ? @[@"不限",@"无信仰", @"马列主义", @"基督徒", @"佛教徒", @"道教", @"伊斯兰教", @"其他"] : @[@"无信仰", @"马列主义", @"基督徒", @"佛教徒", @"道教", @"伊斯兰教", @"其他"];
}

+ (NSArray *)getPotation:(BOOL)select
{
    return select ? @[@"不限",@"从不", @"有时", @"经常", @"看应酬的需要"] : @[@"从不", @"有时", @"经常", @"看应酬的需要"];
}

+ (NSArray *)getSmoke:(BOOL)select
{
    return select ? @[@"不限",@"从不", @"偶尔", @"看应酬的需要", @"经常"] : @[@"从不", @"偶尔", @"看应酬的需要", @"经常"];
}

+ (NSArray *)getChildrenStauts:(BOOL)select
{
    return select ? @[@"不限", @"有", @"没有"] : @[@"有", @"没有"];
}

+ (NSArray *)getBirthAndCon:(BOOL)select
{
    NSMutableArray *min = [[NSMutableArray alloc] init];
    
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
    NSInteger year = dateComponents.year;
    NSInteger from = year - (select ? 80 : 60);
    NSInteger to = year - 18;
    
    for (NSInteger i = from; i <= to; i ++)
    {
        NSArray *max = [LLCommonData getConstellation:YES];
        
        NSString *iString = [NSString stringWithFormat:@"%ld", i];
        
        NSDictionary *dic = @{iString:max};
        
        [min addObject:dic];
        
    }
    
    return [min copy];
}

+ (NSArray *)getConstellation:(BOOL)select
{
    return @[@"摩羯座", @"水瓶座", @"双鱼座", @"白羊座", @"金牛座", @"双子座", @"巨蟹座", @"狮子座", @"处女座", @"天秤座", @"天蝎座", @"射手座"];
}

+ (NSArray *)getZhaoBei:(BOOL)select
{
    return @[@"A 小巧玲珑",@"B XXXX",@"C大小正好",@"D XXXX",@"E XXXX",@"F XXXX",@"G 波涛汹涌"];
}

@end
