//
//  ViewController.m
//  SharingWhatsApp
//
//  Created by YU LU on 24/2/15.
//  Copyright (c) 2015 YU LU. All rights reserved.
//

#import "ViewController.h"
#import "WASWhatsAppUtil.h"

typedef enum {
    kSendText = 0,
    kSendImage,
    kSendTextWithImage,
    kSendCancel
} options;

@interface ViewController ()<UIActionSheetDelegate, UIDocumentInteractionControllerDelegate>{
    UIDocumentInteractionController *docController;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions
- (IBAction)sendDidTouch:(id)sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"Choose" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Send text", @"Send image", @"Send image with text", nil];
    [sheet showInView:self.view];
}

#pragma mark - UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case kSendText:
            [[WASWhatsAppUtil getInstance] sendText:@"This is test text"];
            break;
        case kSendImage:
            [[WASWhatsAppUtil getInstance] sendImage:[UIImage imageNamed:@"image.jpg"] inView:self.view];
            break;
        case kSendTextWithImage:
            NSLog(@"Send text with image");
            NSMutableArray *objectsToShare = [[NSMutableArray alloc]init];
            [objectsToShare addObject:[NSString stringWithFormat:@"Text string"]];
            [objectsToShare addObject:[UIImage imageNamed:@"image.jpg"]];
             
            // init and present the controller
            UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
            [self presentViewController:controller animated:YES completion:nil];
            
            break;
//        default:
//            NSLog(@"Cancel send");
//            break;
    }
}

@end
