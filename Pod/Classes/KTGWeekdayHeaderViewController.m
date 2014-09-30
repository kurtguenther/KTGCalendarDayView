//
//  KTGWeekdayHeaderViewController.m
//  Pods
//
//  Created by Kurt Guenther on 9/29/14.
//
//

#import "KTGWeekdayHeaderViewController.h"
#import <Masonry/Masonry.h>
#import "KTGWeekdayHeaderView.h"

@interface KTGWeekdayHeaderViewController ()

@property (nonatomic,strong) NSMutableArray* weekdayViews;
@end

@implementation KTGWeekdayHeaderViewController

- (instancetype)initWithStartDay:(NSDate*)day {
    self = [super init];
    if(self){
        self.startDay = day;
    }
    return self;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex{
    if(_selectedIndex != selectedIndex){
        _selectedIndex = selectedIndex;
        for(int i = 0; i < self.weekdayViews.count; i++){
            KTGWeekdayHeaderView* v = self.weekdayViews[i];
            v.isSelected = (i == _selectedIndex);
        }

    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:247.0/255.0 alpha:1.0];
    
    self.weekdayViews = [NSMutableArray array];
    
    for(int i = 0; i < 7; i++){
        NSDate* date = [NSDate dateWithTimeInterval:24*60*60*i sinceDate:self.startDay];
        UIView* dayView = [self createDateView:date];
        
        [self.view addSubview:dayView];
        [self.weekdayViews addObject:dayView];

        if(i > 0){
            UIView* prev = self.weekdayViews[i-1];
            [dayView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(prev.mas_width);
                make.left.equalTo(prev.mas_right);
                make.centerY.equalTo(self.view.mas_centerY);
            }];
            
        }
    }
    
    [[self.weekdayViews firstObject] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view.mas_left);
        make.centerY.equalTo(self.view.mas_centerY);        
    }];
    
    [[self.weekdayViews lastObject] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right);
    }];
    
    for(UIView* v in self.weekdayViews){
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectDay:)];
        [v addGestureRecognizer:tap];
    }
}

- (UIView*)createDateView:(NSDate*)date {
    return [[KTGWeekdayHeaderView alloc] initWithDate:date];
}

- (void)selectDay:(UITapGestureRecognizer*)sender {
    int newIndex = [self.weekdayViews indexOfObject:sender.view];
    self.selectedIndex = newIndex;
}

@end
