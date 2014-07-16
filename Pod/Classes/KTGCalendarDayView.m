//
//  KTGCalendarDayView.m
//  Pods
//
//  Created by Kurt Guenther on 7/15/14.
//
//

#import "KTGCalendarDayView.h"
#import "KTGHourMarkerView.h"

@implementation KTGCalendarDayView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];

        [self addObserver:self forKeyPath:@"hourHeight" options:NSKeyValueObservingOptionNew context:nil];
        
        self.hourHeight = 44.f;
        
        [self addSubview:self.scrollView];
        
        self.hourMarkers = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 24.0 * self.hourHeight)];
        
        [self.scrollView addSubview:self.hourMarkers];
        
        NSDateFormatter* hourFormatter = [[NSDateFormatter alloc] init];
        hourFormatter.dateFormat = @"hh";
        
        //TODO: make this use NSLocale for times (So Noon is local, and support of 24 hour)
        for(int i = 0; i < 24; i++){
            NSString* hourTitle;
            if(i == 0) {
                hourTitle = @"12";
            } else if(i == 12) {
                hourTitle = @"Noon";
            } else {
                hourTitle = [NSString stringWithFormat:@"%d", i%12];
            }
            
            KTGHourMarkerView* hourMarkerView = [[KTGHourMarkerView alloc] initWithFrame:CGRectMake(0, i*self.hourHeight, 320, self.hourHeight) title:hourTitle];
            [self.hourMarkers addSubview:hourMarkerView];
        }
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"hourHeight"]) {
        self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds), 24.0 * self.hourHeight);
    }
}

@end
