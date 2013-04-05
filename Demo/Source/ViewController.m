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
    
    
    
    
    
    
}


@end
