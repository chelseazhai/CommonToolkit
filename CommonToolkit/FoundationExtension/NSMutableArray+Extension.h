//
//  NSMutableArray+Extension.h
//  CommonToolkit
//
//  Created by Ares on 13-6-3.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (Stack)

// push an element to stack
- (void)push:(id)pElement;

// pop the top element
- (id)pop;

// clear the stack
- (void)clear;

// get the top element
- (id)top;

// check the stact is or not empty
- (BOOL)empty;

// stack description
- (NSString *)stackDescription;

@end
