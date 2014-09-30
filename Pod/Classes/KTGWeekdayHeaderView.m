//
//  KTGWeekdayHeaderView.m
//  Pods
//
//  Created by Kurt Guenther on 9/30/14.
//
//

#import "KTGWeekdayHeaderView.h"
#import "Masonry.h"

@interface KTGWeekdayHeaderView ()

@property (nonatomic, strong) UILabel* label;
@property (nonatomic, strong) UIView* circle;


@end

@implementation KTGWeekdayHeaderView

@synthesize date = _date;

- (instancetype)initWithDate:(NSDate *)date{
    self = [super init];
    if(self){
        self.date = date;
        
        self.circle = [[UIView alloc] init];
        self.circle.backgroundColor = [UIColor blackColor];
        self.circle.alpha = 0.f;
        [self addSubview:self.circle];
        
        [self.circle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY);            
            //TODO - this should not be hardcoded.
            make.size.equalTo(self).sizeOffset(CGSizeMake(-20, 5));
        }];
        
        
        self.label = [[UILabel alloc] init];
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.textColor = [UIColor blackColor];
        
        NSDateFormatter* df = [[NSDateFormatter alloc] init];
        df.dateFormat = @"d";
        self.label.text = [df stringFromDate:date];
        [self.label sizeToFit];
        [self addSubview:self.label];
        
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY);
            make.height.equalTo(self.mas_height);
        }];
        
        
        self.isSelected = NO;
    }
    return self;
}

- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    
    self.circle.layer.cornerRadius = self.circle.frame.size.height / 2.0f;
    
    if(_isSelected){
        [UIView animateWithDuration:0.3 animations:^{
            self.label.textColor = [self selectedColor];
            self.circle.alpha = 1.0;
        }];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            self.label.textColor = [self defaultColor];
            self.circle.alpha = 0.0;
        }];
    }
}

- (UIColor*) defaultColor {
    NSDateComponents* comps = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitDay | NSCalendarUnitWeekday) fromDate:self.date];
    NSDateComponents* today = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitDay | NSCalendarUnitWeekday) fromDate:[NSDate date]];
    
    if(comps.day == today.day && comps.year == comps.year){
        return [UIColor redColor];
    }
    
    if(comps.weekday == 1 || comps.weekday == 7){
        return [UIColor lightGrayColor];
    }
    
    return [UIColor blackColor];
}

- (UIColor*) selectedColor {
    return [UIColor whiteColor];
}

@end
