//
//  WASWhatsAppUtil.m
//  SharingWhatsApp
//
//  Created by YU LU on 24/2/15.
//  Copyright (c) 2015 YU LU. All rights reserved.
//

#import "WASWhatsAppUtil.h"

__strong static WASWhatsAppUtil* instanceOf = nil;

@interface WASWhatsAppUtil()<UIDocumentInteractionControllerDelegate>{
    UIDocumentInteractionController *_docControl;
}

@end

@implementation WASWhatsAppUtil

+ (WASWhatsAppUtil*)getInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instanceOf = [[WASWhatsAppUtil alloc] init];
    });
    return instanceOf;
}

- (void)sendText:(NSString*)message
{
    NSString    *urlWhats       = [NSString stringWithFormat:@"whatsapp://send?text=%@", message];
    NSURL       *whatsappURL    = [NSURL URLWithString:[urlWhats stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    if ( [self isWhatsAppInstalled]) {
        [[UIApplication sharedApplication] openURL: whatsappURL];
    } else {
        [self alertWhatsappNotInstalled];
    }
}

- (void) sendImage:(UIImage *)image inView:(UIView *)view
{
    if ( [self isWhatsAppInstalled]) {
        NSError *error = nil;
        NSURL *documentURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:&error];
        if (!documentURL) {
            [self alertError:[NSString stringWithFormat:@"Error getting document directory: %@", error]];
            return;
        }
        
        NSURL *tempFile = [documentURL URLByAppendingPathComponent:@"whatsAppTmp.wai"];
        NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
        
        if (![imageData writeToURL:tempFile options:NSDataWritingAtomic error:&error]) {
            [self alertError:[NSString stringWithFormat:@"Error writing File: %@", error]];
            return;
        }
        
        _docControl = [UIDocumentInteractionController interactionControllerWithURL:tempFile];
        _docControl.UTI = @"net.whatsapp.image";
        _docControl.delegate = self;
        
        [_docControl presentOpenInMenuFromRect:view.frame inView:view animated:YES];
    } else {
        [self alertWhatsappNotInstalled];
    }
}


- (void)sendText:(NSString *)message image:(UIImage *)image inView:(UIView *)view
{
    [[[UIAlertView alloc] initWithTitle:@"Alert." message:@"still unsolved." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

- (void) sendAudioinView:(UIView *)view
{
    if ( [self isWhatsAppInstalled])
    {
        NSString *savePath = [[NSBundle mainBundle] pathForResource:@"beeps" ofType:@"mp3"];
        NSURL *tempFile = [NSURL fileURLWithPath:savePath];
        
        _docControl = [UIDocumentInteractionController interactionControllerWithURL:tempFile];
        _docControl.UTI = @"net.whatsapp.audio";
        _docControl.delegate = self;
        
        [_docControl presentOpenInMenuFromRect:CGRectMake(0, 0, 0, 0) inView:view animated:YES];
    } else {
        [self alertWhatsappNotInstalled];
    }
}

#pragma mark - private
- (BOOL)isWhatsAppInstalled {
    return [[UIApplication sharedApplication] canOpenURL: [NSURL URLWithString:@"whatsapp://app"]];
}

#pragma mark - private
- (void)alertWhatsappNotInstalled{
    [[[UIAlertView alloc] initWithTitle:@"Error." message:@"Your device has no WhatsApp installed." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

- (void)alertError:(NSString*)message {
    [[[UIAlertView alloc] initWithTitle:@"Error." message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

@end
