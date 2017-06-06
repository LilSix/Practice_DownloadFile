//
//  ViewController.m
//  Practice_DownloadFile
//
//  Created by user36 on 2017/6/6.
//  Copyright © 2017年 user36. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<NSURLSessionDelegate, NSURLSessionDownloadDelegate> {
    
    NSMutableArray *mutableArray;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSCharacterSet *characterSet = [NSCharacterSet URLQueryAllowedCharacterSet];
//    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration
//                                                          delegate:self
//                                                     delegateQueue:[NSOperationQueue mainQueue]];
    
    NSString *string = @"http://ptx.transportdata.tw/MOTC/v2/Bus/StopOfRoute/City/Taipei/306?$filter=RouteUID eq 'TPE10473'&$format=JSON";
    NSString *encodingString = [string stringByAddingPercentEncodingWithAllowedCharacters:characterSet];
    NSURL *URL = [NSURL URLWithString:encodingString];
    NSData *data = [NSData dataWithContentsOfURL:URL];
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data
                                                     options:NSJSONReadingMutableContainers
                                                       error:nil];
    
    for (NSDictionary *dictionary in array) {
        NSNumber *isKeyPattern = [dictionary objectForKey:@"KeyPattern"];
        NSString *routeUID = [dictionary objectForKey:@"RouteUID"];
        
        if ([isKeyPattern isEqualToNumber:@1]) {
        
            NSLog(@"routeUID = %@", routeUID);
            
            NSDictionary *routeName = [dictionary objectForKey:@"RouteName"];
            
            NSString *nameZhTW = [routeName objectForKey:@"Zh_tw"];
            NSLog(@"string = %@", nameZhTW);
            
            NSNumber *roundTrip = [dictionary objectForKey:@"Direction"];
            if ([roundTrip isEqualToNumber:@0]) {
                
                NSLog(@"去程");
            } else {
                
                NSLog(@"返程");
            }
            
            NSArray *stops = [dictionary objectForKey:@"Stops"];
            for (NSDictionary *dictionary in stops) {
                
                NSDictionary *stopName = [dictionary objectForKey:@"StopName"];
                NSString *stopUID = [dictionary objectForKey:@"StopUID"];
                NSString *zhTW = [stopName objectForKey:@"Zh_tw"];
                
                [mutableArray addObject:zhTW];
                NSLog(@"%@, %@", stopUID, zhTW);
            }
            
            NSLog(@"[stops count]: %ld", [stops count]);
        }
        
        
//        NSLog(@"isKeyPattern = %@", isKeyPattern);
    }
    
//    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:URL];
//
//    [downloadTask resume];

        NSLog(@"[mutableArray count]: %ld", [mutableArray count]);
//    NSLog(@"[array count]: %ld", [array count]);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        
        mutableArray = [NSMutableArray array];
    }
    
    return self;
}

- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location {
    
    NSData *data = [NSData dataWithContentsOfURL:location];
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data
                                                     options:NSJSONReadingMutableContainers
                                                       error:nil];
    NSLog(@"[array count]: %ld", [array count]);
}


@end
