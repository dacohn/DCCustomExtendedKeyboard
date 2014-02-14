//
//  DCCustomExtendedKeyboard.m
//  CustomExtendedKeyboard
//
//  Created by Dan Cohn on 2/14/14.
//  Copyright (c) 2014 Dan Cohn. All rights reserved.
//

#import "DCCustomExtendedKeyboard.h"

#define DCKeyboardTopBuffer 2

@interface DCCustomExtendedKeyboard ()

@property (nonatomic, strong) UIScrollView *keyContainer;
@property (nonatomic, strong) NSMutableArray *buttonList;

@end

@implementation DCCustomExtendedKeyboard

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (instancetype)initWithScrollableView:(BOOL)canScroll
{
    self = [super initWithFrame:CGRectZero inputViewStyle:UIInputViewStyleKeyboard];

    if ( self )
    {
        CGRect frame = self.frame;
        frame.size.height = 40 + DCKeyboardTopBuffer;
        self.frame = frame;
        
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.scrollEnabled = canScroll;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.alwaysBounceHorizontal = YES;
        scrollView.alwaysBounceVertical = NO;
        scrollView.backgroundColor = [UIColor clearColor];
        
        [self addSubview:scrollView];
        
        _keyContainer = scrollView;
        _buttonList = [[NSMutableArray alloc] init];
        _buttonPadding = 15;
        _centerButtons = NO;
    }
    
    return self;
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    // Put half padding in front of buttons
    CGFloat x = self.buttonPadding / 2;
    
    // Figure out button size
    // TODO: Fix for iPad
    for ( UIButton *button in self.buttonList )
    {
        CGRect frame = button.frame;
        frame.origin.x = x;
        
        CGFloat textSize = button.titleLabel.text.length * 15 + 15; //[button.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:button.titleLabel.font}].width;
        CGFloat imageSize = button.imageView.image.size.width + 20;
        
        CGFloat buttonWidth = MAX(textSize, imageSize);
                
        frame.size = CGSizeMake(buttonWidth, button.currentBackgroundImage.size.height);
        button.frame = frame;

        x += buttonWidth + self.buttonPadding;
    }
    
    // Put half padding behind buttons
    x -= (self.buttonPadding/2);
    
    CGRect frame = self.frame;
    frame.origin.y = DCKeyboardTopBuffer;
    frame.size.height -= DCKeyboardTopBuffer;
    self.keyContainer.contentSize = CGSizeMake(MAX(x, frame.size.width), frame.size.height);
    self.keyContainer.frame = frame;
    
    // If buttons should be centered and there are not enough to fill the width of the frame,
    // then figure out how much padding there needs to be on the left and add that to
    // each button's origin
    if ( self.centerButtons && x < self.frame.size.width )
    {
        CGFloat leftPadding = (self.frame.size.width - x) / 2;
        for ( UIButton *button in self.buttonList )
        {
            frame = button.frame;
            frame.origin.x += leftPadding;
            button.frame = frame;
        }

        self.keyContainer.contentSize = CGSizeMake(self.keyContainer.contentSize.width+leftPadding, self.keyContainer.contentSize.height);
    }
}

- (void)setKeyList:(NSArray *)keyList
{
    for ( UIView *subview in [self.keyContainer subviews] )
    {
        [subview removeFromSuperview];
    }
    
    [self.buttonList removeAllObjects];
    
    for ( id item in keyList )
    {
        UIButton *button = nil;
        if ( [item isKindOfClass:[NSString class]] )
        {
            button = [self createButtonWithText:item];
        }
        else if ( [item isKindOfClass:[UIImage class]] )
        {
            button = [self createButtonWithImage:item];
        }
        
        if ( button )
        {
            [self.keyContainer addSubview:button];
            [self.buttonList addObject:button];
        }
    }
}

- (void)keyDown:(id)sender
{
    [[UIDevice currentDevice] playInputClick];
}

- (void)keyUp:(id)sender
{
    if ( self.keyboardDelegate && [self.keyboardDelegate respondsToSelector:@selector(customExtendedKeyboard:didPressKeyAtIndex:)] )
    {
        NSUInteger index = [self.buttonList indexOfObject:sender];
        if ( index != NSNotFound )
        {
            [self.keyboardDelegate customExtendedKeyboard:self didPressKeyAtIndex:index];
        }
    }
}

- (UIButton *)createButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *background = [UIImage imageNamed:@"blankKey"];
    background = [background resizableImageWithCapInsets:UIEdgeInsetsMake(20, 18, 20, 18)];
    [button setBackgroundImage:background forState:UIControlStateNormal];
    [button addTarget:self action:@selector(keyDown:) forControlEvents:UIControlEventTouchDown];
	[button addTarget:self action:@selector(keyUp:) forControlEvents:UIControlEventTouchUpInside];
    button.accessibilityTraits = UIAccessibilityTraitPlaysSound | UIAccessibilityTraitKeyboardKey;
    return button;
}

- (UIButton *)createButtonWithText:(NSString *)text
{
    UIButton *button = [self createButton];
    [button setTitle:text forState:UIControlStateNormal];
    [button setTitle:text forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    UIFont *font = nil;
    if ( self.keyboardDelegate && [self.keyboardDelegate respondsToSelector:@selector(customExtendedKeyboard:fontForKeyAtIndex:)] )
    {
        // self.buttonList shouldn't have this button yet, so use the count for the index of this button
        font = [self.keyboardDelegate customExtendedKeyboard:self fontForKeyAtIndex:self.buttonList.count];
    }
    if ( font == nil )
    {
        font = [UIFont fontWithName:@"HelveticaNeue-Light" size:22];
    }
    button.titleLabel.font = font;
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    return button;
}

- (UIButton *)createButtonWithImage:(UIImage *)image
{
    UIButton *button = [self createButton];
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:image forState:UIControlStateHighlighted];
    return button;
}

@end
