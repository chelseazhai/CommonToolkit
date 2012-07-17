//
//  ContactBean.m
//  CommonToolkit
//
//  Created by  on 12-6-8.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import "ContactBean.h"

#import "ContactBean_Extension.h"

@implementation ContactBean

@synthesize id = _id;
@synthesize groups = _groups;
@synthesize displayName = _displayName;
@synthesize fullNames = _fullNames;
@synthesize namePhonetics = _namePhonetics;
@synthesize phoneNumbers = _phoneNumbers;
@synthesize photo = _photo;

@synthesize extensionDic = _extensionDic;

- (id)init{
    self = [super init];
    if (self) {
        // init ContactBean extension dictionary
        _extensionDic = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (NSComparisonResult)compare:(ContactBean *)pContactBean{
    NSComparisonResult _ret = NSOrderedAscending;
    
    // check contact id, display name and photo
    if (_id == pContactBean.id && [_displayName isEqualToString:pContactBean.displayName] && [_photo isEqualToData:pContactBean.photo]) {
        _ret = NSOrderedSame;
    }
    
    // check groups
    for (NSInteger _index = 0; _index < [_groups count]; _index++) {
        if (![[_groups objectAtIndex:_index] isEqualToString:[pContactBean.groups objectAtIndex:_index]]) {
            _ret = NSOrderedAscending;
            
            return _ret;
        }
    }
    
    // check phone number array
    for (NSInteger __index = 0; __index < [_phoneNumbers count]; __index++) {
        if (![[_phoneNumbers objectAtIndex:__index] isEqualToString:[pContactBean.phoneNumbers objectAtIndex:__index]]) {
            _ret = NSOrderedAscending;
            
            return  _ret;
        }
    }
    
    return _ret;
}

- (NSString *)description{
    return [NSString stringWithFormat:@"ContactBean description: id = %d, group array = %@, display name = %@, full name array = %@, name phonetic array = %@, phone number array = %@ an photo = %@, extension dictionary = %@", _id, _groups, _displayName, _fullNames, _namePhonetics, _phoneNumbers, _photo, _extensionDic];
}

@end
