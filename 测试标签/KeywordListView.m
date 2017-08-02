//
//  KeywordListView.m
//  测试标签
//
//  Created by Yutian Duan on 16/6/30.
//  Copyright © 2016年 Yutian Duan. All rights reserved.
//

#import "KeywordListView.h"

#ifndef CORNER_RADIUS
#define CORNER_RADIUS 10.0f
#endif

#define LABEL_MARGIN_DEFAULT 5.0f
#define BOTTOM_MARGIN_DEFAULT 5.0f
#define FONT_SIZE_DEFAULT 13.0f
#define HORIZONTAL_PADDING_DEFAULT 7.0f
#define VERTICAL_PADDING_DEFAULT 3.0f
#define BACKGROUND_COLOR [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.00]
#define TEXT_COLOR [UIColor blackColor]
#define TEXT_SHADOW_COLOR [UIColor whiteColor]
#define TEXT_SHADOW_OFFSET CGSizeMake(0.0f, 1.0f)
#define BORDER_COLOR [UIColor lightGrayColor]

#ifndef BORDER_WIDTH
#define BORDER_WIDTH 1.0f
#endif

#define HIGHLIGHTED_BACKGROUND_COLOR [UIColor colorWithRed:0.40 green:0.80 blue:1.00 alpha:0.5]
#define DEFAULT_AUTOMATIC_RESIZE NO
#define DEFAULT_SHOW_TAG_MENU NO

@interface KeywordListView () <KeywordTagViewDelegate>

@end

@implementation KeywordListView

- (instancetype)init {
  self = [super init];
  if (self) {
    [self addSubview:_containerView];
    [self setClipsToBounds:YES];
    self.automaticResize = DEFAULT_AUTOMATIC_RESIZE;
    self.highlightedBackgroundColor = HIGHLIGHTED_BACKGROUND_COLOR;
    self.font = [UIFont systemFontOfSize:FONT_SIZE_DEFAULT];
    self.labelMargin = LABEL_MARGIN_DEFAULT;
    self.bottomMargin = BOTTOM_MARGIN_DEFAULT;
    self.horizontalPadding = HORIZONTAL_PADDING_DEFAULT;
    self.verticalPadding = VERTICAL_PADDING_DEFAULT;
    self.cornerRadius = CORNER_RADIUS;
    self.borderColor = BORDER_COLOR;
    self.borderWidth = BORDER_WIDTH;
    self.textColor = TEXT_COLOR;
    self.textShadowColor = TEXT_SHADOW_COLOR;
    self.textShadowOffset = TEXT_SHADOW_OFFSET;
    self.showTagMenu = DEFAULT_SHOW_TAG_MENU;
  }
  return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    [self addSubview:_containerView];
    [self setClipsToBounds:YES];
    self.highlightedBackgroundColor = HIGHLIGHTED_BACKGROUND_COLOR;
    self.font = [UIFont systemFontOfSize:FONT_SIZE_DEFAULT];
    self.labelMargin = LABEL_MARGIN_DEFAULT;
    self.bottomMargin = BOTTOM_MARGIN_DEFAULT;
    self.horizontalPadding = HORIZONTAL_PADDING_DEFAULT;
    self.verticalPadding = VERTICAL_PADDING_DEFAULT;
    self.cornerRadius = CORNER_RADIUS;
    self.borderColor = BORDER_COLOR;
    self.borderWidth = BORDER_WIDTH;
    self.textColor = TEXT_COLOR;
    self.textShadowColor = TEXT_SHADOW_COLOR;
    self.textShadowOffset = TEXT_SHADOW_OFFSET;
    self.showTagMenu = DEFAULT_SHOW_TAG_MENU;
  }
  return self;
}

- (void)setTags:(NSArray *)array {
  _textArray = [[NSArray alloc] initWithArray:array];
  fitSize = CGSizeZero;
  if (_automaticResize) {
    [self display];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, fitSize.width, fitSize.height);
  }
  else {
    [self setNeedsLayout];
  }
}

- (void)setTagBackgroundColor:(UIColor *)color {
  backgroundColor = color;
  [self setNeedsLayout];
}

- (void)setTagHighlightColor:(UIColor *)color {
  self.highlightedBackgroundColor = color;
  [self setNeedsLayout];
}

- (void)setViewOnly:(BOOL)viewOnly {
  if (_viewOnly != viewOnly) {
    _viewOnly = viewOnly;
    [self setNeedsLayout];
  }
}

- (void)layoutSubviews {
  [super layoutSubviews];
  
  [self display];
}

- (void)display {
  NSMutableArray *tagViews = [NSMutableArray array];
  for (UIView *subview in [self subviews]) {
    if ([subview isKindOfClass:[KeywordTagView class]]) {
      KeywordTagView *tagView = (KeywordTagView *) subview;
      for (UIGestureRecognizer *gesture in [subview gestureRecognizers]) {
        [subview removeGestureRecognizer:gesture];
      }
      
      [tagView.button removeTarget:nil action:nil forControlEvents:UIControlEventAllEvents];
      
      [tagViews addObject:subview];
    }
    [subview removeFromSuperview];
  }
  
  CGRect previousFrame = CGRectZero;
  BOOL gotPreviousFrame = NO;
  
  NSInteger tag = 0;
  for (id text in _textArray) {
    KeywordTagView *tagView;
    if (tagViews.count > 0) {
      tagView = [tagViews lastObject];
      [tagViews removeLastObject];
    }
    else {
      tagView = [[KeywordTagView alloc] init];
    }
    
    
    [tagView updateWithString:text
                         font:self.font
           constrainedToWidth:self.frame.size.width - (self.horizontalPadding * 2)
                      padding:CGSizeMake(self.horizontalPadding, self.verticalPadding)
                 minimumWidth:self.minimumWidth
     ];
    
    if (gotPreviousFrame) {
      CGRect newRect = CGRectZero;
      if (previousFrame.origin.x + previousFrame.size.width + tagView.frame.size.width + self.labelMargin > self.frame.size.width) {
        newRect.origin = CGPointMake(0, previousFrame.origin.y + tagView.frame.size.height + self.bottomMargin);
      } else {
        newRect.origin = CGPointMake(previousFrame.origin.x + previousFrame.size.width + self.labelMargin, previousFrame.origin.y);
      }
      newRect.size = tagView.frame.size;
      [tagView setFrame:newRect];
    }
    
    previousFrame = tagView.frame;
    gotPreviousFrame = YES;
    
    [tagView setBackgroundColor:[self getBackgroundColor]];
    [tagView setCornerRadius:self.cornerRadius];
    [tagView setBorderColor:self.borderColor.CGColor];
    [tagView setBorderWidth:self.borderWidth];
    [tagView setTextColor:self.textColor];
    [tagView setTextShadowColor:self.textShadowColor];
    [tagView setTextShadowOffset:self.textShadowOffset];
    [tagView setTag:tag];
    [tagView setDelegate:self];
    
    tag++;
    
    [self addSubview:tagView];
    
    if (!_viewOnly) {
      [tagView.button addTarget:self action:@selector(touchDownInside:) forControlEvents:UIControlEventTouchDown];
      [tagView.button addTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
      [tagView.button addTarget:self action:@selector(touchDragExit:) forControlEvents:UIControlEventTouchDragExit];
      [tagView.button addTarget:self action:@selector(touchDragInside:) forControlEvents:UIControlEventTouchDragInside];
    }
  }
  
  fitSize = CGSizeMake(self.frame.size.width, previousFrame.origin.y + previousFrame.size.height + self.bottomMargin + 1.0f);
  self.contentSize = fitSize;
}

- (CGSize)fittedSize {
  return fitSize;
}

- (void)touchDownInside:(id)sender {
  UIButton *button = (UIButton *) sender;
  [[button superview] setBackgroundColor:self.highlightedBackgroundColor];
}

- (void)touchUpInside:(id)sender {
  UIButton *button = (UIButton *) sender;
  KeywordTagView *tagView = (KeywordTagView *) [button superview];
  [tagView setBackgroundColor:[self getBackgroundColor]];
  
  if ([self.tagDelegate respondsToSelector:@selector(selectedTag:tagIndex:)]) {
    [self.tagDelegate selectedTag:tagView.label.text tagIndex:tagView.tag];
  }
  
  //    NSLog(@"你选中的：%@", tagView.label.text);
  if ([self.tagDelegate respondsToSelector:@selector(selectedTag:)]) {
    [self.tagDelegate selectedTag:tagView.label.text];
  }
  
  if (self.showTagMenu) {
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    [menuController setTargetRect:tagView.frame inView:self];
    [menuController setMenuVisible:YES animated:YES];
    [tagView becomeFirstResponder];
  }
}

- (void)touchDragExit:(id)sender {
  UIButton *button = (UIButton *) sender;
  [[button superview] setBackgroundColor:[self getBackgroundColor]];
}

- (void)touchDragInside:(id)sender {
  UIButton *button = (UIButton *) sender;
  [[button superview] setBackgroundColor:[self getBackgroundColor]];
}

- (UIColor *)getBackgroundColor {
  if (!backgroundColor) {
    return BACKGROUND_COLOR;
  } else {
    return backgroundColor;
  }
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
  _cornerRadius = cornerRadius;
  [self setNeedsLayout];
}

- (void)setBorderColor:(UIColor *)borderColor {
  _borderColor = borderColor;
  [self setNeedsLayout];
}

- (void)setBorderWidth:(CGFloat)borderWidth {
  _borderWidth = borderWidth;
  [self setNeedsLayout];
}

- (void)setTextColor:(UIColor *)textColor {
  _textColor = textColor;
  [self setNeedsLayout];
}

- (void)setTextShadowColor:(UIColor *)textShadowColor {
  _textShadowColor = textShadowColor;
  [self setNeedsLayout];
}

- (void)setTextShadowOffset:(CGSize)textShadowOffset {
  _textShadowOffset = textShadowOffset;
  [self setNeedsLayout];
}

- (void)dealloc {
  _containerView = nil;
  _textArray = nil;
  backgroundColor = nil;
}

#pragma mark - KeywordTagViewDelegate

- (void)tagViewWantsToBeDeleted:(KeywordTagView *)tagView {
  NSMutableArray *mTextArray = [self.textArray mutableCopy];
  [mTextArray removeObject:tagView.label.text];
  [self setTags:mTextArray];
  
  if ([self.tagDelegate respondsToSelector:@selector(tagListTagsChanged:)]) {
    [self.tagDelegate tagListTagsChanged:self];
  }
}

@end


@implementation KeywordTagView

- (instancetype)init {
  self = [super init];
  if (self) {
    _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [_label setTextColor:TEXT_COLOR];
    [_label setShadowColor:TEXT_SHADOW_COLOR];
    [_label setShadowOffset:TEXT_SHADOW_OFFSET];
    [_label setBackgroundColor:[UIColor clearColor]];
    [_label setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:_label];
    
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    _button.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [_button setFrame:self.frame];
    [self addSubview:_button];
    
    self.layer.drawsAsynchronously = YES;
    [self.layer setMasksToBounds:YES];
    [self.layer setCornerRadius:CORNER_RADIUS];
    [self.layer setBorderColor:BORDER_COLOR.CGColor];
    [self.layer setBorderWidth:BORDER_WIDTH];
  }
  return self;
}

- (void)updateWithString:(id)text font:(UIFont *)font constrainedToWidth:(CGFloat)maxWidth padding:(CGSize)padding minimumWidth:(CGFloat)minimumWidth {
  CGSize textSize = CGSizeZero;
  BOOL isTextAttributedString = [text isKindOfClass:[NSAttributedString class]];
  
  if (isTextAttributedString) {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:text];
    [attributedString addAttributes:@{NSFontAttributeName : font} range:NSMakeRange(0, ((NSAttributedString *) text).string.length)];
    
    textSize = [attributedString boundingRectWithSize:CGSizeMake(maxWidth, 0) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    _label.attributedText = [attributedString copy];
  } else {
    textSize = [text sizeWithFont:font forWidth:maxWidth lineBreakMode:NSLineBreakByTruncatingTail];
    _label.text = text;
  }
  
  textSize.width = MAX(textSize.width, minimumWidth);
  textSize.height += padding.height * 2;
  
  self.frame = CGRectMake(0, 0, textSize.width + padding.width * 2, textSize.height);
  _label.frame = CGRectMake(padding.width, 0, MIN(textSize.width, self.frame.size.width), textSize.height);
  _label.font = font;
  
  [_button setAccessibilityLabel:self.label.text];
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
  [self.layer setCornerRadius:cornerRadius];
}

- (void)setBorderColor:(CGColorRef)borderColor {
  [self.layer setBorderColor:borderColor];
}

- (void)setBorderWidth:(CGFloat)borderWidth {
  [self.layer setBorderWidth:borderWidth];
}

- (void)setLabelText:(NSString *)text {
  [_label setText:text];
}

- (void)setTextColor:(UIColor *)textColor {
  [_label setTextColor:textColor];
}

- (void)setTextShadowColor:(UIColor *)textShadowColor {
  [_label setShadowColor:textShadowColor];
}

- (void)setTextShadowOffset:(CGSize)textShadowOffset {
  [_label setShadowOffset:textShadowOffset];
}

- (void)dealloc {
  _label = nil;
  _button = nil;
}

#pragma mark - UIMenuController support

- (BOOL)canBecomeFirstResponder {
  return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
  return (action == @selector(copy:)) || (action == @selector(delete:));
}

- (void)copy:(id)sender {
  [[UIPasteboard generalPasteboard] setString:self.label.text];
}

- (void)delete:(id)sender {
  [self.delegate tagViewWantsToBeDeleted:self];
}


@end
