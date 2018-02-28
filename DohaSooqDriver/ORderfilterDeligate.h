//
//  ORderfilterDeligate.h
//  DohaSooqDriver
//
//  Created by jeya sabeen on 17/01/18.
//  Copyright © 2018 Test User. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ORderfilterDeligate <NSObject>

@optional

-(void) GET_filter_content:(NSString *)STR_orderID get_Status:(NSString *)STR_status;

@end
