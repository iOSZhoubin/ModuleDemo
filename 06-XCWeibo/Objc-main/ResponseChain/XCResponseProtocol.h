//
//  XCResponseProtocol.h
//  Objc-main
//
//  Created by Alexcai on 2018/9/17.
//  Copyright © 2018年 Alexcai. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol XCResponseProtocol <NSObject>

- (void)doSomething:(NSString *)thing responser:(id <XCResponseProtocol>)responser;

@end
