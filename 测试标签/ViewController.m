//
//  ViewController.m
//  测试标签
//
//  Created by Yutian Duan on 16/6/30.
//  Copyright © 2016年 Yutian Duan. All rights reserved.
//

#import "ViewController.h"
#import "KeywordListView.h"
#import "Father.h"
#import "Sark.h"

@implementation Son :Father
- (id)init {
  self = [super init];
  if (self) {
    NSLog(@"%@",NSStringFromClass([self class]));
    NSLog(@"%@",NSStringFromClass([super class]));
  }
  return self;
}
@end


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  id cls = [Sark class];
  void *obj = &cls;
  [(__bridge id)obj speak];
  
  KeywordListView *tagList = [[KeywordListView alloc] init];
  tagList.frame = CGRectMake(10, 100, self.view.frame.size.width - 20, 400);
  [self.view addSubview:tagList];
  tagList.backgroundColor = [UIColor whiteColor];
  tagList.highlightedBackgroundColor = [UIColor purpleColor];
  //    [tagList sethighlightedBackgroundColor:[UIColor clearColor]];
  [tagList setTagBackgroundColor:[UIColor clearColor]];
  [tagList setFont:[UIFont systemFontOfSize:16]];
  //    tagList.cornerRadius = 15;
  //    tagList.showTagMenu = YES;
  tagList.horizontalPadding = 12.0;
  tagList.verticalPadding = 5.0;
  tagList.labelMargin = 10.0;
  tagList.textColor = [UIColor darkGrayColor];
  tagList.viewOnly = NO;
  //    tagList.tagDelegate = self;
  tagList.automaticResize = YES;
  
  NSArray *_array = @[@"曾经最美",@"隐形的翅膀",@"让爱重来",@"爱的天国",@"后悔了吧",@"怎样",@"让我忘了",@"怎么知道你爱我",@"你到底爱",@"你到底爱",@"知道不知",@"赤道和北",@"再见中国",@"爱是怎么回",@"幸福的天堂",@"呐喊",@"遗失的美好",@"划地为牢"];
  [tagList setTags:_array];
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
