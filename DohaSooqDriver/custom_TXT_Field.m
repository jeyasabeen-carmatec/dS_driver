//
//  custom_TXT_Field.m
//  DohaSooqDriver
//
//  Created by Test User on 15/07/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "custom_TXT_Field.h"

@implementation custom_TXT_Field
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectMake(bounds.origin.x + 10, bounds.origin.y, bounds.size.width - 10, bounds.size.height);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectMake(bounds.origin.x + 10, bounds.origin.y, bounds.size.width - 10, bounds.size.height);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
