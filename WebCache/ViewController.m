//
//  ViewController.m
//  WebCache
//
//  Created by 安保 元靖 on 12/02/22.
//  Copyright (c) 2012 Parmy. All rights reserved.
//

#import "ViewController.h"

#import "CacheWebSource.h"

@interface ViewController()

@property(nonatomic, retain) UIWebView *webView;
@property(nonatomic, retain) NSString *url;
@property(nonatomic, assign) BOOL useCache;
@property(nonatomic, assign) double time;
@property(nonatomic, retain) UILabel *timeLbl;

- (void)loadPage;
@end

@implementation ViewController

@synthesize webView = _webView;
@synthesize url = _url;
@synthesize useCache = _useCache;
@synthesize time = _time;
@synthesize timeLbl = _timeLbl;

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];

    _url = @"http://www.kisaragiweb.jp/pi/pi1m.htm";
    
    // Set WebView
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 460)];
    _webView.delegate = self;
    [self.view addSubview:_webView];
    
    // Set Label
    _timeLbl = [[UILabel alloc] init];
    _timeLbl.frame = CGRectMake(10, 410, 200, 40);
    _timeLbl.text = @"---";
    [self.view addSubview:_timeLbl];
    
    // Set Reload
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(220, 410, 100, 40);
    [btn setTitle:@"Reload" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(loadPage) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:btn];
    
    [self loadPage];
}

- (void)loadPage
{
    // useCache
    _useCache = [CacheWebSource useCache:_url];
    
    // Load WebPage
    [CacheWebSource load:_webView url:_url];
}

-(void)webViewDidStartLoad:(UIWebView*)webView{

    // Set Start Time
    _time = [[NSDate date] timeIntervalSince1970];

    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

-(void)webViewDidFinishLoad:(UIWebView*)webView
{
    double past = [[NSDate date] timeIntervalSince1970] - _time;
    
    _timeLbl.text = [NSString stringWithFormat:@"Cache%@ %f", (!_useCache)? @"使用" : @"不使用", past];
    
    // Save WebPageSource
    [CacheWebSource save:webView url:_url expire:20.0f];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}
@end
