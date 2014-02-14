//
//  DCCustomExtendedKeyboard.h
//  CustomExtendedKeyboard
//
//  Created by Dan Cohn on 2/14/14.
//  Copyright (c) 2014 Dan Cohn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DCCustomExtendedKeyboard;

@protocol DCCustomExtenedKeyboardProtocol <NSObject>

@optional
- (void)customExtendedKeyboard:(DCCustomExtendedKeyboard *)keyboard didPressKeyAtIndex:(NSUInteger)index;
- (UIFont *)customExtendedKeyboard:(DCCustomExtendedKeyboard *)keyboard fontForKeyAtIndex:(NSUInteger)index;

@end

@interface DCCustomExtendedKeyboard : UIInputView

@property (nonatomic, strong) NSArray *keyList;
@property (nonatomic, assign) NSUInteger buttonPadding; // default 15
@property (nonatomic, assign) BOOL centerButtons; // default NO
@property (nonatomic, weak) id<DCCustomExtenedKeyboardProtocol> keyboardDelegate;

- (instancetype)initWithScrollableView:(BOOL)canScroll;

@end
