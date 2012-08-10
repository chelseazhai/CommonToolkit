//
//  AddressBookManager.m
//  CommonToolkit
//
//  Created by  on 12-6-8.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import "AddressBookManager.h"

#import "NSString+Extension.h"
#import "NSArray+Extension.h"
#import "NSBundle+Extension.h"

#import "UIDevice+Extension.h"

#import "CommonUtils.h"

#import "ContactBean_Extension.h"

#import "RegexKitLite.h"

#import <objc/message.h>

// matching result contact bean and index array key
#define MATCHING_RESULT_CONTACT @"matchingResultContact"
#define MATCHING_RESULT_INDEXS  @"matchingResultIndexs"

// static singleton AddressBookManager reference
static AddressBookManager *singletonAddressBookManagerRef;

// NSArray contact private category
@interface NSArray (ContactPrivate)

// split array can matches given name phonetics
- (BOOL)isMatchedNamePhonetics:(NSArray *)pMatchesNamePhonetics;

// contact name phonetics string
- (NSString *)namePhoneticsString;

// sorted contacts info array
- (NSMutableArray *)sortedContactsInfoArray;

// multiplied by array
- (NSArray *)multipliedByArray:(NSArray *)pArray;

@end




// NSMutableArray contact private category
@interface NSMutableArray (ContactPrivate)

// append contact to sorted contacts info array
- (NSMutableArray *)appendContact2SortedContactsInfoArray:(ContactBean *)pContact;

@end




// NSString contact private category
@interface NSString (ContactPrivate)

// split to first letter and others
- (NSArray *)splitToFirstAndOthers;

// to array separated by character regular expression ([A-Za-z0-9]*)
- (NSArray *)toArraySeparatedByCharacter;

// multiplied by array
- (NSArray *)multipliedByArray:(NSArray *)pArray;

// get all prefixes
- (NSArray *)getAllPrefixes;

@end




// AddressBookManager extension
@interface AddressBookManager ()

@property (nonatomic, readonly) id addressBookChangedObserver;

// generate contact with contact's name, phone numbers info by record
- (ContactBean *)generateContactNamePhoneNumsInfoByRecord:(ABRecordRef)pRecord;

// get contact information array by particular phone number
- (NSArray *)getContactInfoByPhoneNumber:(NSString *)pPhoneNumber;

// init all contacts contact id - groups dictionary
- (void)initContactIdGroupsDictionary;

// get all contacts info array from addressBook
- (NSMutableArray *)getAllContactsInfoFromAB;

// print contact search result dictionary
- (void)printContactSearchResultDictionary;

// refresh addressBook and return contact id dirty dictionary
// key: contact id(NSInteger), value: action dictionary(NSDictionary *)
- (NSDictionary *)refreshAddressBook;

// private method: addressBook changed callback function
void addressBookChanged(ABAddressBookRef addressBook, CFDictionaryRef info, void *context);

@end




@implementation AddressBookManager

@synthesize addressBookChangedObserver = _mAddressBookChangedObserver;

- (id)init{
    self = [super init];
    if (self) {
        // Initialization code
    }
    return self;
}

- (NSMutableArray *)allContactsInfoArray{
    // remove each contact extension dictionary
    for (ContactBean *_contact in _mAllContactsInfoArray) {
        [_contact.extensionDic removeAllObjects];
    }
    
    return _mAllContactsInfoArray;
}

- (NSMutableArray *)allSortedContactsInfoArray{
    // remove each contact extension dictionary
    for (ContactBean *_contact in _mAllSortedContactsInfoArray) {
        [_contact.extensionDic removeAllObjects];
    }
    
    return _mAllSortedContactsInfoArray;
}

+ (AddressBookManager *)shareAddressBookManager{
    @synchronized(self){
        if (nil == singletonAddressBookManagerRef) {
            singletonAddressBookManagerRef = [[self alloc] init];
        }
    }
    
    return singletonAddressBookManagerRef;
}

- (void)traversalAddressBook{
    // traversal addressBook
    [self initContactIdGroupsDictionary];
    _mAllContactsInfoArray = [self getAllContactsInfoFromAB];
    _mAllSortedContactsInfoArray = [_mAllContactsInfoArray sortedContactsInfoArray];
}

- (ContactBean *)getContactInfoById:(NSInteger)pId{
    ContactBean *_ret = nil;
    
    // check all contacts info array
    _mAllContactsInfoArray = _mAllContactsInfoArray ? _mAllContactsInfoArray : [self getAllContactsInfoFromAB];
    _mAllSortedContactsInfoArray = _mAllSortedContactsInfoArray ? _mAllSortedContactsInfoArray : [_mAllContactsInfoArray sortedContactsInfoArray];
    
    for (ContactBean *_contact in _mAllContactsInfoArray) {
        // check contact id
        if (_contact.id == pId) {
            _ret = _contact;
            
            break;
        }
    }
    
    return _ret;
}

- (NSArray *)getContactByPhoneNumber:(NSString *)pPhoneNumber{
    return [self getContactByPhoneNumber:pPhoneNumber matchingType:sub orderBy:phonetics];
}

- (NSArray *)getContactByPhoneNumber:(NSString *)pPhoneNumber matchingType:(ContactPhoneNumberMatchingType)pPhoneNumberMatchingType orderBy:(ContactSortedType)pSortedType{
    NSMutableArray *_ret = [[NSMutableArray alloc] init];
    
    // check contact search result dictionary and all contacts info array
    _mContactSearchResultDic = _mContactSearchResultDic ? _mContactSearchResultDic : [[NSMutableDictionary alloc] init];
    _mAllContactsInfoArray = _mAllContactsInfoArray ? _mAllContactsInfoArray : [self getAllContactsInfoFromAB];
    _mAllSortedContactsInfoArray = _mAllSortedContactsInfoArray ? _mAllSortedContactsInfoArray : [_mAllContactsInfoArray sortedContactsInfoArray];
    
    // check search contact phone number
    if ([[_mContactSearchResultDic allKeys] containsObject:pPhoneNumber]) {
        // existed in search result dictionary
        for (NSDictionary *_matchingContactDic in [_mContactSearchResultDic objectForKey:pPhoneNumber]) {
            [_ret addObject:[_matchingContactDic objectForKey:MATCHING_RESULT_CONTACT]];
            
            // append contact matching index array
            [((ContactBean *)[_matchingContactDic objectForKey:MATCHING_RESULT_CONTACT]).extensionDic setObject:[_matchingContactDic objectForKey:MATCHING_RESULT_INDEXS] forKey:PHONENUMBER_MATCHING_INDEXS];
        }
    }
    else {
        // define contact search scope
        NSArray *_contactSearchScope = _mAllContactsInfoArray;
        
        // check search contact phone number sub phone number
        if (pPhoneNumber.length >= 2 && [[_mContactSearchResultDic allKeys] containsObject:[pPhoneNumber substringToIndex:pPhoneNumber.length - 2]]) {
            // get sub matched contact array
            NSMutableArray *_subMatchedContactArr = [[NSMutableArray alloc] init];
            
            // reset contact search scope
            for (NSDictionary *_matchingContactDic in [_mContactSearchResultDic objectForKey:[pPhoneNumber substringToIndex:pPhoneNumber.length - 2]]) {
                [_subMatchedContactArr addObject:[_matchingContactDic objectForKey:MATCHING_RESULT_CONTACT]];
            }
            
            _contactSearchScope = _subMatchedContactArr;
        }
        
        // define searched contact array
        NSMutableArray *_searchedContactArray = [[NSMutableArray alloc] init];
        
        // search each contact in contact search scope
        for (ContactBean *_contact in _contactSearchScope) {
            // phone number matching index array's array
            NSMutableArray *_phoneNumberMatchingIndexsArr = [[NSMutableArray alloc] init];
            
            // has phone number matched flag
            BOOL _hasOnePhoneNumberMatched = NO;
            
            // search contact each phone number
            for (NSString *_phoneNumber in _contact.phoneNumbers) {
                // check phone number is sub or full matched
                if (sub == pPhoneNumberMatchingType ? [_phoneNumber containsSubString:pPhoneNumber] : [_phoneNumber isEqualToString:pPhoneNumber]) {
                    _hasOnePhoneNumberMatched = YES;
                    
                    // add phone number matching index array to phone number matching index array's array
                    [_phoneNumberMatchingIndexsArr addObject:[NSArray arrayWithRange:[[_phoneNumber lowercaseString] rangeOfString:[pPhoneNumber lowercaseString]]]];
                }
                else {
                    // add empty matching index array to phone number matching index array's array
                    [_phoneNumberMatchingIndexsArr addObject:[[NSArray alloc] init]];
                }
            }
            
            // has one phone number in contact phone numbers matched
            if (_hasOnePhoneNumberMatched) {
                // add contact to result
                [_ret addObject:_contact];
                
                // append contact matching index array
                [_contact.extensionDic setObject:_phoneNumberMatchingIndexsArr forKey:PHONENUMBER_MATCHING_INDEXS];
                
                // add matching contact to searched contact array
                [_searchedContactArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:_contact, MATCHING_RESULT_CONTACT, [_contact.extensionDic objectForKey:PHONENUMBER_MATCHING_INDEXS], MATCHING_RESULT_INDEXS, nil]];
            }
        }
        
        // add to contact search result dictionary
        [_mContactSearchResultDic setObject:_searchedContactArray forKey:pPhoneNumber];
    }
    
    return pSortedType == phonetics ? [_ret sortedContactsInfoArray] : _ret;
}

- (NSArray *)getContactByName:(NSString *)pName{
    return [self getContactByName:pName matchingType:fuzzy orderBy:phonetics];
}

- (NSArray *)getContactByName:(NSString *)pName matchingType:(ContactNameMatchingType)pNameMatchingType orderBy:(ContactSortedType)pSortedType{
    NSMutableArray *_ret = [[NSMutableArray alloc] init];
    
    // convert search contact name to lowercase string
    pName = [pName lowercaseString];
    
    // check contact search result dictionary and all contacts info array
    _mContactSearchResultDic = _mContactSearchResultDic ? _mContactSearchResultDic : [[NSMutableDictionary alloc] init];
    _mAllContactsInfoArray = _mAllContactsInfoArray ? _mAllContactsInfoArray : [self getAllContactsInfoFromAB];
    _mAllSortedContactsInfoArray = _mAllSortedContactsInfoArray ? _mAllSortedContactsInfoArray : [_mAllContactsInfoArray sortedContactsInfoArray];
    
    // check search contact name
    if ([[_mContactSearchResultDic allKeys] containsObject:pName]) {
        // existed in search result dictionary
        for (NSDictionary *_matchingContactDic in [_mContactSearchResultDic objectForKey:pName]) {
            [_ret addObject:[_matchingContactDic objectForKey:MATCHING_RESULT_CONTACT]];
            
            // append contact matching index array
            [((ContactBean *)[_matchingContactDic objectForKey:MATCHING_RESULT_CONTACT]).extensionDic setObject:[_matchingContactDic objectForKey:MATCHING_RESULT_INDEXS] forKey:NAME_MATCHING_INDEXS];
        }
    }
    else {
        // define contact search scope
        NSArray *_contactSearchScope = _mAllContactsInfoArray;
        
        // check search contact name sub name
        if (pName.length >= 2 && [[_mContactSearchResultDic allKeys] containsObject:[pName substringToIndex:pName.length - 2]]) {
            // get sub matched contact array
            NSMutableArray *_subMatchedContactArr = [[NSMutableArray alloc] init];
            
            // reset contact search scope
            for (NSDictionary *_matchingContactDic in [_mContactSearchResultDic objectForKey:[pName substringToIndex:pName.length - 2]]) {
                [_subMatchedContactArr addObject:[_matchingContactDic objectForKey:MATCHING_RESULT_CONTACT]];
            }
            
            _contactSearchScope = _subMatchedContactArr;
        }
        
        // split search contact name
        NSArray *_searchContactNameSplitArray = nil;
        if (_contactSearchScope && [_contactSearchScope count] > 0) {
            _searchContactNameSplitArray = [pName splitToFirstAndOthers];
        }
        
        // define searched contact array
        NSMutableArray *_searchedContactArray = [[NSMutableArray alloc] init];
        
        // search each contact in contact search scope
        for (ContactBean *_contact in _contactSearchScope) {
            // traversal all split name array
            for (NSString *_splitName in _searchContactNameSplitArray) {
                // split name unmatch flag
                BOOL unmatch = NO;
                
                // matching index array
                NSMutableArray *_nameMatchingIndexArr = [[NSMutableArray alloc] init];
                
                // get split name array
                NSArray *_splitNameArray = [_splitName toArrayWithSeparator:@" "];
                
                // compare split name array count with contact name phonetic array count
                if ([_splitNameArray count] > [_contact.namePhonetics count]) {
                    continue;
                }
                
                // need all matching
                if (fuzzy == pNameMatchingType) {
                    if (![_splitNameArray isMatchedNamePhonetics:_contact.namePhonetics]) {
                        unmatch = YES;
                    }
                    else {
                        // last split name element matching index
                        NSInteger _lastElementMatchingIndex = 0;
                        
                        // set name matching index array
                        for (NSInteger _index = 0; _index < [_splitNameArray count]; _index++) {
                            for (NSInteger __index = _lastElementMatchingIndex; __index < [_contact.namePhonetics count]; __index++) {
                                // split name element matching flag
                                BOOL _elementMatching = NO;
                                
                                for (NSInteger ___index = 0; ___index < [[_contact.namePhonetics objectAtIndex:__index] count]; ___index++) {
                                    // check split name array each element matching index
                                    if ([[[_contact.namePhonetics objectAtIndex:__index] objectAtIndex:___index] hasPrefix:[_splitNameArray objectAtIndex:_index]]) {
                                        // set split name element matching flag
                                        _elementMatching = YES;
                                        
                                        // save split name element matching index
                                        _lastElementMatchingIndex = __index + 1;
                                        
                                        // set name matching index array
                                        [_nameMatchingIndexArr addObject:[NSNumber numberWithInteger:__index]];
                                        
                                        break;
                                    }
                                }
                                
                                // find element matching index
                                if (_elementMatching) {
                                    break;
                                }
                            }
                        }
                    }
                }
                else {
                    // slide split name array on contact name phonetic array
                    for (NSInteger _index = 0; _index < [_contact.namePhonetics count] - [_splitNameArray count] + 1; _index++) {
                        // split name array match flag in particular contact name phonetic array
                        BOOL _matched = NO;
                        
                        // match each split name
                        for (NSInteger __index = 0; __index < [_splitNameArray count]; __index++) {
                            // one split name unmatch flag
                            BOOL __unmatched = NO;
                            
                            // traversal multi phonetic
                            for (NSInteger ___index = 0; ___index < [[_contact.namePhonetics objectAtIndex:_index + __index] count]; ___index++) {
                                // matched, contact phonetic has prefix with split name
                                if ([[[_contact.namePhonetics objectAtIndex:_index + __index] objectAtIndex:___index] hasPrefix:[_splitNameArray objectAtIndex:__index]]) {
                                    break;
                                }
                                else if (___index == [[_contact.namePhonetics objectAtIndex:_index + __index] count] - 1) {
                                    __unmatched = YES;
                                }
                            }
                            
                            // one split name unmatch, break, slide split name array
                            if (__unmatched) {
                                break;
                            }
                            
                            // all split name matched, break
                            if (!__unmatched && __index == [_splitNameArray count] - 1) {
                                _matched = YES;
                                break;
                            }
                        }
                        
                        // one particular split name array metched, break
                        if (_matched) {
                            // set name matching index array
                            _nameMatchingIndexArr = [NSArray arrayWithRange:NSMakeRange(_index, [_splitNameArray count])];
                            
                            break;
                        }
                        
                        // all split name array unmatch, break, search next contact
                        if (!_matched && _index == [_contact.namePhonetics count] - [_splitNameArray count]) {
                            unmatch = YES;
                            break;
                        }
                    }
                }
                
                // one contact match, add in search result array
                if (!unmatch) {
                    // add contact to result
                    [_ret addObject:_contact];
                    
                    // append contact matching index array
                    [_contact.extensionDic setObject:_nameMatchingIndexArr forKey:NAME_MATCHING_INDEXS];
                    
                    // add matching contact to searched contact array
                    [_searchedContactArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:_contact, MATCHING_RESULT_CONTACT, [_contact.extensionDic objectForKey:NAME_MATCHING_INDEXS], MATCHING_RESULT_INDEXS, nil]];
                    
                    break;
                }
            }
        }
        
        // add to contact search result dictionary
        [_mContactSearchResultDic setObject:_searchedContactArray forKey:pName];
    }
    
    return pSortedType == phonetics ? [_ret sortedContactsInfoArray] : _ret;
}

- (void)getContactEnd{
    // check contact search result dictionary
    if (_mContactSearchResultDic) {
        [_mContactSearchResultDic removeAllObjects];
    }
}

- (NSArray *)contactsDisplayNameArrayWithPhoneNumber:(NSString *)pPhoneNumber{
    // get contact information array by particular phone number
    NSArray *_contactInfoArray = [self getContactInfoByPhoneNumber:pPhoneNumber];
    
    // define return result
    NSMutableArray *_ret = [[NSMutableArray alloc] initWithCapacity:[_contactInfoArray count]];
    
    // check contact info array
    if (0 == [_contactInfoArray count]) {
        // set default return result
        [_ret addObject:pPhoneNumber];
    }
    else {
        // set each contact display name
        for (ContactBean *_contact in _contactInfoArray) {
            [_ret addObject:_contact.displayName];
        }
    }
    
    return _ret;
}

- (void)addABChangedObserver:(id)pObserver{
    // validate addressBookChanged implemetation
    if ([CommonUtils validateProcessor:pObserver andSelector:@selector(addressBookChanged:info:observer:)]) {
        // check addressBook changed observer
        if (_mAddressBookChangedObserver && ![pObserver isEqual:_mAddressBookChangedObserver]) {
            // remove addressBook changed observer
            [self removeABChangedObserver:_mAddressBookChangedObserver];
        }
        
        // save addressBook changed observer
        _mAddressBookChangedObserver = pObserver;
        
        // register external change callback function
        ABAddressBookRegisterExternalChangeCallback(ABAddressBookCreate(), addressBookChanged, (__bridge void *)(_mAddressBookChangedObserver));
    }
    else if (nil != pObserver) {
        NSLog(@"Warning: %@ can't implement addressBook changed callback function %@", NSStringFromClass(((NSObject *)pObserver).class), NSStringFromSelector(@selector(addressBookChanged:info:observer:)));
        
        // register external change callback function
        ABAddressBookRegisterExternalChangeCallback(ABAddressBookCreate(), addressBookChanged, NULL);
    }
}

- (void)removeABChangedObserver:(id)pObserver{
    // unregister external change callback function
    ABAddressBookUnregisterExternalChangeCallback(ABAddressBookCreate(), addressBookChanged, (__bridge void *)(pObserver));
}

- (ContactBean *)generateContactNamePhoneNumsInfoByRecord:(ABRecordRef)pRecord{
    ContactBean *_contact = [[ContactBean alloc] init];
    
    // set contact id
    _contact.id = ABRecordGetRecordID(pRecord);
    
    // name info
    // get person first name, middle name and last name
    NSString *_firstName = (__bridge_transfer NSString *)ABRecordCopyValue(pRecord, kABPersonFirstNameProperty);
    NSString *_middleName = (__bridge_transfer NSString *)ABRecordCopyValue(pRecord, kABPersonMiddleNameProperty);
    NSString *_lastName = (__bridge_transfer NSString *)ABRecordCopyValue(pRecord, kABPersonLastNameProperty);
    
    // check first, middle and last name
    _firstName = (!_firstName) ? @"" : _firstName;
    _middleName = (!_middleName) ? @"" : _middleName;
    _lastName = (!_lastName) ? @"" : _lastName;
    
    // donn't need to use MiddleName usually
    // check system current setting language
    switch ([UIDevice currentDevice].systemCurrentSettingLanguage) {
        case zh_Hans:
        case zh_Hant:
            {
                // set display name
                _contact.displayName = [[NSString stringWithFormat:@"%@ %@", _lastName, _firstName] isNil] ? (zh_Hans == [UIDevice currentDevice].systemCurrentSettingLanguage) ? @"无名字" : @"無名字" : [NSString stringWithFormat:@"%@ %@", _lastName, _firstName];
                
                // set full name array
                NSMutableArray *_tmpNameArray = [[NSMutableArray alloc] init];
                [_tmpNameArray addObjectsFromArray:[_lastName toArraySeparatedByCharacter]];
                [_tmpNameArray addObjectsFromArray:[_firstName toArraySeparatedByCharacter]];
                _contact.fullNames = _tmpNameArray;
                
                // set name phonetics
                NSMutableArray *_tmpNamePhoneticArray = [[NSMutableArray alloc] init];
                for (NSString *_name in _contact.fullNames) {
                    // get each name unicode
                    unichar _unicode = [_name characterAtIndex:0];
                    // check name unicode
                    if (_unicode >= 19968 && _unicode <= 40869) {
                        // chinese character
                        NSString *_nameUnicodeString = [NSString stringWithFormat:@"%0X", _unicode];
                        [_tmpNamePhoneticArray addObject:[NSLocalizedStringFromPinyin4jBundle(_nameUnicodeString, nil) toArrayWithSeparator:@","]];
                    }
                    else {
                        // others, character
                        [_tmpNamePhoneticArray addObject:[NSArray arrayWithObject:_name]];
                    }
                }
                _contact.namePhonetics = _tmpNamePhoneticArray;
            }
            break;
            
        case en:
        default:
            {
                // set display name
                _contact.displayName = [[NSString stringWithFormat:@"%@ %@", _firstName, _lastName] isNil] ? @"No Name" : [NSString stringWithFormat:@"%@ %@", _firstName, _lastName];
                
                // set full name array
                _contact.fullNames = [NSArray arrayWithObjects:_firstName, _lastName, nil];
                
                // set name phonetics
                _contact.namePhonetics = [NSArray arrayWithObjects:[_firstName lowercaseString], [_lastName lowercaseString], nil];
            }
            break;
    }
    
    // phone numbers info
    // get contact's phone numbers array in addressBook
    ABMultiValueRef _contactPhoneNumberArrayInAB = (ABMultiValueRef)ABRecordCopyValue(pRecord, kABPersonPhoneProperty);
    
    // check contact's phone numbers array in addressBook
    if(_contactPhoneNumberArrayInAB){
        NSMutableArray *_contactPNArr = [[NSMutableArray alloc] init];
        
        // process temp phone number array
        for(int _index = 0; _index < ABMultiValueGetCount(_contactPhoneNumberArrayInAB); _index++){
            NSString *_phoneNumber = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(_contactPhoneNumberArrayInAB, _index); 
            
            // add each phone number to contact phone number array
            [_contactPNArr addObject:[_phoneNumber stringByTrimmingCharactersInString:@"()- "]];
        }
        
        // set contact phone number array
        _contact.phoneNumbers = _contactPNArr;
    }
    
    CFRelease(_contactPhoneNumberArrayInAB);
    
    return _contact;
}

- (NSArray *)getContactInfoByPhoneNumber:(NSString *)pPhoneNumber{
    NSMutableArray *_ret = [[NSMutableArray alloc] init];
    
    // check all contacts info array
    _mAllContactsInfoArray = _mAllContactsInfoArray ? _mAllContactsInfoArray : [self getAllContactsInfoFromAB];
    _mAllSortedContactsInfoArray = _mAllSortedContactsInfoArray ? _mAllSortedContactsInfoArray : [_mAllContactsInfoArray sortedContactsInfoArray];
    
    // search each contact in all contacts info array
    for (ContactBean *_contact in _mAllContactsInfoArray) {
        // search contact each phone number
        for (NSString *_phoneNumber in _contact.phoneNumbers) {
            // check phone number is matched
            if ([_phoneNumber isEqualToString:pPhoneNumber]) {
                // add contact to result
                [_ret addObject:_contact];
                break;
            }
        }
    }
    
    return _ret;
}

- (void)initContactIdGroupsDictionary{
    // check contact id - groups dictionary
    if (!_mContactIdGroupsDic) {
        _mContactIdGroupsDic = [[NSMutableDictionary alloc] init];
    }
    else {
        // return immediately
        return;
    }
    
    // fetch the addressBook 
    ABAddressBookRef addressBook = ABAddressBookCreate();
    
    // get all group array
    CFArrayRef _groups = ABAddressBookCopyArrayOfAllGroups(addressBook);
    
    // process all group array
    for(int _index = 0; _index < CFArrayGetCount(_groups); _index++){
        // get group object
        ABRecordRef _group = CFArrayGetValueAtIndex(_groups, _index);
        
        // get group name, part of contact id - groups dictionary, group array value
        NSString *_groupName = (__bridge NSString*)ABRecordCopyValue(_group, kABGroupNameProperty);
        
        // get all group members
        CFArrayRef _groupMembers = ABGroupCopyArrayOfAllMembers(_group);
        
        // process the group members array 
        for (int __index = 0; __index < CFArrayGetCount(_groupMembers); __index++) {
            // get group member id
            ABRecordID _memberID = ABRecordGetRecordID(CFArrayGetValueAtIndex(_groupMembers, __index));
            
            // judge group member id
            if ([[_mContactIdGroupsDic allKeys] containsObject:[NSNumber numberWithInt:_memberID]]) {
                // get existed value
                NSMutableArray *_value = [NSMutableArray arrayWithArray:[_mContactIdGroupsDic objectForKey:[NSNumber numberWithInt:_memberID]]];
                
                // append the group name
                [_value addObject:_groupName];
                // set dictionary
                [_mContactIdGroupsDic setObject:_value forKey:[NSNumber numberWithInt:_memberID]];
            }
            else{
                // set dictionary
                [_mContactIdGroupsDic setObject:[NSArray arrayWithObject:_groupName] forKey:[NSNumber numberWithInt:_memberID]];
            }
        }
    }
    
    // release
    CFRelease(addressBook);
}

- (NSMutableArray *)getAllContactsInfoFromAB{
    NSMutableArray *_ret = [[NSMutableArray alloc] init];
    
    // fetch the addressBook 
    ABAddressBookRef addressBook = ABAddressBookCreate();
    
    // get all contacts
    CFArrayRef _contacts = ABAddressBookCopyArrayOfAllPeople(addressBook);
    
    // process contacts array
    for(int _index = 0; _index < CFArrayGetCount(_contacts); _index++){
        // get contact record reference
        ABRecordRef _person = CFArrayGetValueAtIndex(_contacts, _index);
        
        // get contact info
        // id
        ABRecordID _recordID = ABRecordGetRecordID(_person);
        // group array
        if (!_mContactIdGroupsDic) {
            [self initContactIdGroupsDictionary];
        }
        NSArray* _groupArray = [_mContactIdGroupsDic objectForKey:[NSNumber numberWithInt:_recordID]];
        
        // generate contact name and phone number info
        ContactBean *_contactBean = [self generateContactNamePhoneNumsInfoByRecord:_person];
        
        // photo
        NSData* _photo = (__bridge NSData*)ABPersonCopyImageData(_person);
        
        // perfect contact
        _contactBean.groups = _groupArray;
        _contactBean.photo = _photo;
        
        // add contactBean in all contacts array
        [_ret addObject:_contactBean];
    }
    
    // release
    CFRelease(addressBook);
    
    return _ret;
}

- (void)printContactSearchResultDictionary{
    NSLog(@"Important Info: %@, contact search result dictionary = %@", NSStringFromClass(self.class), _mContactSearchResultDic);
}

- (NSDictionary *)refreshAddressBook{
    NSMutableDictionary *_ret = [[NSMutableDictionary alloc] init];
    
    // re-init contactsId group dictionary
    _mContactIdGroupsDic = nil;
    [self initContactIdGroupsDictionary];
    
    @autoreleasepool {
        // get new contacts info array from addressBook
        NSArray *_newContactsInfoArray = [self getAllContactsInfoFromAB];
        
        // remove contact from all contacts info array if not existed in new contacts info array
        // define contact existed in new all contacts info array flag
        BOOL _existedInNew;
        for (NSInteger _index = 0; _index < [_mAllContactsInfoArray count]; _index++) {
            // get contact in all contacts info array
            ContactBean *_contact = [_mAllContactsInfoArray objectAtIndex:_index];
            
            // set/re-set existed flag
            _existedInNew = NO;
            
            for (ContactBean *__contact in _newContactsInfoArray) {
                // check new contacts info array existed the contact which in all contacts info array
                if (_contact.id == __contact.id) {
                    _existedInNew = YES;
                    
                    break;
                }
            }
            
            // if existed, check next else remove the contact in all contacts info array
            if (!_existedInNew) {
                // get the deleting contact index in sorted contacts info array
                NSInteger _indexOfSortedContactsInfoArray = [_mAllSortedContactsInfoArray indexOfObject:[_mAllContactsInfoArray objectAtIndex:_index]];
                
                // delete
                [_mAllContactsInfoArray removeObjectAtIndex:_index];
                [_mAllSortedContactsInfoArray removeObjectAtIndex:_indexOfSortedContactsInfoArray];
                
                // add to dirty contact id dictionary
                [_ret setObject:[NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:contactDelete] forKey:CONTACT_ACTION] forKey:[NSNumber numberWithInteger:_contact.id]];
            }
        }
        
        // compare and merge contact
        for (ContactBean *_contact in _newContactsInfoArray) {
            // get contact in all contacts info array
            ContactBean *_oldContact = [self getContactInfoById:_contact.id];
            
            if (nil == _oldContact || NSOrderedSame != [_contact compare:_oldContact]) {
                // reset all contacts info array, if existed, replace else add new contact
                if (_oldContact) {
                    // replace
                    [_mAllSortedContactsInfoArray removeObjectAtIndex:[_mAllSortedContactsInfoArray indexOfObject:_oldContact]];
                    _oldContact = [_oldContact copyBaseProp:_contact];
                    [_mAllSortedContactsInfoArray appendContact2SortedContactsInfoArray:_oldContact];
                    
                    // create and init contact action dictionary
                    NSMutableDictionary *_contactActionDic = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInteger:contactModify] forKey:CONTACT_ACTION];
                    // detail action property can't implemetation???
                    
                    // add to dirty contact id dictionary
                    [_ret setObject:_contactActionDic forKey:[NSNumber numberWithInteger:_contact.id]];
                }
                else {
                    // add new
                    [_mAllContactsInfoArray addObject:_contact];
                    [_mAllSortedContactsInfoArray appendContact2SortedContactsInfoArray:_contact];
                    
                    // add to dirty contact id dictionary
                    [_ret setObject:[NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:contactAdd] forKey:CONTACT_ACTION] forKey:[NSNumber numberWithInteger:_contact.id]];
                }
            }
        }
    }
    
    return _ret;
}

void addressBookChanged(ABAddressBookRef addressBook, CFDictionaryRef info, void *context){
    // get addressBook changed observer
    id _addressBookChangedObserver = [AddressBookManager shareAddressBookManager].addressBookChangedObserver;
    
    // check addressBook changed observer, @chelsea ???, unregister external change callback function failed
    if (![_addressBookChangedObserver isEqual:(__bridge id)(context)]) {
        return;
    }
    
    // refresh addressBook and get dirty contact id dictionary
    info = (__bridge CFDictionaryRef)[[AddressBookManager shareAddressBookManager] refreshAddressBook];
    
    // clear contact search result dictionary
    [[AddressBookManager shareAddressBookManager] getContactEnd];
    
    // send message to addressBook changed observer
    if (NULL != context && 0 != [(__bridge NSDictionary *)info count]) {
        objc_msgSend(_addressBookChangedObserver, @selector(addressBookChanged:info:observer:), addressBook, info, _addressBookChangedObserver);
    }
}

@end




@implementation NSArray (ContactPrivate)

- (BOOL)isMatchedNamePhonetics:(NSArray *)pMatchesNamePhonetics{
    BOOL _ret = NO;
    
    if (nil != self && nil != pMatchesNamePhonetics && 0 != [self count] && [self count] <= [pMatchesNamePhonetics count]) {
        // split array has more elements
        if ([self count] > 1) {
            // slide split array in matches name phonetics
            for (NSInteger _index = 0; _index < [pMatchesNamePhonetics count] - [self count] + 1; _index++) {
                // check first element in aplit array and matches name phonetics
                BOOL _headerMatched = NO;
                
                for (NSInteger __index = 0; __index < [[pMatchesNamePhonetics objectAtIndex:_index] count]; __index++) {
                    if ([[[pMatchesNamePhonetics objectAtIndex:_index] objectAtIndex:__index] hasPrefix:[self objectAtIndex:0]]) {
                        _headerMatched = YES;
                        
                        break;
                    }
                }
                
                // if header not matched, slide split array
                if (!_headerMatched) {
                    continue;
                }
                
                // remove header, matches others left
                NSArray *_subSplitArray = [self subarrayWithRange:NSMakeRange(1, [self count] - 1)];
                NSArray *_subNamePhonetics = [pMatchesNamePhonetics subarrayWithRange:NSMakeRange(_index + 1, [pMatchesNamePhonetics count] - (_index + 1))];
                
                // left matches
                if ([_subSplitArray isMatchedNamePhonetics:_subNamePhonetics]) {
                    _ret = YES;
                    
                    break;
                }
            }
        }
        // split array just has one element
        else if(1 == [self count]) {
            BOOL _matched = NO;
            
            for (NSInteger _index = 0; _index < [pMatchesNamePhonetics count]; _index++) {
                for (NSInteger __index = 0; __index < [[pMatchesNamePhonetics objectAtIndex:_index] count]; __index++) {
                    if ([[[pMatchesNamePhonetics objectAtIndex:_index] objectAtIndex:__index] hasPrefix:[self objectAtIndex:0]]) {
                        _matched = YES;
                        _ret = YES;
                        
                        break;
                    }
                }
                
                // if matches, break immediately
                if (_matched) {
                    break;
                }
            }
        }
    }
    
    return _ret;
}

- (NSString *)namePhoneticsString{
    NSMutableString *_ret = [[NSMutableString alloc] init];
    
    // name phonetics is not empty
    if (self && [self count] > 0) {
        // append each name first phonetics
        for (NSInteger _index = 0; _index < [self count]; _index++) {
            [_ret appendString:[[self objectAtIndex:_index] objectAtIndex:0]];
        }
    }
    
    return _ret;
}

- (NSMutableArray *)sortedContactsInfoArray{
    NSMutableArray *_ret = [[NSMutableArray alloc] init];
    
    // process need to sorted contacts info array
    for (ContactBean *_contact in self) {
        // append contact to sorted contacts info array
        [_ret appendContact2SortedContactsInfoArray:_contact];
    }
    
    return _ret;
}

- (NSArray *)multipliedByArray:(NSArray *)pArray{
    NSMutableSet *_ret = [[NSMutableSet alloc] init];
    
    // check parameter array
    if (self && (!pArray || 0 == [pArray count])) {
        [_ret addObjectsFromArray:self];
    }
    
    // check self
    if (pArray && (!self || 0 == [self count])) {
        [_ret addObjectsFromArray:pArray];
    }
    
    // self and parameter array not nil
    if (self && pArray && [self count] > 0 && [pArray count] > 0) {
        // traversal self
        for (NSString *_selfArrayString in self) {
            // traversal parameter
            for (NSString *_parameterArrayString in pArray) {
                [_ret addObject:[NSString stringWithFormat:@"%@%@", _selfArrayString, _parameterArrayString]];
            }
        }
    }
    
    return [_ret allObjects];
}

@end




@implementation NSMutableArray (ContactPrivate)

- (NSMutableArray *)appendContact2SortedContactsInfoArray:(ContactBean *)pContact{
    if (nil != self) {
        // if self is empty, add the first without compare
        if (0 == [self count]) {
            [self addObject:pContact];
        }
        else {
            // comare with each sorted contact in sorted contacts info array
            for (NSInteger _index = 0; _index < [self count]; _index++) {
                // the contact has no name
                if ([[pContact.namePhonetics namePhoneticsString] isEqualToString:@""]) {
                    if (![[((ContactBean *)[self objectAtIndex:_index]).namePhonetics namePhoneticsString] isEqualToString:@""]) {
                        // at last
                        if (_index == [self count] - 1) {
                            [self addObject:pContact];
                            
                            break;
                        }
                        else {
                            // except the sorted contact with name
                            continue;
                        }
                    }
                    // if the sorted contact without name, compare their first phone number
                    else if ([[pContact.phoneNumbers objectAtIndex:0] compare:[((ContactBean *)[self objectAtIndex:_index]).phoneNumbers objectAtIndex:0]] < NSOrderedSame) {
                        [self insertObject:pContact atIndex:_index];
                        
                        break;
                    }
                    
                    // at last
                    if (_index == [self count] - 1) {
                        [self addObject:pContact];
                        
                        break;
                    }
                }
                
                // compare the contact name phonetics, if the had been sorted contact without name, insert immediately
                if ([[((ContactBean *)[self objectAtIndex:_index]).namePhonetics namePhoneticsString] isEqualToString:@""] || [[pContact.namePhonetics namePhoneticsString] compare:[((ContactBean *)[self objectAtIndex:_index]).namePhonetics namePhoneticsString]] < NSOrderedSame) {
                    [self insertObject:pContact atIndex:_index];
                    
                    break;
                }
                
                // at last
                if (_index == [self count] - 1) {
                    [self addObject:pContact];
                    
                    break;
                }
            }
        }
    }
    
    return self;
}

@end




@implementation NSString (Contact)

- (NSArray *)splitToFirstAndOthers{
    NSMutableArray *_ret = [[NSMutableArray alloc] init];
    
    // check self
    if ([self isNil]) {
        NSLog(@"Error: nil or empty string mustn't split");
    }
    else if (self.length >= 2) {
        // get first letter and others
        NSString *_firstLetter = [self substringToIndex:1];
        NSString *_others = [self substringFromIndex:1];
        
        [_ret addObjectsFromArray:[_firstLetter multipliedByArray:[_others splitToFirstAndOthers]]];
    }
    else {
        [_ret addObject:self];
    }
    
    return _ret;
}

- (NSArray *)toArraySeparatedByCharacter{
    NSMutableArray *_ret = [NSMutableArray arrayWithArray:[self componentsSeparatedByRegex:@"([A-Za-z0-9]*)"]];
    
    // all characters
    if (_ret && 0 == [_ret count] && ![self isNil]) {
        [_ret addObject:self];
    }
    else if (_ret && [_ret count] > 0) {
        // trim "" object
        for (NSInteger _index = 0; _index < [_ret count]; _index++) {
            if ([[_ret objectAtIndex:_index] isNil]) {
                [_ret removeObjectAtIndex:_index];
            }
        }
    }
    
    return _ret;
}

- (NSArray *)multipliedByArray:(NSArray *)pArray{
    NSMutableArray *_ret = [[NSMutableArray alloc] init];
    
    for (NSString *_string in pArray) {
        // x1 x2
        [_ret addObject:[NSString stringWithFormat:@"%@ %@", self, _string]];
        // x1x2
        [_ret addObject:[NSString stringWithFormat:@"%@%@", self, _string]];
    }
    
    return _ret;
}

- (NSArray *)getAllPrefixes{
    NSMutableArray *_ret = [[NSMutableArray alloc] init];
    
    for (NSInteger _index = 0; _index < self.length; _index++) {
        [_ret addObject:[self substringToIndex:_index + 1]];
    }
    
    return _ret;
}

@end
