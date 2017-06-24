//
//  DetailWorkerVC.m
//  SimpleClientServerApp-ForReactive
//
//  Created by Uber on 23/06/2017.
//  Copyright © 2017 Uber. All rights reserved.
//

#import "DetailWorkerVC.h"

@interface DetailWorkerVC () 

// UI
@property (weak, nonatomic) IBOutlet UIImageView *mainPhoto;
@property (weak, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *thePostLabel;
@property (weak, nonatomic) IBOutlet UILabel *mainTextLabel;

@property (strong, nonatomic) WorkerFullModel* detailWorker;
@end

@implementation DetailWorkerVC

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getDetailInfoWorkerFromServer];

}

#pragma mark - Server

-(void) getDetailInfoWorkerFromServer
{
   [[ServerManager sharedManager] getFullInfoByWorkers:self.linkOnFullCV
                                             onSuccess:^(WorkerFullModel *worker) {
                                                 self.detailWorker = worker;
                                                 [self setupController];
                                             } onFailure:^(NSError *errorBlock, NSInteger statusCode) {
                                                 NSLog(@"Not found detail cv");
                                             }];
}
#pragma mark - Action



#pragma mark - Helpers Methods

- (void) setupController {
    
    [self.mainPhoto setImageWithURL:[NSURL URLWithString:self.detailWorker.photoURL]];
    self.firstNameLabel.text = self.detailWorker.firstName;
    self.lastNameLabel.text  = self.detailWorker.lastName;
    self.thePostLabel.text = self.detailWorker.thePost;
    self.mainTextLabel.text = self.detailWorker.mainText;
    
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    tapRecognizer.numberOfTapsRequired = 1;
    [self.mainPhoto addGestureRecognizer:tapRecognizer];
}



- (void)tapAction:(UITapGestureRecognizer *)tap
{
    if ([tap.view isKindOfClass:[UIImageView class]]) {
        
        UIImageView* imgFromGesture = (UIImageView*)tap.view;
        PhotoModel* photo = [[PhotoModel alloc] initFromUIImage:imgFromGesture.image];
       
        NYTPhotosViewController* photoVC = [[NYTPhotosViewController alloc] initWithPhotos:@[photo]];
        [self presentViewController:photoVC animated:YES completion:nil];
    }
}



@end
