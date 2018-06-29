//
//  LLRowPickView.m
//  JoySpell
//
//  Created by linl on 2018/3/26.
//  Copyright © 2018年 xkdao. All rights reserved.
//

#import "LLRowPickView.h"
#import "LLPickTextField.h"

#import "LLRowPickLogic.h"
//#import "UIImageView+WebCache.h"
//#import "LLImagePicker.h"

#define LL_NULLString(string) ((![string isKindOfClass:[NSString class]])||[string isEqualToString:@""] || (string == nil) || [string isEqualToString:@""] || [string isKindOfClass:[NSNull class]]||[[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0)

NSString * const kRowPickKeyName = @"kRowPickKeyName";
NSString * const kRowPickKeyType = @"kRowPickKeyType";
NSString * const kRowPickKeyValue = @"kRowPickKeyValue";
NSString * const kRowPickKeyData = @"kRowPickKeyData";
NSString * const kRowPickKeyHoldText = @"kRowPickKeyHoldText";
NSString * const kRowPickKeyDefaultSelect = @"kRowPickKeyDefaultSelect";
NSString * const kRowPickKeyHasLine = @"kRowPickKeyHasLine";
NSString * const kRowPickKeyHasArrow = @"kRowPickKeyHasArrow";
NSString * const kRowPickKeyHeight = @"kRowPickKeyHeight";
NSString * const kRowPickKeyPickNum = @"kRowPickKeyPickNum";
NSString * const kRowPickKeyIsSelection = @"kRowPickKeyIsSelection";
NSString * const kRowPickKeyEditable = @"kRowPickKeyEditable";
NSString * const kRowPickKeyShowAttrs = @"kRowPickKeyShowAttrs";
NSString * const kRowPickKeyHoldAttrs = @"kRowPickKeyHoldAttrs";

static NSString *kLayerTag = @"layerTag";

@interface LLRowPickView () <UITextFieldDelegate>
{
    CGFloat ll_pickHeight;
    CGFloat ll_pickLeft;
    CGFloat ll_pickRight;
    NSInteger ll_pickNum;
    
    NSString *ll_pickName;
    EnumPickType ll_pickType;
    NSString *ll_pickValue;
    NSArray *ll_pickData;
    NSString *ll_pickHold;
    NSString *ll_pickDefault;
    BOOL ll_pickHasLine;
    BOOL ll_pickHasArrow;
    BOOL ll_pickSelect;
    BOOL ll_pickEditable;
    
    NSDictionary<NSAttributedStringKey, id> *ll_pickShowTextAttr;
    NSDictionary<NSAttributedStringKey, id> *ll_pickHoldTextAttr;
    
    BOOL ll_isNew;
}

@property (nonatomic) UIView *ll_viewRow;

@property (nonatomic) LLPickTextField *ll_pickTextFieldNew;

@property (nonatomic) UIImageView *ll_imgHead;

@property (nonatomic) UIImageView *ll_imgArrow;

@property (nonatomic) UIView *ll_viewLine;

@property (nonatomic) UIButton *ll_btnBackGround;

@property (nonatomic) LLRowPickLogic *ll_pickLogic;

@end

@implementation LLRowPickView

@synthesize ll_paramDic = _ll_paramDic;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void)dealloc
{
    
}

#pragma mark - lazy load

- (LLRowPickLogic *)ll_pickLogic
{
    if (!_ll_pickLogic) {
        _ll_pickLogic = [[LLRowPickLogic alloc] init];
    }
    return _ll_pickLogic;
}

- (UIView *)ll_viewRow
{
    if (!_ll_viewRow) {
        _ll_viewRow = [[UIView alloc] initWithFrame:CGRectMake(ll_pickLeft, 0, 200 - ll_pickLeft - ll_pickRight, ll_pickHeight)];
        [self addSubview:_ll_viewRow];
    }
    return _ll_viewRow;
}

- (UILabel *)ll_lblTitle
{
    if (!_ll_lblTitle) {
        _ll_lblTitle = [[UILabel alloc] init];
        _ll_lblTitle.backgroundColor = [UIColor clearColor];
        _ll_lblTitle.textAlignment = NSTextAlignmentLeft;
        _ll_lblTitle.textColor = [UIColor blackColor];
        _ll_lblTitle.font = [UIFont boldSystemFontOfSize:15];
    }
    return _ll_lblTitle;
}

- (LLPickTextField *)ll_pickTextFieldNew
{
    if (!_ll_pickTextFieldNew) {
        _ll_pickTextFieldNew = [[LLPickTextField alloc] init];
        _ll_pickTextFieldNew.textAlignment = NSTextAlignmentRight;
    }
    return _ll_pickTextFieldNew;
}

- (UIImageView *)ll_imgHead
{
    if (!_ll_imgHead) {
        _ll_imgHead = [[UIImageView alloc] init];
        _ll_imgHead.contentMode = UIViewContentModeScaleAspectFill;
        _ll_imgHead.layer.masksToBounds = YES;
        _ll_imgHead.layer.cornerRadius = 35/2;
        _ll_imgHead.userInteractionEnabled = YES;
    }
    return _ll_imgHead;
}

- (UIImageView *)ll_imgArrow
{
    if (!_ll_imgArrow) {
        _ll_imgArrow = [[UIImageView alloc] initWithFrame:CGRectMake(0, (ll_pickHeight - 12)/2, 20, 12)];
        _ll_imgArrow.contentMode = UIViewContentModeScaleAspectFit;
        _ll_imgArrow.image = [UIImage imageNamed:@"grey_s_arrow"];
    }
    return _ll_imgArrow;
}

- (UIView *)ll_viewLine
{
    if (!_ll_viewLine) {
        _ll_viewLine = [[UIView alloc] init];
        _ll_viewLine.backgroundColor = [UIColor lightGrayColor];
    }
    return _ll_viewLine;
}

- (UIButton *)ll_btnBackGround
{
    if (!_ll_btnBackGround) {
        _ll_btnBackGround = [[UIButton alloc] initWithFrame:self.bounds];
        [_ll_btnBackGround addTarget:self action:@selector(ll_doClickBg) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_ll_btnBackGround];
    }
    return _ll_btnBackGround;
}

- (NSMutableDictionary *)ll_paramDic
{
    if (!_ll_paramDic) {
        _ll_paramDic = [NSMutableDictionary new];
        [_ll_paramDic setObject:@"" forKey:kRowPickKeyName];
        [_ll_paramDic setObject:@(EnumPickType_label) forKey:kRowPickKeyType];
        [_ll_paramDic setObject:@"" forKey:kRowPickKeyValue];
        [_ll_paramDic setObject:@[] forKey:kRowPickKeyData];
        [_ll_paramDic setObject:@"" forKey:kRowPickKeyHoldText];
        [_ll_paramDic setObject:@"" forKey:kRowPickKeyDefaultSelect];
        [_ll_paramDic setObject:@(0) forKey:kRowPickKeyHasLine];
        [_ll_paramDic setObject:@(0) forKey:kRowPickKeyHasArrow];
        [_ll_paramDic setObject:@(0) forKey:kRowPickKeyHeight];
        [_ll_paramDic setObject:@(1) forKey:kRowPickKeyPickNum];
        [_ll_paramDic setObject:@(0) forKey:kRowPickKeyIsSelection];
        [_ll_paramDic setObject:@(1) forKey:kRowPickKeyEditable];
        [_ll_paramDic setObject:@{
                               NSForegroundColorAttributeName:[UIColor blackColor],
                               NSFontAttributeName:[UIFont systemFontOfSize:16]
                               } forKey:kRowPickKeyShowAttrs];
        [_ll_paramDic setObject:@{
                               NSForegroundColorAttributeName:[UIColor lightGrayColor],
                               NSFontAttributeName:[UIFont systemFontOfSize:16]
                               } forKey:kRowPickKeyHoldAttrs];
    }
    return _ll_paramDic;
}

- (void)setLl_paramDic:(NSMutableDictionary *)paramDic
{
    for (NSString *key in paramDic.allKeys)
    {
        [self.ll_paramDic setObject:paramDic[key] forKey:key];
    }
}

#pragma mark - private method

- (void)initData
{
    ll_pickHeight = [self.ll_paramDic[kRowPickKeyHeight] floatValue] > 0 ? [self.ll_paramDic[kRowPickKeyHeight] floatValue] : 70;
    ll_pickLeft = self.ll_edgeInsetsRow.left > 0 ? self.ll_edgeInsetsRow.left : 0;
    ll_pickRight = self.ll_edgeInsetsRow.right > 0 ? self.ll_edgeInsetsRow.right : 0;
    ll_pickNum = [self.ll_paramDic[kRowPickKeyPickNum] integerValue];
    
    ll_pickName = self.ll_paramDic[kRowPickKeyName];
    ll_pickType = [self.ll_paramDic[kRowPickKeyType] integerValue];
    ll_pickValue = [NSString stringWithFormat:@"%@",self.ll_paramDic[kRowPickKeyValue]];
    ll_pickData = self.ll_paramDic[kRowPickKeyData];
    ll_pickHold = self.ll_paramDic[kRowPickKeyHoldText];
    ll_pickDefault = self.ll_paramDic[kRowPickKeyDefaultSelect];
    ll_pickHasLine = [self.ll_paramDic[kRowPickKeyHasLine] boolValue];
    ll_pickHasArrow = [self.ll_paramDic[kRowPickKeyHasArrow] boolValue];
    ll_pickSelect = [self.ll_paramDic[kRowPickKeyIsSelection] boolValue];
    ll_pickEditable = [self.ll_paramDic[kRowPickKeyEditable] boolValue];
    
    ll_pickShowTextAttr = self.ll_paramDic[kRowPickKeyShowAttrs];
    ll_pickHoldTextAttr = self.ll_paramDic[kRowPickKeyHoldAttrs];
    
    ll_isNew = YES;
}

- (void)initSubviews
{
    [self initData];
    
    [self.ll_viewRow addSubview:self.ll_lblTitle];
    if (ll_isNew) {
        [self.ll_viewRow addSubview:self.ll_pickTextFieldNew];
        [self.ll_viewRow addSubview:self.ll_imgHead];
        [self.ll_viewRow addSubview:self.ll_viewLine];
    } else {
//        [self.viewRow addSubview:self.textField];
//        [self.viewRow addSubview:self.pickTextField];
        [self.ll_viewRow addSubview:self.ll_imgHead];
        [self.ll_viewRow addSubview:self.ll_viewLine];
    }
    
    self.frame = CGRectMake(0, 0, 200, CGRectGetMaxY(self.ll_viewRow.frame));
}

- (void)createImageView
{
    if (ll_pickType == EnumPickType_image) {
        self.ll_imgHead.hidden = NO;
//        [self.imgHead sd_setImageWithURL:[NSURL URLWithString:pickValue] placeholderImage:[UIImage imageNamed:@"moren_pic_touxiang"]];
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doImageClick)];
//        [self.imgHead addGestureRecognizer:tap];
        self.ll_btnBackGround.hidden = NO;
    } else {
        self.ll_imgHead.hidden = YES;
    }
}

- (void)createPickViewNew
{
    if (ll_pickType == EnumPickType_image) {
        self.ll_pickTextFieldNew.hidden = YES;
        return;
    }
    self.ll_pickTextFieldNew.hidden = NO;
    
    self.ll_btnBackGround.hidden = ll_pickType == EnumPickType_textfield;
    
    self.ll_pickTextFieldNew.delegate = self;
    
    if (ll_pickType == EnumPickType_pick || ll_pickType == EnumPickType_datePick)
    {
        self.ll_pickTextFieldNew.delegate = nil;
    }
    else if (ll_pickType == EnumPickType_textfield)
    {
        [self.ll_pickTextFieldNew addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    
    self.ll_pickTextFieldNew.ll_isLimit = [self.ll_pickLogic ll_isPickLimit];
    
    self.ll_pickTextFieldNew.font = ll_pickShowTextAttr[NSFontAttributeName];
    self.ll_pickTextFieldNew.textColor = ll_pickShowTextAttr[NSForegroundColorAttributeName];
    self.ll_pickTextFieldNew.attributedPlaceholder = [self.ll_pickLogic ll_attributedStr:ll_pickHold
                                                                     selectText:ll_pickHold
                                                                     selectAttr:ll_pickHoldTextAttr];
    self.ll_pickTextFieldNew.rightViewMode = UITextFieldViewModeAlways;
    if (ll_pickHasArrow) {
        self.ll_pickTextFieldNew.rightView = self.ll_imgArrow;
    } else {
//        self.ll_pickTextFieldNew.rightView = [[UIView alloc] initWithFrame:self.ll_imgArrow.frame];
        self.ll_pickTextFieldNew.rightView = nil;
    }
    self.ll_pickTextFieldNew.enabled = ll_pickEditable;
    
    if (ll_pickType == EnumPickType_label) {
        self.ll_pickTextFieldNew.enabled = NO;
    }
    
    //选择列数
    self.ll_pickTextFieldNew.ll_numberOfComponents = ll_pickNum;
    
    if (!LL_NULLString(ll_pickValue) && ![ll_pickValue isEqualToString:@"0"]) {
        self.ll_pickTextFieldNew.text = [self.ll_pickLogic ll_getShowValue];
    } else {
        self.ll_pickTextFieldNew.text = @"";
    }
    
    self.ll_pickTextFieldNew.ll_type = (EnumPickField)ll_pickType;
    
    NSArray *selectArray = [NSArray new];
    
    if (ll_pickType == EnumPickType_datePick)
    {
        if (!LL_NULLString(ll_pickValue))
        {
            [self.ll_pickTextFieldNew ll_setDataIndexes:@[ll_pickValue]];
        }
    }
    else
    {
        selectArray = ll_pickData.count == 0 ? [self.ll_pickLogic ll_getPickArray] : ll_pickData;
        
        NSArray *indexs = [self.ll_pickLogic ll_getPickIndexs:selectArray];
        
        self.ll_pickTextFieldNew.ll_data = @{@"" : selectArray};
        
        [self.ll_pickTextFieldNew ll_setDataIndexes:indexs];
    }
    
    __weak typeof(self) weakSelf = self;;
    
    self.ll_pickTextFieldNew.ll_pickerCompletion = ^(NSArray *selectedTitles)
    {
        NSString *result = [weakSelf.ll_pickLogic ll_handlePickValue:selectedTitles];
        
        NSString *value = [weakSelf.ll_pickLogic ll_getTrueValue:result];
        
        weakSelf.ll_pickTextFieldNew.text = result;
        
        [weakSelf.ll_paramDic setObject:value forKey:kRowPickKeyValue];
        
        if (weakSelf.ll_resultBlock)
        {
            weakSelf.ll_resultBlock(weakSelf);
        }
    };
}


#pragma mark public method

- (void)ll_updateData
{
    [self initData];
    
    [self.ll_pickLogic ll_initData:self.ll_paramDic];
    
    self.ll_lblTitle.text = ll_pickName;
    
    self.ll_viewLine.hidden = !ll_pickHasLine;
    
    CGFloat widthScreen = [UIScreen mainScreen].bounds.size.width;
    
    CGFloat widthLeft = [self.ll_lblTitle sizeThatFits:CGSizeMake(widthScreen, ll_pickHeight)].width + 10;
    CGFloat widthRight = widthScreen - ll_pickLeft - ll_pickRight - widthLeft;
    
    self.frame = CGRectMake(0, 0, widthScreen, ll_pickHeight);
    self.ll_viewRow.frame = CGRectMake(ll_pickLeft, 0, widthScreen - ll_pickLeft - ll_pickRight, ll_pickHeight);
    self.ll_lblTitle.frame = CGRectMake(0, 0, widthLeft, ll_pickHeight);
    
    if (ll_isNew) {
        self.ll_pickTextFieldNew.frame = CGRectMake(widthLeft, 0, widthRight, ll_pickHeight);
        self.ll_imgHead.frame = CGRectMake(self.ll_viewRow.frame.size.width - (ll_pickHeight - 16) - 15, 8, ll_pickHeight - 16 , ll_pickHeight - 16);
        self.ll_imgHead.layer.cornerRadius = self.ll_imgHead.frame.size.height/2;
        self.ll_viewLine.frame = CGRectMake(0, ll_pickHeight - 1, self.ll_viewRow.frame.size.width, 0.5);
        
        [self createPickViewNew];
        [self createImageView];
    } else {
//        self.textField.frame = CGRectMake(widthLeft, 0, widthRight, pickHeight);
//        self.pickTextField.frame = CGRectMake(widthLeft, 0, widthRight, pickHeight);
//        self.imgHead.frame = CGRectMake(self.viewRow.frame.size.width - 35, 0, 35 , 35);
//        self.viewLine.frame = CGRectMake(0, pickHeight - 10, self.viewRow.frame.size.width, 0.5);
//
//        [self createTextFieldView];
//        [self createPickView];
//        [self createDatePickFieldView];
//        [self createImageView];
    }
}

- (void)ll_updateValue:(NSString *)result value:(NSString *)value
{
    self.ll_pickTextFieldNew.text = result;
    
    [self.ll_paramDic setObject:value forKey:kRowPickKeyValue];
}

#pragma mark - UI

- (void)doImageClick
{

//    UIViewController *vc = self.nim_viewController;
//
//    WEAKSELF
//
//    [[LLImagePicker shareInstance] show:vc complete:^(NSArray<UIImage *> *photos) {
//
//        weakSelf.imgSelect = photos.firstObject;
//        weakSelf.imgHead.image = photos.firstObject;
////        [weakSelf.paramDic setObject:url forKey:kRowPickKeyValue];
//        if (weakSelf.resultBlock)
//        {
//            weakSelf.resultBlock(weakSelf);
//        }
//
//    }];
}

- (void)ll_doClickBg
{
    if (ll_pickType == EnumPickType_label)
    {
        return;
    }
    
    if (ll_pickType == EnumPickType_image)
    {
        [self doImageClick];
        return;
    }
    
    if (ll_pickType == EnumPickType_button)
    {
        if (self.ll_resultBlock)
        {
            self.ll_resultBlock(self);
        }
    }
    else
    {
        [self.ll_pickTextFieldNew ll_doClickBg];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    if (ll_pickType == EnumPickType_button)
    {
        if (self.ll_resultBlock)
        {
            self.ll_resultBlock(self);
        }
        return NO;
    }
    else if (ll_pickType == EnumPickType_textfield)
    {
        [self.ll_pickTextFieldNew ll_addWindowBgView];
    }
    
    return YES;
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return [self.ll_pickLogic textField:textField shouldChangeCharactersInRange:range replacementString:string];
}

- (void)textFieldDidChange:(UITextField *)textField
{
    [self.ll_pickLogic textFieldDidChange:textField];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    //    if (NULLString(textField.text))
    //    {
    //        return;
    //    }
    if (!LL_NULLString(ll_pickValue) && [ll_pickValue isEqualToString:textField.text])
    {
        return;
    }
    
    [self.ll_paramDic setObject:textField.text forKey:kRowPickKeyValue];
    
    NSLog(@"key:%@,value:%@",ll_pickName,textField.text);
    
    if (self.ll_resultBlock)
    {
        self.ll_resultBlock(self);
    }
}

#pragma mark - 示例
- (void)createRow
{
    //参数作用看.h
    LLRowPickView *pick = [[LLRowPickView alloc] init];
    
    NSMutableDictionary *dic = [NSMutableDictionary new];
    
    [dic setObject:@(47) forKey:kRowPickKeyHeight];
    
    [dic setObject:@"昵称" forKey:kRowPickKeyName];
    
    [dic setObject:@(EnumPickType_textfield) forKey:kRowPickKeyType];
    
    [dic setObject:@"昵称值" forKey:kRowPickKeyValue];
    //pick类型用，两列的选择自行在createPickView方法中修改
    [dic setObject:@[@"1",@"2"] forKey:kRowPickKeyData];
    
    [dic setObject:@"请填写" forKey:kRowPickKeyHoldText];
    
    [dic setObject:@"pick或date类型用的默认选择" forKey:kRowPickKeyDefaultSelect];
    //就1，2可选
    [dic setObject:@(2) forKey:kRowPickKeyPickNum];
    
    [dic setObject:@{
                     NSForegroundColorAttributeName:[UIColor blackColor],
                     NSFontAttributeName:[UIFont systemFontOfSize:15]
                     } forKey:kRowPickKeyShowAttrs];
    
    [dic setObject:@{
                     NSForegroundColorAttributeName:[UIColor blackColor],
                     NSFontAttributeName:[UIFont systemFontOfSize:15]
                     } forKey:kRowPickKeyHoldAttrs];
    
    pick.ll_paramDic = dic;
    
    pick.ll_edgeInsetsRow = UIEdgeInsetsMake(0, 25, 0, 25);
    
    [pick ll_updateData];
    
    pick.ll_lblTitle.font = [UIFont systemFontOfSize:15];
    
    pick.ll_resultBlock = ^(LLRowPickView *row) {
        
        //获取填写或者选择的值
        //        NSString *str = row.paramDic[kRowPickKeyValue];
        
    };
}

@end
