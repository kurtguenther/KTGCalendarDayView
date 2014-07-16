//
//  KTGCalendarEventView.h
//  Pods
//
//  Created by Kurt Guenther on 7/15/14.
//
//

#import <UIKit/UIKit.h>
#import "KTGCalendarEvent.h"

@interface KTGCalendarEventView : UIView

@property (nonatomic, strong) id<KTGCalendarEvent> event;

@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UILabel* subtitleLabel;

@end
