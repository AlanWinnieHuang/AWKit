//
//  AppleFactoryCell.m
//  AWKitProduct
//
//  Created by winnie on 2019/12/16.
//  Copyright © 2019 winnie. All rights reserved.
//

#import "AppleFactoryCell.h"

@implementation AppleFactoryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor orangeColor];
    }
    return self;
}

@end
