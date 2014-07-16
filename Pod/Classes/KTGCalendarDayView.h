//
//  KTGCalendarDayView.h
//  Pods
//
//  Created by Kurt Guenther on 7/15/14.
//
//

#import <UIKit/UIKit.h>

@interface KTGCalendarDayView : UIView

@property (nonatomic, strong) UIScrollView* scrollView;
@property (nonatomic, strong) UIView* hourMarkers;

@property (nonatomic) CGFloat hourHeight;

@end
