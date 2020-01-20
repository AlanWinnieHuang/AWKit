//
//  FatherFactory.h
//  AWKitProduct
//
//  Created by winnie on 2019/12/16.
//  Copyright © 2019 winnie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface FatherFactory : NSObject
+ (FatherFactory *)createFactoryWithType:(NSInteger)type;
@end

NS_ASSUME_NONNULL_END
 
