//
//  KeywordListView.h
//  测试标签
//
//  Created by Yutian Duan on 16/6/30.
//  Copyright © 2016年 Yutian Duan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KeywordTagListDelegate, KeywordTagViewDelegate;


@interface KeywordListView : UIScrollView {
    NSArray *titleArray;
    CGSize  fitSize;
    UIColor *backgroundColor;
}
@property (weak, nonatomic) id <KeywordTagListDelegate> tagDelegate;

/// 是否只view<而无点击事件>
@property (assign, nonatomic) BOOL viewOnly;
/// 是否显示菜单
@property (assign, nonatomic) BOOL showTagMenu;
/// 容器
@property (strong, nonatomic) UIView *containerView;
/// 数据源
@property (strong, nonatomic) NSArray *textArray;
@property (strong, nonatomic) UIColor *highlightedBackgroundColor;
/// listView高度是否自适应
@property (assign, nonatomic) BOOL automaticResize;
/// 设置tag的font
@property (strong, nonatomic) UIFont *font;
/// 设置tag和tag的水平间距
@property (assign, nonatomic) CGFloat labelMargin;
/// tag和tag的垂直间距
@property (assign, nonatomic) CGFloat bottomMargin;
/// text与tag的左右水平间距
@property (assign, nonatomic) CGFloat horizontalPadding;
/// text与tag的上下垂直间距
@property (assign, nonatomic) CGFloat verticalPadding;
/// tag的最小宽度
@property (assign, nonatomic) CGFloat minimumWidth;
/// tag的圆角
@property (assign, nonatomic) CGFloat cornerRadius;
/// tag的边框颜色
@property (strong, nonatomic) UIColor *borderColor;
/// tag的边框宽度
@property (assign, nonatomic) CGFloat borderWidth;
/// tag的文本颜色
@property (strong, nonatomic) UIColor *textColor;
@property (strong, nonatomic) UIColor *textShadowColor;
@property (assign, nonatomic) CGSize textShadowOffset;

- (void)setTagBackgroundColor:(UIColor *)color;

- (void)setTagHighlightColor:(UIColor *)color;

- (void)setTags:(NSArray *)array;

- (void)display;

- (CGSize)fittedSize;

@end


//
@interface KeywordTagView : UIView

@property(strong, nonatomic) UIButton *button;
@property(strong, nonatomic) UILabel *label;
@property(weak, nonatomic) id <KeywordTagViewDelegate> delegate;

- (void)updateWithString:(NSString *)text
                    font:(UIFont *)font
      constrainedToWidth:(CGFloat)maxWidth
                 padding:(CGSize)padding
            minimumWidth:(CGFloat)minimumWidth;

- (void)setLabelText:(NSString *)text;

- (void)setCornerRadius:(CGFloat)cornerRadius;

- (void)setBorderColor:(CGColorRef)borderColor;

- (void)setBorderWidth:(CGFloat)borderWidth;

- (void)setTextColor:(UIColor *)textColor;

- (void)setTextShadowColor:(UIColor *)textShadowColor;

- (void)setTextShadowOffset:(CGSize)textShadowOffset;

@end


@protocol KeywordTagListDelegate <NSObject>

@optional

- (void)selectedTag:(NSString *)tagName tagIndex:(NSInteger)tagIndex;

- (void)selectedTag:(NSString *)tagName;

- (void)tagListTagsChanged:(KeywordListView *)tagList;

@end

@protocol KeywordTagViewDelegate <NSObject>

@required

- (void)tagViewWantsToBeDeleted:(KeywordTagView *)tagView;

@end

