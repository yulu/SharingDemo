//
//  WASWhatsAppUtil.h
//  SharingWhatsApp
//
//  Created by YU LU on 24/2/15.
//  Copyright (c) 2015 YU LU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WASWhatsAppUtil : NSObject

+ (id)getInstance;
- (void)sendText:(NSString*)message;
- (void)sendImage:(UIImage*)image inView:(UIView*)view;
- (void)sendText:(NSString*)message image:(UIImage*)image inView:(UIView*)view;
- (void)sendAudioinView:(UIView*)view;

@end
