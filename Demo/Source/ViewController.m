//
//  ViewController.m
//  WordpressDemo
//
//  Created by Oliver Drobnik on 22.03.13.
//  Copyright (c) 2013 Drobnik KG. All rights reserved.
//

#import "ViewController.h"

#import "DTWordpress.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)uploadImage:(id)sender {
    NSString *user = self.userTextField.text;
    NSString *pass = self.passTextField.text;
    NSURL *URL = [NSURL URLWithString:self.URLTextField.text];
    
    DTWordpress *wordpress = [[DTWordpress alloc] initWithEndpointURL:URL];
    wordpress.userName = user;
    wordpress.password = pass;
    
    UIImage *image = [UIImage imageNamed:@"Default"];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
    
    self.uploadImageButton.enabled = NO;
    [self.activityIndicator startAnimating];
    
    [wordpress newMediaObjectWithFileName:@"bla.jpg" contentType:@"image/jpeg" data:imageData shouldOverwrite:YES completion:^(NSInteger mediaID, NSURL *mediaURL, NSError *error) {
        
        // on main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert show];
            }
            else
            {
                NSString *message = [NSString stringWithFormat:@"Uploaded image, URL: %@", [mediaURL absoluteString]];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert show];
            }

            self.uploadImageButton.enabled = YES;
            [self.activityIndicator stopAnimating];
        });
    }];
}


@end
