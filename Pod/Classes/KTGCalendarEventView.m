//
//  KTGCalendarEventView.m
//  Pods
//
//  Created by Kurt Guenther on 7/15/14.
//
//

#import "KTGCalendarEventView.h"

@implementation KTGCalendarEventView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectInset(self.bounds, 5.f, 0.f)];
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (void)setEvent:(id<KTGCalendarEvent>)event{
    _event = event;
    self.titleLabel.text = [event title];
}

@end
