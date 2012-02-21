//
//  CacheWebView.h
//  WebCache
//
//  Created by 安保 元靖 on 12/02/22.
//  Copyright (c) 2012 Parmy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CacheWebSource : NSObject

+ (void)load:(UIWebView *)webView url:(NSString *)url;
+ (void)save:(UIWebView *)webView url:(NSString *)url expire:(double)expire;
+ (BOOL)useCache:(NSString *)url;
@end

