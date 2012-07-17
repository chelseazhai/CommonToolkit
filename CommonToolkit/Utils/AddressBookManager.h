//
//  AddressBookManager.h
//  CommonToolkit
//
//  Created by  on 12-6-8.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AddressBook/AddressBook.h>

#import "ContactBean.h"

// dirty contact id dictionary key
#define DIRTYCONTACT_ADD_KEY    @"dirtyContactAdd"
#define DIRTYCONTACT_MODIFY_KEY   @"dirtyContactModify"
#define DIRTYCONTACT_DELETE_KEY @"dirtyContactDelete"

// addressBook changed delegate
@protocol AddressBookChangedDelegate <NSObject>

@required

// addressBook changed callback function
- (void)addressBookChanged:(ABAddressBookRef)pAddressBook info:(CFDictionaryRef)pInfo context:(void *)pContext;

@end




@interface AddressBookManager : NSObject {
    // all contacts, contact id - groups dictionary
    // key is contact record id (int32_t)
    // value is contact group array (NSArray)
    NSMutableDictionary *_mContactIdGroupsDic;
    
    // all contacts info array, object is contact bean
    NSMutableArray *_mAllContactsInfoArray;
    
    // contact search result dictionary
    // key is search keyword (NSString)
    // value is contact bean (ContactBean)
    NSMutableDictionary *_mContactSearchResultDic;
}

@property (nonatomic, readonly) NSMutableArray *allContactsInfoArray;

// share singleton AddressBookManager
+ (AddressBookManager *)shareAddressBookManager;

// traversal addressBook, important, do it first
- (void)traversalAddressBook;

// get contacts by phone number: sub matching
- (NSArray *)getContactByPhoneNumber:(NSString *)pPhoneNumber;

// get contacts by name(not chinaese character): fuzzy matching
- (NSArray *)getContactByName:(NSString *)pName;

// get contact end
- (void)getContactEnd;

// contacts display name array with user input phone number
- (NSArray *)contactsDisplayNameArrayWithPhoneNumber:(NSString *)pPhoneNumber;

// add addressBook changed callback observer
- (void)addABChangedObserver:(NSObject *)pObserver;

// remove addressBook changed callback observer
- (void)removeABChangedObserver:(NSObject *)pObserver;

@end
