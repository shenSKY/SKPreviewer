//
//  ViewController.m
//  SKPreviewer
//
//  Created by 沈凯 on 2018/9/6.
//  Copyright © 2018年 Ssky. All rights reserved.
//

#import "ViewController.h"
#import "SKPreviewer.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)buttonAction:(UIButton *)sender {
    
    [SKPreviewer previewFromImageView:sender.imageView container:self.view];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
