//
//  FatherFactory.m
//  AWKitProduct
//
//  Created by winnie on 2019/12/16.
//  Copyright © 2019 winnie. All rights reserved.
//

#import "FatherFactory.h"
#import "BannerFactory.h"
#import "AppleFactory.h"
@implementation FatherFactory

+ (FatherFactory *)createFactoryWithType:(NSInteger)type {
    FatherFactory *factory = nil;
    switch (type) {
        case 0:
        {
            factory = [[BannerFactory alloc] init];
        }
            break;
        case 1:
        {
            factory = [[AppleFactory alloc] init];
        }
            break;
        case 2:
        {
            
        }
    }
    return factory;
}

@end
