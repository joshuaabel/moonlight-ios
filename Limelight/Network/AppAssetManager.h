//
//  AppManager.h
//  Moonlight
//
//  Created by Diego Waxemberg on 10/25/14.
//  Copyright (c) 2014 Moonlight Stream. All rights reserved.
//

#import "HttpManager.h"


@class TemporaryApp;
@class TemporaryHost;

@protocol AppAssetCallback <NSObject>

- (void) receivedAssetForApp:(TemporaryApp*)app;

@end

@interface AppAssetManager : NSObject

- (id) initWithCallback:(id<AppAssetCallback>)callback;
- (void) retrieveAssetsFromHost:(TemporaryHost*)host;
- (void) stopRetrieving;
+ (NSString*) boxArtPathForApp:(TemporaryApp*)app;

@end
