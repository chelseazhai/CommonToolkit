//
//  HttpUtils.m
//  CommonToolkit
//
//  Created by Ares on 12-6-11.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import "HttpUtils.h"

#import "ASIFormDataRequest.h"

#import "NSString+Extension.h"

#import "HttpRequestManager.h"

// http request user info extension support type set
#define HTTPREQUESTUSERINFOEXTSUPPORTTYPESET    [NSSet setWithObjects:HTTPREQUESTRESPONSEENCODING, nil]

// http request method mode type
typedef enum {
    get,
    post
} HTTPRequestMethod;


// HttpUtil extension
@interface HttpUtils ()

// send http request with method, type and postFormat if it is post request
+ (void)sendRequestWithUrl:(NSString *)pUrl andParameter:(NSDictionary *)pParameter andUserInfo:(NSDictionary *)pUserInfo andProcessor:(id)pProcessor andFinishedRespSelector:(SEL)pFinRespSel andFailedRespSelector:(SEL)pFailRespSel andRequestMethod:(HTTPRequestMethod)pMethod andRequestType:(HTTPRequestType)pType andPostFormat:(HttpPostFormat)pPostFormat;

@end




@implementation HttpUtils

+ (void)getRequestWithUrl:(NSString *)pUrl andParameter:(NSDictionary *)pParameter andUserInfo:(NSDictionary *)pUserInfo andRequestType:(HTTPRequestType)pType andProcessor:(id)pProcessor andFinishedRespSelector:(SEL)pFinRespSel andFailedRespSelector:(SEL)pFailRespSel{
    [self sendRequestWithUrl:pUrl andParameter:pParameter andUserInfo:pUserInfo andProcessor:pProcessor andFinishedRespSelector:pFinRespSel andFailedRespSelector:pFailRespSel andRequestMethod:get andRequestType:pType andPostFormat:nonentity];
}

+ (void)postRequestWithUrl:(NSString *)pUrl andPostFormat:(HttpPostFormat)pPostFormat andParameter:(NSDictionary *)pParameter andUserInfo:(NSDictionary *)pUserInfo andRequestType:(HTTPRequestType)pType andProcessor:(id)pProcessor andFinishedRespSelector:(SEL)pFinRespSel andFailedRespSelector:(SEL)pFailRespSel{
    [self sendRequestWithUrl:pUrl andParameter:pParameter andUserInfo:pUserInfo andProcessor:pProcessor andFinishedRespSelector:pFinRespSel andFailedRespSelector:pFailRespSel andRequestMethod:post andRequestType:pType andPostFormat:pPostFormat];
}

+ (void)sendRequestWithUrl:(NSString *)pUrl andParameter:(NSDictionary *)pParameter andUserInfo:(NSDictionary *)pUserInfo andProcessor:(id)pProcessor andFinishedRespSelector:(SEL)pFinRespSel andFailedRespSelector:(SEL)pFailRespSel andRequestMethod:(HTTPRequestMethod)pMethod andRequestType:(HTTPRequestType)pType andPostFormat:(HttpPostFormat)pPostFormat{
    // check request url
    if ([pUrl isNil]) {
        NSLog(@"Error: send http request error - request url is nil.");
        
        // return immediately
        return;
    }
    else {
        pUrl = [pUrl perfectHttpRequestUrl];
    }
    
    // create ASIHTTPRequest object
    ASIHTTPRequest *_request;
    
    // check http request send method
    switch (pMethod) {
        case post:
            {
                // init request object
                _request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:pUrl]];
                // set request send method
                _request.requestMethod = @"POST";
                // set post http parameter
                [pParameter enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
                    [(ASIFormDataRequest *)_request addPostValue:obj forKey:key];
                }];
                // check post request post format
                switch (pPostFormat) {
                    case multipartFormData:
                        ((ASIFormDataRequest *)_request).postFormat = ASIMultipartFormDataPostFormat;
                        break;
                        
                    case urlEncoded:
                    default:
                        ((ASIFormDataRequest *)_request).postFormat = ASIURLEncodedPostFormat;
                        break;
                }
            }
            break;
            
        case get:
        default:
            {
                // create and init get request url string
                NSMutableString *_getReqUrlString = [NSMutableString stringWithString:pUrl];
                for (NSInteger _index = 0; _index < [pParameter count]; _index++) {
                    // first append '?'
                    if (0 == _index) {
                        [_getReqUrlString appendString:@"?"];
                    }
                    // append parameter to request url
                    [_getReqUrlString appendFormat:@"%@=%@", [[pParameter allKeys] objectAtIndex:_index], [[pParameter allValues] objectAtIndex:_index]];
                    // not end append '&' 
                    if ([pParameter count] - 1 != _index) {
                        [_getReqUrlString appendString:@"&"];
                    }
                }
                // init request object
                _request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:_getReqUrlString]];
                // set request send method
                _request.requestMethod = @"GET";
            }
            break;
    }
    
    // set timeout seconds
    [_request setTimeOutSeconds:10.0];
    
    // crate and init http request object to save processor, finishedRespSelector and failedRespSelector and add it to http request bean Dictionary
    [[HttpRequestManager shareHttpRequestManager] setHttpRequestBean:[HttpRequestBean initWithProcessor:pProcessor andFinishedRespSelector:pFinRespSel andFailedRespSelector:pFailRespSel] forKey:[NSNumber numberWithInteger:[_request hash]]];
    
    // set delegate
    _request.delegate = [[HttpRequestManager shareHttpRequestManager] httpRequestBeanForKey:[NSNumber numberWithInteger:[_request hash]]];
    
    // check and set user infomation
    if (nil != pUserInfo) {
        @autoreleasepool {
            // define ASIHTTPRequest user info dictionary
            NSMutableDictionary *_asiHTTPRequestUserInfo = [[NSMutableDictionary alloc] initWithDictionary:pUserInfo];
            
            // process each user info key-value
            for (int index = 0; index < [pUserInfo.allKeys count]; index++) {
                // get user info dictionary key
                NSString *_userInfoKey = [pUserInfo.allKeys objectAtIndex:index];
                
                // check user info key-value if or not needed to process
                if ([HTTPREQUESTUSERINFOEXTSUPPORTTYPESET containsObject:_userInfoKey]) {
                    // process http request response encoding
                    if ([HTTPREQUESTRESPONSEENCODING isEqualToString:_userInfoKey]) {
                        // set http request response encoding
                        _request.defaultResponseEncoding = _request.responseEncoding = ((NSNumber *)[pUserInfo objectForKey:_userInfoKey]).unsignedIntegerValue;
                    }
                    
                    // remove the custom user info key-value
                    [_asiHTTPRequestUserInfo removeObjectForKey:_userInfoKey];
                }
                else {
                    // get next user info dictionary key
                    continue;
                }
            }
            
            // reset user info dictionary param
            pUserInfo = _asiHTTPRequestUserInfo;
        }
    }
    _request.userInfo = pUserInfo;
    
    // set response selectors
    _request.didFinishSelector = @selector(httpRequestDidFinishedRequest:);
    _request.didFailSelector = @selector(httpRequestDidFailedRequest:);
    
    // start send request with type
    switch (pType) {
        case asynchronous:
            // start asynchronous request
            [_request startAsynchronous];
            break;
            
        case synchronous:
        default:
            // start synchronous request
            [_request startSynchronous];
            break;
    }
}

@end
