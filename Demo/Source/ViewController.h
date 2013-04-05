//
//  ViewController.h
//  WordpressDemo
//
//  Created by Oliver Drobnik on 22.03.13.
//  Copyright (c) 2013 Drobnik KG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *userTextField;
@property (weak, nonatomic) IBOutlet UITextField *passTextField;
@property (weak, nonatomic) IBOutlet UITextField *URLTextField;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *uploadImageButton;

@end
