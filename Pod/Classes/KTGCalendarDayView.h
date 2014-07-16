//
//  KTGCalendarDayView.h
//  Pods
//
//  Created by Kurt Guenther on 7/15/14.
//
//

#import <UIKit/UIKit.h>
#import "KTGCalendarEvent.h"

@class KTGCalendarDayView;

@protocol KTGCalendarDayViewDelegate <NSObject>
@required
@end

@protocol KTGCalendarDayViewDataSource <NSObject>
@required
-(NSArray*)events;
- (UIView*)calendarDayView:(KTGCalendarDayView*)calendarDayView eventViewForEvent:(id<KTGCalendarEvent>)event;
@end



@interface KTGCalendarDayView : UIView

@property (nonatomic, strong) UIScrollView* scrollView;
@property (nonatomic, strong) UIView* hourMarkers;
@property (nonatomic, strong) UIView* eventsContainer;

@property (nonatomic) CGFloat hourHeight;

@property (nonatomic, strong) id<KTGCalendarDayViewDataSource> dataSource;
@property (nonatomic, strong) id<KTGCalendarDayViewDelegate> delegate;

-(void)reloadData;

@end
