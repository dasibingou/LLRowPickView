//
//  LLPickTextField.m
//  JoySpell
//
//  Created by linl on 2018/3/26.
//  Copyright © 2018年 xkdao. All rights reserved.
//

#import "LLPickTextField.h"

@interface LLPickTextField () <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic) UIPickerView *pvMain;

@property (nonatomic) UIDatePicker *dpMain;

@property (nonatomic) UIView *viewAccessory;

@property (nonatomic) UIButton *btnWindow;

@property (nonatomic) NSMutableArray *selectedIndexes;

@property (nonatomic) NSMutableArray *initialIndexes;

@end

@implementation LLPickTextField

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
    }
    return self;
}

#pragma mark - lazy load

- (void)setLl_type:(EnumPickField)type
{
    _ll_type = type;
    
    self.inputView = nil;
    
    self.inputAccessoryView = self.viewAccessory;
    
    [[self valueForKey:@"textInputTraits"] setValue:[UIColor blueColor] forKey:@"insertionPointColor"];
    
    if (type == EnumPickField_pickview)
    {
        [[self valueForKey:@"textInputTraits"] setValue:[UIColor clearColor] forKey:@"insertionPointColor"];
    }
    else if (type == EnumPickField_datepick)
    {
        [[self valueForKey:@"textInputTraits"] setValue:[UIColor clearColor] forKey:@"insertionPointColor"];
    }
}

- (UIPickerView *)pvMain
{
    if (!_pvMain) {
        _pvMain = [[UIPickerView alloc] init];
        _pvMain.backgroundColor = HEXCOLOR(0xf5f5f5);
        _pvMain.delegate = self;
        _pvMain.dataSource = self;
    }
    return _pvMain;
}

- (UIDatePicker *)dpMain
{
    if (!_dpMain) {
        _dpMain = [[UIDatePicker alloc] init];
        _dpMain.datePickerMode = UIDatePickerModeDate;
        NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
        NSInteger year = dateComponents.year;
        NSDateComponents *fromDateComponents = [[NSDateComponents alloc] init];
        fromDateComponents.year = year - 100;
        NSDateComponents *toDateComponents = [[NSDateComponents alloc] init];
        toDateComponents.year = year - 18;
        NSDateComponents *defaultDateComponents = [[NSDateComponents alloc] init];
        defaultDateComponents.year = year - 25;
        _dpMain.minimumDate = [[NSCalendar currentCalendar] dateFromComponents:fromDateComponents];
        _dpMain.maximumDate = [[NSCalendar currentCalendar] dateFromComponents:toDateComponents];
    }
    return _dpMain;
}

- (UIView *)viewAccessory
{
    if (!_viewAccessory) {
        _viewAccessory = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
        _viewAccessory.backgroundColor = [UIColor whiteColor];
        
        UIButton *cancel = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
        cancel.titleLabel.font = [UIFont systemFontOfSize:16];
        [cancel setTitleColor:BASE_COLOR_RED forState:UIControlStateNormal];
        [cancel setTitle:@"取消" forState:UIControlStateNormal];
        [cancel addTarget:self action:@selector(doAccessoryCancel) forControlEvents:UIControlEventTouchUpInside];
        [_viewAccessory addSubview:cancel];
        
        UIButton *ok = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 80, 0, 80, 44)];
        ok.titleLabel.font = [UIFont systemFontOfSize:16];
        [ok setTitleColor:BASE_COLOR_RED forState:UIControlStateNormal];
        [ok setTitle:@"确定" forState:UIControlStateNormal];
        [ok addTarget:self action:@selector(doAccessoryOk) forControlEvents:UIControlEventTouchUpInside];
        [_viewAccessory addSubview:ok];
    }
    return _viewAccessory;
}

- (UIButton *)btnWindow
{
    if (!_btnWindow) {
        _btnWindow = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnWindow.frame = self.window.frame;
        _btnWindow.backgroundColor = [UIColor colorWithRed:1/255.0 green:1/255.0 blue:1/255.0 alpha:1];
        [_btnWindow addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self.window addSubview:_btnWindow];
    }
    return _btnWindow;
}

- (NSMutableArray *)selectedIndexes
{
    if (!_selectedIndexes) {
        _selectedIndexes = [[NSMutableArray alloc] init];
    }
    return _selectedIndexes;
}

- (NSMutableArray *)initialIndexes
{
    if (!_initialIndexes) {
        _initialIndexes = [[NSMutableArray alloc] init];
    }
    return _initialIndexes;
}

#pragma mark - private method
- (void)initSubviews
{
    //    [[self valueForKey:@"textInputTraits"] setValue:[UIColor clearColor] forKey:@"insertionPointColor"];
}

- (void)showPickView
{
    [self ll_addWindowBgView];
    
    self.inputView = self.pvMain;
    
    //    self.inputAccessoryView = self.viewAccessory;
    
    [self becomeFirstResponder];
    
    if ([self.selectedIndexes count])
    {
        for (int i = 0; i < [self.selectedIndexes count]; i ++)
        {
            NSNumber *indexNumber = [self.selectedIndexes objectAtIndex:i];
            
            if (i == [self.selectedIndexes count] - 1)
            {
                [self.pvMain reloadComponent:i];
            }
            
            [self.pvMain selectRow:[indexNumber integerValue] inComponent:i animated:NO];
        }
    }
}

- (void)showPickDateView
{
    [self ll_addWindowBgView];
    
    self.inputView = self.dpMain;
    
    //    self.inputAccessoryView = self.viewAccessory;
    
    [self becomeFirstResponder];
    
    if ([self.selectedIndexes count])
    {
        self.dpMain.date = [self dateWithMYDateString:self.selectedIndexes.firstObject];
    }
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

- (void)handleResult
{
    if (self.ll_pickerCompletion)
    {
        NSMutableArray *texts = [[NSMutableArray alloc] init];
        
        if (self.ll_type == EnumPickField_pickview)
        {
            NSArray *data = (NSArray *)[[self.ll_data allValues] firstObject];
            
            NSInteger index = [self.selectedIndexes.firstObject integerValue];
            
            if (self.ll_isLimit)
            {
                if (index == 0)
                {
                    [texts addObject:@"不限"];
                    
                    [texts addObject:@"不限"];
                }
                else
                {
                    [texts addObject:data[index]];
                    
                    NSInteger index1 = [self.selectedIndexes[1] integerValue];
                    
                    NSArray *array = [self getLimitArray];
                    
                    [texts addObject:array[index1]];
                }
            }
            else
            {
                if (self.ll_numberOfComponents == 1)
                {
                    NSString *first = data[index];
                    
                    [texts addObject:first];
                }
                else
                {
                    NSInteger index1 = [self.selectedIndexes[1] integerValue];
                    
                    NSString *first = [data[index] allKeys].firstObject;
                    
                    NSDictionary *dic = (NSDictionary *)data[index];
                    
                    NSArray *array = (NSArray *)[[dic allValues] firstObject];
                    
                    NSString *second = array[index1];
                    
                    [texts addObject:first];
                    
                    [texts addObject:second];
                }
            }
            
            
        }
        else
        {
            NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self.dpMain.date];
            
            NSString *result = [NSString stringWithFormat:@"%ld-%ld-%ld", (long)dateComponents.year, (long)dateComponents.month, (long)dateComponents.day];
            
            [texts addObject:result];
        }
        self.ll_pickerCompletion(texts);
    }
}

- (NSArray *)getLimitArray
{
    NSInteger index = [self.selectedIndexes.firstObject integerValue];
    
    if (index == 0)
    {
        return [[NSArray alloc] init];
    }
    
    NSArray *data = (NSArray *)[[self.ll_data allValues] firstObject];
    
    NSArray *array = [data subarrayWithRange:NSMakeRange(index, data.count - index)];
    
    return array;
}

#pragma mark - public method
- (void)ll_setDataIndexes:(NSArray *)indexes
{
    if ([indexes count])
    {
        [self.initialIndexes setArray:indexes];
        
        [self.selectedIndexes setArray:indexes];
    }
}

- (void)ll_addWindowBgView
{
    [self.window addSubview:self.btnWindow];
    self.btnWindow.alpha = 0;
    [UIView animateWithDuration:0.25f animations:^{
        self.btnWindow.alpha = 0.5;
    }];
    
}

- (void)ll_removeWindowBgView
{
    [UIView animateWithDuration:0.25f animations:^{
        self.btnWindow.alpha = 0;
    } completion:^(BOOL finished) {
        [self.btnWindow removeFromSuperview];
    }];
}

#pragma mark - event
- (void)doAccessoryCancel
{
    [self endEditing:YES];
    [self ll_removeWindowBgView];
    if (self.ll_type == EnumPickField_pickview || self.ll_type == EnumPickField_datepick) {
        [self.selectedIndexes setArray:self.initialIndexes];
    }
}

- (void)doAccessoryOk
{
    [self endEditing:YES];
    [self ll_removeWindowBgView];
    if (self.ll_type == EnumPickField_pickview || self.ll_type == EnumPickField_datepick) {
        [self handleResult];
    }
}

- (void)ll_doClickBg
{
    if (self.ll_type == EnumPickField_pickview)
    {
        [self showPickView];
    }
    else if (self.ll_type == EnumPickField_datepick)
    {
        [self showPickDateView];
    }
}

- (void)buttonPressed
{
    [self endEditing:YES];
    [self.selectedIndexes setArray:self.initialIndexes];
    [self ll_removeWindowBgView];
}

#pragma mark - UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return self.ll_numberOfComponents;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger number = 0;
    
    NSArray *data = (NSArray *)[[self.ll_data allValues] firstObject];
    
    if (component == 0)
    {
        number = [data count];
    }
    else
    {
        if (self.ll_isLimit)
        {
            NSArray *array = [self getLimitArray];
            
            number = array.count;
        }
        else
        {
            NSInteger index = [self.selectedIndexes.firstObject integerValue];
            
            if ([data[index] isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *dic = (NSDictionary *)data[index];
                
                number = [[[dic allValues] firstObject] count];
            }
            else if ([data[index] isKindOfClass:[NSString class]])
            {
                number = [data count];
            }
        }
    }
    
    return number;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title = nil;
    
    NSArray *data = (NSArray *)[[self.ll_data allValues] firstObject];
    
    if (self.ll_isLimit)
    {
        if (component == 0)
        {
            title = data[row];
        }
        else
        {
            NSArray *array = [self getLimitArray];
            
            title = array[row];
        }
    }
    else
    {
        if (self.ll_numberOfComponents == 1)
        {
            title = data[row];
        }
        else
        {
            if (component == 0)
            {
                title = [data[row] allKeys].firstObject;
            }
            else
            {
                NSInteger index = [self.selectedIndexes.firstObject integerValue];
                
                if ([data[index] isKindOfClass:[NSDictionary class]])
                {
                    NSDictionary *dic = (NSDictionary *)data[index];
                    
                    NSArray *array = (NSArray *)[[dic allValues] firstObject];
                    
                    title = array[row];
                }
                else if ([data[index] isKindOfClass:[NSString class]])
                {
                    title = data[row];
                }
            }
        }
    }
    
    return title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self.selectedIndexes replaceObjectAtIndex:component withObject:[NSNumber numberWithInteger:row]];
    
    if (component < self.ll_numberOfComponents - 1)
    {
        [self.selectedIndexes replaceObjectAtIndex:component + 1 withObject:[NSNumber numberWithInteger:0]];
        
        [pickerView reloadComponent:component + 1];
        
        if ([pickerView selectedRowInComponent:component + 1])
        {
            for (int i = 0; i < [self.selectedIndexes count]; i ++)
            {
                NSNumber *indexNumber = [self.selectedIndexes objectAtIndex:i];
                
                [pickerView selectRow:[indexNumber integerValue] inComponent:i animated:NO];
            }
        }
    }
}

#pragma mark - UITextFieldDelegate
- (CGRect)editingRectForBounds:(CGRect)bounds
{
    CGRect originalRect = [super editingRectForBounds:bounds];
    
    CGRect rect = CGRectMake(originalRect.origin.x + self.ll_edgeInsets.left, originalRect.origin.y + self.ll_edgeInsets.top, originalRect.size.width - self.ll_edgeInsets.left - self.ll_edgeInsets.right, originalRect.size.height - self.ll_edgeInsets.top - self.ll_edgeInsets.bottom);
    
    return rect;
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
    CGRect originalRect = [super textRectForBounds:bounds];
    
    CGRect rect = CGRectMake(originalRect.origin.x + self.ll_edgeInsets.left, originalRect.origin.y + self.ll_edgeInsets.top, originalRect.size.width - self.ll_edgeInsets.left - self.ll_edgeInsets.right, originalRect.size.height - self.ll_edgeInsets.top - self.ll_edgeInsets.bottom);
    
    return rect;
}

@end
