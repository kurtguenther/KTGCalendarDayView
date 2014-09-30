//
//  KTGCalendarDayViewController.m
//  Pods
//
//  Created by Kurt Guenther on 9/30/14.
//
//

#import "KTGCalendarDayViewController.h"
#import "KTGCalendarDayView.h"
#import "Masonry.h"

@interface KTGCalendarDayViewController ()

@property (nonatomic,strong) KTGCalendarDayView* dayView;

@end

@implementation KTGCalendarDayViewController

- (instancetype)initWithDate:(NSDate *)date{
    self = [super init];
    if(self){
        self.date = date;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.dayView = [[KTGCalendarDayView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.dayView];
    
//    [self.view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(self.view.mas_width);
//        make.width.equalTo(self.view.mas_height);
//        make.centerX.equalTo(self.view.mas_centerX);
//        make.centerY.equalTo(self.view.mas_centerY);
//    }];
}

@end