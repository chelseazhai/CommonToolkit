//
//  CommonUtils.m
//  CommonToolkit
//
//  Created by  on 12-6-9.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import "CommonUtils.h"

#import "HttpRequestManager.h"
#import "UIViewExtensionManager.h"
#import "AddressBookManager.h"
#import "FoundationExtensionManager.h"

@implementation CommonUtils

+ (BOOL)validateProcessor:(id)pProcessor andSelector:(SEL)pSelector{
    BOOL _ret = NO;
    
    if (pProcessor && [pProcessor respondsToSelector:pSelector]) {
        _ret = YES;
    }
    else {
        NSLog(@"%@ : %@", pProcessor ? @"Warning" : @"Error", pProcessor ? [NSString stringWithFormat:@"processor = %@ can't implement method = %@", pProcessor, NSStringFromSelector(pSelector)] : @"processor is nil");
    }

    return _ret;
}

+ (NSArray *)convertIntegerToBinaryArray:(NSInteger)pInteger{
    // get int bits count in ios
    size_t bits = sizeof(int) * CHAR_BIT;
    
    NSMutableArray *_ret = [[NSMutableArray alloc] initWithCapacity:bits];
    
    // type punning because signed shift is implementation-defined
    unsigned u = *(unsigned *)&pInteger;
    for (; bits--; u >>= 1) {
        [_ret addObject:[NSNumber numberWithInt:u & 1 ? 1 : 0]];
    }        
    
    // array reverse
    return [[_ret reverseObjectEnumerator] allObjects];
}

+ (void)printHttpRequestBeanDictionary{
    [[HttpRequestManager shareHttpRequestManager] printHttpRequestBeanDictionary];
}

+ (void)printUIViewExtensionBeanDictionary{
    [[UIViewExtensionManager shareUIViewExtensionManager] printUIViewExtensionBeanDictionary];
}

+ (void)printContactSearchResultDictionary{
    [[AddressBookManager shareAddressBookManager] performSelector:@selector(printContactSearchResultDictionary)];
}

+ (void)printFoundationExtensionBeanDictionary{
    [[FoundationExtensionManager shareFoundationExtensionManager] printFoundationExtensionBeanDictionary];
}

@end
