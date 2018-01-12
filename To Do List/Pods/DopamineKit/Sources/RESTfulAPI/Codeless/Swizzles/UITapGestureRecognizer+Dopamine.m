//
//  UITapGestureRecognizer+Dopamine.m
//  Pods
//
//  Created by Akash Desai on 12/11/17.
//
//

#import <UITapGestureRecognizer+Dopamine.h>

#import <DopamineKit/DopamineKit-swift.h>
#import <SwizzleHelper.h>

#import <objc/runtime.h>

@implementation DopamineTapGestureRecognizer

+ (void) swizzleSelectors {
    
#if DEBUG
    [SwizzleHelper injectSelector:[DopamineTapGestureRecognizer class] :@selector(swizzled_initWithTarget:action:) :[UITapGestureRecognizer class] :@selector(initWithTarget:action:)];
    [SwizzleHelper injectSelector:[DopamineTapGestureRecognizer class] :@selector(swizzled_addTarget:action:) :[UITapGestureRecognizer class] :@selector(addTarget:action:)];
#endif
    
}

- (instancetype) swizzled_initWithTarget:(id)target action:(SEL)action {
    
    [CodelessAPI submitTapActionWithTarget:target action:action];
    
    return [self swizzled_initWithTarget:target action:action];
}

- (void) swizzled_addTarget:(id)target action:(SEL)action {
    
    [CodelessAPI submitTapActionWithTarget:target action:action];
    
    if ([self respondsToSelector:@selector(swizzled_addTarget:action:)])
    [self swizzled_addTarget:target action:action];
}

@end

