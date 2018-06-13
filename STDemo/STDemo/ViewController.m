//
//  ViewController.m
//  STDemo
//
//  Created by bingo on 2018/6/13.
//  Copyright © 2018年 bingo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<NSURLSessionDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    [self test];
}


- (void)test {
    
    
   
}


-(void)getReq
{
    //默认的是get
    NSURL * url = [NSURL URLWithString:@"http://120.25.226.186:32812/login?username=520&pwd=520&type=JSON"];
    
    NSURLSession * session = [NSURLSession sharedSession];
    NSURLSessionDataTask * dataTask = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSString * string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",string);
    }];
    
    [dataTask resume];
}


-(void)postReq
{
    NSURL * url = [NSURL URLWithString:@"http://120.25.226.186:32812/login"];
    NSMutableURLRequest * requestM = [[NSMutableURLRequest alloc] initWithURL:url];
    requestM.HTTPMethod = @"POST";
    requestM.HTTPBody = [@"username=520&pwd=520&type=JSON" dataUsingEncoding:NSUTF8StringEncoding];
    [[NSURLSession sharedSession] dataTaskWithRequest:requestM completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
    }];
}

-(void)containUrlDelegate
{
    NSURL * url = [NSURL URLWithString:@"http://120.25.226.186:32812/login"];
    NSMutableURLRequest * requestM = [[NSMutableURLRequest alloc] initWithURL:url];
    requestM.HTTPMethod = @"POST";
    requestM.HTTPBody = [@"username=520&pwd=520&type=JSON" dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURLSession * session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]delegate:self delegateQueue:nil] ;
    NSURLSessionDataTask * dataTask = [session dataTaskWithRequest:requestM ];
    [dataTask resume];
}


-(void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(NSError *)error
{
    
}

-(void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler
{
    
}

- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
