//
//  KTGWeekdayHeaderView.h
//  Pods
//
//  Created by Kurt Guenther on 9/30/14.
//
//

#import <UIKit/UIKit.h>

@interface KTGWeekdayHeaderView : UIView

@property (nonatomic, strong) NSDate* date;

@property (nonatomic) BOOL isSelected;

- (instancetype)initWithDate:(NSDate*)date;



@end
