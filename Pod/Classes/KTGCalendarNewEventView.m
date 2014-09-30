//
//  KTGCalendarNewEventView.m
//  Pods
//
//  Created by Kurt Guenther on 7/17/14.
//
//

#import "KTGCalendarNewEventView.h"

@implementation KTGCalendarNewEventView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIColor* baseColor = [UIColor colorWithRed:27/255.f green:173/255.f blue:248/255.f alpha:1.0];
        self.backgroundColor = baseColor;
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectInset(self.bounds, 5.f, 0.f)];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:12.f];
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.text = @"New Event";
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    NSDictionary* views = @{@"title" : self.titleLabel};
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-5-[title]" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[title]" options:0 metrics:nil views:views]];
    [self.titleLabel sizeToFit];

    [super layoutSubviews];
}

@end
