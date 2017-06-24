//
//  LoginTVC.m
//  SimpleClientServerApp-ForReactive
//
//  Created by Uber on 23/06/2017.
//  Copyright © 2017 Uber. All rights reserved.
//

#import "LoginTVC.h"

@interface LoginTVC ()

@property (strong, nonatomic) MBProgressHUD *HUD;
@property (strong, nonatomic) NSDictionary* accountData;

// UI
@property (weak, nonatomic) IBOutlet UIImageView *mainImage;

@property (weak, nonatomic) IBOutlet UITextField *loginTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UIButton *fogotPasswordButton;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;
@property (weak, nonatomic) IBOutlet UIButton *createAppleIdButton;

@property (weak, nonatomic) IBOutlet UIView *grayView;
@end

@implementation LoginTVC

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetupController];
    
}

#pragma mark - Server

- (void) getAccountsData
{
    
       [[ServerManager sharedManager] getAccountsData:^(NSDictionary *dictWithLoginAndPassword) {
        
            self.accountData = [NSDictionary dictionaryWithDictionary:dictWithLoginAndPassword];
            [self checkAccountsData];
        }onFailure:^(NSError *errorBlock, NSInteger statusCode) {
              NSLog(@"errorBlock = %@ | statusCode = %ld",errorBlock,(long)statusCode);
        }];
}

#pragma mark - Action

- (IBAction)signInAction:(UIButton *)sender
{
    [self.HUD show:YES];
    self.view.userInteractionEnabled = NO;
    
    
    if (!self.accountData) {
        [self getAccountsData];

    } else {
        [self checkAccountsData];
    }
}

- (void) checkAccountsData {
    
    [self.HUD show:NO];
    self.view.userInteractionEnabled = YES;
    
    NSLog(@"[self.accountData valueForKey:self.loginTextField.text] = %@", [self.accountData valueForKey:self.loginTextField.text]);
    
    if ([[self.accountData valueForKey:self.loginTextField.text] isEqualToString:self.passwordTextField.text])
    {
        WorkersTVC* workVC = [[WorkersTVC alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:workVC];
        //[navigationController pushViewController:workVC animated:YES];
#warning See to
        navigationController.navigationItem.title = @"Workers Apple";
        [self presentViewController:navigationController animated:YES completion:nil];
        
    } else {
        
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Ошибка"
                                                                           message:@"Логин или пароль не верны"
                                                                     preferredStyle:UIAlertControllerStyleAlert];
   
            UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"OK"
                                                                 style:UIAlertActionStyleDefault
                                                               handler:nil];
            [alert addAction:otherAction];
            [self presentViewController:alert animated:YES completion:nil];
          }
}
#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   return CGRectGetHeight(self.tableView.bounds);
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - Untils

-(void) initialSetupController
{
    self.mainImage.layer.masksToBounds = YES;
    self.mainImage.layer.cornerRadius  = 5;
    
    self.grayView.layer.masksToBounds = YES;
    self.grayView.layer.cornerRadius  = 5;
    
    self.signInButton.layer.masksToBounds = YES;
    self.signInButton.layer.cornerRadius  = 5;
    
    self.createAppleIdButton.layer.masksToBounds = YES;
    self.createAppleIdButton.layer.cornerRadius  = 5;
}

@end
























