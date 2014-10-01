//
//  KTGCalendarDayViewController.m
//  Pods
//
//  Created by Kurt Guenther on 9/30/14.
//
//

#import "KTGCalendarDayViewController.h"
#import "Masonry.h"

@interface KTGCalendarDayViewController ()

@end

@implementation KTGCalendarDayViewController

- (instancetype)initWithDate:(NSDate *)date{
    self = [super init];
    if(self){
        self.date = date;
        self.initOffset = CGPointMake(-1, -1);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.dayView = [[KTGCalendarDayView alloc] initWithFrame:self.view.bounds];
    self.dayView.date = self.date;
    self.dayView.dataSource = self.dataSource;
    [self.view addSubview:self.dayView];
    self.view.backgroundColor = [UIColor blackColor];
    
    [self.dayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view.mas_width);
        make.height.equalTo(self.view.mas_height);
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
    }];
    
    if(self.initOffset.y >= 0){
        self.dayView.scrollView.contentOffset = self.initOffset;
    }
}

@end
