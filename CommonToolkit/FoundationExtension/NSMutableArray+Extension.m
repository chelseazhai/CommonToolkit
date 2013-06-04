//
//  NSMutableArray+Extension.m
//  CommonToolkit
//
//  Created by Ares on 13-6-3.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import "NSMutableArray+Extension.h"

@implementation NSMutableArray (Stack)

- (void)push:(id)pElement{
    // add an element to the stack
    [self addObject:pElement];
}

- (id)pop{
    id _topElement = nil;
    
    // check the stack
    if (!self.empty) {
        // get top element
        _topElement = [self lastObject];
        
        // remove the last element from the stack
        [self removeLastObject];
    }
    else {
        NSLog(@"the stack is empty, needn't pop");
    }
    
    return _topElement;
}

- (void)clear{
    // remove all elements from stack
    [self removeAllObjects];
}

- (id)top{
    id _topElement = nil;
    
    // check the stack
    if (!self.empty) {
        // get top element
        _topElement = [self lastObject];
    }
    else {
        NSLog(@"the stack is empty, can't get the top element");
    }
    
    return _topElement;
}

- (BOOL)empty{
    return 0 == self.count ? TRUE : FALSE;
}

- (NSString *)stackDescription{
    NSMutableString *_description = [[NSMutableString alloc] initWithString:@"NSStack all elements = "];
    
    for (int i = 0; i < self.count; i++) {
        id _element = [self objectAtIndex:i];
        
        [_description appendFormat:@"%@", _element];
        
        if (self.count - 1 != i) {
            [_description appendString:@","];
        }
    }
    
    return _description;
}

@end
