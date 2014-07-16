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
        
        self.backgroundColor = [self calculateBackgroundColor:baseColor];
        
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (void)setEvent:(id<KTGCalendarEvent>)event{
    _event = event;
    self.titleLabel.text = [event title];
    [self.titleLabel sizeToFit];
    
}

- (UIColor*) calculateBackgroundColor:(UIColor*)input {
    CGFloat hue, saturation, brightness, alpha ;
    [input getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha ] ;
    UIColor * newColor = [ UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:alpha * 0.4 ] ;
    return newColor;
}

- (UIColor*) calculateTextColor:(UIColor*)input {
    CGFloat hue, saturation, brightness, alpha ;
    [input getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha ] ;
    UIColor * newColor = [ UIColor colorWithHue:hue saturation:saturation brightness:0.5 alpha:alpha ] ;
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
