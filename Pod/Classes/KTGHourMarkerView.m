//
//  KTGHourMarkerView.m
//  Pods
//
//  Created by Kurt Guenther on 7/15/14.
//
//

#import "KTGHourMarkerView.h"

@implementation KTGHourMarkerView

- (id)initWithFrame:(CGRect)frame title:(NSString*)title
{
    self = [super initWithFrame:frame];
    if (self) {
        //TODO: make this autolayout
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0.f, 35.f, 20.f)];
        label.text = title;
        label.font = [UIFont boldSystemFontOfSize:11.f];
        label.textAlignment = NSTextAlignmentRight;
        label.textColor = [UIColor colorWithWhite:0.65 alpha:0.8];
        [self addSubview:label];
        
        self.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    //TODO: find out true color
    CGContextSetFillColorWithColor(context, [UIColor colorWithWhite:0.65 alpha:0.8].CGColor);
    CGContextFillRect(context, CGRectMake(40.f, 10, self.bounds.size.width, 0.5f));
    
}


@end
