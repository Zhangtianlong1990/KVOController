//
//  ViewController.m
//  KVOController
//
//  Created by 张天龙 on 2022/11/20.
//

#import "ViewController.h"
#import "MJViewModel.h"
#import "KVOController.h"
#import "BViewController.h"

@interface ViewController ()
@property (nonatomic,strong) MJViewModel *viewModel;
@property (nonatomic,strong) MJViewModel *viewModel2;

@end

@implementation ViewController
- (void)changeIDOfViewModel2{
    self.viewModel2.ID = [NSString stringWithFormat:@"armdom ID %d",arc4random()%100];
}
- (void)changeIDOfViewModel{
    self.viewModel.ID = [NSString stringWithFormat:@"armdom ID %d",arc4random()%100];
}
- (void)changeNameOfViewModel{
    
    self.viewModel.name = [NSString stringWithFormat:@"armdom name %d",arc4random()%100];
}

- (void)changeNameOfViewModel2{
    
    self.viewModel2.name = [NSString stringWithFormat:@"armdom name %d",arc4random()%100];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button1 = [[UIButton alloc] init];
    button1.backgroundColor = [UIColor redColor];
    button1.frame = CGRectMake(20, 100, 300, 50);
    [button1 setTitle:@"changeNameOfViewModel" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(changeNameOfViewModel) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    
    UIButton *button2 = [[UIButton alloc] init];
    button2.backgroundColor = [UIColor blackColor];
    button2.frame = CGRectMake(20, 150, 300, 50);
    [button2 setTitle:@"changeIDOfViewModel" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(changeIDOfViewModel) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button2];
    
    UIButton *button3 = [[UIButton alloc] init];
    button3.backgroundColor = [UIColor blueColor];
    button3.frame = CGRectMake(20, 200, 300, 50);
    [button3 setTitle:@"changeNameOfViewModel2" forState:UIControlStateNormal];
    [button3 addTarget:self action:@selector(changeNameOfViewModel2) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button3];
    
    UIButton *button4 = [[UIButton alloc] init];
    button4.backgroundColor = [UIColor purpleColor];
    button4.frame = CGRectMake(20, 250, 300, 50);
    [button4 setTitle:@"changeIDOfViewModel2" forState:UIControlStateNormal];
    [button4 addTarget:self action:@selector(changeIDOfViewModel2) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button4];
    
    UIButton *button5 = [[UIButton alloc] init];
    button5.backgroundColor = [UIColor grayColor];
    button5.frame = CGRectMake(20, 300, 300, 50);
    [button5 setTitle:@"set viewModel to nil" forState:UIControlStateNormal];
    [button5 addTarget:self action:@selector(releaseViewModel) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button5];
    
    self.viewModel = [[MJViewModel alloc] init];
    self.viewModel.name = @"张三";
    self.viewModel.ID = @"1";
    self.viewModel2 = [[MJViewModel alloc] init];
    self.viewModel2.name = @"李四";
    self.viewModel2.ID = @"2";
    
    [[KVOController shareInstance] mj_observeObject:self.viewModel forKeyPath:@"name" observerKeyPathDidChange:^(id value) {
        NSLog(@"viewModel's name is change %@",value);
        
    }];
    
    [[KVOController shareInstance] mj_observeObject:self.viewModel forKeyPath:@"name" observerKeyPathDidChange:^(id value) {
        NSLog(@"viewModel's name 第2次监听 %@",value);
        
    }];
    
    [[KVOController shareInstance] mj_observeObject:self.viewModel forKeyPath:@"ID" observerKeyPathDidChange:^(id value) {
        NSLog(@"viewModel's ID is change %@",value);
        
    }];
    
    [[KVOController shareInstance] mj_observeObject:self.viewModel forKeyPaths:@"name-ID" observerKeyPathDidChange:^(id value) {
        NSLog(@"combine viewModel‘s name and ID  = %@",value);
        
    }];
    
    [[KVOController shareInstance] mj_observeObject:self.viewModel2 forKeyPath:@"name" observerKeyPathDidChange:^(id value) {
        NSLog(@"viewModel2's name is change %@",value);
        
    }];
    
    [[KVOController shareInstance] mj_observeObject:self.viewModel2 forKeyPath:@"ID" observerKeyPathDidChange:^(id value) {
        NSLog(@"viewModel2's ID is change %@",value);
        
    }];
    
    [[KVOController shareInstance] mj_observeObject:self.viewModel2 forKeyPaths:@"name-ID" observerKeyPathDidChange:^(id value) {
        NSLog(@"combine viewModel2's name and ID  = %@",value);
        
    }];
    
    
}

- (void)releaseViewModel{
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"viewModel change thread %@",[NSThread currentThread]);

        self.viewModel = nil;
    });
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"viewModel2 change thread %@",[NSThread currentThread]);

        self.viewModel2 = nil;
    });
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self presentViewController:[[BViewController alloc] init] animated:YES completion:nil];
}


@end
