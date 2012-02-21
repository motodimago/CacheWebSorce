//
//  CacheWebView.m
//  WebCache
//
//  Created by 安保 元靖 on 12/02/22.
//  Copyright (c) 2012 Parmy. All rights reserved.
//

#import "CacheWebSource.h"

@interface CacheWebSource()

+ (BOOL)isExpired:(NSNumber *)expire;
+ (NSString *)makePath:(NSString *)url;

@end

@implementation CacheWebSource


+ (void)load:(UIWebView *)webView url:(NSString *)url
{
    NSDictionary *cache = [NSDictionary dictionaryWithContentsOfFile:[CacheWebSource makePath:url]];

    BOOL expired = YES;

    if ([cache objectForKey:@"expire"]) {
        expired = [CacheWebSource isExpired:[cache objectForKey:@"expire"]];
    }
    
    if (!expired) {
        NSLog(@"LOAD Cache");
        [webView loadHTMLString:[cache objectForKey:@"source"] baseURL:nil];
    } else {
        NSLog(@"NOT LOAD Cache");
        NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        [webView loadRequest:req]; 
    }
}

+ (void)save:(UIWebView *)webView url:(NSString *)url expire:(double)expire
{
    NSDictionary *cache = [NSDictionary dictionaryWithContentsOfFile:[CacheWebSource makePath:url]];

    BOOL expired = NO;
 
    if ([cache objectForKey:@"expire"]) {
        expired = [CacheWebSource isExpired:[cache objectForKey:@"expire"]];
    } else {
        expired = YES;
    }
    
    if (expired) {
        NSString *source = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('html')[0].outerHTML"];
        NSNumber *expireSec = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970] + expire];
        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:expireSec, @"expire", source, @"source" ,nil];
        if ([data writeToFile:[CacheWebSource makePath:url] atomically:YES]) {
            NSLog(@"SAVE SUCCESS Cache");
        } else {
            NSLog(@"SAVE FAULT Cache");
        }
    } else {
        NSLog(@"NOT SAVE Cache");
    }
}

+ (BOOL)useCache:(NSString *)url
{
    NSDictionary *cache = [NSDictionary dictionaryWithContentsOfFile:[CacheWebSource makePath:url]];
    if ([cache objectForKey:@"expire"]) {
        return [CacheWebSource isExpired:[cache objectForKey:@"expire"]];
    } else {
        return NO;
    }
    return NO;
}


+ (BOOL)isExpired:(NSNumber *)expire
{
    return ([expire doubleValue] <= [[NSDate date] timeIntervalSince1970]);
}

+ (NSString *)makePath:(NSString *)url
{
    CFStringRef ref = 
    CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)url,NULL,(CFStringRef)@"!*'();:@&=+$,/?%#[]~",kCFStringEncodingUTF8);
    NSString *encUrl = [NSString stringWithString:(NSString *)ref];
    CFRelease(ref);

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [[paths objectAtIndex:0] stringByAppendingPathComponent:encUrl];
}

@end