//
//  ReplyViewController.m
//  SinoDefense
//
//  Created by Sarah Pan on 2016-06-26.
//  Copyright © 2016 Swipe Stack Ltd. All rights reserved.
//

#import "PostViewController.h"
#import "URLRequestManager.h"

@implementation PostViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigator];
    [self setViewValues];
    [self.tableView setSeparatorColor:[UIColor blackColor]];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - navigator

- (void)setNavigator {
    UINavigationItem *navItem = self.navigationItem;
    navItem.title = @"Reply";
    //[[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
    //                                                     forBarMetrics:UIBarMetricsDefault];
    navItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    if(_isNewPost){
        self.navigationController.navigationBar.topItem.title = @"";
    }else{
        self.navigationController.navigationBar.topItem.title = @"";
    }
    [self createRightButtonItem];
}

- (void)createRightButtonItem {
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"tick_icon"]
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:self
                                                                          action:@selector(sendNewPost)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

#pragma mark - set view layout

- (void)setViewValues{
    _postContentTextView.text = @"enter your post content here";
    _postContentTextView.editable=YES;
    _postTopicField.text = _postTitle;
    _addPhotosButton.layer.cornerRadius = 10.0f;
    _addPhotosButton.layer.borderWidth = 0.5;
    [_addPhotosButton.layer setBorderColor:[[UIColor blueColor] CGColor]];
    _addPicturesButton.layer.cornerRadius = 10.0f;
    _addPicturesButton.layer.borderWidth = 0.5;
    [_addPicturesButton.layer setBorderColor:[[UIColor blueColor] CGColor]];
    _addEmojisButton.layer.cornerRadius = 10.0f;
    _addEmojisButton.layer.borderWidth = 0.5;
    [_addEmojisButton.layer setBorderColor:[[UIColor blueColor] CGColor]];
    _previewButton.layer.cornerRadius = 10.0f;
    _previewButton.layer.borderWidth = 0.5;
    [_previewButton.layer setBorderColor:[[UIColor blueColor] CGColor]];
}



#pragma mark - buttons

-(void)sendReply
{
    NSString *title = self.postTopicField.text;
    NSString *content = self.postContentTextView.text;
    NSMutableURLRequest *request = [[URLRequestManager sharedInstance] getReplyRequest:self.replyId withTitle: title withContent: content withAttachment: nil];
    //NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    //[connection start];
}

#pragma mark - NSURLConnection delegate

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    NSLog(@"%@" , error);
}


#pragma mark - button actions
- (IBAction)addPictures:(id)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:NULL];
}

- (IBAction)addPhotos:(id)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:NULL];
}

- (IBAction)addEmojis:(id)sender {
}

- (IBAction)preview:(id)sender {
}

- (IBAction)backgroundTaped:(id)sender{
    
}

#pragma mark - imagePicker
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(nonnull NSDictionary<NSString *,id> *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    _image = image;
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
