//
//  XCStrategyManager.m
//  Objc-UI
//
//  Created by Alexcai on 2018/8/29.
//  Copyright © 2018年 Alexcai. All rights reserved.
//

#import "XCStrategyManager.h"

@interface XCStrategyManager()

// 策略字典: key -> NSInvocation
@property (nonatomic, strong)NSMutableDictionary <NSString*, NSInvocation*>*strategyDict;

@property (nonatomic, strong) NSMutableDictionary <NSString *, NSDictionary *>*paramsDict;

@property (nonatomic, strong) NSMutableDictionary *senderDict;

@property (nonatomic, copy) NSString *paramKey;

@end


@implementation XCStrategyManager


+ (instancetype)defaultManager{
    static dispatch_once_t onceToken;
    static XCStrategyManager *__instance = nil;
    dispatch_once(&onceToken, ^{
        __instance = [[self alloc]init];
        __instance.strategyDict = [NSMutableDictionary dictionaryWithCapacity:10];
        __instance.paramsDict = [NSMutableDictionary dictionaryWithCapacity:10];
        __instance.senderDict = [NSMutableDictionary dictionaryWithCapacity:10];
        __instance.paramKey = @"__instance_param_key";
    });
    return __instance;
    
}

/**
 添加策略到管理者中(含参数)
 */
+ (void)appendStrategy:(NSString *)key target:(id)sender selector:(SEL)action param:(NSDictionary *)dict{
    [[self defaultManager] appendStrategy:key target:sender selector:action param:dict];
}
/**
 添加策略到管理者中(不含参数)
 */
+ (void)appendStrategy:(NSString *)key target:(id)sender selector:(SEL)action{
    [self appendStrategy:key target:sender selector:action param:@{}];
}
/**
 执行策略
 */
+ (void)executeStrategyWithKey:(NSString *)strategyKey{
    [[self defaultManager] executeStrategyWithKey:strategyKey];
}

/**
 移除策略
 @param key 移除策略的key键
 */
+ (void)removeStrategy:(NSString *)key{
    [[self defaultManager]removeStrategy:key];
}


/**
 移除所有策略
 */
+ (void)removeAllStrategy{
    [[self defaultManager] removeAllStrategy];
}

/**
 添加策略到管理者中(含参数)
 */
- (void)appendStrategy:(NSString *)key target:(id)sender selector:(SEL)action param:(NSDictionary *)dict{
    if (sender == nil) {
        NSAssert(sender, @"sender must not be nil");
        return;
    }
    __weak typeof(sender) weakTarget = sender;
    self.senderDict[key] = weakTarget;
    
    
    NSMethodSignature *signature = [sender methodSignatureForSelector:action];
    NSAssert(signature, @"action must be imlemented");
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    
    invocation.target = weakTarget;
    invocation.selector = action;
    self.strategyDict[key] = invocation;
    
    // 空的dict,直接返回
    if (dict.allKeys.count < 1) {  return;}
    
    NSString *paramKey = [NSString stringWithFormat:@"%@%@",key,self.paramKey];
    self.paramsDict[paramKey] = dict;
    
}


/**
 执行策略
 */
- (void)executeStrategyWithKey:(NSString *)strategyKey{
    NSInvocation *invocation = self.strategyDict[strategyKey];
    id target = self.senderDict[strategyKey];
    if (invocation == nil || target == nil) {return;}
  
    NSString *paramKey = [NSString stringWithFormat:@"%@%@",strategyKey,self.paramKey];
    NSDictionary *param = self.paramsDict[paramKey];
    if (param) {
        [invocation setArgument:&param atIndex:2];
    }
    [invocation invoke];
}

/**
移除策略
 @param key 移除策略的key键
 */
- (void)removeStrategy:(NSString *)key{
    self.strategyDict[key] = nil;
     NSString *paramKey = [NSString stringWithFormat:@"%@%@",key,self.paramKey];
    self.paramsDict[paramKey] = nil;
    self.senderDict[key] = nil;
}

/**
 移除所有策略
 */
- (void)removeAllStrategy{
    [self.paramsDict removeAllObjects];
    [self.strategyDict removeAllObjects];
}

@end
