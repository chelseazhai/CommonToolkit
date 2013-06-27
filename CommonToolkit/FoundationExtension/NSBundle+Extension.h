//
//  NSBundle+Extension.h
//  CommonToolkit
//
//  Created by Ares on 12-6-18.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import <Foundation/Foundation.h>

// toasts, urls and remote background server fields string file name
#define TOASTSSTRING_FILENAME   @"Toasts"
#define URLSSTRING_FILENAME @"Urls"
#define RBGSERVERFIELDSSTRING_FILENAME  @"RBGServerFields"

// toasts localized string from self bundle with name
#define NSToastsLocalizedString(key, comment)  \
    NSLocalizedStringFromTable(key, TOASTSSTRING_FILENAME, comment)

// urls string from self bundle with name
#define NSUrlsString(key, comment)  \
    NSLocalizedStringFromTable(key, URLSSTRING_FILENAME, comment)

// remote background server fields string from self bundle with name
#define NSRBGServerFieldsString(key, comment)  \
    NSLocalizedStringFromTable(key, RBGSERVERFIELDSSTRING_FILENAME, comment)

// localized string from other bundle with name
#define NSLocalizedStringFromBundle(bundle, key, comment)   \
    [[NSBundle mainBundle] localizedStringFromBundle:(bundle) forKey:(key) value:@"" inTable:nil]

// localized string from other bundle with name in table
#define NSLocalizedStringFromBundleInTable(bundle, table, key, comment)   \
    [[NSBundle mainBundle] localizedStringFromBundle:(bundle) forKey:(key) value:@"" inTable:(table)]

// localized string from commonToolkit bundle
#define NSLocalizedStringFromCommonToolkitBundle(key, comment)  \
    [[NSBundle mainBundle] localizedStringFromBundle:@"CommonToolkitBundle" forKey:(key) value:@"" inTable:nil]

// localized string from pinyin4j bundle
#define NSLocalizedStringFromPinyin4jBundle(key, comment)  \
    [[NSBundle mainBundle] localizedStringFromBundle:@"Pinyin4jBundle" forKey:(key) value:@"" inTable:nil]

// resource content file path from commonToolkit bundle
#define NSResourcePathStringFromCommonToolkitBundle(resource)   \
    [[NSBundle mainBundle] resourcePathFromBundle:@"CommonToolkitBundle" name:(resource)]

@interface NSBundle (ResourcesFromBundle)

// method for retrieving localized strings from other bundle with name
- (NSString *)localizedStringFromBundle:(NSString *)pBundleName forKey:(NSString *)pKey value:(NSString *)pValue inTable:(NSString *)pTableName;

// method for retrieving resource content file path from other bundle with name
- (NSString *)resourcePathFromBundle:(NSString *)pBundleName name:(NSString *)pName;

@end
