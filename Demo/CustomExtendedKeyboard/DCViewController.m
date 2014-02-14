//
//  DCViewController.m
//  CustomExtendedKeyboard
//
//  Created by Dan Cohn on 2/14/14.
//  Copyright (c) 2014 Dan Cohn. All rights reserved.
//

#import "DCViewController.h"
#import "DCCustomExtendedKeyboard.h"

@interface DCViewController () <DCCustomExtenedKeyboardProtocol>

@property (nonatomic, strong) UITextField *textField;

@end

@implementation DCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/2, 30)];
    self.textField.center = CGPointMake(self.view.frame.size.width/2, 60);
    self.textField.borderStyle = UITextBorderStyleLine;
    self.textField.placeholder = @"Add text here";
    
    DCCustomExtendedKeyboard *keyboard = [[DCCustomExtendedKeyboard alloc] initWithScrollableView:YES];
    // Delegate must be specified before keyList if using custom font delegate
    keyboard.keyboardDelegate = self;
    keyboard.keyList = @[ @"Q", @"W", @"E", @"ABCDEF", [UIImage imageNamed:@"LeftArrow"], [UIImage imageNamed:@"RightArrow"]];
    keyboard.buttonPadding = 10;
    keyboard.centerButtons = YES;
    
    self.textField.inputAccessoryView = keyboard;
    [self.view addSubview:self.textField];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.textField becomeFirstResponder];
}

- (void)customExtendedKeyboard:(DCCustomExtendedKeyboard *)keyboard didPressKeyAtIndex:(NSUInteger)index
{
    switch (index) {
        case 0:
            self.textField.text = [self.textField.text stringByAppendingString:@"Q"];
            break;
            
        case 1:
            self.textField.text = [self.textField.text stringByAppendingString:@"W"];
            break;
            
        case 2:
            self.textField.text = [self.textField.text stringByAppendingString:@"E"];
            break;
            
        case 3:
            self.textField.text = [self.textField.text stringByAppendingString:@"ABCDEF"];
            break;
            
        default:
            break;
    }
}

- (UIFont *)customExtendedKeyboard:(DCCustomExtendedKeyboard *)keyboard fontForKeyAtIndex:(NSUInteger)index
{
    return nil;
}

@end
