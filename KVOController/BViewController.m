//
//  BViewController.m
//  KVOController
//
//  Created by 张天龙 on 2022/11/21.
//

#import "BViewController.h"
#import "MJViewModel.h"
#import "KVOController.h"

@interface BViewController ()
@property (nonatomic,strong) MJViewModel *viewModel3;
@end

@implementation BViewController

- (void)changeIDOfViewModel3{
    self.viewModel3.ID = [NSString stringWithFormat:@"armdom ID %d",arc4random()%100];
}
- (void)changeNameOfViewModel3{
    
    self.viewModel3.name = [NSString stringWithFormat:@"armdom name %d",arc4random()%100];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.viewModel3 = [[MJViewModel alloc] init];
    self.viewModel3.name = @"王五";
    self.viewModel3.ID = @"3";
    
    UIButton *button3 = [[UIButton alloc] init];
    button3.backgroundColor = [UIColor blueColor];
    button3.frame = CGRectMake(20, 200, 300, 50);
    [button3 setTitle:@"changeNameOfViewModel3" forState:UIControlStateNormal];
    [button3 addTarget:self action:@selector(changeNameOfViewModel3) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button3];
    
    UIButton *button4 = [[UIButton alloc] init];
    button4.backgroundColor = [UIColor purpleColor];
    button4.frame = CGRectMake(20, 250, 300, 50);
    [button4 setTitle:@"changeIDOfViewModel3" forState:UIControlStateNormal];
    [button4 addTarget:self action:@selector(changeIDOfViewModel3) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button4];
    
    UIButton *button5 = [[UIButton alloc] init];
    button5.backgroundColor = [UIColor grayColor];
    button5.frame = CGRectMake(20, 300, 300, 50);
    [button5 setTitle:@"set viewModel to nil" forState:UIControlStateNormal];
    [button5 addTarget:self action:@selector(dismissVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button5];
    
    [[KVOController shareInstance] mj_observeObject:self.viewModel3 forKeyPath:@"name" observerKeyPathDidChange:^(id value) {
        NSLog(@"viewModel3's name is change %@",value);
        
    }];
    
    [[KVOController shareInstance] mj_observeObject:self.viewModel3 forKeyPath:@"ID" observerKeyPathDidChange:^(id value) {
        NSLog(@"viewModel3's ID is change %@",value);
        
    }];
    
    [[KVOController shareInstance] mj_observeObject:self.viewModel3 forKeyPaths:@"name-ID" observerKeyPathDidChange:^(id value) {
        NSLog(@"combine viewModel3 name and ID  = %@",value);
        
    }];
    
}

- (void)dismissVC{
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
