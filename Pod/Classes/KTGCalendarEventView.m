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
        
        UIColor* baseColor = [UIColor colorWithRed:27/255.f green:173/255.f blue:248/255.f alpha:1.0];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectInset(self.bounds, 5.f, 0.f)];
        self.titleLabel.textColor = [self calculateTextColor:baseColor];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:12.f];
        self.titleLabel.numberOfLines = 0;
        
        self.subtitleLabel = [[UILabel alloc] initWithFrame:CGRectInset(self.bounds, 5.f, 0.f)];
        self.subtitleLabel.textColor = [self calculateTextColor:baseColor];
        self.subtitleLabel.font = [UIFont systemFontOfSize:10.f];
        self.subtitleLabel.numberOfLines = 0;
        
        self.backgroundColor = [self calculateBackgroundColor:baseColor];
        
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.subtitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.subtitleLabel];
        
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)setEvent:(id<KTGCalendarEvent>)event{
    _event = event;
    self.titleLabel.text = [event title];
    [self.titleLabel sizeToFit];
    
    if([event respondsToSelector:@selector(subtitle)]){
        self.subtitleLabel.text = [event subtitle];
        [self.subtitleLabel sizeToFit];
    }
    
    [self setNeedsLayout];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    BOOL canFitVertically = CGRectGetHeight(self.bounds) >  self.titleLabel.intrinsicContentSize.height + self.subtitleLabel.intrinsicContentSize.height;
    
    NSDictionary* views = @{@"title" : self.titleLabel, @"subtitle" : self.subtitleLabel};
    
    if(canFitVertically){
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-5-[title]" options:0 metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-5-[subtitle]" options:0 metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[title]-0-[subtitle]" options:0 metrics:nil views:views]];
    } else {
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-5-[title]-5-[subtitle]" options:0 metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[title]" options:0 metrics:nil views:views]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeBaseline relatedBy:NSLayoutRelationEqual toItem:self.subtitleLabel attribute:NSLayoutAttributeBaseline multiplier:1.0 constant:0]];
    }
    
    [self.subtitleLabel sizeToFit];
    [super layoutSubviews];
}

- (UIColor*) calculateBackgroundColor:(UIColor*)input {
    CGFloat hue, saturation, brightness, alpha ;
    [input getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha ] ;
    UIColor * newColor = [ UIColor colorWithHue:hue saturation:saturation*0.4 brightness:1.0 alpha:alpha * 0.5 ] ;
    return newColor;
}

- (UIColor*) calculateTextColor:(UIColor*)input {
    CGFloat hue, saturation, brightness, alpha ;
    [input getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha ] ;
    UIColor * newColor = [ UIColor colorWithHue:hue saturation:saturation brightness:brightness*0.7 alpha:alpha ] ;
    return newColor;
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    //TODO: find out true color
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:27/255.f green:173/255.f blue:248/255.f alpha:1.0].CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, 2.f, CGRectGetHeight(self.bounds)));
    
}

@end
