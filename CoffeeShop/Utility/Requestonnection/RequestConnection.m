//
//  RequestConnection.m
//  LoungePirate
//
//  Created by FxBytes on 09/04/2014.
//  Copyright (c) 2014 Fxbytes. All rights reserved.
//

#import "RequestConnection.h"

@implementation RequestConnection

#pragma clang diagnostic ignored "-Warc-performSelector-leaks"


#pragma mark - FourSquare

+ (void)sendRequestWithGetUrlForFoursquare:(NSString *)method param:(NSDictionary *)params delegate:(id)ownerClassRef success:(SEL)successSel failure:(SEL)failureSel {
	
	NSString *strUrl = [NSString stringWithFormat:@"%@?",method];
	
	for (NSString *key in params) {
		strUrl = [strUrl stringByAppendingFormat:@"%@=%@&", key, [params valueForKey:key]];
	}
	
	if ([[strUrl substringFromIndex:strUrl.length-1] isEqualToString:@"&"]) {
		strUrl = [strUrl substringToIndex:strUrl.length-1];
	}
	NSLog(@"**strUrl get %@",strUrl);
	
	NSString* encodedUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:encodedUrl]];
    
	[NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error) {
		
		if (!error) {
			
			NSString *req = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
			NSLog(@"sendRequestWithGetUrl raw response *********** = %@",req);
			
			NSMutableDictionary *parsedDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
			//NSLog(@"sendRequestWithGetUrl response: %@", parsedDic);
			
			if (!error) {
                
				if ([ownerClassRef respondsToSelector:successSel]) {
					[ownerClassRef performSelector:successSel withObject:parsedDic];
				}
			} else {
				
				if ([ownerClassRef respondsToSelector:failureSel]) {
					[ownerClassRef performSelector:failureSel withObject:parsedDic];
				}
			}
		} else {
			
			if ([ownerClassRef respondsToSelector:failureSel]) {
				[ownerClassRef performSelector:failureSel withObject:error.userInfo];
			}
		}
	}];
}



@end
