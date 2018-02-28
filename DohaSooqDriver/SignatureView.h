//
//  SignatureView.h
//  Implementing_Signaturepad
//
//  Created by Test User on 03/07/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignatureView : UIView
@property (nonatomic, retain) UIGestureRecognizer *theSwipeGesture;
@property (nonatomic, retain) UIImageView *drawImage;
@property (nonatomic, assign) CGPoint lastPoint;
@property (nonatomic, assign) BOOL mouseSwiped;
@property (nonatomic, assign) CGPoint currentPoint;
@property (nonatomic, assign) NSInteger mouseMoved;


- (void)setSignature:(NSData *)theLastData;
- (BOOL)isSignatureWrite;
@end
