//
//  RequestConnection.h
//  LoungePirate
//
//  Created by FxBytes on 09/04/2014.
//  Copyright (c) 2014 Fxbytes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestConnection : NSObject

+ (void)sendRequestWithGetUrlForFoursquare:(NSString *)method param:(NSDictionary *)params delegate:(id)ownerClassRef success:(SEL)successSel failure:(SEL)failureSel;

@end
